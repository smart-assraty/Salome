@rem Event
@echo off
chcp 850
<<<<<<< HEAD
::Берем значения с конфига
::for /f "tokens=1,2 delims==" %%a in (E:\flutterfiles\lib\configTimeStart.ini) do (
::    if %%a==mytime set mytime=%%b
::)
schtasks /create /sc weekly /d SAT /tn hardtime /sd %date:~-10% /st 10:10 /tr c:\Windows\System32\bat.bat
=======
for /f "tokens=1,2 delims==" %%a in (C:\Users\user2\Salome\assets\scripts\config.ini) do (
    if %%a==mytime set mytime=%%b
    if %%a==day set day=%%b
)
schtasks /create /sc weekly /d %day% /tn hardtime /sd %date:~-10% /st %mytime% /tr C:\Users\user2\Salome\assets\scripts\Backup.bat
>>>>>>> 1b4da43d5dac3742e506c65c0838f27acda9e230
