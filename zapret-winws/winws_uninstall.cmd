@echo off
cd /d "%~dp0"

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Повышение прав. Пожалуйста, подтвердите запрос UAC.
    wscript elevator.vbs "%~f0"
    exit /b
)

set SERVICE_NAME=winws_optimized

net stop %SERVICE_NAME%
sc delete %SERVICE_NAME%

echo Служба %SERVICE_NAME% успешно удалена.
pause
exit /b
