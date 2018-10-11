@ECHO OFF

setlocal enabledelayedexpansion enableextensions

REM ---------------------------------------
REM - PHPMND - PHP Magical Number         -
REM - @see https://github.com/povils/phpmnd -
REM ---------------------------------------

CLS

ECHO =========================================
ECHO = Running PHPMND                        =
ECHO = PHP Magical Number                    =
ECHO = @see https://github.com/povils/phpmnd =
ECHO =========================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

REM Get the folder of this current script.
REM Suppose that the ruleset.xml configuration file can be retrieved
REM from the current "script" folder which can be different of the
REM current working directory
SET ScriptFolder=%~dp0

CALL :fnProcessFolder %cd%

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO Process folder %1
ECHO.

REM Be sure that PHPMND (https://github.com/povils/phpmnd)
REM has been installed globally by using, first,
REM composer global require povils/phpmnd
REM If not, phpmnd won't be retrieved in the %APPDATA% folder


REM ECHO Command line options are
ECHO     %1 (scanned folder)
ECHO.

CALL %APPDATA%\Composer\vendor\bin\phpmnd %1 --process --hint

GOTO:EOF

::--------------------------------------------------------
::-- Show help instructions
::--------------------------------------------------------
:HELP

ECHO phpmnd.bat [-h]
ECHO.
ECHO -h : to get this screen
ECHO.

GOTO END:

:END
ECHO.
ECHO End
