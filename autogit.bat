@echo off
echo %1 %2
rem exit /b 0
set /p  Version=<version
set /p  Build_ID=<build
echo %Build_ID%
set /A  Build_ID=Build_ID+1
echo %Build_ID% >build
echo %Version%.%Build_ID%

git add -A
git commit -am "AutoCommit Build: %Version%+%Build_ID% %1"
git push