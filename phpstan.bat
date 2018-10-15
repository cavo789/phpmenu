@ECHO OFF

REM Author : AVONTURE Christophe

setlocal enabledelayedexpansion enableextensions

REM Define global variables
SET PROGNAME=PHPSTAN
SET GITHUB=https://github.com/phpstan/phpstan
SET COMPOSER=phpstan/phpstan
SET SCRIPT=%APPDATA%\Composer\vendor\bin\phpstan.bat
SET BATCH=%~n0%~x0

CLS

ECHO ===========================================
ECHO = Running %PROGNAME%                         =
ECHO = PHP Static Analysis Tool                =
ECHO = @see %GITHUB% =
ECHO ===========================================
ECHO.

IF "%1"=="/?" GOTO :HELP
IF "%1"=="-?" GOTO :HELP
IF /I "%1"=="-h" GOTO :HELP


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

REM Get the rule level. 0 is the loosest and 7 is the strictest.
REM "max" is an alias for the highest level
SET LogLevel=3
IF NOT "%2" =="" (
    SET LogLevel=%2
)

REM Get the folder of this current script.
REM Suppose that the ruleset.xml configuration file can be retrieved
REM from the current "script" folder which can be different of the
REM current working directory
SET ScriptFolder=%~dp0

REM For phpstan, check if we've a file phpstan.neon in the current
REM working directory i.e. the one of the project phpstan.neon
REM If so, use that configuration file.
REM If not, use the phpstan.neon present in the folder of the phpstan.bat
REM script
SET CurrentFolder=%cd%

SET configFile=%CurrentFolder%\phpstan.neon

IF "%LogLevel%"=="max" (
    REM Use the MAX level file
    SET configFile=%CurrentFolder%\phpstanMax.neon

    IF NOT EXIST %configFile% (
        SET configFile=%ScriptFolder%phpstanMax.neon
    )
) ELSE (
    REM Use standard level from 0 till 7
    SET configFile=%CurrentFolder%\phpstan.neon

    IF NOT EXIST %configFile% (
        SET configFile=%ScriptFolder%phpstan.neon
    )
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

REM --level max is the highest control level (0 is the loosest and 7 is the strictest)
REM is https://github.com/phpstan/phpstan#rule-levels

REM ECHO Command line options are
ECHO     %1 (scanned folder)
ECHO     --level %LogLevel%
ECHO     -c %configFile% (configuration file used)
ECHO.

REM Define the name for the logfile for the analyzed folder
REM Will be phpstan_FOLDERNAME.log
CALL :getBaseName %1
SET outputFile=%tmp%\phpstan_%BaseName%.log

REM Remove previous file just to be sure that an old version won't remains
IF EXIST %outputFile% (
    DEL %outputFile%
)

REM Start PHPSTAN
CALL %SCRIPT% analyze %1 --level %LogLevel% -c %configFile% >> %outputFile%

REM Open Notepad; use START and not CALL because START will not wait by default
REM but only when there is something in the log
CALL :setFileSize %outputFile%

REM When the output logfile is empty, perfect, otherwise open Notepad
if %fileSize% LSS 1 (
    ECHO *** Wonderful! Everything is OK in folder %1 ***
) ELSE (
    REM !!! Warnings found in folder %1 !!!
    START notepad %outputFile%
)

ECHO.

GOTO:EOF

::--------------------------------------------------------
::-- setFileSize - Get file size
::-- Should be called with the full filename as parameter
::--------------------------------------------------------
:setFileSize
SET fileSize=%~z1

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

ECHO %BATCH% [-h] 
ECHO or
ECHO %BATCH% [foldername] [level]
ECHO.
ECHO -h : to get this screen
ECHO.
ECHO 1. foldername : if you want to scan all subfolders of your project, don't
ECHO specify a foldername. If you want to scan only one, mention his name like,
ECHO for instance, "%BATCH% Classes" for scanning only the Classes folder (case
ECHO not sensitive).
ECHO.
ECHO 2. rules level : PHPSTAN Rule levels can be from 0 (the loosest) till 7 (the strictest)
ECHO Default is "3"
ECHO.
ECHO Remarks
ECHO -------
ECHO.
ECHO If you want to use your own configuration file; create a phpstan.neon file
ECHO in your project's folder.

GOTO END:

:END
ECHO.
ECHO End
