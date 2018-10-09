@echo off
cls

echo =============================
echo = Running PHAN              =
echo =============================

%APPDATA%\Composer\vendor\bin\phan.bat --allow-polyfill-parser
