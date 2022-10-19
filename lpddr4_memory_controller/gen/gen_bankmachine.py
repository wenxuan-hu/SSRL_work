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
from litedram.phy.dfi import Interface
from litedram.phy.lpddr4.commands import DFIPhaseAdapter
from litedram.phy.utils import CommandsPipeline
from litedram.frontend.axi import LiteDRAMAXI2Native,LiteDRAMAXIPort
from litedram.frontend.wishbone import LiteDRAMWishbone2Native
from litex.soc.interconnect.wishbone import Interface as LiteDRAMWishbonePort
from litedram.core.crossbar import LiteDRAMCrossbar
from litedram.core.controller import ControllerSettings, LiteDRAMController
from litedram.phy import dfi
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

        default_controller_settings = dict(
            cmd_buffer_depth    = 2,
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
    
        default_geom_settings = dict(
            addressbits=17,
            bankbits = 3,
            rowbits  = 17,
            colbits  = 10,
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
        settings.phy    = SimpleSettings(**phy_settings)
        settings.geom   = SimpleSettings(**geom_settings)
        settings.timing = SimpleSettings(**timing_settings)
        
        address_align = log2_int(16)
        interface = LiteDRAMInterface(address_align, settings)
        print("Gnerating ",str(args[0])," bankmachines...")
        for i in range(int(args[0])):
            bankmachine = BankMachine(i,
                address_width = interface.address_width,
                address_align = address_align,
                nranks        = 1,
                settings      = settings
            )
            module_name='bankmachine_'+str(i)
            ios=set(bankmachine.req.flatten())|set(bankmachine.cmd.flatten())
            ios.add(bankmachine.refresh_req)
            ios.add(bankmachine.refresh_gnt)
            ios.add(bankmachine.tRTP)
            ios.add(bankmachine.tWTP)
            ios.add(bankmachine.tRC)
            ios.add(bankmachine.tRAS)
            ios.add(bankmachine.tRP)
            ios.add(bankmachine.tRCD)
            ios.add(bankmachine.tCCDMW)
            verilog.convert(bankmachine,ios,name=module_name).write(module_name+'.v')
            print("Finished Bankmachine generation ",str(i))
if __name__ == "__main__":
    main()
