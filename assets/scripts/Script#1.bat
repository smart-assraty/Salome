@rem Script for Nikolai
@echo off
for /f "tokens=1,2 delims==" %%a in (C:\Users\user2\Salome\assets\scripts\config.ini) do (
    if %%a==wayToFiles set wayToFiles=%%b
    if %%a==wayToDisk set wayToDisk=%%b
    if %%a==disk set disk=%%b
)
start C:\Users\user2\Salome\assets\scripts\load.exe \\.\%disk%
xcopy %wayToFiles%\ %wayToDisk%
start C:\Users\user2\Salome\assets\scripts\eject.exe \\.\%disk%