#
# This file is part of LiteDRAM.
#
# Copyright (c) 2016-2019 Florent Kermarrec <florent@enjoy-digital.fr>
# SPDX-License-Identifier: BSD-2-Clause

from migen import *
from migen.genlib.record import Record

from litex.soc.interconnect.csr import AutoCSR

from litedram.dfii import DFIInjector
from litedram.core.controller import ControllerSettings, LiteDRAMController
from litedram.core.crossbar import LiteDRAMCrossbar
from litedram.frontend.axi import LiteDRAMAXI2Native,LiteDRAMAXIPort
from litedram.frontend.wishbone import LiteDRAMWishbone2Native
from litex.soc.interconnect.wishbone import Interface as LiteDRAMWishbonePort

# Core ---------------------------------------------------------------------------------------------

class LiteDRAMCore(Module, AutoCSR):
    def __init__(self, phy, geom_settings, timing_settings, clk_freq, **kwargs):
        #self.submodules.dfii = DFIInjector(
            #addressbits = max(geom_settings.addressbits, getattr(phy, "addressbits", 0)),
            #bankbits    = max(geom_settings.bankbits, getattr(phy, "bankbits", 0)),
            #nranks      = phy.settings.nranks,
            #databits    = phy.settings.dfi_databits,
            #nphases     = phy.settings.nphases)
        #self.comb += self.dfii.master.connect(phy.dfi)
	
        self.submodules.controller = controller = LiteDRAMController(
            phy_settings    = phy.settings,
            geom_settings   = geom_settings,
            timing_settings = timing_settings,
            clk_freq        = clk_freq,
            **kwargs)
        #self.comb += controller.dfi.connect(self.dfii.slave)
        
        self.submodules.crossbar = LiteDRAMCrossbar(controller.interface)
        axi=LiteDRAMAXIPort(data_width=controller.interface.data_width, address_width=32, id_width=1, clock_domain="sys")
        #axi_pad=Record(axi.layout_flat())
        self.submodules.axi=LiteDRAMAXI2Native(
            axi=axi,
            port=self.crossbar.get_port(),
            w_buffer_depth=16,
            r_buffer_depth=16,
            base_address=0x00000000,
            with_read_modify_write=False
        )
        wishbone=LiteDRAMWishbonePort(data_width=controller.interface.data_width, adr_width=32, bursting=False)
        self.submodules.wishbone=LiteDRAMWishbone2Native(
            wishbone=wishbone,
            port=self.crossbar.get_port(),
            base_address=0x10000000
        )
        self.crossbar.do_finalize()
      

        self.ios = set(self.controller.dfi.flatten())
        self.ios |= set(axi.aw.flatten())|set(axi.ar.flatten())|set(axi.r.flatten())|set(axi.w.flatten())|set(axi.b.flatten())
        self.ios |= set(wishbone.flatten())
        self.ios |= set(self.controller.get_csrs())
        
