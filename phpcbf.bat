@ECHO OFF

setlocal enabledelayedexpansion enableextensions

REM ------------------------------------------------------------
REM - PHP-CodeSniffer - Start CodeSniffer on each subfolder of -
REM - the current working and automatically correct coding     -
REM - standard violations                                      -
REM - @see https://github.com/squizlabs/PHP_CodeSniffer        -
REM ------------------------------------------------------------

CLS

ECHO ===============================================================
ECHO = Running PHPCBF - PHP-CodeSniffer CBF                        =
ECHO = PHP_CodeSniffer automatic coding standard violations fixer  =
ECHO ===============================================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

REM Check the if the script was called with a parameter and
REM in that case, this parameter is the name of a folder to scan
REM (scanOnlyFolderName will be empty or f.i. equal to "classes", a folder name)
SET scanOnlyFolderName=%1

REM Get the folder of this current script. 
REM Suppose that the ruleset.xml configuration file can be retrieved
REM from the current "script" folder which can be different of the 
REM current working directory
SET ScriptFolder=%~dp0

REM For phpcbf, check if we've a file ruleset.xml in the current
REM working directory i.e. the one of the project.
REM If so, use that configuration file.
REM If not, use the ruleset.xml present in the folder of the phpcbf.bat
REM script
SET configFile=%cd%\ruleset.xml
IF NOT EXIST %configFile% (
    SET configFile=%ScriptFolder%ruleset.xml
) 

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

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO Process folder %1
ECHO.

REM Be sure that PHP_CodeSniffer (https://github.com/squizlabs/PHP_CodeSniffer)
REM has been installed globally by using, first, 
REM composer global require squizlabs/php_codesniffer
REM If not, php-cs-fixer won't be retrieved in the %APPDATA% folder

REM ECHO Command line options are 
ECHO     %1 (scanned folder)
ECHO     --standard=%configFile% (configuration file used)
ECHO.

CALL %APPDATA%\Composer\vendor\bin\phpcbf --standard=%configFile% %1 %2

GOTO:EOF

::--------------------------------------------------------
::-- Show help instructions
::--------------------------------------------------------
:HELP

ECHO phpcbf.bat [-h] [foldername]
ECHO.
ECHO -h : to get this screen
ECHO.
ECHO foldername : if you want to scan all subfolders of your project, don't
ECHO specify a foldername. If you want to scan only one, mention his name like,
ECHO for instance, "phpcbf.bat Classes" for scanning only the Classes folder (case 
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
