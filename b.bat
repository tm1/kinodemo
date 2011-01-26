@echo off
rem dcc32 -I"C:\Program Files\Borland\Delphi5\lib" -R"C:\Program Files\Borland\Delphi5\lib" demo4
dcc32 -M -U"C:\Delphi\Lib" -R"C:\Program Files\Borland\Delphi5\lib" demo4
rem del *.dcu > nul
call c.bat