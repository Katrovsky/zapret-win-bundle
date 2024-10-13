@echo off
cd /d "%~dp0"
:: Проверка на наличие прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Повышение прав. Пожалуйста, подтвердите запрос UAC.
    wscript elevator.vbs "%~f0"
    exit /b
)

set ARGS=--wf-tcp=80,443 --wf-udp=443,50000-65535 ^
--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=9 --new ^
--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --dpi-desync=fake,split --dpi-desync-fooling=badseq --new ^
--filter-udp=50000-65535 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d2"

call :srvinst winws_optimized
echo Служба успешно установлена и запущена.
pause
exit /b

:srvinst
net stop %1
sc delete %1
sc create %1 binPath= "\"%~dp0winws.exe\" %ARGS%" DisplayName= "zapret DPI bypass : %1" start= auto
sc description %1 "zapret DPI bypass software"
sc start %1
goto :eof
