@ECHO OFF

REM Author : AVONTURE Christophe

setlocal enabledelayedexpansion enableextensions

REM Define global variables
SET PROGNAME=PHAN
SET GITHUB=https://github.com/phan/phan
SET COMPOSER=phan/phan
SET SCRIPT=%APPDATA%\Composer\vendor\bin\phan.bat
SET BATCH=%~n0%~x0

CLS

ECHO ======================================
ECHO = Running %PROGNAME%                       =
ECHO = Phan is a static analyzer for PHP. =
ECHO = @see %GITHUB%  =
ECHO ======================================
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

REM For phan, check if we've a file .phan\config.php in the current
REM working directory i.e. the one of the project.
REM If so, use that configuration file.
REM If not, use the .phan\config.php present in the folder of the phan.bat
REM script
SET configFile=%cd%\.phan\config.php
IF NOT EXIST %configFile% (
    SET configFile=%ScriptFolder%.phan\config.php
)

REM Delete previous logs
DEL %tmp%\%PROGNAME%*.log /Q > NUL

REM If the script is started with a dot as folder to check, 
REM it means: run accross all folders so just do it and job is done
IF "%scanOnlyFolderName%" EQU "." (
    CALL :fnProcessFolder .
    GOTO END:
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

CALL :fnGetLogContent

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
SET outputFile=%tmp%\%PROGNAME%.log
IF "%1" NEQ "." (
    SET outputFile=%tmp%\%PROGNAME%.%1.log
)

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

CALL %SCRIPT% -o %outputFile% --config-file %configFile% -l %1

REM Get the size of the log file: when 0, perfect! No error encountered
CALL :setFileSize %outputFile%

if %fileSize% LSS 1 (
    ECHO *** Wonderful! Everything is OK in folder %1 *** > %outputFile%
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
::-- fnGetLogContent - Retrieve all .log files there were
::-- generated by the fnProcessFolder function and merge
::-- them into one single log file. Then display that file
::--------------------------------------------------------
:fnGetLogContent

REM All our log files are stored in the temporary folder
REM with a name starting by our PROGNAME constant.
SET LOGFILES="%tmp%\%PROGNAME%.tmp"

REM Our merge file
SET MERGED="%tmp%\%PROGNAME%.report.tmp"

REM Get the list of .log files and store the list in a .tmp file
DIR /B /O:n %tmp%\%PROGNAME%*.log > %LOGFILES%

REM Make sure we won't use previous run
IF EXIST %MERGED% (
    DEL %MERGED% > NUL
)

REM Process every single log file; one by one
FOR /F %%A IN ('TYPE %LOGFILES%') DO (
    ECHO    Process %%A

    REM Get the file's content and append it our in report file
    TYPE %tmp%\%%A >> %MERGED%
)

REM Sort the file, rewrite it.
SORT %MERGED% /o %MERGED%

REM Keep unique lines
SET SORTED="%tmp%\%PROGNAME%.sorted"
COPY %MERGED% %SORTED%
UNIQ %SORTED% > %MERGED%
DEL %SORTED%

REM Show somes statistics about the log
REM @see https://github.com/phan/phan/wiki/Tutorial-for-Analyzing-a-Large-Sloppy-Code-Base#start-doing-a-weak-analysis
ECHO     A few statistics about the number of times the same error type occurs
ECHO.
CAT %MERGED% | cut -d ' ' -f2 | sort | uniq -c | sort /R

REM Open the file with Notepad, START and not CALL because START 
REM will not wait by default
START notepad %MERGED%

GOTO:EOF

::--------------------------------------------------------
::-- Not installed
::--------------------------------------------------------
:NOTINSTALLED

ECHO %PROGNAME% (%GITHUB%) is not installed
ECHO on your machine. Please run the following command from a DOS prompt:
ECHO.
ECHO composer global require %COMPOSER%s
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
ECHO Remarks
ECHO -------
ECHO.
ECHO If you want to use your own configuration file; create a .phan/config.php file
ECHO in your project's folder.

GOTO END:

:END
ECHO.

ECHO End
