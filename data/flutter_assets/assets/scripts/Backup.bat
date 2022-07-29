start \b C:\Users\user2\Salome\build\windows\runner\Release\data\flutter_assets\assets\scripts\load.exe \\.\D:
set mydate=%DATE:~3,2%-%DATE:~0,2%-%DATE:~6,4%
xcopy /y /o /e /d:%mydate% "C:\" "D:\"
start \b C:\Users\user2\Salome\build\windows\runner\Release\data\flutter_assets\assets\scripts\eject.exe \\.\D: