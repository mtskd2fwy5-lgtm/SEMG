@echo off
setlocal
set "ROOT=%~dp0..\.."
set "VIVADO=D:\FPGA\VIVADO\2025.2\Vivado\bin"
set "OUT=%ROOT%\sim\results_lcd_input"
if not exist "%OUT%" mkdir "%OUT%"
cd /d "%OUT%"
call "%VIVADO%\xvlog.bat" -sv "%ROOT%\src\rtl\mpu6050_tilt.v" "%ROOT%\src\rtl\touch_gt911.v" "%ROOT%\sim\lcd_input_tb.sv" "%VIVADO%\..\data\verilog\src\glbl.v"
if errorlevel 1 exit /b 1
call "%VIVADO%\xelab.bat" --timescale 1ns/1ps -L unisims_ver lcd_input_tb glbl -s lcd_input_sim
if errorlevel 1 exit /b 1
call "%VIVADO%\xsim.bat" lcd_input_sim -runall -log simulate.log
if errorlevel 1 exit /b 1
findstr /c:"TEST_PASS LCD_INPUT" simulate.log >nul
if errorlevel 1 exit /b 1
findstr /c:"Fatal:" /c:"ERROR:" simulate.log >nul
if not errorlevel 1 exit /b 1
exit /b 0
