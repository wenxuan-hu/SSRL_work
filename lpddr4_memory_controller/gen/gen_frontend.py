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
    if(len(args)==1 and args[0]=='axi'):
        axi_port=LiteDRAMAXIPort(data_width=256, address_width=32, id_width=4, clock_domain="sys")
        dram_port = LiteDRAMNativePort("both", 27, 256)
        axi2native=LiteDRAMAXI2Native(
            axi=axi_port,
            port=dram_port,
            w_buffer_depth=16,
            r_buffer_depth=16,
            base_address=0x00000000,
            with_read_modify_write=True
        )
        ios=set(axi_port.aw.flatten())|set(axi_port.ar.flatten())|set(axi_port.r.flatten())|set(axi_port.w.flatten())|set(axi_port.b.flatten())
        ios|=set(dram_port.cmd.flatten())|set(dram_port.rdata.flatten())|set(dram_port.wdata.flatten())
        verilog.convert(axi2native,ios,name="axi2native").write("axi2native.v")
    elif(len(args)==1 and args[0]=='wishbone'):
        wishbone_port=LiteDRAMWishbonePort(data_width=32, adr_width=32, bursting=True)
        dram_port = LiteDRAMNativePort("both", 27, 256)
        wishbone2native=LiteDRAMWishbone2Native(
            wishbone=wishbone_port,
            port=dram_port,
            base_address=0x40000000
        )
        ios=set(wishbone_port.flatten())
        ios|=set(dram_port.cmd.flatten())|set(dram_port.rdata.flatten())|set(dram_port.wdata.flatten())
        verilog.convert(wishbone2native,ios,name="wb2native").write("wb2native.v")
if __name__ == "__main__":
    main()
