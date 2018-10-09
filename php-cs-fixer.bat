@echo off

setlocal enabledelayedexpansion enableextensions

REM ---------------------------------------------------------
REM - PHP-CS-FIXER - Fix all folders of the current working -
REM - directory then fix the current folder too             -
REM ---------------------------------------------------------

cls

echo ====================================
echo = Running PHP-CS-FIXER             =
echo ====================================

REM Get the folder of this current script. 
REM Suppose that the .php-cs configuration file can be retrieved
REM from the current "script" folder which can be different of the 
REM current working directory
SET ScriptFolder=%~dp0

REM -------------------------------------------------------
REM - Populate the list of folders that should be ignored -
REM -------------------------------------------------------

set i=-1

for %%f in (.git, .phan, .vscode, vendor) do (
    set /a i=!i!+1
    set arrIgnore[!i!]=%%f
)

set lastindex=!i!

REM ---------------------------------------------------------
REM - Get the list of subfolders of the current working dir -
REM ---------------------------------------------------------

for /d %%d in (*.*) do (

    REM %%d contains a folder name like f.i. "assets"
    REM Check if that folder name should be ignored or not

    set "bContinue=true"
    set foldername=%%d

    for /L %%f in (0, 1, !lastindex!) do ( 
        if !foldername! == !arrIgnore[%%f]! (
             REM We can ignore the folder
             set "bContinue=false"
        )
    )

    if "!bContinue!" equ "true" (
        ECHO.
        ECHO Process folder %%d
        ECHO.
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

REM Be sure that PHP-CS-Fixer (https://github.com/FriendsOfPHP/PHP-CS-Fixer)
REM has been installed globally by using, first, 
REM composer global require friendsofphp/php-cs-fixer
REM If not, php-cs-fixer won't be retrieved in the %APPDATA% folder
call %APPDATA%\Composer\vendor\bin\php-cs-fixer fix %1 --show-progress=none --verbose --config=%ScriptFolder%.php-cs

goto:eof

:END
ECHO.

ECHO End
