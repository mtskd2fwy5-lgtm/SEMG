@echo off
rem Build the PS bare-metal stream monitor with Vivado's bundled ARM GCC.
rem Output: ps_uart_print.elf (downloaded to the board by run_xsct.tcl).

setlocal
set GCC=D:\FPGA\VIVADO\2025.2\gnu\aarch32\nt\gcc-arm-none-eabi\bin\arm-none-eabi-gcc.exe
set EMB=D:\FPGA\VIVADO\2025.2\data\embeddedsw
set SDPS=%EMB%\XilinxProcessorIPLib\drivers\sdps_v4_5\src
set STANDALONE=%EMB%\lib\bsp\standalone_v9_4\src
set FATFS=%EMB%\lib\sw_services\xilffs_v5_5\src
cd /d "%~dp0"
set CONTROL_FLAGS=
set APP_ELF=ps_uart_print.elf
if "%~1"=="--pl-control" (
    set CONTROL_FLAGS=-DPL_CONTROL_ENABLE=1
    set APP_ELF=ps_uart_print_pl_control.elf
)

"%GCC%" -mcpu=cortex-a9 -marm -mfloat-abi=soft -ffreestanding -nostdlib ^
    -DNDEBUG -DFILE_SYSTEM_INTERFACE_SD %CONTROL_FLAGS% ^
    -O2 -Wall -Wextra -Wl,--build-id=none -T lscript.ld ^
    -Isd_support -I"%FATFS%\include" -I"%SDPS%" ^
    -I"%STANDALONE%\common" -I"%STANDALONE%\arm\cortexa9" ^
    -I"%STANDALONE%\arm\common\gcc" ^
    -o %APP_ELF% main.c sd_record.c startup.S display_memory.S ^
    "%SDPS%\xsdps.c" "%SDPS%\xsdps_card.c" "%SDPS%\xsdps_host.c" "%SDPS%\xsdps_options.c" ^
    "%FATFS%\ff.c" "%FATFS%\ffunicode.c" "%FATFS%\ffsystem.c" -lgcc

if errorlevel 1 (
    echo BUILD FAILED
    exit /b 1
)
echo BUILD OK: %APP_ELF%
