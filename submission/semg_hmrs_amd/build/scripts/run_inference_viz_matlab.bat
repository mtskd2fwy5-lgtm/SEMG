@echo off
REM Visualize the baseline model inference chain with MATLAB.
REM Step 1: export model params from the joblib checkpoint to model_params.mat
REM Step 2: run the MATLAB script (forward pass + figure)
cd /d ./
python tools\export_model_mat.py || exit /b 1
"D:\MATLAB R2024b(64bit)\MATLAB\bin\matlab.exe" -batch "run('./\tools\visualize_inference.m')"

