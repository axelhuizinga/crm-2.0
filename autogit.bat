@echo off
SetLocal EnableDelayedExpansion
set CMessage=
for /F "delims=" %%i in (cmessage.txt) do set CMessage=!CMessage! %%i

echo %CMessage%
EndLocal
set /p  Version=<version
set /p  Build_ID=<build

echo %CMessage% > clast.txt
echo %Build_ID%
set /A  Build_ID=Build_ID+1
echo %Build_ID% >build
echo %Version%.%Build_ID%

git add -A
git commit -am "AutoCommit Build: %Version%+%Build_ID% %CMessage%"
git push
break>cmessage.txt

