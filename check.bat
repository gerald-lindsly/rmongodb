rd /s/q rmongodb\src-i386
rd /s/q rmongodb\src-x64
R CMD check rmongodb
if not errorlevel 1 goto Done
echo ERROR
:Done
