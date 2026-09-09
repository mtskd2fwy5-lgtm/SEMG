@echo off
setlocal

set "PROJECT_ROOT=%~dp0..\.."
set "VIVADO_ROOT=D:\FPGA\VIVADO\2025.2\Vivado"
set "RESULT_DIR=%PROJECT_ROOT%\sim\results"

if not exist "%VIVADO_ROOT%\bin\xvlog.bat" (
    echo Vivado simulator not found: %VIVADO_ROOT%\bin\xvlog.bat
    exit /b 1
)

if not exist "%RESULT_DIR%" mkdir "%RESULT_DIR%"
cd /d "%RESULT_DIR%"

call "%VIVADO_ROOT%\bin\xvlog.bat" -work work ^
    "%PROJECT_ROOT%\src\rtl\ads1299_spi.v" ^
    "%PROJECT_ROOT%\sim\ads1299_functional_tb.v"
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xelab.bat" ads1299_functional_tb -s ads1299_sim -debug typical
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xsim.bat" ads1299_sim -runall
exit /b %errorlevel%
