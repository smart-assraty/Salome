@rem Script for Nikolai
@echo off
for /f "tokens=1,2 delims==" %%a in (C:\Users\smartassraty\FlutterProject\lib\scripts\config.ini) do (
    if %%a==wayToFiles set wayToFiles=%%b
    if %%a==wayToDisk set wayToDisk=%%b
    if %%a==disk set disk=%%b
)
ForFiles /p "%wayToFiles%" /s /c "cmd /c del @file /f /q" /d -60
start D:\Release\scripts\load.exe \\.\%disk%
xcopy %wayToFiles%\ %wayToDisk%
start D:\Release\scripts\eject.exe \\.\%disk%