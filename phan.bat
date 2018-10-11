@ECHO OFF

setlocal enabledelayedexpansion enableextensions

REM --------------------------------------------------
REM - PHAN - Scan all folders of the current working -
REM - directory and report errors                    -
REM - @see https://github.com/phan/phan              -
REM --------------------------------------------------

CLS

ECHO ======================================
ECHO = Running PHAN                       =
ECHO = Phan is a static analyzer for PHP. =
ECHO = @see https://github.com/phan/phan  =
ECHO ======================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

REM Check the if the script was called with a parameter and
REM in that case, this parameter is the name of a folder to scan
REM (scanOnlyFolderName will be empty or f.i. equal to "classes", a folder name)
SET scanOnlyFolderName=%1

REM Get the folder of this current script.
REM Suppose that the .php-cs configuration file can be retrieved
REM from the current "script" folder which can be different of the
REM current working directory
SET ScriptFolder=%~dp0

REM For phan, check if we've a file .phan\config.php in the current
REM working directory i.e. the one of the project.
REM If so, use that configuration file.
REM If not, use the .phan\config.php present in the folder of the phan.bat
REM script
SET configFile=%cd%\.phan\config.php
IF NOT EXIST %configFile% (
    SET configFile=%ScriptFolder%.phan\config.php
)

REM Initialize the list of folders that should be ignored
REM @see https://stackoverflow.com/a/18869970/1065340

SET "file=%ScriptFolder%.phpmenu-ignore"
SET "ignore="

IF EXIST %file% (
    SET /A i=0
    REM Read the file and make a string with all folder's name
    FOR /F "delims=" %%a in ('Type "%file%"') do (
        SET ignore=!ignore!%%a
    )

    REM Also initialize an array of folders that shouldn't be
    REM processed
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
        REM Check if that folder name should be ignored or not

        FOR /L %%f IN (0, 1, !lastindex!) DO (
            REM IF /I for case insensitive check
            IF /I %%d == !arrIgnore[%%f]! (
                ECHO Ignore folder %%d
                REM We can ignore the folder
                SET "bContinue=false"
            )
        )
    )

    REM bContinue still on true? If so, process the folder
    IF "!bContinue!" equ "true" (
        CALL :fnProcessFolder %%d
    )
)

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO.
ECHO Process folder %1
ECHO.

REM  -l, --directory <directory>
REM     A directory that should be parsed for class and
REM     method information. After excluding the directories
REM     defined in --exclude-directory-list, the remaining
REM     files will be statically analyzed for errors.

REM --exclude-directory-list <dir_list>
REM     A comma-separated list of directories that defines files
REM     that will be excluded from static analysis, but whose
REM     class and method information should be included.

REM --include-analysis-file-list <file_list>
REM     A comma-separated list of files that will be included in
REM     static analysis. All others won't be analyzed.

REM -k, --config-file
REM    A path to a config file to load (instead of the default of
REM    .phan/config.php).

REM -b, --backward-compatibility-checks
REM    Check for potential PHP 5 -> PHP 7 BC issues

REM Define the name for the logfile for the analyzed folder
SET outputFile=%tmp%\phan_%1.log

REM Remove previous file just to be sure that an old version won't remains
IF EXIST %outputFile% (
    DEL %outputFile%
)

REM ECHO Command line options are
ECHO     -l %1 (scanned folder)
ECHO     -o %outputFile% (output filename)
REM ECHO     --allow-polyfill-parser
REM ECHO     --exclude-directory-list %ignore%
ECHO     --config-file %configFile% (configuration file used)
ECHO.

CALL %APPDATA%\Composer\vendor\bin\phan.bat -o %outputFile% --config-file %configFile% -l %1

REM Open Notepad; use START and not CALL because START will not wait by default
REM but only when there is something in the log
CALL :setFileSize %outputFile%

REM When the output logfile is empty, perfect, otherwise open Notepad
if %fileSize% LSS 1 (
    ECHO *** Wonderful! Everything is OK in folder %1 ***
) ELSE (
    REM !!! Warnings found in folder %1 !!!
    START notepad %outputFile%

    REM Show somes statistics about the log
    REM @see https://github.com/phan/phan/wiki/Tutorial-for-Analyzing-a-Large-Sloppy-Code-Base#start-doing-a-weak-analysis
    ECHO     A few statistics about the number of times the same error type occurs
    ECHO.
    CAT %outputFile% | cut -d ' ' -f2 | sort | uniq -c | sort /R
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
::-- Show help instructions
::--------------------------------------------------------
:HELP

ECHO phan.bat [-h] [foldername]
ECHO.
ECHO -h : to get this screen
ECHO.
ECHO foldername : if you want to scan all subfolders of your project, don't
ECHO specify a foldername. If you want to scan only one, mention his name like,
ECHO for instance, "phan.bat Classes" for scanning only the Classes folder (case
ECHO not sensitive).
ECHO.
ECHO Remarks
ECHO -------
ECHO.
ECHO If you want to use your own configuration file; create a .phan/config.php file
ECHO in your project's folder.

GOTO END:

:END
ECHO.

ECHO End
