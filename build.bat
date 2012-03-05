R CMD INSTALL rmongodb
if not errorlevel 1 goto Done
echo ERROR
:Done
