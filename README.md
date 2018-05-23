# myDAC_FPGA
The FPGA implementation of the myDAC project, originally written for the EE2020 course project in NUS.

## Implementation
This project is written for a Xilinx XC7A35T FPGA, on a Digilent Basys 3 development board. Main part of the HDL code is written in Verilog, except some imported driver code in VHDL.

Some Xilinx IPs provided along with Vivado are used in this project as well, however not included in this repository since the source is encrypted and the files are too large.

The hardware target works with a controller program [myDAC_SerialHost](https://github.com/thefoggycity/myDAC_SerialHost), to generate arbitary wave.

## Disclaimer
- This project *DOES NOT come with a licence*, due to various reasons such as involving IP cores, driver modules, and the project itself is a course project. You may take the upload code as reference. Reuse of Verilog code is permitted, however please refrain from copying it for the EE2020/EE2026 modules offered in NUS.

- The code is provided *AS IS*. Absolutely no warranty is provided with the code, and under no case the author will be hold liable for any loss due to usage of the given code.
