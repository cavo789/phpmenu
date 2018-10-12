@ECHO OFF

REM Author : AVONTURE Christophe

setlocal enabledelayedexpansion enableextensions

REM Define global variables
SET PROGNAME=PHPUNIT
SET GITHUB=https://github.com/sebastianbergmann/phpunit
SET COMPOSER=phpunit/phpunit
SET SCRIPT=%APPDATA%\Composer\vendor\bin\phpunit.bat
SET BATCH=%~n0%~x0

CLS

ECHO =====================================================
ECHO = %PROGNAME%                                           =
ECHO = PHP Unit Testing                                  =
ECHO = @see %GITHUB% =
ECHO =====================================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

IF NOT EXIST %SCRIPT% (
    GOTO NOTINSTALLED:
)

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

REM ECHO Command line options are
ECHO     %1 (scanned folder)
ECHO     --stop-on-failure (Stop execution upon first error or failure)
ECHO     -v (Output more verbose information)
ECHO     -c %configFile% (Configuration file used)
ECHO.


IF "%configFile%" NEQ "" (
    CALL %SCRIPT% %scanFolderName% --colors=auto --stop-on-failure -c %configFile%
) ELSE (
    REM No phpunit.xml found
    CALL %SCRIPT% %scanFolderName% --colors=auto --stop-on-failure
)

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

ECHO %BATCH% [-h]
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
