@ECHO OFF

setlocal enabledelayedexpansion enableextensions

REM --------------------------------------------------
REM - PHAN - Scan all folders of the current working -
REM - directory and report errors                    -
REM - @src https://github.com/phan/phan              -
REM --------------------------------------------------

CLS

ECHO ======================================
ECHO = Running PHAN                       =
ECHO = Phan is a static analyzer for PHP. =
ECHO ======================================
ECHO.

REM Get the folder of this current script. 
REM Suppose that the .php-cs configuration file can be retrieved
REM from the current "script" folder which can be different of the 
REM current working directory
SET ScriptFolder=%~dp0

REM Initialize the list of folders that should be ignored 
REM @see https://stackoverflow.com/a/18869970/1065340

SET "file=%ScriptFolder%.phpmenu-ignore"
SET "ignore="

IF EXIST %file% (
    SET /A i=0
	 REM Read the file and make a string with all folder's name
    FOR /F "delims=" %%a in ('Type "%file%"') do (
        SET ignore=!ignore!%%a 
    )
)

REM --exclude-directory-list <dir_list>
REM     A comma-separated list of directories that defines files
REM     that will be excluded from static analysis, but whose
REM     class and method information should be included.

REM --include-analysis-file-list <file_list>
REM     A comma-separated list of files that will be included in
REM     static analysis. All others won't be analyzed.

REM -k, --config-file
REM    A path to a config file to load (instead of the default of
REM    .phan/config.php).

REM --color
REM    Add colors to the outputted issues. Tested in Unix.
REM    This is recommended for only the default --output-mode ('text')

REM -b, --backward-compatibility-checks
REM    Check for potential PHP 5 -> PHP 7 BC issues

ECHO Command line options are 
ECHO     --allow-polyfill-parser 
ECHO     --exclude-directory-list %ignore% 
ECHO     -k %ScriptFolder%.phan\config.php 
ECHO     --color 
ECHO     --backward-compatibility-checks
ECHO.

%APPDATA%\Composer\vendor\bin\phan.bat --allow-polyfill-parser --exclude-directory-list vendor -k %ScriptFolder%.phan\config.php --color --backward-compatibility-checks

:END
ECHO.
ECHO End
