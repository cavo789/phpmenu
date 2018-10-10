@ECHO OFF

setlocal enabledelayedexpansion enableextensions

REM -----------------------------------
REM - Show a menu for running scripts -
REM -----------------------------------

CLS

:MENU

ECHO  -----------------
ECHO  -- Script menu --
ECHO  -----------------
ECHO.
ECHO  1. Start PHAN (Phan is a static analyzer for PHP) (shortcut: phan.bat)
ECHO  2. Start PHPStan (PHP Static Analysis Tool) (shortcut: phpstan.bat)
ECHO.
ECHO  5. Start PHPCBF (Start PHP_CodeSniffer automatic fixer) (shortcut: phpcbf.bat)
ECHO.
ECHO  7. Start PHPCS (Start PHP_CodeSniffer, detect and show remaining errors) (shortcut: phpcs.bat)
ECHO  8. Start PHP-CS-FIXER (Start PHP-CS-FIXER, detect and show remaining errors) (shortcut: php-cs-fixer.bat)
ECHO.
ECHO  0. Exit
ECHO.

SET /p answer="Please make a choice? "

IF /i "%answer%"=="1" GOTO :PHAN
IF /i "%answer%"=="2" GOTO :PHPSTAN
IF /i "%answer%"=="5" GOTO :PHPCBF
IF /i "%answer%"=="7" GOTO :PHPCS
IF /i "%answer%"=="8" GOTO :PHPCSFIXER
IF /i "%answer%"=="0" GOTO :END

:PHAN
CLS
CALL phan.bat
GOTO :END

:PHPSTAN
CLS
CALL phpstan.bat
GOTO :END

:PHPCBF
CLS
CALL phpcbf.bat
GOTO :END

:PHPCS
CLS
CALL phpcs.bat
GOTO :END

:PHPCSFIXER
CLS
CALL php-cs-fixer.bat
GOTO :END

:END
