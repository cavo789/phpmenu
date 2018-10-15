@ECHO OFF

REM Author : AVONTURE Christophe

setlocal enabledelayedexpansion enableextensions

REM Define global variables
SET PROGNAME=PHPDOC
SET GITHUB=https://github.com/phpDocumentor/phpDocumentor2
SET SCRIPT=%APPDATA%\Composer\vendor\bin\phpDocumentor.phar
SET BATCH=%~n0%~x0

CLS

ECHO ========================================================
ECHO = %PROGNAME% - Documentation Generator for PHP             =
ECHO = @see %GITHUB% =
ECHO ========================================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

IF NOT EXIST %SCRIPT% (
    GOTO NOTINSTALLED:
)

REM For phpdoc, check if we've a file phpdoc.xml in the current
REM working directory i.e. the one of the project.
REM If so, use that configuration file.
REM If not, use the phpdoc.xml present in the folder of the phpdoc.bat
REM script
SET configFile=%cd%\phpdoc.xml
IF NOT EXIST %configFile% (
    SET configFile=%ScriptFolder%phpdoc.xml
)

REM ECHO Command line options are
ECHO     --config=%configFile%
ECHO     --progressbar (show progress)
ECHO     -t docs (target folder will be 'docs')
ECHO.

php %SCRIPT% run --config=%configFile% --progressbar -t docs

START chrome.exe %cd%\docs\index.html

GOTO:EOF

::--------------------------------------------------------
::-- Not installed
::--------------------------------------------------------
:NOTINSTALLED

ECHO %PROGNAME% (%GITHUB%) is not installed
ECHO on your machine. Since phpDocumentor2 should be installed manually, please do:
ECHO.
ECHO 1. Go to %GITHUB%/releases and take the latest release
ECHO 2. Download both the `phpDocumentor.phar` and `phpDocumentor.phar.pubkey` files
ECHO 3. Go to your `%APPDATA%\Composer\Vendor\Bin\` folder and save the two files there 
ECHO.

GOTO END:

::--------------------------------------------------------
::-- Show help instructions
::--------------------------------------------------------
:HELP

ECHO %BATCH% [-h] [foldername]
ECHO.
ECHO -h : to get this screen
ECHO.

GOTO END:

:END
ECHO.
ECHO End
