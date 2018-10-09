@echo off

setlocal enabledelayedexpansion enableextensions

REM ------------------------------------------------------------
REM - PHP-STAN - Start PHPSTAN (PHP Static Analysis Tool) on   -
REM - each subfolder of the current working                    -
REM - @see https://github.com/phpstan/phpstan                  -
REM ------------------------------------------------------------

cls

echo ===================================
echo = Running PHPSTAN                 =
echo ===================================

REM Get the folder of this current script. 
REM Suppose that the ruleset.xml configuration file can be retrieved
REM from the current "script" folder which can be different of the 
REM current working directory
SET ScriptFolder=%~dp0

REM Process the working folder
CALL :fnProcessFolder %cd%

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

REM Be sure that PHPSTAN (https://github.com/phpstan/phpstan)
REM has been installed globally by using, first, 
REM composer global require phpstan/phpstan
REM If not, php-cs-fixer won't be retrieved in the %APPDATA% folder

REM --level max is the highest control level (0 is the loosest and 7 is the strictest) 
REM is https://github.com/phpstan/phpstan#rule-levels
call %APPDATA%\Composer\vendor\bin\phpstan analyze %1 --level max -c %ScriptFolder%phpstan.neon

goto:eof

:END
ECHO.

ECHO End
