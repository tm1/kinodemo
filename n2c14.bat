@echo off
:loop
echo ;---------------------------;
echo ;        New Session        ;
echo ;---------------------------;
nc.exe -v -v -n 192.168.10.14 20021
echo ;= = = = = = = = = = = = = =;
pause > nul
goto loop