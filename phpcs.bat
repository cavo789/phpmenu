@ECHO OFF

setlocal enabledelayedexpansion enableextensions

REM ------------------------------------------------------------
REM - PHP-CodeSniffer - Start CodeSniffer on each subfolder of -
REM - the current working - JUST REPORT ERRORS (phpcs)         -
REM - @see https://github.com/squizlabs/PHP_CodeSniffer        -
REM ------------------------------------------------------------

CLS

ECHO ==================================================
ECHO = Running PHPCS - PHP-CodeSniffer                =
ECHO = PHP_CodeSniffer tokenizes PHP, JavaScript and  =
ECHO = CSS files and detects violations of a defined  =
ECHO = set of coding standards.                       =
ECHO ==================================================
ECHO.

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

    REM %%d contains a folder name like f.i. "assets"
    REM Check if that folder name should be ignored or not

    SET "bContinue=true"
    SET foldername=%%d

    FOR /L %%f IN (0, 1, %lastindex%) DO ( 

        IF !foldername! == !arrIgnore[%%f]! (
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

REM -l
REM    Local directory only, no recursion
CALL :fnProcessFolder . -l

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO.
ECHO Process folder %1
ECHO.

REM Be sure that PHP_CodeSniffer (https://github.com/squizlabs/PHP_CodeSniffer)
REM has been installed globally by using, first, 
REM composer global require squizlabs/php_codesniffer
REM If not, php-cs-fixer won't be retrieved in the %APPDATA% folder

CALL %APPDATA%\Composer\vendor\bin\phpcs --standard=%ScriptFolder%ruleset.xml %1 %2
GOTO:EOF

:END
ECHO.

ECHO End
