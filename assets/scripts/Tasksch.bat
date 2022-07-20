@rem Event
@echo off
chcp 850
::Берем значения с конфига
::for /f "tokens=1,2 delims==" %%a in (E:\flutterfiles\lib\configTimeStart.ini) do (
::    if %%a==mytime set mytime=%%b
::)
schtasks /create /sc weekly /d SAT /tn hardtime /sd %date:~-10% /st 10:10 /tr c:\Windows\System32\bat.bat