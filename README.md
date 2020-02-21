# macos-web-development

Installs MacOS web development AMP stack (Apache, MySQL and PHP).


## Why macos-web-development?

Because you want to

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

Because you want to manage your own stack of independent software, which you are free to mess around with in any way you want. *Macos-web-development* simply installs packages – mostly with [Homebrew](https://brew.sh) (which is also automatically installed) – and edits configuration files.



## Features

- **Browse** `http://{any}.test` to visit `~/{user}/WebServer/sites/{any}/public` (fully customizable path).
- **Switch** between PHP versions 5.6 to 7.4 using command `sphp {version}`, for example `sphp 7.2`.
- **Distribute** Apache vhosts configuraton and PHP ini from template files in repository. Simply adjust them to your needs before installation... or not. 🙃
- **Opt put** of software you don't want. For example `--no-mysql`.
- **Dry run** – check which software is already installed etc. This is the default behaviour, use `--no-dry-run` to actually install stuff.
- **Uninstall** – not sure when you would use this, but hey, it's a free world. 😀

### Apache configuration

After installation the Apache vhosts configuration is found at `/usr/local/etc/httpd/extra/httpd-vhosts.conf`. Change it whenever you want and restart Apache using `sudo apachectl -k restart`.


### PHP ini

The custom PHP ini file is installed as a symlink in each PHP version, pointing to `/usr/local/php/php.ini`. One file for all PHP versions = enjoy. 🥳


## Usage

#### Full installation (dry run with info)

```bash
./macos-web-development.sh
```


#### Full installation

```bash
./macos-web-development.sh --no-dry-run
```


#### Installation with selected versions of PHP and no MySQL

```bash
./macos-web-development.sh --no-php-5-6 --no-php-7-0 --no-php-7-4 --no-mysql --no-dry-run
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
- **PHP** versions 5.6 to 7.4
- **sphp** a PHP switching script


## Options

Option            | Description
:---              | :---
‑h or ‑‑help      | Display help.
‑‑no‑apache       | Skip Apache.
‑‑no‑dnsmasq      | Skip Dnsmasq. You just won't be able to browse `http://{any}.test` to automatically visit `~/WebServer/sites/{any}/public`. Virtual hosts can sill be managed manually.
‑‑no‑dry‑run      | Disable dry run and actually install stuff.
‑‑no‑mysql        | Skip MySQL.
‑‑no‑php          | Skip PHP.
‑‑no‑php‑5‑6      | Skip PHP 5.6
‑‑no‑php‑7‑0      | Skip PHP 7.0
‑‑no‑php‑7‑1      | Skip PHP 7.1
‑‑no‑php‑7‑2      | Skip PHP 7.2
‑‑no‑php‑7‑3      | Skip PHP 7.3
‑‑no‑php‑7‑4      | Skip PHP 7.4
‑‑no‑php‑enable   | Don't enable the latest PHP version installed.
‑‑no‑xcode‑select | Skip Xcode command line developer tools.
‑‑uninstall       | Uninstall. Takes no other options than `--no-dry-run` and will uninstall everything – all versions of PHP etc.


## Credit

### Setup is based on these resources

- [The Perfect Web Development Environment for Your New Mac](https://mallinson.ca/posts/5/the-perfect-web-development-environment-for-your-new-mac) by Chris Mallinson
- [macOS 10.15 Catalina Apache Setup: Multiple PHP Versions](https://getgrav.org/blog/macos-catalina-apache-multiple-php-versions) by Andy Miller
- [How To Install Apache on macOS 10.15 Catalina Using Homebrew](https://medium.com/better-programming/how-to-install-apache-on-macos-10-15-catalina-using-homebrew-78373ad962eb) by Casey McCullen
- [How To Install a PHP 7.2 on macOS 10.15 Catalina Using Homebrew and PECL](https://medium.com/better-programming/how-to-install-a-php-7-2-on-macos-10-15-catalina-using-homebrew-and-pecl-ad5b6c9ffb17) by Casey McCullen

### sphp

Script by Andy Miller: [Easy Brew PHP version switching](https://gist.github.com/rhukster/f4c04f1bf59e0b74e335ee5d186a98e2)


## Requirements

### MacOS

Successfully tested with a fresh installation of **MacOS Catalina** *(10.15.3)*

Probably works with earlier versions too... 🙄