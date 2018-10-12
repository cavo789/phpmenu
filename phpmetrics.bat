@ECHO OFF

REM Author : AVONTURE Christophe

setlocal enabledelayedexpansion enableextensions

REM Define global variables
SET PROGNAME=PHPMetrics
SET GITHUB=https://github.com/phpmetrics/PhpMetrics
SET COMPOSER=phpmetrics/phpmetrics
SET SCRIPT=%APPDATA%\Composer\vendor\bin\phpmetrics.bat
SET BATCH=%~n0%~x0

CLS

ECHO =================================================
ECHO = Running %PROGNAME%                            =
ECHO = Static analysis tool for PHP                  =
ECHO = @see %GITHUB% =
ECHO =================================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

IF NOT EXIST %SCRIPT% (
    GOTO NOTINSTALLED:
)

CALL :fnProcessFolder %cd%

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO Process folder %1
ECHO.

REM Define the name for the output folder
SET outputFolder=%tmp%\phpmetrics

REM Remove previous file just to be sure that an old version won't remains
IF EXIST %outputFolder% (
    DEL /Q /S %outputFolder%\*.* > NUL
)

REM ECHO Command line options are
ECHO     %1 (scanned folder)
ECHO     --report-html=%outputFolder% (output folder)
ECHO.

CALL %SCRIPT% %1 --report-html=%outputFolder%

START chrome.exe %outputFolder%\index.html

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

GOTO END:

:END

ECHO.
ECHO End
