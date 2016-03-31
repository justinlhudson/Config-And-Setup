@echo off

:: create new user area
set _userDataArea=%LOCALAPPDATA%\Google\Chrome\User Data\
set _randomArea=c:\temp\%RANDOM%

echo %_userDataArea%
echo %_randomArea%

mkdir %_randomArea%
copy "%_userDataArea%"\* "%_randomArea%" /y 
start chrome.exe --user-data-dir=%_randomArea%
