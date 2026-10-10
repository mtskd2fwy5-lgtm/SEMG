@echo off
rem Build a standalone Zynq boot image: FSBL + bitstream + PS application.
rem Run from any directory after the implementation bitstream and ELF exist.

setlocal
set ROOT=%~dp0..\..
set BOOTGEN=D:\FPGA\VIVADO\2025.2\Vitis\bin\bootgen.bat
set BIF=%ROOT%\build\boot\boot_image.bif
set OUT=%ROOT%\build\boot\BOOT.BIN

if not exist "%BOOTGEN%" (
    echo BOOTGEN NOT FOUND: %BOOTGEN%
    exit /b 1
)
if not exist "%ROOT%\build\vitis_ws\platform\export\platform\sw\boot\fsbl.elf" (
    echo FSBL NOT FOUND
    exit /b 1
)
if not exist "%ROOT%\build\vivado\hand_motion_reconstruction.runs\impl_1\design_1.bit" (
    echo BITSTREAM NOT FOUND
    exit /b 1
)
if not exist "%ROOT%\sw\ps_uart_print\ps_uart_print.elf" (
    echo CURRENT PS ELF NOT FOUND
    exit /b 1
)

pushd "%ROOT%"
call "%BOOTGEN%" -arch zynq -image "%BIF%" -w -o i "%OUT%"
set RC=%ERRORLEVEL%
popd

if not "%RC%"=="0" (
    echo BOOT.BIN BUILD FAILED
    exit /b %RC%
)
echo BOOT.BIN READY: %OUT%
