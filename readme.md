# DOT Files

> My dot files and configuration items / scripts. Remark: scripts are Windows batch files; won't work on other OS than Windows

_ [Install](#install)
	_ [Environnement variable - PATH](#environnement-variable---path)
	_ [Composer - Global](#composer---global)
	_ [File .phpmenu-ignore](#file-phpmenu-ignore)
_ [Usage](#usage)
	_ [phpmenu.bat](#phpmenubat)
	_ [1 phan.bat](#1-phanbat)
	_ [2 phpstan.bat](#2-phpstanbat)
	_ [3 phpcbf.bat](#3-phpcbfbat)
	_ [4 phpcs.bat](#4-phpcsbat)
	_ [5 php-cs-fixer.bat](#5-php-cs-fixerbat)
_ [License](#license)

## Install

Just take a copy of files on your hard disk

### Environnement variable - PATH

To use the scripts present in this repository, once copied onto your hard disk (let's say `c:\scripts`), make sure that you've initialized the `%PATH%` environnement variable of Windows and add `c:\scripts\` as one of the first entry; should be before your global `Composer\vendor\bin` entry).

### Composer - Global

This done, you'll also need to configure your local global composer directory by either installing dependencies one by one or by copying the `composer.json` file that you'll find in this current repository to your `%APPDATA%\Composer` folder. Note: you can also create a `symlink` in `%APPDATA%\Composer` and refer to the current `composer.json` file.

Once copied there, run `composer global update` to get the latest version and/or install dependencies.

### File .phpmenu-ignore

Scripts will scan / solve issues in your project tree structure but there are folders that can (should) be ignored like `.git`, `vendor`, ...

You can mention such folder once in the `.phpmenu-ignore` file for all scripts. Just edit the `.phpmenu-ignore` and add one line by folder that should be ignored.

Also do this in the `phpstan.neon` file that is used by `PHPSTAN`. Take a look on the `excludes_analyse` entry in `phpstan.neon`.

## Usage

Open a DOS prompt, go to your PHP project root folder (like `c:\projects\amazing_projects`) and run `phpmenu.bat` (refer to the [Install](#install) chapter here above if not working)

### phpmenu.bat

This script is just a menu and will display something like this:

```
-----------------
-- Script menu --
-----------------

1. Start PHAN (Phan is a static analyzer for PHP) (shortcut: phan.bat)
2. Start PHPStan (PHP Static Analysis Tool) (shortcut: phpstan.bat)
3. Start PHPCBF (Start PHP_CodeSniffer automatic fixer) (shortcut: phpcbf.bat)
4. Start PHPCS (Start PHP_CodeSniffer, detect and show remaining errors) (shortcut: phpcs.bat)
5. Start PHP-CS-FIXER (Start PHP-CS-FIXER, detect and show remaining errors) (shortcut: php-cs-fixer.bat)
6. Exit
```

Making a choice will start the desired script and `0` will exit the menu.

#### 1 phan.bat

Phan is a static analyzer for PHP and will help to have a better codebase.

See [https://github.com/phan/phan](https://github.com/phan/phan)

Be sure that Phan is installed by running `composer global require phan/phan` (or by using the composer.json mentioned in chapter 1)

#### 2 phpstan.bat

PHPStan is a static analysis tool and will help to have a better codebase.

See [https://github.com/phpstan/phpstan](https://github.com/phpstan/phpstan)

Be sure that PHPStan is installed by running `composer global require phpstan/phpstan` (or by using the composer.json mentioned in chapter 1)

#### 3 phpcbf.bat

PHPCBF will automatically correct coding standard violations.

See [https://github.com/squizlabs/PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)

Be sure that PHP_CodeSniffer is installed by running `composer global require squizlabs/php_codesniffer` (or by using the composer.json mentioned in chapter 1)

#### 4 phpcs.bat

PHPCS tokenizes PHP, JavaScript and CSS files to detect violations of a defined coding standard.

See [https://github.com/squizlabs/PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)

Be sure that PHP_CodeSniffer is installed by running `composer global require squizlabs/php_codesniffer` (or by using the composer.json mentioned in chapter 1)

#### 5 php-cs-fixer.bat

PHP-CS-Fixer is a tool for automatically fix PHP coding standards issues.

See [https://github.com/FriendsOfPHP/PHP-CS-Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer)

Be sure that PHP-CS-Fixer is installed by running `composer global require friendsofphp/php-cs-fixer` (or by using the composer.json mentioned in chapter 1)

## License

[MIT](LICENSE)
