for /f "tokens=1,2 delims==" %%a in (C:\Users\smartassraty\FlutterProject\lib\scripts\config.ini) do (
    if %%a==mytime set mytime=%%b
    if %%a==script set script=%%b
    if %%a==day set day==%%b
)
schtasks /create /sc weekly /d %day% /tn hardtime /sd %date% /st %mytime% /tr %script%
echo %errorlevel%