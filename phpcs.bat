@ECHO OFF

REM Author : AVONTURE Christophe

setlocal enabledelayedexpansion enableextensions

REM Define global variables
SET PROGNAME=PHPCS
SET GITHUB=https://github.com/squizlabs/PHP_CodeSniffer
SET COMPOSER=squizlabs/php_codesniffer
SET SCRIPT=%APPDATA%\Composer\vendor\bin\phpcs.bat
SET BATCH=%~n0%~x0

CLS

ECHO =====================================================
ECHO = Running %PROGNAME% - PHP-CodeSniffer                   =
ECHO = PHP_CodeSniffer tokenizes PHP, JavaScript and     =
ECHO = CSS files and detects violations of a defined     =
ECHO = set of coding standards.                          =
ECHO = @see %GITHUB% =
ECHO =====================================================
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
REM Suppose that the ruleset.xml configuration file can be retrieved
REM from the current "script" folder which can be different of the
REM current working directory
SET ScriptFolder=%~dp0

REM For phpcs, check if we've a file ruleset.xml in the current
REM working directory i.e. the one of the project.
REM If so, use that configuration file.
REM If not, use the ruleset.xml present in the folder of the phpcs.bat
REM script
SET configFile=%cd%\ruleset.xml
IF NOT EXIST %configFile% (
    SET configFile=%ScriptFolder%ruleset.xml
)

REM Delete previous logs
DEL %tmp%\%PROGNAME%*.log /Q

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

REM -l
REM    Local directory only, no recursion
IF "%scanOnlyFolderName%" EQU "" (
    CALL :fnProcessFolder . -l
)

CALL :fnGetLogContent

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO Process folder %1
ECHO.

REM Define the name for the logfile for the analyzed folder
REM Will be %PROGNAME%_FOLDERNAME.log
SET outputFile=%tmp%\%PROGNAME%_%1.log

REM Remove previous file just to be sure that an old version won't remains
IF EXIST %outputFile% (
    DEL %outputFile%
)

REM ECHO Command line options are
ECHO     %1 (scanned folder)
ECHO     --standard=%configFile% (configuration file used)
ECHO     --ignore=*.min.css,*.min.js 
ECHO.

REM CALL %SCRIPT% --config-set installed_paths %APPDATA%\Composer\vendor\phpcompatibility\php-compatibility\PHPCompatibility
CALL %SCRIPT% --standard=%configFile% %1 %2 --ignore=*.min.css,*.min.js >> %outputFile%

REM Open Notepad; use START and not CALL because START will not wait by default
REM but only when there is something in the log
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
    DEL %MERGED%
)

REM Process every single log file; one by one
FOR /F %%A IN ('TYPE %LOGFILES%') DO (
    ECHO    Process %%A

    REM Get the file's content and append it our in report file
    TYPE %tmp%\%%A >> %MERGED%
)

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
ECHO Remarks
ECHO -------
ECHO.
ECHO If you want to use your own configuration file; create a ruleset.xml file
ECHO in your project's folder.

GOTO END:

:END
ECHO.

ECHO End
