start \b C:\Users\user2\Salome\assets\scripts\load.exe \\.\D:
set mydate=%DATE:~3,2%-%DATE:~0,2%-%DATE:~6,4%
xcopy /y /o /e /d:%mydate% "C:\asdfsdf" "D:\sdfsjfl"
start \b C:\Users\user2\Salome\assets\scripts\eject.exe \\.\D: