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

system_clk_freq=533e6



class MySettings(Settings):
    def __init__(self, **kwargs):
        self.set_attributes(kwargs)

geom_settings = dict(
    addressbits = 17,
    bankbits = 3,
    rowbits  = 17,
    colbits  = 10,
    )
controller_settings = dict(
    cmd_buffer_depth    = 8,
    cmd_buffer_buffered = False,
    with_auto_precharge = True,
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
def reads_cmd_generator(axi_port):
    reads = [Read(1023, [0], [2**(32//8)-1], 0, type=BURST_FIXED, len=0, size=log2_int(32//8)) for _ in range(32)]
    prng = random.Random(42)
    while not axi_port.reads_enable:
        yield
    for read in reads:
        while prng.randrange(100) < ar_valid_random:
            yield
        # Send command
        yield axi_port.ar.valid.eq(1)
        yield axi_port.ar.addr.eq(read.addr<<2)
        yield axi_port.ar.burst.eq(read.type)
        yield axi_port.ar.len.eq(read.len)
        yield axi_port.ar.size.eq(read.size)
        yield axi_port.ar.id.eq(read.id)
        yield
        while (yield axi_port.ar.ready) == 0:
            yield
        yield axi_port.ar.valid.eq(0)

#testbench
def mc_test(dut):
    for i in range(20):
        print((yield dut.dfi))
        yield


def main():
    class DFIAdapter(Module):
        def __init__(self):
            self.dfi = Interface(
                addressbits = 17,
                bankbits    = 6,
                nranks      = 1,
                databits    = 64,
                nphases     = 4
            )
            #phase adapter
            adapters = [DFIPhaseAdapter(phase, masked_write=True) for phase in self.dfi.phases]
            self.submodules += adapters

            #command pipeline
            self.submodules.commands = CommandsPipeline(adapters,
                cs_ser_width = 4,
                ca_ser_width = 4,
                ca_nbits     = 6,
                cmd_nphases_span = 4,
                extended_overlaps_check = True
            )
            self.ios=set(self.dfi.flatten())
            self.ios|=set(self.commands.ca)
            self.ios|=set([self.commands.cs])

    #LPDDR4 Memory Model
    DFIAdapter=DFIAdapter()
    pads=LPDDR4SimulationPads()
    LPDDR4Memory_Model=MT53E256M16D1(clk_freq=system_clk_freq,rate="1:4")
    LPDDR4Sim_Model=LPDDR4Sim(pads=pads,sys_clk_freq=system_clk_freq, cl=6, cwl=4, disable_delay=False, log_level="INFO")
    #LPDDR4 Phy Model
    phy=DoubleRateLPDDR4SimPHY(
        sys_clk_freq       = system_clk_freq,
        aligned_reset_zero = True,
        masked_write       = True
    )
    
    #ser_latency  = Latency(sys=Serializer.LATENCY)
    #des_latency  = Latency(sys=Deserializer.LATENCY)
    #phy=LPDDR4PHY(pads,phytype="LPDDR4SimPHY",ser_latency=ser_latency,des_latency=des_latency,sys_clk_freq=system_clk_freq)
    
    #config settings
    settings        = MySettings(**controller_settings)
    settings.geom   = MySettings(**geom_settings)
    settings.timing = LPDDR4Memory_Model.timing_settings
    settings.phy    = phy
    
    #generate verilog
    #litedram_bankmachine=BankMachine(8,7,4,1,settings)
    #litedram_controller=LiteDRAMController(phy,settings.geom,LPDDR4Memory_Model.timing_settings,system_clk_freq)
    litedram_core=LiteDRAMCore(phy,settings.geom,settings.timing,system_clk_freq)
    verilog.convert(litedram_core, litedram_core.ios,name="litedram_core").write("litedram_core_533e6.v")
    #verilog.convert(LPDDR4Memory_Model, LPDDR4Memory_Model.ios,name="MT53E256M16D1").write("MT53E256M16D1.v")
    #verilog.convert(LPDDR4Sim_Model,name="LPDDR4_MM").write("LPDDR4_MM.v")
    #verilog.convert(DFIAdapter,DFIAdapter.ios,name="DFIAdapter").write("DFIAdapter.v")
    #test
    #run_simulation(litedram_controller,mc_test(litedram_controller),vcd_name="simple_test.vcd")
    
        

if __name__ == "__main__":
    main()
