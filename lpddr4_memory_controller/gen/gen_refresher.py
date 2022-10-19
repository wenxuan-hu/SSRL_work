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
        LPDDR4Memory_Model=MT53E256M16D1(clk_freq=533e6,rate="1:4")
        class Obj: pass
        settings = Obj()
        settings.with_refresh = True
        settings.refresh_zqcs_freq = 1e0
        settings.timing = Obj()
        settings.timing.tREFI = LPDDR4Memory_Model.timing_settings.tREFI
        settings.timing.tRP   = LPDDR4Memory_Model.timing_settings.tRP
        settings.timing.tRFC  = LPDDR4Memory_Model.timing_settings.tRFC
        settings.timing.tZQCS = LPDDR4Memory_Model.timing_settings.tZQCS
        print("settings.timing.tZQCS=",settings.timing.tZQCS)
        settings.geom = Obj()
        settings.geom.addressbits = 17
        settings.geom.bankbits    = 3
        settings.phy = Obj()
        settings.phy.nranks = 1

        refresher = Refresher(settings, clk_freq=533e6, postponing=int(args[0]))
        module_name="refresher_pos_"+args[0]
        print("Gnerating Refresher...")
        ios=set(refresher.cmd.flatten())
        ios.remove(refresher.cmd.first)
        ios.remove(refresher.cmd.is_read)
        ios.remove(refresher.cmd.is_write)
        ios.remove(refresher.cmd.is_cmd)
        ios.add(refresher.tRP)
        ios.add(refresher.tRFC)
        ios.add(refresher.tREFI)
        ios.add(refresher.postponing)
        verilog.convert(refresher,ios,name=module_name).write(module_name+'.v')
        print("Finished Refresher generation ")
if __name__ == "__main__":
    main()
