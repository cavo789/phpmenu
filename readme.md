# DOT Files

> My dot files and configuration items / scripts

* [Install](#install)
* [Usage](#usage)
   * [composer.json](#composerjson)
   * [phan.bat](#phanbat)
   * [phpcbf.bat](#phpcbfbat)
   * [phpcs.bat](#phpcsbat)
   * [php-cs-fixer.bat](#php-cs-fixerbat)
   * [phpstan.bat](#phpstanbat)
* [License](#license)

## Install

Just take a copy of files on your hard disk

## Usage

### composer.json

This file is intended to be used for the global settings of Composer i.e. put this file in your `%APPDATA%\Composer` folder (better, create a `symlink`).

### phan.bat

### phpcbf.bat

### phpcs.bat

### php-cs-fixer.bat

Notes:

1. This script is for Windows developers only
2. Be sure that [PHP-CS-Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer) has been installed globally (i.e. with `composer global require friendsofphp/php-cs-fixer`)

That script will make a loop and will process every folders present in the current working directory.

The batch file contains a loop for initializing a list of folders that should be ignored.

The code below says: ignore the three mentioned folders when processing subfolders. Just edit the `.bat` file and add yours.

```batch
for %%f in (.phan, .vscode, vendor) do (
    set /a i=!i!+1
    set arrIgnore[!i!]=%%f
)
```

To use the file, just open your DOS prompt, go to your PHP project root folder (like `c:\projects\amazing_projects`) and run `php-cs-fixer.bat` (be sure that file is present in a folder mentioned in the `%PATH%` environnement variable)

### phpstan.bat

## License

[MIT](LICENSE)
