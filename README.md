# macos-web-development

Installs macOS web development AMP stack (Apache, MySQL and PHP).


## Why macos-web-development?

### Because you want to

```bash
./macos-web-development.sh --no-dry-run
```

... and then instantly create a cool PHP based website at http://cool.test

```bash
mkdir -p ~/WebServer/sites/cool/public && echo "<h1>Cool</h1>" >> ~/WebServer/sites/cool/public/index.php
```

... without reading tutorials and performing installation steps manually. 🤩

You will also be able to create http://cool.com.test or http://cool.co.uk.test or whatever.

### Also

Because you want to manage your own stack of independent software, which you are free to mess around with in any way you want. Macos-web-development simply installs packages, mostly with [Homebrew](https://brew.sh) (which is also automatically installed), and edits configuration files.



## Features

- **Browse** `http://{any}.test` to visit `~/{user}/WebServer/sites/{any}/public` (fully customizable path).
- **Switch** between PHP versions 5.6 to 8.1 using command `sphp {version}`, for example `sphp 8.1`.
- **Distribute** Apache vhosts configuraton and PHP ini from template files in repository. Simply adjust them to your needs before installation... or not. 🙃
- **Opt out** of software you don't want. For example `--no-mysql`.
- **Dry run** – check which software is already installed etc. This is the default behaviour, use `--no-dry-run` to actually install stuff.
- **Uninstall** – removes most stuff, but not all. ☝️ [See details below](#uninstallation-1).

### Apache configuration

After installation the Apache vhosts configuration is found at `/usr/local/etc/httpd/extra/httpd-vhosts.conf` for Intel based macs and at `/opt/homebrew/etc/httpd/extra/httpd-vhosts.conf` for newer macs. Change it whenever you want and restart Apache using `brew services restart httpd`.


### PHP ini

The custom PHP ini file is installed as a symlink in each PHP version, pointing to `/usr/local/php/php.ini`. One file for all PHP versions = enjoy. 🥳


## Installing macos-web-development (self installation)

**macos-web-development** was originally not intended to be installed, and works fine by just executing `./macos-web-delopment.sh` from your downloaded repository. [See Usage below](#usage).

If you self install macos-web-development you can execute it from anywhere by replacing `./macos-web-delopment.sh` with `macos-web-delopment` in the Usage instructions below. This is primarily useful for future [complementary installations](#complementary-installation).


#### How to self install

```bash
./self-install
```

* Installs files to `/usr/local/macos-web-development/`.
* Creates executable symlink at `/usr/local/bin/macos-web-development` (should be in your `$PATH`).


#### Caveats

When you self install macos-web-development, the templates for Apache and PHP configurations are also installed, so you need to tweak them (if desired) before self installation.

You can always perform a new self installation to update macos-web-development (and your templates).


## Usage

Replace `./macos-web-delopment.sh` with `macos-web-delopment` in all exmples below if you have self installed macos-web-development.

#### Full installation (dry run with info)

```bash
./macos-web-development.sh
```


#### Full installation

```bash
./macos-web-development.sh --no-dry-run
```


#### Installation with selected version of PHP and no MySQL

```bash
./macos-web-development.sh --only-php-7-4 --no-mysql --no-dry-run
```


#### Installation with preset

##### Common

Installs mandatory stuff and **Apache**, **MySQL**, **PHP 7.4** and **Dnsmasq**.

```bash
./macos-web-development.sh --p-common --no-dry-run
```

##### Minimal

Installs mandatory stuff and **Apache**, **PHP 7.4** and **Dnsmasq**. No **MySQL**.

```bash
./macos-web-development.sh --p-minimal --no-dry-run
```


#### Uninstallation

Maybe you're poking around with your computer and want to *uninstall... install... uninstall... install...* 😎

```bash
./macos-web-development.sh --uninstall --no-dry-run
```


#### See the help for all details

```bash
./macos-web-development.sh --help
```


## Installed software

The following software is included in a full installation.

- **xcode-select** Xcode command line developer tools. You probably already have this... feel free to pass `--no-xcode-select`.
- **Homebrew**
- **Openldap**
- **Libiconv**
- **MySQL**
- **Dnsmasq** to be able to browse `http://{any}.test`
- **Apache** some say it's better with Homebrew than the MacOS default. 🤷‍♂️ Script based Apache PHP configuration (and PHP switching with `sphp`) only works with a Homebrew:ed Apache.
- **PHP** versions 5.6 to 8.1
- **sphp** a PHP switching script

All of the above will only be installed if not already on the machine. However, **Apache** and versions of **PHP** will only be skipped by default if they were already installed with **Homebrew**. If not, they will be installed with Homebrew and replace existing ones, which will remain untouched on the system. Should you choose to uninstall with macos-web-development, the existing software should be brought back to life, as if nothing ever happened.


### Uninstallation

- Will not uninstall **xcode-select**, **Homebrew** and **Openldap**.
- Will not remove the server root folder at `~/WebServer/sites` (or the folder you specified), or any websites in there.
- Will uninstall the **MySQL server**, but will not remove any **databases**.
- Takes no other options than `--no-dry-run` and will always uninstall all supported versions of **PHP** etc.


### Complementary installation

Should you decide that you need a specific feature after installation without it, just execute a new installation. Installed software will be left alone, and only the missing packages will be installed.

#### To only install a new version of PHP (8.1 in this example)

```bash
./macos-web-development.sh --only-php --only-php-8-1 --no-dry-run
```


## Options

Option                                    | Description
:---                  | :---
`-h` or `--help`      | Display help.
`--no-apache`         | Skip Apache.
`--no-dnsmasq`        | Skip Dnsmasq. You just won't be able to browse `http://{any}.test` to automatically visit `~/WebServer/sites/{any}/public`. Virtual hosts can still be managed manually.
`--no-dry-run`        | Disable dry run and actually install stuff.
`--no-mysql`          | Skip MySQL.
`--no-php`            | Skip PHP.
`--no-php-5-6`        | Skip PHP 5.6
`--no-php-7-0`        | Skip PHP 7.0
`--no-php-7-1`        | Skip PHP 7.1
`--no-php-7-2`        | Skip PHP 7.2
`--no-php-7-3`        | Skip PHP 7.3
`--no-php-7-4`        | Skip PHP 7.4
`--no-php-8-0`        | Skip PHP 8.0
`--no-php-8-1`        | Skip PHP 8.1
`--no-php-enable`     | Don't automatically enable the latest version of PHP in currently executing installation.
`--no-xcode-select`   | Skip Xcode command line developer tools.
`--only-apache`       | Only install Apache.
`--only-dnsmasq`      | Only install Dnsmasq.
`--only-mysql`        | Only install MySQL.
`--only-php`          | Only install PHP.
`--only-php-5-6`      | Only install PHP 5.6. Combine with `--only-php` if desired.
`--only-php-7-0`      | Only install PHP 7.0. Combine with `--only-php` if desired.
`--only-php-7-1`      | Only install PHP 7.1. Combine with `--only-php` if desired.
`--only-php-7-2`      | Only install PHP 7.2. Combine with `--only-php` if desired.
`--only-php-7-3`      | Only install PHP 7.3. Combine with `--only-php` if desired.
`--only-php-7-4`      | Only install PHP 7.4. Combine with `--only-php` if desired.
`--only-php-8-0`      | Only install PHP 8.0. Combine with `--only-php` if desired.
`--only-php-8-1`      | Only install PHP 8.1. Combine with `--only-php` if desired.
`--only-xcode-select` | Only install Xcode command line tools.
`--p-common`          | Common preset. Sets options `--only-php-7-4 --no-xcode-select`
`--p-minimal`         | Minimal preset. Sets options `--no-mysql --only-php-7-4 --no-xcode-select`
`--uninstall`         | Uninstall. Takes no other options than `--no-dry-run` and will uninstall all versions of PHP etc.


## Credit

### Setup is based on these resources

- *(This link is broken and I can't find the resource elsewhere. I'm keeping it anyway.)* [The Perfect Web Development Environment for Your New Mac](https://mallinson.ca/posts/5/the-perfect-web-development-environment-for-your-new-mac) by Chris Mallinson.
- [macOS 10.15 Catalina Apache Setup: Multiple PHP Versions](https://getgrav.org/blog/macos-catalina-apache-multiple-php-versions) by Andy Miller.
- [How To Install Apache on macOS 10.15 Catalina Using Homebrew](https://medium.com/better-programming/how-to-install-apache-on-macos-10-15-catalina-using-homebrew-78373ad962eb) by Casey McCullen.
- [How To Install a PHP 7.2 on macOS 10.15 Catalina Using Homebrew and PECL](https://medium.com/better-programming/how-to-install-a-php-7-2-on-macos-10-15-catalina-using-homebrew-and-pecl-ad5b6c9ffb17) by Casey McCullen.

### sphp

Original script by Andy Miller: [Easy Brew PHP version switching](https://gist.github.com/rhukster/f4c04f1bf59e0b74e335ee5d186a98e2).

It has been slightly modified to work well with **macos-web-development**.


## Requirements

### macOS tests

- **macOS Monterey** *(12.1)* – successfully tested.
- ~~macOS Big Sur~~ *(11.x)* – **not tested**.
- **macOS Catalina** *(10.15.3)* – successfully tested.
- ~~**macOS Sierra~~ *(10.12.6)* – **tested without success**