@echo off
setlocal

set "PROJECT_ROOT=%~dp0..\.."
set "VIVADO_ROOT=<amd-tools>\Vivado"
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
    "%PROJECT_ROOT%\src\rtl\emg_notch50.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_comb50.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_line_filter.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_bandpass.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_window_features.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_feature_bank.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_nn_infer.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_fatigue.v" ^
    "%PROJECT_ROOT%\src\rtl\axis_async_fifo.v" ^
    "%PROJECT_ROOT%\src\rtl\axis_packet_mux.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_data_path.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_pl_export.v" ^
    "%PROJECT_ROOT%\src\rtl\emg_pl_export_status.v" ^
    "%PROJECT_ROOT%\sim\ads1299_model.v" ^
    "%PROJECT_ROOT%\sim\emg_pl_export_tb.v"
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xelab.bat" emg_pl_export_tb -s emg_pl_export_sim -debug typical
if errorlevel 1 exit /b 1

call "%VIVADO_ROOT%\bin\xsim.bat" emg_pl_export_sim -runall -log emg_pl_export_bias.log
if errorlevel 1 exit /b 1
findstr /c:"TEST_PASS EMG export" emg_pl_export_bias.log >nul
if errorlevel 1 exit /b 1

python "%PROJECT_ROOT%\tools\check_pl_nn_sim.py"
exit /b %errorlevel%

