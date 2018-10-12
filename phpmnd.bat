@ECHO OFF

REM Author : AVONTURE Christophe

setlocal enabledelayedexpansion enableextensions

REM Define global variables
SET PROGNAME=PHPMND
SET GITHUB=https://github.com/povils/phpmnd
SET COMPOSER=povils/phpmnd
SET SCRIPT=%APPDATA%\Composer\vendor\bin\phpmnd.bat
SET BATCH=%~n0%~x0

CLS

ECHO =========================================
ECHO = Running %PROGNAME%                        =
ECHO = PHP Magical Number                    =
ECHO = @see %GITHUB% =
ECHO =========================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

IF NOT EXIST %SCRIPT% (
    GOTO NOTINSTALLED:
)

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

REM ECHO Command line options are
ECHO     %1 (scanned folder)
ECHO.

CALL %SCRIPT% %1 --progress --hint

GOTO:EOF

::--------------------------------------------------------
::-- Not installed
::--------------------------------------------------------
:NOTINSTALLED

ECHO %PROGNAME% (%GITHUB%) is not installed
ECHO on your machine. Please run the following command from a DOS prompt:
ECHO.
ECHO composer global require %COMPOSER%
ECHO.
ECHO After a while, the program will be installed in your %APPDATA%\Composer folder.

GOTO END:

::--------------------------------------------------------
::-- Show help instructions
::--------------------------------------------------------
:HELP

ECHO %BATCH% [-h]
ECHO.
ECHO -h : to get this screen
ECHO.

GOTO END:

:END
ECHO.
ECHO End
