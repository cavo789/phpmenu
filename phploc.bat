@ECHO OFF

setlocal enabledelayedexpansion enableextensions

REM -----------------------------------------------------------------
REM - PHPLOC - Tool for quickly measuring the size of a PHP project -
REM - @see https://github.com/sebastianbergmann/phploc              -
REM -----------------------------------------------------------------

CLS

ECHO ====================================================
ECHO = PHPLOC - Tool for quickly measuring the          =
ECHO = size of a PHP project                            =
ECHO = @see https://github.com/sebastianbergmann/phploc =
ECHO ====================================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

REM Check the if the script was called with a parameter and
REM in that case, this parameter is the name of a folder to scan
REM (scanFolderName will be empty or f.i. equal to "classes", a folder name)
SET scanFolderName=%cd%
IF "%1" NEQ "" (
	REM %1 is a foldername like "classes" (relative name); make it absolute
	SET scanFolderName=%cd%\%1
)

REM Process the folder
CALL :fnProcessFolder %scanFolderName%

GOTO END:

::--------------------------------------------------------
::-- fnProcessFolder - Process a given folder
::--------------------------------------------------------
:fnProcessFolder

ECHO Process folder %1
ECHO.

REM Be sure that PHPLOC (https://github.com/sebastianbergmann/phploc)
REM has been installed globally by using, first,
REM composer global require phploc/phploc
REM If not, phploc won't be retrieved in the %APPDATA% folder

REM ECHO Command line options are
ECHO     %1 (scanned folder)
ECHO     --exclude vendor
ECHO.

CALL %APPDATA%\Composer\vendor\bin\phploc %1 --exclude vendor

GOTO:EOF

::--------------------------------------------------------
::-- Show help instructions
::--------------------------------------------------------
:HELP

ECHO phploc.bat [-h] [foldername]
ECHO.
ECHO -h : to get this screen
ECHO.
ECHO foldername : if you want to scan all subfolders of your project, don't
ECHO specify a foldername. If you want to scan only one, mention his name like,
ECHO for instance, "phploc.bat Classes" for scanning only the Classes folder (case
ECHO not sensitive).
ECHO.

GOTO END:

:END
ECHO.
ECHO End
