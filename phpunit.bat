@ECHO OFF

setlocal enabledelayedexpansion enableextensions

REM -----------------------------------------------------
REM - PHPUnit - PHP Unit Testing                        -
REM - @see https://github.com/sebastianbergmann/phpunit -
REM -----------------------------------------------------

CLS

ECHO =====================================================
ECHO = PHPUNIT                                           =
ECHO = PHP Unit Testing                                  =
ECHO = @see https://github.com/sebastianbergmann/phpunit =
ECHO =====================================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

REM Presume that unit testings are in a folder called "/Tests"
SET scanFolderName=%cd%\Tests

REM For phpunit, check if we've a file phpunit.xml in the current
REM working directory i.e. the one of the project phpunit.xml
REM If so, use that configuration file.
REM If not, use the phpunit.xml present in the folder of the phpunit.bat
REM script
SET configFile=%cd%\phpunit.xml
IF NOT EXIST %configFile% (
    SET configFile=%ScriptFolder%phpunit.xml
)
IF NOT EXIST %configFile% (
    SET configFile=
)

ECHO Process folder %1
ECHO.

REM Be sure that PHPUNIT (https://github.com/sebastianbergmann/phpunit)
REM has been installed globally by using, first,
REM composer global require phpunit/phpunit
REM If not, phpunit won't be retrieved in the %APPDATA% folder

REM ECHO Command line options are
ECHO     %1 (scanned folder)
ECHO     --stop-on-failure (Stop execution upon first error or failure)
ECHO     -v (Output more verbose information)
ECHO     -c %configFile% (Configuration file used)
ECHO.


IF "%configFile%" NEQ "" (
    CALL %APPDATA%\Composer\vendor\bin\phpunit %scanFolderName% --colors=auto --stop-on-failure -c %configFile%
) ELSE (
    REM No phpunit.xml found
    CALL %APPDATA%\Composer\vendor\bin\phpunit %scanFolderName% --colors=auto --stop-on-failure
)

GOTO:EOF

::--------------------------------------------------------
::-- Show help instructions
::--------------------------------------------------------
:HELP

ECHO phpunit.bat [-h]
ECHO.
ECHO -h : to get this screen
ECHO.
ECHO Remarks
ECHO -------
ECHO.
ECHO If you want to use your own configuration file; create a phpunit.xml file
ECHO in your project's folder.

GOTO END:

:END
ECHO.
ECHO End
