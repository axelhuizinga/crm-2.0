@echo off
set n="$(cat <<-EOF

EOF
)"
rem exit /b 0
set /p  Version=<version
set /p  Build_ID=<build
set /p CMessage=<.cmessage
echo %CMessage% > .cmessage.bak
echo %Build_ID%
set /A  Build_ID=Build_ID+1
echo %Build_ID% >build
echo %Version%.%Build_ID%

git add -A
git commit -am "AutoCommit Build: %Version%+%Build_ID% %CMessage%"
git push
break>.cmessage

