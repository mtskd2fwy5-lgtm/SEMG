@echo off
REM Run this BEFORE every Vitis IDE debug launch (after the first power-on).
REM It halts the core so the IDE's bitstream download can never hang the bus
REM (an app polling the PL DMA gets hung the instant the PL is cleared).
REM After this, just launch the debugger in the IDE as usual.
"D:\FPGA\VIVADO\2025.2\Vitis\bin\xsct.bat" "%~dp0dbg_stop.tcl"
