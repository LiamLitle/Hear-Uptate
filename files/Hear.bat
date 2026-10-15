@echo off
cd /d "%~dp0"
powershell -NoProfile -Command "Get-CimInstance Win32_Process | Where-Object { $_.Name -eq 'pythonw.exe' -and ($_.CommandLine -like '*hear.py*' -or $_.CommandLine -like '*voicetess.py*' -or $_.CommandLine -like '*hear_reglages_web.py*') } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }" >nul 2>&1
if not exist .venv\Scripts\python.exe (
    echo First setup, this can take a few minutes...
    py -3 -m venv .venv || python -m venv .venv
    .venv\Scripts\python.exe -m pip install --upgrade pip
)
fc /b requirements.txt .venv\req.ok >nul 2>&1
if errorlevel 1 (
    echo Installing dependencies...
    .venv\Scripts\python.exe -m pip install -r requirements.txt && copy /y requirements.txt .venv\req.ok >nul
)
if not exist .venv\clean.ok (
    .venv\Scripts\python.exe -m pip uninstall -y noisereduce matplotlib contourpy cycler kiwisolver fonttools pyparsing python-dateutil joblib >nul 2>&1
    echo ok > .venv\clean.ok
)
.venv\Scripts\python.exe -c "import keyboard, pystray, PIL, sounddevice, pyperclip, uiautomation, onnx_asr, scipy, webview" || (echo. & echo Something is missing, please send me the error above. & pause & exit /b 1)
start "" .venv\Scripts\pythonw.exe hear.py
