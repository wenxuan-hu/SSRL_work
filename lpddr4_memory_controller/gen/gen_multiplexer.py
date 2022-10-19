import sys
from migen import *
from migen.fhdl import verilog
from litedram.common import *
from litedram.core.__init__ import LiteDRAMCore
from litedram.core.controller import LiteDRAMController
from litedram.phy.lpddr4.basephy import LPDDR4PHY
from litedram.phy.lpddr4.s7phy import S7LPDDR4PHY
from litedram.phy.lpddr4.simphy import LPDDR4SimPHY,DoubleRateLPDDR4SimPHY
from litedram.phy.lpddr4.simphy import LPDDR4SimulationPads
from litedram.phy.lpddr4.sim import LPDDR4Sim
from litedram.phy.utils import delayed, Serializer, Deserializer, Latency
from litedram.core.bankmachine import BankMachine
from litedram.modules import MT53E256M16D1
from litedram.core.test_axi import Read
from litedram.phy.dfi import Interface as DFIInterface
from litedram.phy.lpddr4.commands import DFIPhaseAdapter
from litedram.phy.utils import CommandsPipeline
from litedram.frontend.axi import LiteDRAMAXI2Native,LiteDRAMAXIPort
from litedram.frontend.wishbone import LiteDRAMWishbone2Native
from litex.soc.interconnect.wishbone import Interface as LiteDRAMWishbonePort
from litedram.core.crossbar import LiteDRAMCrossbar
from litedram.core.controller import ControllerSettings, LiteDRAMController
#from litedram.phy import dfi
from litedram.core.refresher import Refresher
from litedram.core.bankmachine import BankMachine
from litedram.core.multiplexer import Multiplexer
def main():
    args=sys.argv[1:]
    if(len(args)==1):
        phy=DoubleRateLPDDR4SimPHY(
            sys_clk_freq       = 533e6,
            aligned_reset_zero = True,
            masked_write       = True
        )
        default_geom_settings = dict(
            addressbits = 17,
            bankbits = 3,
            rowbits  = 17,
            colbits  = 10,
        )
        default_controller_settings = dict(
            cmd_buffer_depth    = 8,
            cmd_buffer_buffered = False,
            with_auto_precharge = True,
        )
   
        default_phy_settings = dict(
            cwl           = phy.settings.cwl,
            nphases       = phy.settings.nphases,
            nranks        = phy.settings.nranks,
            memtype       = phy.settings.memtype,
            dfi_databits  = phy.settings.dfi_databits,
            read_latency  = phy.settings.read_latency,
            write_latency = phy.settings.write_latency
        )
        timing_settings_266e6 = dict(
            tWTR = 4,
            tFAW = 12,
            tRRD = 4,
            tZQCS= None,
            tRFC = 49,
            tREFI= 1040,
            tRAS = 12,
            tRC  = 18,
            tCCD = 8,
            tRCD = 6,
            tRP  = 7,
            tWR  = 6,
        )

        timing_settings_533e6 = dict(
            tWTR = 7,
            tFAW = 23,
            tRRD = 7,
            tZQCS= None,
            tRFC = 97,
            tREFI= 2083,
            tRAS = 24,
            tRC  = 35,
            tCCD = 8,
            tRCD = 11,
            tRP  = 12,
            tWR  = 11,
        )
        controller_settings = default_controller_settings
        phy_settings        = default_phy_settings
        geom_settings       = default_geom_settings
        timing_settings     = timing_settings_533e6
        class SimpleSettings(Settings):
            def __init__(self, **kwargs):
                self.set_attributes(kwargs)

        settings        = SimpleSettings(**controller_settings)
        settings.phy    = phy
        settings.geom   = SimpleSettings(**geom_settings)
        settings.timing = SimpleSettings(**timing_settings)
        settings.with_refresh = True
        settings.refresh_zqcs_freq = 1e0
        settings.read_time=32
        settings.write_time=16
        settings.with_bandwidth=False
        address_align = log2_int(16)
        interface = LiteDRAMInterface(address_align, settings)
        dfi = DFIInterface(
            addressbits = settings.geom.addressbits,
            bankbits    = settings.geom.bankbits,
            nranks      = settings.phy.nranks,
            databits    = settings.phy.dfi_databits,
            nphases     = settings.phy.nphases)

        LPDDR4Memory_Model=MT53E256M16D1(clk_freq=533e6,rate="1:4")
        refresher = Refresher(settings, clk_freq=533e6, postponing=int(args[0]))
        bank_machines = []
        ios=set()
        for i in range(int(args[0])):
            bankmachine = BankMachine(i,
                address_width = interface.address_width,
                address_align = address_align,
                nranks        = 1,
                settings      = settings
            )
            bank_machines.append(bankmachine)
            ios|=set(bankmachine.cmd.flatten())
            ios.add(bankmachine.refresh_req)
            ios.add(bankmachine.refresh_gnt)

        multiplexer = Multiplexer(
            settings      = settings,
            bank_machines = bank_machines,
            refresher     = refresher,
            dfi           = dfi,
            interface     = interface)
        module_name='multiplexer_b'+args[0]
        ios|=set(dfi.flatten())
        ios|=set(refresher.cmd.flatten())
        ios.add(interface.rdata)
        ios.add(interface.wdata)
        ios.add(interface.wdata_we)
        ios.add(multiplexer.rdphase)
        ios.add(multiplexer.wrphase)
        ios.add(multiplexer.rdcmdphase)
        ios.add(multiplexer.wrcmdphase)
        ios.add(multiplexer.tRRD)
        ios.add(multiplexer.tFAW)
        ios.add(multiplexer.tCCD)
        ios.add(multiplexer.WTR_LATENCY)
        ios.add(multiplexer.RTW_LATENCY)
        ios.add(multiplexer.read_time)
        ios.add(multiplexer.write_time)
        verilog.convert(multiplexer,ios,name=module_name).write(module_name+'.v')
        print("Finished Multiplexer generation with ",args[0], "bankmachine interfaces")
if __name__ == "__main__":
    main()
