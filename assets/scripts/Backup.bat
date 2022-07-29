start \b C:\Users\user2\Salome\assets\scripts\load.exe \\.\D:
set mydate=%DATE:~3,2%-%DATE:~0,2%-%DATE:~6,4%
for /f "tokens=1,2 delims==" %%a in (C:\Users\user2\Salome\assets\scripts\config.ini) do (
    if %%a==way set way=%%b
    if %%a==disk set disk=%%b
)
xcopy /y /o /e /d:%mydate% "%way%" "%disk%"
start \b C:\Users\user2\Salome\assets\scripts\eject.exe \\.\D: