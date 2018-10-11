@ECHO OFF

setlocal enabledelayedexpansion enableextensions

REM -----------------------------------
REM - Show a menu for running scripts -
REM -----------------------------------

CLS

ECHO ======================================
ECHO = PHPMENU                            =
ECHO = Which scripts do you want to start =
ECHO ======================================
ECHO.

IF "%1"=="/?" GOTO :HELP
if "%1"=="-?" GOTO :HELP
if "%1"=="-h" GOTO :HELP

REM Check the if the script was called with a parameter and
REM in that case, this parameter is the name of a folder to scan
REM (scanOnlyFolderName will be empty or f.i. equal to "classes", a folder name)
SET scanOnlyFolderName=%1

:MENU

IF "%scanOnlyFolderName%" NEQ "" (
	ECHO *** Scripts will be fired only for folder %scanOnlyFolderName% ***
)

IF "%scanOnlyFolderName%" EQU "" (
   ECHO Tip: need to scan only one folder? Call phpmenu with the foldername like this: "phpmenu Myclasses"
)

ECHO.

ECHO  1. Start PHAN (Phan is a static analyzer for PHP) shortcut: phan.bat %scanOnlyFolderName%
ECHO  2. Start PHPStan (PHP Static Analysis Tool) shortcut: phpstan.bat %scanOnlyFolderName%
ECHO  3. Start PHPCPD (PHP Copy/Paste detector) shortcut: phpcpd.bat %scanOnlyFolderName%
ECHO.
ECHO  5. Start PHPCBF (Start PHP_CodeSniffer automatic fixer) shortcut: phpcbf.bat %scanOnlyFolderName%
ECHO.
ECHO  7. Start PHPCS (Start PHP_CodeSniffer, detect and show remaining errors) shortcut: phpcs.bat %scanOnlyFolderName%
ECHO  8. Start PHP-CS-FIXER (Start PHP-CS-FIXER, detect and show remaining errors) shortcut: php-cs-fixer.bat %scanOnlyFolderName%
ECHO.
ECHO  0. Exit
ECHO.

SET /P answer="Please make a choice? " 0-8

REM IF /I for case insensitive check
IF /I "%answer%"=="1" GOTO :PHAN
IF /I "%answer%"=="2" GOTO :PHPSTAN
IF /I "%answer%"=="3" GOTO :PHPCPD
IF /I "%answer%"=="5" GOTO :PHPCBF
IF /I "%answer%"=="7" GOTO :PHPCS
IF /I "%answer%"=="8" GOTO :PHPCSFIXER

GOTO :END

:PHAN
CLS
CALL phan.bat %scanOnlyFolderName%
GOTO :END

:PHPSTAN
CLS
CALL phpstan.bat %scanOnlyFolderName%
GOTO :END

:PHPCPD
CLS
CALL phpcpd.bat %scanOnlyFolderName%
GOTO :END

:PHPCBF
CLS
CALL phpcbf.bat %scanOnlyFolderName%
GOTO :END

:PHPCS
CLS
CALL phpcs.bat %scanOnlyFolderName%
GOTO :END

:PHPCSFIXER
CLS
CALL php-cs-fixer.bat %scanOnlyFolderName%
GOTO :END

::--------------------------------------------------------
::-- Show help instructions
::--------------------------------------------------------
:HELP

ECHO phpmenu.bat [-h] [foldername]
ECHO.
ECHO -h : to get this screen
ECHO.
ECHO foldername : if you want to process all subfolders of your project, don't
ECHO specify a foldername. If you want to scan only one, mention his name like,
ECHO for instance, "phpmenu.bat Classes" for processing only the Classes folder (case
ECHO not sensitive).
ECHO.

GOTO END:

:END
