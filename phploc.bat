@ECHO OFF

REM Author : AVONTURE Christophe

setlocal enabledelayedexpansion enableextensions

REM Define global variables
SET PROGNAME=PHPLOC
SET GITHUB=https://github.com/sebastianbergmann/phploc
SET COMPOSER=phploc/phploc
SET SCRIPT=%APPDATA%\Composer\vendor\bin\phploc.bat
SET BATCH=%~n0%~x0

CLS

ECHO ====================================================
ECHO = %PROGNAME% - Tool for quickly measuring the          =
ECHO = size of a PHP project                            =
ECHO = @see %GITHUB% =
ECHO ====================================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

IF NOT EXIST %SCRIPT% (
    GOTO NOTINSTALLED:
)

REM Check the if the script was called with a parameter and
REM in that case, this parameter is the name of a folder to scan
REM (scanFolderName will be empty or f.i. equal to "classes", a folder name)
SET scanFolderName=%cd%
IF "%1" NEQ "" (
	REM %1 is a foldername like "classes" (relative name); make it absolute
	SET scanFolderName=%cd%\%1
)

REM Process the folder
CALL :fnProcessFolder %scanFolderName%

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO Process folder %1
ECHO.

REM Define the name for the logfile for the analyzed folder
REM Will be phpstan_FOLDERNAME.log
CALL :getBaseName %1
SET outputFile=%tmp%\phploc_%BaseName%.log

REM Remove previous file just to be sure that an old version won't remains
IF EXIST %outputFile% (
    DEL %outputFile%
)


REM ECHO Command line options are
ECHO     %1 (scanned folder)
ECHO     --exclude vendor
ECHO.

CALL %SCRIPT% %1 --exclude vendor > %outputFile%

START chrome.exe %outputFile%

GOTO:EOF

::--------------------------------------------------------
::-- getBaseName - Get basename of a file/folder
::-- Return tests f.i. from C:\root\folder\tests
::--------------------------------------------------------
:getBaseName
SET getBaseName=%~n1

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

ECHO %BATCH% [-h] [foldername]
ECHO.
ECHO -h : to get this screen
ECHO.
ECHO foldername : if you want to scan all subfolders of your project, don't
ECHO specify a foldername. If you want to scan only one, mention his name like,
ECHO for instance, "%BATCH% Classes" for scanning only the Classes folder (case
ECHO not sensitive).
ECHO.

GOTO END:

:END
ECHO.
ECHO End
