@ECHO OFF

REM Author : AVONTURE Christophe

setlocal enabledelayedexpansion enableextensions

REM Define global variables
SET PROGNAME=PHP Compatibility
SET GITHUB=https://github.com/PHPCompatibility/PHPCompatibility
SET COMPOSER=phpcompatibility/php-compatibility
SET SCRIPT=%APPDATA%\Composer\vendor\bin\phpcs.bat
SET BATCH=%~n0%~x0

CLS

ECHO =============================================================
ECHO = Running %PROGNAME% with PHP-CodeSniffer            =
ECHO = PHP Check compatibility                                   =
ECHO = Make sure PHPCS is already installed                      =
ECHO = @see %GITHUB% =
ECHO =============================================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

IF NOT EXIST %SCRIPT% (
    GOTO NOTINSTALLED:
)

IF NOT EXIST %APPDATA%\Composer\vendor\phpcompatibility (
    GOTO NOTINSTALLED:
)

REM Check the if the script was called with a parameter and
REM in that case, this parameter is the name of a folder to scan
REM (scanOnlyFolderName will be empty or f.i. equal to "classes", a folder name)
SET scanOnlyFolderName=%1
IF "%scanOnlyFolderName%" EQU "." (
    SET scanOnlyFolderName=
)

REM
SET phpVERSION=%2
IF "%phpVERSION%" equ "" (
    SET phpVERSION=7.2
)

REM Get the folder of this current script.
REM Suppose that the ruleset.xml configuration file can be retrieved
REM from the current "script" folder which can be different of the
REM current working directory
SET ScriptFolder=%~dp0

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

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO Process folder %1
ECHO.

REM Define the name for the logfile for the analyzed folder
REM Will be phpcs_FOLDERNAME.log
SET outputFile=%tmp%\phpcs_%1.log

REM Remove previous file just to be sure that an old version won't remains
IF EXIST %outputFile% (
    DEL %outputFile%
)

REM ECHO Command line options are
ECHO     %1 (scanned folder)
ECHO     testVersion %phpVERSION% (PHP version to check)
ECHO.

REM CALL %SCRIPT% --config-set installed_paths %APPDATA%\Composer\vendor\phpcompatibility\php-compatibility\PHPCompatibility
CALL %SCRIPT% %1 --standard=%APPDATA%\Composer\vendor\phpcompatibility\php-compatibility\PHPCompatibility --runtime-set testVersion %phpVERSION% >> %outputFile%

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
::-- Not installed
::--------------------------------------------------------
:NOTINSTALLED

ECHO %PROGNAME% (%GITHUB%) is not installed
ECHO on your machine. Please run the following command from a DOS prompt:
ECHO.
ECHO composer global require %COMPOSER%
ECHO.
ECHO Make also sure that you've PHPCS installed:
ECHO.
ECHO composer global require squizlabs/php_codesniffer
ECHO.

GOTO END:

::--------------------------------------------------------
::-- Show help instructions
::--------------------------------------------------------
:HELP

ECHO %BATCH% [-h] [foldername] [php_version]
ECHO.
ECHO -h : to get this screen
ECHO.
ECHO foldername : if you want to scan all subfolders of your project, don't
ECHO specify a foldername. If you want to scan only one, mention his name like,
ECHO for instance, "%BATCH% Classes" for scanning only the Classes folder (case
ECHO not sensitive).
ECHO
ECHO php_version : the version to check for instance, "%BATCH% Classes 7.2" for checking
ECHO the compatibility of the folder for PHP 7.2.

GOTO END:

:END
ECHO.

ECHO End
