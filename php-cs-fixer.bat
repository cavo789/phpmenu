@ECHO OFF

REM Author : AVONTURE Christophe

setlocal enabledelayedexpansion enableextensions

REM Define global variables
SET PROGNAME=PHP-CS-FIXER
SET GITHUB=https://github.com/FriendsOfPHP/PHP-CS-Fixer
SET COMPOSER=friendsofphp/php-cs-fixer
SET SCRIPT=%APPDATA%\Composer\vendor\bin\php-cs-fixer
SET BATCH=%~n0%~x0

CLS

ECHO ===========================================================
ECHO = Running %PROGNAME%                                    =
ECHO = A tool to automatically fix PHP coding standards issues =
ECHO = @see %GITHUB%       =
ECHO ===========================================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

IF NOT EXIST %SCRIPT% (
    GOTO NOTINSTALLED:
)

REM Check the if the script was called with a parameter and
REM in that case, this parameter is the name of a folder to scan
REM (scanOnlyFolderName will be empty or f.i. equal to "classes", a folder name)
SET scanOnlyFolderName=%1

REM Get the folder of this current script.
REM Suppose that the .php-cs configuration file can be retrieved
REM from the current "script" folder which can be different of the
REM current working directory
SET ScriptFolder=%~dp0

REM For php-cs-fixer, check if we've a file .php-cs in the current
REM working directory i.e. the one of the project .php-cs
REM If so, use that configuration file.
REM If not, use the .php-cs present in the folder of the php-cs-fixer.bat
REM script
SET configFile=%cd%\.php-cs
IF NOT EXIST %configFile% (
    SET configFile=%ScriptFolder%.php-cs
)

REM -------------------------------------------------------
REM - Populate the list of folders that should be ignored -
REM -------------------------------------------------------

REM Initialize the list of folders that should be ignored
REM @see https://stackoverflow.com/a/18869970/1065340

SET "file=%ScriptFolder%.phpmenu-ignore"
IF EXIST %file% (
    SET /A i=0

    FOR /F "usebackq delims=" %%a in ("%file%") do (
        SET /A i+=1
        CALL SET arrIgnore[%%i%%]=%%a
        CALL SET n=%%i%%
    )
)

SET lastindex=%i%

REM ---------------------------------------------------------
REM - Get the list of subfolders of the current working dir -
REM ---------------------------------------------------------

FOR /d %%d IN (*.*) DO (

    SET "bContinue=true"

    REM %%d contains a folder name like f.i. "assets"
    REM Check if the folder should be scanned

    REM 1. No if a foldername was mentionned as parameter of this
    REM script telling that only that folder should be
    REM processed and that folder is not the processed one (i.e. %%d)

    IF "%scanOnlyFolderName%" NEQ "" (
        REM IF /I for case insensitive check
        IF /I "%scanOnlyFolderName%" NEQ "%%d" (
            ECHO Ignore folder %%d
            SET "bContinue=false"
        )
    )

    REM 2. If bContinue is still true, check if the folder name
    REM    is mentionned in the array of folders to ignore
    IF "!bContinue!" equ "true" (
        SET foldername=%%d

        FOR /L %%f IN (0, 1, !lastindex!) DO (
            REM IF /I for case insensitive check
            IF /I %%d == !arrIgnore[%%f]! (
                ECHO Ignore folder %%d
                REM We can ignore the folder
                SET "bContinue=false"
            )
        )
    )

    IF "!bContinue!" equ "true" (
        CALL :fnProcessFolder %%d
    )
)

REM And process the root folder
IF "%scanOnlyFolderName%" EQU "" (
    CALL :fnProcessFolder . -l
)

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO.
ECHO Process folder %1
ECHO.

REM ECHO Command line options are
ECHO     fix %1 (scanned folder)
ECHO     --config=%configFile% (configuration file used)
ECHO.

CALL %SCRIPT% fix %1 --show-progress=none --verbose --config=%configFile%

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

ECHO %BATCH%.bat [-h] [foldername]
ECHO.
ECHO -h : to get this screen
ECHO.
ECHO foldername : if you want to scan all subfolders of your project, don't
ECHO specify a foldername. If you want to scan only one, mention his name like,
ECHO for instance, "%BATCH% Classes" for scanning only the Classes folder (case
ECHO not sensitive).
ECHO.
ECHO Remarks
ECHO -------
ECHO.
ECHO If you want to use your own configuration file; create a .php-cs file
ECHO in your project's folder.

GOTO END:
:END
ECHO.

ECHO End
