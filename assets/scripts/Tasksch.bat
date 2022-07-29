@rem Event
@echo off
chcp 850
for /f "tokens=1,2 delims==" %%a in (C:\Users\user2\Salome\assets\scripts\config.ini) do (
    if %%a==mytime set mytime=%%b
    if %%a==day set day=%%b
)
schtasks /create /sc weekly /d %day% /tn hardtime /sd %date:~-10% /st %mytime% /tr C:\Users\user2\Salome\assets\scripts\Backup.bat
