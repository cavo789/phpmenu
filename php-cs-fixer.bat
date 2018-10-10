@ECHO OFF

setlocal enabledelayedexpansion enableextensions

REM ----------------------------------------------------------
REM - PHP-CS-FIXER - Scan all folders of the current working -
REM - directory - JUST REPORT ERRORS (phpcs)                 -
REM - @src https://github.com/FriendsOfPHP/PHP-CS-Fixer      -
REM ----------------------------------------------------------

CLS

ECHO ===========================================================
ECHO = Running PHP-CS-FIXER                                    =
ECHO = A tool to automatically fix PHP coding standards issues =
ECHO ===========================================================
ECHO.

REM Get the folder of this current script. 
REM Suppose that the .php-cs configuration file can be retrieved
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

    REM %%d contains a folder name like f.i. "assets"
    REM Check if that folder name should be ignored or not

    SET "bContinue=true"
    SET foldername=%%d

    FOR /L %%f IN (0, 1, !lastindex!) DO ( 
        if !foldername! == !arrIgnore[%%f]! (
            ECHO Ignore folder !foldername!
            REM We can ignore the folder
            SET "bContinue=false"
        )
    )

    IF "!bContinue!" equ "true" (
        CALL :fnProcessFolder %%d
    )
)

REM And process the root folder
CALL :fnProcessFolder .

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO.
ECHO Process folder %%d
ECHO.

REM Be sure that PHP-CS-Fixer (https://github.com/FriendsOfPHP/PHP-CS-Fixer)
REM has been installed globally by using, first, 
REM composer global require friendsofphp/php-cs-fixer
REM If not, php-cs-fixer won't be retrieved in the %APPDATA% folder
CALL %APPDATA%\Composer\vendor\bin\php-cs-fixer fix %1 --show-progress=none --verbose --config=%ScriptFolder%.php-cs

GOTO:EOF

:END
ECHO.

ECHO End
