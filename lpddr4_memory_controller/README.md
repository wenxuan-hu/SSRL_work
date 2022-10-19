# ASIC LPDDR4 Memory Controller based on LiteDRAM. 

## Features

1. Modified originial python script for LPDDR4 1:4 clock frequency ratio.
2. Parameterize each module. Use CSR to dynamically adjust timing parameters and constraints. Add external AHB-lite interface for CSR load and store.
3. Add tCCDMW (masked-write) support and tRTP (read to precharge).
4. Add DFIAdapter to translate original DFI commands into LPDDR4 commands to make it easier to be integrated with open-source LPDDR4 PHY like Wavious-wddr-phy: https://github.com/waviousllc/wav-lpddr-hw.
5. Custom verilog generation python script for each submodule.
6. UVM testbench for each submodule and top level.

## How to use
### Verilog Generation
To generate the verilog code of each module:
- Clone original LiteDRAM repo and replace the python source code in litedram/core with files in /core in this repo. Notice some files like commands.py, common.py, dfi.py may be placed in other dictories.

- cd into `./gen` and use `python3 <gen_.py> <args>`
For example: 

```bash
python3 gen_multiplexer_8.py 8
```
### UVM test
To use synopsys VCS to test specific module, use
```bash
cd verif
make sim <module_name>
```