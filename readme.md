# DOT Files

> My dot files and configuration items / scripts. Remark: scripts are Windows batch files; won't work on other OS than Windows

* [Install](#install)
	* [Environnement variable - PATH](#environnement-variable---path)
	* [Composer - Global](#composer---global)
	* [File .phpmenu-ignore](#file-phpmenu-ignore)
* [Usage](#usage)
	* [PHPMENU](#phpmenu)
	* [1. PHAN](#1-phan)
	* [2. PHPStan](#2-phpstan)
	* [3. PHPCPD](#3-phpcpd)
	* [4. PHPCS](#4-phpcs)
	* [5. PHPMD](#5-phpmd)
	* [6. PHPMND](#6-phpmnd)
	* [7. PHP Metrics](#7-php-metrics)
	* [8. PHPUNIT](#8-phpunit)
	* [9. PHPCBF](#9-phpcbf)
	* [10. PHP-CS-FIXER](#10-php-cs-fixer)
	* [11. PHPLOC](#11-phploc)
* [License](#license)

## Install

Make a clone of this repository on your disk and just download every files and store them in a folder like f.i. `c:\scripts\phpmenu`.

### Environnement variable - PATH

To use the scripts present in this repository, once copied onto your hard disk (let's say `c:\scripts\phpmenu`), make sure that you've initialized the `%PATH%` environnement variable of Windows and add `c:\scripts\phpmenu` as one of the first entry; should be before your global `Composer\vendor\bin` entry).

This will make life easier: by opening a DOS prompt in any folder (like `c:\my_repositories\php_amazing`), you can just type `phpmenu` and Windows will run the one of `c:\scripts\phpmenu`.

### Composer - Global

This done, you'll also need to configure your local global composer directory by either installing dependencies one by one or by copying the `composer.json` file that you'll find in this current repository to your `%APPDATA%\Composer` folder. Note: you can also create a `symlink` in `%APPDATA%\Composer` and refer to the current `composer.json` file.

Once copied there, run `composer global update` to get the latest version and/or install dependencies.

### File .phpmenu-ignore

Scripts will scan / solve issues in your project tree structure but there are folders that can (should) be ignored like `.git`, `vendor`, ...

You can mention such folder once in the `.phpmenu-ignore` file for all scripts. Just edit the `.phpmenu-ignore` and add one line by folder that should be ignored.

Also do this in the `phpstan.neon` file that is used by `PHPSTAN`. Take a look on the `excludes_analyse` entry in `phpstan.neon`.

## Usage

Open a DOS prompt, go to your PHP project root folder (like `c:\my_repositories\php_amazing`) and run `phpmenu` (refer to the [Install](#install) chapter here above if not working)

### PHPMENU

This script will display an interface and allow you to choose which script should be started:

```
======================================
= PHPMENU                            =
= Which scripts do you want to start =
======================================

Tip: need to scan only one folder? Call phpmenu with the foldername like this: "phpmenu Myclasses"

  Scan tools
    1. Start PHAN (Phan is a static analyzer for PHP) shortcut: phan.bat
    2. Start PHPStan (PHP Static Analysis Tool) shortcut: phpstan.bat
    3. Start PHPCPD (PHP Copy/Paste detector) shortcut: phpcpd.bat
    4. Start PHPCS (Start PHP_CodeSniffer, detect and show remaining errors) shortcut: phpcs.bat
    5. Start PHPMD (Start PHP Mess Detector) shortcut: phpmd.bat
    6. Start PHPMND (Start PHP Magical Number) shortcut: phpmnd.bat
    7. Start PHP Metrics (Start Static analysis tool for PHP) shortcut: phpmetrics.bat

  Testing tools
    8. Start PHPUNIT (PHP Unit tests) shortcut: phpunit.bat

  Fixed standard violation
    9. Start PHPCBF (Start PHP_CodeSniffer automatic fixer) shortcut: phpcbf.bat
   10. Start PHP-CS-FIXER (Start PHP-CS-FIXER, detect and show remaining errors) shortcut: php-cs-fixer.bat

  Statistics
   11. Start PHPLOC (Tool for quickly measuring the size of a PHP project) shortcut: phploc.bat

 0. Exit
```

Making a choice will start the desired script and `0` will exit the menu.

#### 1. PHAN

Phan is a static analyzer for PHP and will help to have a better codebase and a more robust code.

Phan offers 5 levels of controls, from `Emergency` (only report really severe problems) to `LOW` (max report level) for purists like me who want zero warning.

Phan will scan the code and check f.i. against unused variables,

Phan goes so far as to check the doc-block blocks to see if you have indicated the right variables, types, etc. and we all know that we quickly change the name / type of a parameter and forget to keep the doc-block up to date; Phan will see it.

You can use rules defined in this package (see folder `.phan\config.php`) or use your own; just make a copy of `.phan\config.php` and copy it into your project's folder.

For more information about Phan, please take a look on the [Phan repository](https://github.com/phan/phan).

Note: be sure that Phan is installed by running `composer global require phan/phan` (or by using the composer.json mentioned in chapter 1)

#### 2. PHPStan

PHPStan is a static analysis tool and help to discover bugs in code without running it!

You can use rules defined in this package (see file `phpstan.eon`) or use your own; just make a copy of `phpstan.eon` and copy it into your project's root folder.

For more information about PHPStan, please take a look on the [PHPStan repository](https://github.com/phpstan/phpstan).

Note: be sure that PHPStan is installed by running `composer global require phpstan/phpstan` (or by using the composer.json mentioned in chapter 1)

#### 3. PHPCPD

PHP Copy/Paste detector will help to detect duplicate code in PHP files.

Do you've copied five or more lines from that file and paste it there and there? Sometimes, a do this for just a test and ... forget these lines.

For more information about PHPCPD, please take a look on the [PHPCPD repository](https://github.com/sebastianbergmann/phpcpd).

Note: be sure that PHPCPD is installed by running `composer global require sebastian/phpcpd` (or by using the composer.json mentioned in chapter 1)

#### 4. PHPCS

PHPCS tokenizes PHP, JavaScript and CSS files to detect violations of a defined coding standard.

See also [PHPCBF](#9-phpcbf) for automatically fixing somes violations detected by PHPCS.

For more information about PHPCS, please take a look on the [PHPCS repository](https://github.com/squizlabs/PHP_CodeSniffer). Also take a look on the configuration options : [https://github.com/squizlabs/PHP_CodeSniffer/wiki/Configuration-Options](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Configuration-Options)

Note: be sure that PHP_CodeSniffer is installed by running `composer global require squizlabs/php_codesniffer` (or by using the composer.json mentioned in chapter 1)

#### 5. PHPMD

PHPMD - Mess detector takes a given PHP source code base and look for several potential problems within that source. These problems can be things like:

-   Possible bugs
-   Suboptimal code
-   Overcomplicated expressions
-   Unused parameters, methods, properties
-   ...

For more information about PHPMD, please take a look on the [PHPMD repository](https://github.com/phpmd/phpmd).

Note: be sure that PHPMD is installed by running `composer global require phpmd/phpmd` (or by using the composer.json mentioned in chapter 1)

#### 6. PHPMND

PHP Magical Number will analyze your source code and try to find hardcoded figures like in:

```php
if (mb_strlen($password) > 7) {
  throw new InvalidArgumentException("password");
}
```

And suggest to create constants so it'll be much more easier to maintain.

```php
const MAX_PASSWORD_LENGTH = 7;
[...]
if (mb_strlen($password) > self::MAX_PASSWORD_LENGTH)
```

For more information about PHP Magical Number, please take a look on the [PHPMND repository](https://github.com/povils/phpmnd).

Note: be sure that PHPMD is installed by running `composer global require povils/phpmnd` (or by using the composer.json mentioned in chapter 1)

#### 7. PHP Metrics

PHP Metrics will produce HTML pages to allow you to see a lot of information's about your project and see, f.i., a chart with the complexity of your classes.

For more information about PHP Metrics, please take a look on the [PHP Metrics repository](https://github.com/phpmetrics/PhpMetrics).

Note: be sure that PHP Metrics is installed by running `composer global require phpmetrics/phpmetrics` (or by using the composer.json mentioned in chapter 1)

#### 8. PHPUNIT

PHPUNIT will make easy to run your unit tests from a command prompt.

For more information aboutPHPUNIT, please take a look on the [PHPUNIT repository](https://github.com/sebastianbergmann/phpunit).

Note: be sure that PHPUNIT is installed by running `composer global require phpunit/phpunit` (or by using the composer.json mentioned in chapter 1)

#### 9. PHPCBF

PHPCBF works with [PHPCS](#4-phpcs) and allow to automatically correct coding standard violations detected by [PHPCS](#4-phpcs).

After having fired PHPCBF, remaining violations should be manually solved.

For more information about PHPCBF, please take a look on the [PHPCBF repository](https://github.com/squizlabs/PHP_CodeSniffer).

Note: be sure that PHP_CodeSniffer is installed by running `composer global require squizlabs/php_codesniffer` (or by using the composer.json mentioned in chapter 1)

#### 10. PHP-CS-FIXER

PHP-CS-Fixer is a tool for automatically fix PHP coding standards issues. Can be used conjointely with [PHPCBF](#9-phpcbf).

For more information about PHP-CS-Fixer, please take a look on the [PHP-CS-Fixer repository](https://github.com/FriendsOfPHP/PHP-CS-Fixer).

Note: be sure that PHP-CS-Fixer is installed by running `composer global require friendsofphp/php-cs-fixer` (or by using the composer.json mentioned in chapter 1)

#### 11. PHPLOC

PHPLOC produces statistics about your project like getting the number of files/folders, total number of lines (code, comments, ...), calculate percentage and others things (cyclomatic complexity, number of dependencies, ...)

For more information about PHPLOC, please take a look on the [PHPLOC repository](https://github.com/sebastianbergmann/phploc).

Note: be sure that PHPLOC is installed by running `composer global require phploc/phploc` (or by using the composer.json mentioned in chapter 1)

## License

[MIT](LICENSE)
