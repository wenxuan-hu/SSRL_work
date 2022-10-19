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

def main():
    args=sys.argv[1:]
    if(len(args)==1):
        phy=DoubleRateLPDDR4SimPHY(
            sys_clk_freq       = 533e6,
            aligned_reset_zero = True,
            masked_write       = True
        )

        default_controller_settings = dict(
            cmd_buffer_depth = 8,
            address_mapping  = "ROW_BANK_COL",
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
            bankbits = 3,
            rowbits  = 17,
            colbits  = 10,
        )

        controller_settings = default_controller_settings
        phy_settings        = default_phy_settings
        geom_settings       = default_geom_settings

        class SimpleSettings(Settings):
            def __init__(self, **kwargs):
                self.set_attributes(kwargs)

        settings        = SimpleSettings(**controller_settings)
        settings.phy    = SimpleSettings(**phy_settings)
        settings.geom   = SimpleSettings(**geom_settings)

        
        address_align = log2_int(16)
        interface = LiteDRAMInterface(address_align, settings)
        ports_num=int(args[0])
        module_name='crossbar_'+str(ports_num)+'ports'

	#module instance
        crossbar = LiteDRAMCrossbar(interface)
        ios=set()
        for i in range(ports_num):
            dram_port=crossbar.get_port()
            ios|=set(dram_port.cmd.flatten())|set(dram_port.rdata.flatten())|set(dram_port.wdata.flatten())
        crossbar.do_finalize()
        ios|=set(interface.flatten())
        ios.add(crossbar.read_latency)
        ios.add(crossbar.write_latency)
        print("generate crossbar with ",args[0],"ports!")
        verilog.convert(crossbar,ios,name=module_name).write(module_name+'.v')
        print("Finished generating ", module_name,".v")
if __name__ == "__main__":
    main()
