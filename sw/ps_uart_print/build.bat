@echo off
rem Build the PS bare-metal stream monitor with Vivado's bundled ARM GCC.
rem Output: ps_uart_print.elf (downloaded to the board by run_xsct.tcl).

setlocal
set GCC=D:\FPGA\VIVADO\2025.2\gnu\aarch32\nt\gcc-arm-none-eabi\bin\arm-none-eabi-gcc.exe
cd /d "%~dp0"

"%GCC%" -mcpu=cortex-a9 -marm -mfloat-abi=soft -ffreestanding -nostdlib ^
    -O2 -Wall -Wextra -Wl,--build-id=none -T lscript.ld ^
    -o ps_uart_print.elf main.c startup.S -lgcc

if errorlevel 1 (
    echo BUILD FAILED
    exit /b 1
)
echo BUILD OK: ps_uart_print.elf
