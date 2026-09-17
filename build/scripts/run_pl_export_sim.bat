@echo off
setlocal

set "PROJECT_ROOT=%~dp0..\.."
set "VIVADO_ROOT=D:\FPGA\VIVADO\2025.2\Vivado"
set "RESULT_DIR=%PROJECT_ROOT%\sim\results"

if not exist "%VIVADO_ROOT%\bin\xvlog.bat" (
    echo Vivado simulator not found: %VIVADO_ROOT%\bin\xvlog.bat
    exit /b 1
)

if not exist "%RESULT_DIR%\export_stim.txt" (
    echo stimulus missing, generating export_stim.txt ...
    python "%PROJECT_ROOT%\tools\emg_reference.py" gen
    if errorlevel 1 exit /b 1
)
cd /d "%RESULT_DIR%"

call "%VIVADO_ROOT%\bin\xvlog.bat" -work work ^
    "%PROJECT_ROOT%\src\rtl\ads1299_spi.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_bandpass.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_window_features.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_feature_bank.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_nn_infer.v" ^
    "%PROJECT_ROOT%\src\rtl\axis_async_fifo.v" ^
    "%PROJECT_ROOT%\src\rtl\axis_packet_mux.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_data_path.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_pl_export.v" ^
    "%PROJECT_ROOT%\sim\emg_pl_export_tb.v"
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xelab.bat" emg_pl_export_tb -s emg_pl_export_sim -debug typical
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xsim.bat" emg_pl_export_sim -runall
if errorlevel 1 exit /b 1

python "%PROJECT_ROOT%\tools\check_pl_nn_sim.py"
exit /b %errorlevel%
