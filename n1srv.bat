@echo off
:loop
echo ;---------------------------;
echo ;        New Session        ;
echo ;---------------------------;
nc.exe -v -v -n -L -p 20021 < welcome.txt
pause > nul
echo ;= = = = = = = = = = = = = =;
goto loop
