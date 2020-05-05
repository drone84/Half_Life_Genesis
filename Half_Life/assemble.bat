@echo off

REM md ..\bin
REM md ..\bin\debug
REM md ..\bin\debug\roms

:start
del *.lst
64tass --m65816 game-main.asm --long-address --flat  -b -o game-main.bin --list game-main.lst
64tass --m65816 game-main.asm --long-address --flat  --intel-hex -o game-main.hex --list game-main_hex.lst
if errorlevel 1 goto fail

REM copy kernel.hex ..\bin\debug\roms
REM copy kernel.lst ..\bin\debug\roms

:fail
choice /m "Try again?"
if errorlevel 2 goto end
goto start

:end
echo END OF LINE
