@ECHO OFF

setlocal enabledelayedexpansion enableextensions

REM -------------------------------------------------
REM - PHPMetrics - Static analysis tool for PHP     -
REM - @see https://github.com/phpmetrics/PhpMetrics -
REM -------------------------------------------------

CLS

ECHO ================================================
ECHO = Running PHPMetrics                           =
ECHO = Static analysis tool f PHP                   =
ECHO = @see https://github.com/phpmetrics/PhpMetric =
ECHO ================================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

CALL :fnProcessFolder %cd%

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO Process folder %1
ECHO.

REM Be sure that PHPMetrics (https://github.com/phpmetrics/PhpMetrics)
REM has been installed globally by using, first,
REM composer global require phpmetrics/phpmetrics
REM If not, phpmetrics won't be retrieved in the %APPDATA% folder

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

CALL %APPDATA%\Composer\vendor\bin\phpmetrics %1 --report-html=%outputFolder%

START chrome.exe %outputFolder%\index.html

GOTO:EOF

::--------------------------------------------------------
::-- Show help instructions
::--------------------------------------------------------
:HELP

ECHO phpmetrics.bat [-h]
ECHO.
ECHO -h : to get this screen

GOTO END:

:END
ECHO.
ECHO End
