![Banner](images/banner.jpg)

# PHP menu

> My PHP toolbox (configuration files and utilities). Remark: scripts are Windows batch files; won't work on other OS than Windows

* [Install](#install)
  * [Environnement variable - PATH](#environnement-variable---path)
  * [Composer - Global](#composer---global)
  * [File .phpmenu-ignore](#file-phpmenu-ignore)
* [Usage](#usage)
  * [1. PHPCBF](#1-phpcbf)
    * [PHPCBF - Output](#phpcbf---output)
    * [PHPCBF - Configuration](#phpcbf---configuration)
      * [PHPCBF - Ignore specific files or folder](#phpcbf---ignore-specific-files-or-folder)
  * [2. PHP-CS-FIXER](#2-php-cs-fixer)
    * [PHP-CS-FIXER - Output](#php-cs-fixer---output)
    * [PHP-CS-FIXER - Configuration](#php-cs-fixer---configuration)
      * [PHP-CS-FIXER - Header](#php-cs-fixer---header)
      * [PHP-CS-FIXER - Indentation](#php-cs-fixer---indentation)
      * [PHP-CS-FIXER - Ignore specific files or folder](#php-cs-fixer---ignore-specific-files-or-folder)
  * [10. PHAN](#10-phan)
    * [Phan - Output](#phan---output)
    * [Phan - Directives](#phan---directives)
    * [Phan - Configuration](#phan---configuration)
      * [Phan - Ignore specific files](#phan---ignore-specific-files)
      * [Phan - Ignore specific folder](#phan---ignore-specific-folder)
      * [Phan - Add classes](#phan---add-classes)
    * [Phan - Understanding issues](#phan---understanding-issues)
      * [PhanRedefineClass](#phanredefineclass)
      * [PhanUndeclaredClassMethod](#phanundeclaredclassmethod)
      * [PhanUnreferencedPublicMethod](#phanunreferencedpublicmethod)
      * [PhanUnreferencedUseNormal](#phanunreferencedusenormal)
      * [PhanUnusedVariable](#phanunusedvariable)
      * [PhanUnusedVariableCaughtException](#phanunusedvariablecaughtexception)
      * [PhanWriteOnlyPrivateProperty](#phanwriteonlyprivateproperty)
  * [11. PHPStan](#11-phpstan)
    * [PHPStan - Output](#phpstan---output)
    * [PHPStan - Configuration](#phpstan---configuration)
      * [PHPStan - Ignore specific folder](#phpstan---ignore-specific-folder)
      * [PHPStan - Add classes](#phpstan---add-classes)
    * [PHPStan - Understanding issues](#phpstan---understanding-issues)
      * [Autoloading not configured properly](#autoloading-not-configured-properly)
  * [12. PHPCPD](#12-phpcpd)
    * [PHPCPD - Output](#phpcpd---output)
  * [13. PHPCS](#13-phpcs)
    * [PHPCS - Output](#phpcs---output)
    * [PHPCS - Configuration](#phpcs---configuration)
  * [14. PHPMD](#14-phpmd)
    * [PHPMD - Output](#phpmd---output)
    * [PHPMD - Configuration](#phpmd---configuration)
      * [PHPMD - Ignore specific folder](#phpmd---ignore-specific-folder)
  * [15. PHPMND](#15-phpmnd)
    * [PHPMND - Output](#phpmnd---output)
  * [16. PHP Metrics](#16-php-metrics)
    * [PHP Metrics - Output](#php-metrics---output)
  * [19. PHP 7.x Compatibility](#19-php-7x-compatibility)
    * [PHP Compatibility - Output](#php-compatibility---output)
  * [20. PHPUNIT](#20-phpunit)
    * [PHPUnit - Output](#phpunit---output)
  * [25. PHPLOC](#25-phploc)
    * [PHPLOC - Output](#phploc---output)
  * [30. PHPDOC](#30-phpdoc)
    * [PHPDOC - Output](#phpdoc---output)
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

You can mention such folders once in the `.phpmenu-ignore` file for all scripts. Just edit the `.phpmenu-ignore` and add one line by folder that should be ignored.

Also do this in the `phpstan.neon` file that is used by `PHPSTAN`. Take a look on the `excludes_analyse` entry in `phpstan.neon`.

## Usage

Open a DOS prompt, go to your PHP project root folder (like `c:\my_repositories\php_amazing`) and run `phpmenu` (refer to the [Install](#install) chapter here above if not working)

This script will display an interface and allow you to choose which script should be started:

```
=======================================
= PHPMENU                             =
= Which scripts do you want to start? =
=======================================

Tip: need to scan only one folder? Call phpmenu with the foldername like this: "phpmenu Myclasses"

  Fix automatically standard violation
    1. Start PHPCBF (Start PHP_CodeSniffer automatic fixer) shortcut: phpcbf.bat
    2. Start PHP-CS-FIXER (Start PHP-CS-FIXER, detect and show remaining errors) shortcut: php-cs-fixer.bat

  Scan tools
   10. Start PHAN (Phan is a static analyzer for PHP) shortcut: phan.bat
   11. Start PHPStan (PHP Static Analysis Tool) shortcut: phpstan.bat
   12. Start PHPCPD (PHP Copy/Paste detector) shortcut: phpcpd.bat
   13. Start PHPCS (Start PHP_CodeSniffer, detect and show remaining errors) shortcut: phpcs.bat
   14. Start PHPMD (Start PHP Mess Detector) shortcut: phpmd.bat
   15. Start PHPMND (Start PHP Magical Number) shortcut: phpmnd.bat
   16. Start PHP Metrics (Start Static analysis tool for PHP) shortcut: phpmetrics.bat

   19. Start Check compatibility PHP 7.x shortcut: phpcompatibility.bat

  Testing tools
   20. Start PHPUNIT (PHP Unit tests) shortcut: phpunit.bat

  Statistics
   25. Start PHPLOC (Tool for quickly measuring the size of a PHP project) shortcut: phploc.bat

  Documentation
   30. Start PHPDOC (generate documentation) shortcut: phpdoc.bat

 0. Exit

Please make a choice?
```

Making a choice will start the desired script and `0` will exit the menu.

### 1. PHPCBF

> Shortcut: `phpcbf.bat`

PHPCBF works with [PHPCS](#13-phpcs) and allow to automatically correct coding standard violations detected by [PHPCS](#13-phpcs).

After having fired PHPCBF, remaining violations should be manually solved.

For more information about PHPCBF, please take a look on the [PHPCBF repository](https://github.com/squizlabs/PHP_CodeSniffer).

Note: be sure that PHP_CodeSniffer is installed by running `composer global require squizlabs/php_codesniffer` (or by using the composer.json mentioned in chapter 1)

#### PHPCBF - Output

You'll see on the console the list of changes made by files, the column `FIXED` contains the number of changes that were automatically applied (like converting tabs to space f.i. depending our the configuration) and `REMAINING` the number of changes that you'll need to make manually (see [PHPCS](#13-phpcs) for this).

```
PHPCBF RESULT SUMMARY
--------------------------------------------------
FILE                              FIXED  REMAINING
--------------------------------------------------
public\assets\js\interface.js     127    0
src\classes\debug.php             1      2
--------------------------------------------------
A TOTAL OF xxx ERRORS WERE FIXED IN xxx FILES
--------------------------------------------------
```

#### PHPCBF - Configuration

##### PHPCBF - Ignore specific files or folder

In your project, if you want to ignore folders, just get a copy of the `ruleset.xml` file and put that file in your application folder. Then edit the file, find the `exclude-pattern` nodes (there is one by pattern) and add your rules.

```xml
  <exclude-pattern>*/.git/*</exclude-pattern>
  <exclude-pattern>*/.phan/*</exclude-pattern>
  <exclude-pattern>*/.vscode/*</exclude-pattern>
  <exclude-pattern>*/docs/*</exclude-pattern>
  <exclude-pattern>*/public/DBDump/*</exclude-pattern>
  <exclude-pattern>*/src/classes/tests/*</exclude-pattern>
  <exclude-pattern>*/src/utilities/*</exclude-pattern>
  <exclude-pattern>*/tests/*</exclude-pattern>
  <exclude-pattern>*/vendor/*</exclude-pattern>
  <exclude-pattern>*.min.js</exclude-pattern>
  <exclude-pattern>*.min.css</exclude-pattern>
```

### 2. PHP-CS-FIXER

> Shortcut: `php-cs-fixer.bat`

PHP-CS-Fixer is a tool for automatically fix PHP coding standards issues. Can be used conjointly with [PHPCBF](#1-phpcbf).

For more information about PHP-CS-Fixer, please take a look on the [PHP-CS-Fixer repository](https://github.com/FriendsOfPHP/PHP-CS-Fixer).

Note: be sure that PHP-CS-Fixer is installed by running `composer global require friendsofphp/php-cs-fixer` (or by using the composer.json mentioned in chapter 1)

#### PHP-CS-FIXER - Output

For each processed folder, a .log file will be generated by the tool and will then be opened in Notepad.

The log will contains the list of changes; just like `git diff` does.

Here is an example:

The list of applied rules is mentioned just after the filename, see between `()`.

```diff
   1) configuration.php (phpdoc_scalar, phpdoc_summary, return_type_declaration, no_extra_blank_lines)
      ---------- begin diff ----------
--- Original
+++ New
@@ @@
-     * @var boolean
+     * @var bool
@@ @@
-    public static function getApiSurveysOnlyWithAtLeastOneAnswer() : bool
+    public static function getApiSurveysOnlyWithAtLeastOneAnswer(): bool
```

#### PHP-CS-FIXER - Configuration

##### PHP-CS-FIXER - Header

Each .php files can get a header: a doc-block can be added in each file. To enable this and to modify the text of the header, just get a copy of the `.php-cs` file and put that file in your application folder. Then edit the file, find the `$header` variable and add your text.

Then locate this block (search for `header_comment`) and uncomment it i.e. remove the `//` that are present at the beginning of each lines.

```
'header_comment' => [
  'header' => $header,
  'location' => 'after_declare_strict'
],
```

##### PHP-CS-FIXER - Indentation

To set your preferred indentation (tabs or spaces), get a copy of the `.php-cs` file and put that file in your application folder. Then edit the file, search for `setIndent` and specify there the indentation to use. 

```
->setIndent('    ')
```

##### PHP-CS-FIXER - Ignore specific files or folder

In your project, if you want to ignore folders, just get a copy of the `.php-cs` file and put that file in your application folder. Then edit the file, find the `exclude-pattern` nodes (there is one by pattern) and add your rules.

```xml
  <exclude-pattern>*/.git/*</exclude-pattern>
  <exclude-pattern>*/.phan/*</exclude-pattern>
  <exclude-pattern>*/.vscode/*</exclude-pattern>
  <exclude-pattern>*/docs/*</exclude-pattern>
  <exclude-pattern>*/public/DBDump/*</exclude-pattern>
  <exclude-pattern>*/src/classes/tests/*</exclude-pattern>
  <exclude-pattern>*/src/utilities/*</exclude-pattern>
  <exclude-pattern>*/tests/*</exclude-pattern>
  <exclude-pattern>*/vendor/*</exclude-pattern>
  <exclude-pattern>*.min.js</exclude-pattern>
  <exclude-pattern>*.min.css</exclude-pattern>
```

### 10. PHAN

> Shortcut: `phan.bat`

Phan is a static analyzer for PHP and will help to have a better codebase and a more robust code.

Phan offers 5 levels of controls, from `Emergency` (only report really severe problems) to `LOW` (max report level) for purists like me who want zero warning.

Phan will scan the code and check f.i. against unused variables.

Phan goes so far as to check the doc-block blocks to see if you have indicated the right variables, types, etc. and we all know that we quickly change the name / type of a parameter and forget to keep the doc-block up to date; Phan will see it.

You can use rules defined in this package (see folder `.phan\config.php`) or use your own; just make a copy of `.phan\config.php` and copy it into your project's folder.

For more information about Phan, please take a look on the [Phan repository](https://github.com/phan/phan).

Note: be sure that Phan is installed by running `composer global require phan/phan` (or by using the composer.json mentioned in chapter 1)

#### Phan - Output

The result of the `phan.bat` script will be a log file that will be automatically opened with Notepad so it's easy to retrieve all errors / warnings / notices / ... and process them.

#### Phan - Directives

Phan directives are documented here : https://github.com/phan/phan/wiki/Annotating-Your-Source-Code

#### Phan - Configuration

##### Phan - Ignore specific files

In your project, if you want to ignore files, just get a copy of the `.phan\config.php` file and put that file in your application folder. Then edit the file, find the `exclude_file_list` key and update it like, f.i., here below. This will ask Phan to ignore these files.

```php
'exclude_file_list' => [
  'public\\DBDump\\DB_Dump.php',
  'public\\DBDump\\DB_Import.php',
  'public\\DBDump\\MySQLDump.php',
  'public\\DBDump\\MySQLImport.php'
],
```

Note: you can also use the `exclude_file_regex` key if you want and use regular expression pattern.

##### Phan - Ignore specific folder

In your project, if you want to ignore folders, just get a copy of the `.phan\config.php` file and put that file in your application folder. Then edit the file, find the `exclude_analysis_directory_list` key and update it like, f.i., here below. This will ask Phan to ignore these folders.

```php
'exclude_analysis_directory_list' => [
  '.git/',
  '.phan/',
  '.vscode/',
  'docs/',
  'libs/',
  'resources/logs/',
  'resources/reports/',
  'tests/',
  'vendor/',
],
```

##### Phan - Add classes

Add your own classes to the Phan configuration file. Get a copy of the `.phan\config.php` file and put that file in your application folder. Then edit the file, find the `directory_list` key and update it like to add where your own classes are stored, f.i.:

```php
'directory_list' => [
  'config',
  'src/classes',
  'src/controllers',
  'vendor/cavo789/php_helpers/src',
  'vendor/phpunit/phpunit/src',
  'vendor/phan/phan/src/Phan',
],
```

#### Phan - Understanding issues

##### PhanRedefineClass

A class has been scanned but, most probably, was already be loaded by Phan, this happens when Phan is configured for loading a set of classes first (see `Phan - Add classes`).

If your file was indeed loaded in the Phan's configuration, you can ignore the warning like below by just adding a comment like before:

```php
// @phan-suppress-next-line PhanRedefineClass
class MyClass
```

The full error message is something like `PhanRedefineClass Class ... defined at xxx was previously defined as Class ... at xxx`. The mentioned classname, filename and line number are the same.

If it's your case, please refers to `Phan - Add classes`.

##### PhanUndeclaredClassMethod

When you get errors like `PhanUndeclaredClassMethod Call to method xxx from undeclared class xxx` a possible error is just that the class `xxx` wasn't loaded by Phan. Phan need to first load yours classes so he can determine if a method exists or not.

If it's your case, please refers to `Phan - Add classes`.

##### PhanUnreferencedPublicMethod

This warning can be a false positive. A message like `PhanUnreferencedPublicMethod Possibly zero references to public method class::method()` tells that Phan think this method isn't used at all in your project. 

To ignore the error, add a dock-block like

```php
/**
 * @suppress PhanUnreferencedPublicMethod
 *
 * @return bool
 */
public function myFunction(): bool
{
```

##### PhanUnreferencedUseNormal 

The error `PhanUnreferencedUseNormal Possibly zero references to use statement for classlike/namespace xxx (aaa/bbb)` can occurs when you've add a `use aaa\bbb as xxx;` at the top of the file and Phan think that you don't use that classe. This can be a false positive when the class is used inside a conditional statement like a `if`.

Verify if you're using the class and if it's the case, add a comment line like: 

```php
// @phan-suppress-next-line PhanUnreferencedUseNormal
use aaa\bbb as xxx;
```

##### PhanUnusedVariable

You've declared a variable and you didn't use it. In most of case, you can remove the declaration but, if you can't, just add a line just before like this:

```php
// @phan-suppress-next-line PhanUnusedVariable
list($regex, $sessionId) = $match;
```

In this example, `$match` is an array with two items, we're using the `list()` function for using names instead of position but, in fact, we don't need to the first variable so, just ignore. 

We can also ignore the warning for an entire function by adding the ignore statement in the doc-block:

```php
/**
 * @suppress PhanUnusedVariable
 *
 * @return bool
 */
public function myFunction(): bool
{
```

##### PhanUnusedVariableCaughtException

When it's a false positive, add a directive like:

```php
// @phan-suppress-next-line PhanUnusedVariableCaughtException
} catch (\Exception $e) {
```

##### PhanWriteOnlyPrivateProperty

Phan has found a variable like f.i. `private $language = 'en';` and think that the variable is never modified. He suggest then to choose for a constant instead of a variable.

If you want to ignore the recommendation, add a line just before like:

```php
// @phan-suppress-next-line PhanWriteOnlyPrivatePropertyCaughtException
private $language = 'fr'
```

or, in a doc-block, 

```php
/**
 * @suppress PhanWriteOnlyPrivateProperty 
 * @var string
 */
private $language = 'fr';
```

### 11. PHPStan

> Shortcut: `phpstan.bat`

PHPStan is a static analysis tool and help to discover bugs in code without running it! For instance, discovering that you're using an undefined constant / variable, calling undeclared class or method, ...

You can use rules defined in this package (see file `phpstan.eon`) or use your own; just make a copy of `phpstan.eon` and copy it into your project's root folder.

For more information about PHPStan, please take a look on the [PHPStan repository](https://github.com/phpstan/phpstan).

Note: be sure that PHPStan is installed by running `composer global require phpstan/phpstan` (or by using the composer.json mentioned in chapter 1)

#### PHPStan - Output

The result of the `phpstan.bat` script will be a log file that will be automatically opened with Notepad so it's easy to retrieve all errors / warnings / notices / ... and process them.

Here is an example:

```
 ------ --------------------------------------------------------- 
  Line   C:\Christophe\Repository\src\classes\tests\WebClient.php
 ------ --------------------------------------------------------- 
  25     Property Classes\Tests\WebClient::$response has unknown class Classes\Tests\GuzzleHttp\Response as its type.
  48     Property Classes\Tests\WebClient::$http has unknown class Classes\Tests\GuzzleHttp\Client as its type.
  60     Property Classes\Tests\WebClient::$http (Classes\Tests\GuzzleHttp\Client) does not accept GuzzleHttp\Client.
  70     Property Classes\Tests\WebClient::$http (Classes\Tests\GuzzleHttp\Client) does not accept null.
  93     Call to method request() on an unknown class Classes\Tests\GuzzleHttp\Client.
 ------ --------------------------------------------------------- 
```

#### PHPStan - Configuration

##### PHPStan - Ignore specific folder

In your project, if you want to ignore folders, just get a copy of the `phpstan.neon` file and put that file in your application folder. Then edit the file, find the `excludes_analyse` key and update it like, f.i., here below. This will ask Phan to ignore these folders.

```
parameters:
    excludes_analyse:
        - %currentWorkingDirectory%/.phan/*
        - %currentWorkingDirectory%/.git/*
        - %currentWorkingDirectory%/.vscode/*
        - %currentWorkingDirectory%/docs/*
        - %currentWorkingDirectory%/src/classes/tests/*
        - %currentWorkingDirectory%/src/utilities/*
        - %currentWorkingDirectory%/tests/*
        - %currentWorkingDirectory%/vendor/*
```

##### PHPStan - Add classes

Add your own classes to the PHPStan configuration file; just get a copy of the `phpstan.neon` file and put that file in your application folder. Then edit the file, find the `autoload_files` key and update it like, f.i., here below and add your own classes are stored, f.i.:

```
parameters:
    - autoload_files:
        - %currentWorkingDirectory%/vendor/autoload.php
        - %currentWorkingDirectory%/autoload.php
        - %currentWorkingDirectory%/my_autoloader.php
```

(don't remove any lines, just add yours)

#### PHPStan - Understanding issues

##### Autoloading not configured properly

If, inside your script, you're using external classes; be sure that your autoloader are loaded by PHPStan. If not, you'll receive the following error:
`Class A_CLASS_NAME was not found while trying to analyse it - autoloading is probably not configured properly.`

If it's your case, please refers to `PHPStan - Add classes`.

### 12. PHPCPD

> Shortcut: `phpcpd.bat`

PHP Copy/Paste detector will help to detect duplicate code in PHP files.

Do you've copied five or more lines from that file and paste it there and there? Sometimes, a do this for just a test and ... forget these lines.

For more information about PHPCPD, please take a look on the [PHPCPD repository](https://github.com/sebastianbergmann/phpcpd).

Note: be sure that PHPCPD is installed by running `composer global require sebastian/phpcpd` (or by using the composer.json mentioned in chapter 1)

#### PHPCPD - Output

The result of the `phpcpd.bat` script is echoed on the console.

Most probably you'll get a `No clones found.` (unless you're using *copy* the *paste* a lot).

### 13. PHPCS

> Shortcut: `phpcs.bat`

PHPCS tokenizes PHP, JavaScript and CSS files to detect violations of a defined coding standard.

See also [PHPCBF](#9-phpcbf) for automatically fixing somes violations detected by PHPCS.

For more information about PHPCS, please take a look on the [PHPCS repository](https://github.com/squizlabs/PHP_CodeSniffer). Also take a look on the configuration options : [https://github.com/squizlabs/PHP_CodeSniffer/wiki/Configuration-Options](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Configuration-Options)

Note: be sure that PHP_CodeSniffer is installed by running `composer global require squizlabs/php_codesniffer` (or by using the composer.json mentioned in chapter 1)

#### PHPCS - Output

The result of the `phpcs.bat` script will be a log file that will be automatically opened with Notepad so it's easy to retrieve all errors / warnings / notices / ... and process them.

Here is an example:

```
FILE: C:\Christophe\Repository\public\assets\js\interface.js
------------------------------------------------------------
FOUND 127 ERRORS AFFECTING 117 LINES
------------------------------------------------------------
   1 | ERROR | [x] Expected 1 space after FUNCTION keyword; 0 found
   8 | ERROR | [x] Line indented incorrectly; expected at least 4 spaces, found 2
  13 | ERROR | [x] Line indented incorrectly; expected at least 4 spaces, found 2
  33 | ERROR | [x] Opening brace should be on a new line
  35 | ERROR | [x] Line indented incorrectly; expected at least 8 spaces, found 4
```

#### PHPCS - Configuration

PHPCS is using the `ruleset.xml` file so if you need to update the file to fit your needs, just get a copy of that file and copy it in your application folder.

### 14. PHPMD

> Shortcut: `phpmd.bat`

PHPMD - Mess detector takes a given PHP source code base and look for several potential problems within that source. These problems can be things like:

-   Possible bugs
-   Suboptimal code
-   Overcomplicated expressions
-   Unused parameters, methods, properties
-   ...

For more information about PHPMD, please take a look on the [PHPMD repository](https://github.com/phpmd/phpmd).

Note: be sure that PHPMD is installed by running `composer global require phpmd/phpmd` (or by using the composer.json mentioned in chapter 1)

#### PHPMD - Output

The script will generate one `.html` file by processed folder. The file will then be automatically opened with Chrome.

#### PHPMD - Configuration

PHPMD is using the `rulesets\codesize.xml` file so if you need to update the file to fit your needs, just get a copy of that file and copy it in your application folder.

##### PHPMD - Ignore specific folder

In your project, if you want to ignore folders, just get a copy of the `.phpmenu-ignore` file and put that file in your application folder. Then edit the file and add the list of folders to ignore like; f.i.:

```
.git
.phan
.vscode
build
docs
tests
vendor
```

### 15. PHPMND

> Shortcut: `phpmnd.bat`

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

#### PHPMND - Output

The script will generate a `.xml` file as output and the file will be opened with Chrome when the scan is done.

Here is an example:

PHPMND has identified that a number `404` has been used in the line 112 of the file. No suggestion is made but it's clear here that the idea is to defined a constant like `HTTP_404` and use the constant instead of the figure.

```xml
<?xml version="1.0"?>
<phpmnd version="2.0.0" fileCount="14" errorCount="2">
  <files>
    <file path="src\classes\tests\WebClient.php" errors="1">
      <entry line="112" start="41" end="44">
        <snippet>
          <![CDATA[            if ((!$this->silentMode) && (404 !== $statusCode)) {]>
        </snippet>
        <suggestions/>
      </entry>
    </file>
  </files>
</phpmnd>
```

### 16. PHP Metrics

> Shortcut: `phpmetrics.bat`

PHP Metrics will produce HTML pages to allow you to see a lot of information's about your project and see, f.i., a chart with the complexity of your classes.

For more information about PHP Metrics, please take a look on the [PHP Metrics repository](https://github.com/phpmetrics/PhpMetrics).

Note: be sure that PHP Metrics is installed by running `composer global require phpmetrics/phpmetrics` (or by using the composer.json mentioned in chapter 1)

#### PHP Metrics - Output

The result of the scan will be a local website stored in your temporary folder. Once the scan is done, Chrome will be opened and the index page of the site will be displayed.

![PHP Metrics - Output](images/phpmetrics.jpg)

### 19. PHP 7.x Compatibility

> Shortcut: `phpcompatibility.bat`

This script will scan PHP files against possible errors with PHP 7.x.

The list of rules are located in the folder `%APPDATA%\Composer\vendor\phpcompatibility\php-compatibility\PHPCompatibility`.

The check is done by default against PHP 7.2 but you can change that by calling the script by specifying the version. The first parameter is the folder to scan (`src` here below) then the PHP version (`7.3`)

```
phpcompatibility src 7.3
```

#### PHP Compatibility - Output

A logfile will be generated with possible errors then opened in Notepad.

### 20. PHPUNIT

PHPUNIT will make easy to run your unit tests from a command prompt.

For more information aboutPHPUNIT, please take a look on the [PHPUNIT repository](https://github.com/sebastianbergmann/phpunit).

Note: be sure that PHPUNIT is installed by running `composer global require phpunit/phpunit` (or by using the composer.json mentioned in chapter 1)

#### PHPUnit - Output

The output will be the one as coded in your PHP files.

### 25. PHPLOC

PHPLOC produces statistics about your project like getting the number of files/folders, total number of lines (code, comments, ...), calculate percentage and others things (cyclomatic complexity, number of dependencies, ...)

For more information about PHPLOC, please take a look on the [PHPLOC repository](https://github.com/sebastianbergmann/phploc).

Note: be sure that PHPLOC is installed by running `composer global require phploc/phploc` (or by using the composer.json mentioned in chapter 1)

#### PHPLOC - Output

Something like this:

```
phploc 4.0.1 by Sebastian Bergmann.

Directories                                         11
Files                                               46

Size
  Lines of Code (LOC)                             7752
  Comment Lines of Code (CLOC)                    3171 (40.91%)
  Non-Comment Lines of Code (NCLOC)               4581 (59.09%)
  Logical Lines of Code (LLOC)                    1621 (20.91%)
    Classes                                       1339 (82.60%)
      Average Class Length                          31
        Minimum Class Length                         0
        Maximum Class Length                       183
      Average Method Length                          6
        Minimum Method Length                        1
        Maximum Method Length                       42
    Functions                                       25 (1.54%)
      Average Function Length                        5
    Not in classes or functions                    257 (15.85%)

Cyclomatic Complexity
  Average Complexity per LLOC                     0.19
  Average Complexity per Class                    7.65
    Minimum Class Complexity                      1.00
    Maximum Class Complexity                     44.00
  Average Complexity per Method                   2.45
    Minimum Method Complexity                     1.00
    Maximum Method Complexity                    21.00

Dependencies
  Global Accesses                                   63
    Global Constants                                52 (82.54%)
    Global Variables                                 0 (0.00%)
    Super-Global Variables                          11 (17.46%)
  Attribute Accesses                               421
    Non-Static                                     397 (94.30%)
    Static                                          24 (5.70%)
  Method Calls                                     723
    Non-Static                                     457 (63.21%)
    Static                                         266 (36.79%)

Structure
  Namespaces                                        10
  Interfaces                                         0
  Traits                                             0
  Classes                                           43
    Abstract Classes                                 2 (4.65%)
    Concrete Classes                                41 (95.35%)
  Methods                                          194
    Scope
      Non-Static Methods                           148 (76.29%)
      Static Methods                                46 (23.71%)
    Visibility
      Public Methods                               145 (74.74%)
      Non-Public Methods                            49 (25.26%)
  Functions                                          5
    Named Functions                                  2 (40.00%)
    Anonymous Functions                              3 (60.00%)
  Constants                                         44
    Global Constants                                24 (54.55%)
    Class Constants                                 20 (45.45%)
```

### 30. PHPDOC

This script will scan all your files and will create a `docs` folder under your application root folder and will output there a lot of html files that will describe your application.

#### PHPDOC - Output

![PHPDOC - Output](images/phpdoc.png)

## License

[MIT](LICENSE)
