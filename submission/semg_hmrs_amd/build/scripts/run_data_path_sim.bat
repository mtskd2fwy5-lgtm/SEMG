@echo off
setlocal

set "PROJECT_ROOT=%~dp0..\.."
set "VIVADO_ROOT=<amd-tools>\Vivado"
set "RESULT_DIR=%PROJECT_ROOT%\sim\results_data_path"

if not exist "%VIVADO_ROOT%\bin\xvlog.bat" (
    echo Vivado simulator not found: %VIVADO_ROOT%\bin\xvlog.bat
    exit /b 1
)

if not exist "%RESULT_DIR%" mkdir "%RESULT_DIR%"
cd /d "%RESULT_DIR%"

call "%VIVADO_ROOT%\bin\xvlog.bat" -work work ^
    "%PROJECT_ROOT%\src\rtl\axis_async_fifo.v" ^
    "%PROJECT_ROOT%\src\rtl\axis_packet_mux.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_data_path.v" ^
    "%PROJECT_ROOT%\sim\emg_data_path_tb.v"
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xelab.bat" emg_data_path_tb -s emg_data_path_sim
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xsim.bat" emg_data_path_sim -runall -log data_path_sim.log
if errorlevel 1 exit /b 1
findstr /c:"TEST_PASS data_path:" data_path_sim.log >nul
if errorlevel 1 exit /b 1
exit /b 0

