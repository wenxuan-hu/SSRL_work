#
# This file is part of LiteDRAM.
#
# Copyright (c) 2015 Sebastien Bourdeauducq <sb@m-labs.hk>
# Copyright (c) 2016-2019 Florent Kermarrec <florent@enjoy-digital.fr>
# SPDX-License-Identifier: BSD-2-Clause

"""LiteDRAM BankMachine (Rows/Columns management)."""

import math

from migen import *

from litex.soc.interconnect import stream

from litedram.common import *
from litedram.core.multiplexer import *

# AddressSlicer ------------------------------------------------------------------------------------

class _AddressSlicer:
    """Helper for extracting row/col from address

    Column occupies lower bits of the address, row - higher bits. Address has
    a forced alignment, so column does not contain alignment bits.
    """
    def __init__(self, colbits, address_align):
        self.colbits       = colbits
        self.address_align = address_align

    def row(self, address):
        split = self.colbits - self.address_align
        return address[split:]

    def col(self, address):
        split = self.colbits - self.address_align
        return Cat(Replicate(0, self.address_align), address[:split])

# BankMachine --------------------------------------------------------------------------------------

class BankMachine(Module):
    """Converts requests from ports into DRAM commands

    BankMachine abstracts single DRAM bank by keeping track of the currently
    selected row. It converts requests from LiteDRAMCrossbar to targetted
    to that bank into DRAM commands that go to the Multiplexer, inserting any
    needed activate/precharge commands (with optional auto-precharge). It also
    keeps track and enforces some DRAM timings (other timings are enforced in
    the Multiplexer).

    BankMachines work independently from the data path (which connects
    LiteDRAMCrossbar with the Multiplexer directly).

    Stream of requests from LiteDRAMCrossbar is being queued, so that reqeust
    can be "looked ahead", and auto-precharge can be performed (if enabled in
    settings).

    Lock (cmd_layout.lock) is used to synchronise with LiteDRAMCrossbar. It is
    being held when:
     - there is a valid command awaiting in `cmd_buffer_lookahead` - this buffer
       becomes ready simply when the next data gets fetched to the `cmd_buffer`
     - there is a valid command in `cmd_buffer` - `cmd_buffer` becomes ready
       when the BankMachine sends wdata_ready/rdata_valid back to the crossbar

    Parameters
    ----------
    n : int
        Bank number
    address_width : int
        LiteDRAMInterface address width
    address_align : int
        Address alignment depending on burst length
    nranks : int
        Number of separate DRAM chips (width of chip select)
    settings : ControllerSettings
        LiteDRAMController settings

    Attributes
    ----------
    req : Record(cmd_layout)
        Stream of requests from LiteDRAMCrossbar
    refresh_req : Signal(), in
        Indicates that refresh needs to be done, connects to Refresher.cmd.valid
    refresh_gnt : Signal(), out
        Indicates that refresh permission has been granted, satisfying timings
    cmd : Endpoint(cmd_request_rw_layout)
        Stream of commands to the Multiplexer
    """
    def __init__(self, n, address_width, address_align, nranks, settings):
        self.req = req = Record(cmd_layout(address_width))
        self.refresh_req = refresh_req = Signal()
        self.refresh_gnt = refresh_gnt = Signal()

        a  = settings.geom.addressbits
        ba = settings.geom.bankbits + log2_int(nranks)
	    #self.n=Signal(ba)
        self.cmd = cmd = stream.Endpoint(cmd_request_rw_layout(a, ba))

        # # #
        self.tRTP=Signal(max=255,reset_less=True,name="bm_tRTP_cfg")
        self.tWTP=Signal(max=255,reset_less=True,name="bm_tWTP_cfg")
        self.tRC=Signal(max=255,reset_less=True,name="bm_tRC_cfg")
        self.tRAS=Signal(max=255,reset_less=True,name="bm_tRAS_cfg")
        self.tRP=Signal(max=255,reset_less=True,name="bm_tRP_cfg")
        self.tRCD=Signal(max=255,reset_less=True,name="bm_tRCD_cfg")
        self.tCCDMW=Signal(max=255,reset_less=True,name="bm_tCCDMW_cfg")
        #self.read_time=Signal(max=255,reset_less=True,name="mul_READ_TIME_cfg")
        #self.write_time=Signal(max=255,reset_less=True,name="mul_WRITE_TIME_cfg")
        auto_precharge = Signal()

        # Command buffer ---------------------------------------------------------------------------
        cmd_buffer_layout    = [("we", 1), ("mw",1),("addr", len(req.addr))]
        cmd_buffer_lookahead = stream.SyncFIFO(
            cmd_buffer_layout, settings.cmd_buffer_depth,
            buffered=settings.cmd_buffer_buffered)
        cmd_buffer = stream.Buffer(cmd_buffer_layout) # 1 depth buffer to detect row change
        self.submodules += cmd_buffer_lookahead, cmd_buffer
        self.comb += [
            req.connect(cmd_buffer_lookahead.sink, keep={"valid", "ready", "we","mw", "addr"}),
            cmd_buffer_lookahead.source.connect(cmd_buffer.sink),
            cmd_buffer.source.ready.eq(req.wdata_ready | req.rdata_valid),
            req.lock.eq(cmd_buffer_lookahead.source.valid | cmd_buffer.source.valid),
        ]

        slicer = _AddressSlicer(settings.geom.colbits, address_align)

        # Row tracking -----------------------------------------------------------------------------
        row        = Signal(settings.geom.rowbits,reset=0)
        row_opened = Signal(reset=0)
        row_hit    = Signal(reset=0)
        row_open   = Signal(reset=0)
        row_close  = Signal(reset=1)
        self.comb += row_hit.eq(row == slicer.row(cmd_buffer.source.addr))
        self.sync += \
            If(row_close,
                row_opened.eq(0)
            ).Elif(row_open,
                row_opened.eq(1),
                row.eq(slicer.row(cmd_buffer.source.addr))
            )

        # Address generation -----------------------------------------------------------------------
        row_col_n_addr_sel = Signal(reset=0)
        self.comb += [
            #cmd.ba.eq(self.n),
            cmd.ba.eq(n),
            If(row_col_n_addr_sel,
                cmd.a.eq(slicer.row(cmd_buffer.source.addr))
            ).Else(
                cmd.a.eq((auto_precharge << 10) | slicer.col(cmd_buffer.source.addr))
            )
        ]
        # tCCDMW (masked-write) controller -----------------------------------------------------
        self.submodules.tccdmwcon = tccdmwcon = tXXDController(self.tCCDMW)
        self.comb += tccdmwcon.valid.eq(cmd.valid & cmd.ready & cmd.is_write)

        # tRTP (read-to-precharge) controller -----------------------------------------------------
        self.submodules.trtpcon = trtpcon = tXXDController(self.tRTP)
        self.comb += trtpcon.valid.eq(cmd.valid & cmd.ready & cmd.is_read)

        # tWTP (write-to-precharge) controller -----------------------------------------------------
        """
        write_latency = math.ceil(settings.phy.cwl / settings.phy.nphases)
        precharge_time = write_latency + settings.timing.tWR + settings.timing.tCCD # AL=0
        """
        self.submodules.twtpcon = twtpcon = tXXDController(self.tWTP)
        self.comb += twtpcon.valid.eq(cmd.valid & cmd.ready & cmd.is_write)

        # tRC (activate-activate) controller -------------------------------------------------------
        self.submodules.trccon = trccon = tXXDController(self.tRC)
        self.comb += trccon.valid.eq(cmd.valid & cmd.ready & row_open)

        # tRAS (activate-precharge) controller -----------------------------------------------------
        self.submodules.trascon = trascon = tXXDController(self.tRAS)
        self.comb += trascon.valid.eq(cmd.valid & cmd.ready & row_open)
        # tRP (precharge-activate) controller -----------------------------------------------------
        self.submodules.trpcon = trpcon = tXXDController(self.tRP)
        # tRCD (activate-column access) controller -----------------------------------------------------
        self.submodules.trcdcon = trcdcon = tXXDController(self.tRCD)
        self.comb += trcdcon.valid.eq(cmd.valid & cmd.ready & row_open)

        # Auto Precharge generation ----------------------------------------------------------------
        # generate auto precharge when current and next cmds are to different rows
        if settings.with_auto_precharge:
            self.comb += \
                If(cmd_buffer_lookahead.source.valid & cmd_buffer.source.valid,
                    If(slicer.row(cmd_buffer_lookahead.source.addr) !=
                       slicer.row(cmd_buffer.source.addr),
                        auto_precharge.eq(row_close == 0)
                    )
                )

        # Control and command generation FSM -------------------------------------------------------
        # Note: tRRD, tFAW, tCCD, tWTR timings are enforced by the multiplexer
        self.submodules.fsm = fsm = FSM()
        fsm.act("REGULAR",
            row_close.eq(0),
            NextValue(req.rdata_valid,0),
            NextValue(req.wdata_ready,0),
            If(refresh_req,
                NextState("REFRESH")
            ).Elif(cmd_buffer.source.valid,
                If(row_opened,
                    If(row_hit,
                        If(cmd_buffer.source.we, #write/masked-write
                            If(cmd_buffer.source.mw, #masked/write
                                If(tccdmwcon.ready, #tCCDMW met
                                cmd.valid.eq(1),
                                cmd.is_mw.eq(1),
                                If(cmd.ready,NextValue(req.wdata_ready,1)).Else(NextValue(req.wdata_ready,0)),
                                cmd.is_write.eq(1),
                                cmd.cas.eq(1),
                                cmd.we.eq(1),
                                ).Else(
                                    NextValue(req.wdata_ready,0)
                                )
                            ).Else( #write
                                cmd.valid.eq(1),
                                cmd.is_mw.eq(0),
                                If(cmd.ready,NextValue(req.wdata_ready,1)).Else(NextValue(req.wdata_ready,0)),
                                cmd.is_write.eq(1),
                                cmd.we.eq(1),
                                cmd.cas.eq(1)
                            )
                        #read
                        ).Else( 
                            cmd.valid.eq(1),
                            If(cmd.ready,NextValue(req.rdata_valid,1)).Else(NextValue(req.rdata_valid,0)),
                            cmd.is_read.eq(1),
                            cmd.cas.eq(1)
                        ),
                        If((cmd.valid& cmd.ready) & auto_precharge,
                           NextState("AUTOPRECHARGE")
                        )
                    ).Else(  # row_opened & ~row_hit
                        NextState("PRECHARGE")
                    )
                ).Else(  # ~row_opened
                    NextState("PRECHARGE")
                )
            )
        )
        fsm.act("PRECHARGE",
            NextValue(req.rdata_valid,0),
            NextValue(req.wdata_ready,0),
            # Note: we are presenting the column address, A10 is always low
            If((twtpcon.ready & trtpcon.ready) & trascon.ready,
                cmd.valid.eq(1),
                If(cmd.ready,
                    [NextState("TRP"),
                    trpcon.valid.eq(1)]
                ),
                cmd.ras.eq(1),
                cmd.cas.eq(0),
                cmd.we.eq(1),
                cmd.is_cmd.eq(1)
            ),
            row_close.eq(1)
        )
        fsm.act("AUTOPRECHARGE",
            NextValue(req.rdata_valid,0),
            NextValue(req.wdata_ready,0),
            If((twtpcon.ready &trtpcon.ready) & trascon.ready,
                [NextState("TRP"),
                trpcon.valid.eq(1)]
            ),
            row_close.eq(1)
        )
        fsm.act("ACTIVATE",
            NextValue(req.rdata_valid,0),
            NextValue(req.wdata_ready,0),
            If(trccon.ready,
                row_col_n_addr_sel.eq(1),
                row_close.eq(0),
                row_open.eq(1),
                cmd.valid.eq(1),
                cmd.is_cmd.eq(1),
                If(cmd.ready,
                    NextState("TRCD")
                ),
                cmd.ras.eq(1)
            )  
        )
        fsm.act("REFRESH",
            NextValue(req.rdata_valid,0),
            NextValue(req.wdata_ready,0),
            If(twtpcon.ready & trascon.ready,
                refresh_gnt.eq(1),
            ),
            row_close.eq(1),
            cmd.is_cmd.eq(1),
            If(~refresh_req,
                NextState("REGULAR")
            )
        )
        fsm.act("TRP",
            NextValue(req.rdata_valid,0),
            NextValue(req.wdata_ready,0),
            row_close.eq(0),
            trpcon.valid.eq(0),
            If(trpcon.ready,
                NextState("ACTIVATE") 
            )
        )
        fsm.act("TRCD",
            NextValue(req.rdata_valid,0),
            NextValue(req.wdata_ready,0),
            row_close.eq(0),
            If(trcdcon.ready,
                NextState("REGULAR")
            )
        )
        
        """
        fsm.delayed_enter("TRP", "ACTIVATE", settings.timing.tRP - 1)
        fsm.delayed_enter("TRCD", "REGULAR", settings.timing.tRCD - 1)
        """
