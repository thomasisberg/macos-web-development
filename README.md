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

### Also

Because you want to manage your own stack of independent software, which you are free to mess around with in any way you want. *Macos-web-development* simply installs packages – mostly with [Homebrew](https://brew.sh) (which is also automatically installed) – and edits configuration files.



## Features

- Browse `http://{any}.test` to visit `~/{user}/WebServer/sites/{any}/public` (fully customizable path).
- Switch between PHP versions 5.6 to 7.4 using command `sphp {version}`, for example `sphp 7.2`.
- Distributes Apache vhosts configuraton and PHP ini from example files in repository. Simply adjust them to your needs before installation... or not. 🙃
- Install desired software only, by opting out.
- Defaults to dry run – see what the script will do before actually doing it.
- Uninstall. Not sure when you would use this, but hey, it's a free world. 😀

### Apache configuration

After installation the Apache vhosts configuration is found at `/usr/local/etc/httpd/extra/`. Change it whenever you want and restart Apache using `sudo apachectl -k restart`.


### PHP ini

The custom PHP ini file is installed as a symlink in each PHP version, pointing to `/usr/local/php/php.ini`. One file for all PHP versions. Enjoy! 🥳


## Usage

#### Full installation (dry run with info)

```bash
./macos-web-development.sh
```


#### Full installation

```bash
./macos-web-development.sh --no-dry-run
```

Then browse http://localhost, or http://cool.test after creating it:

```bash
mkdir -p ~/WebServer/sites/cool/public && echo "<h1>Cool</h1>" >> ~/WebServer/sites/cool/public/index.html
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
- **Dnsmasq** to be able to browser `http://{any}.test`
- **Apache** some say it's better with Homebrew than the MacOS default. 🤷‍♂️ Script based PHP configuration and PHP switching with `sphp` only works with a Homebrew:ed Apache.
- **PHP** versions 5.6 to 7.4
- **sphp** a PHP switching script


## Credit

### Setup is based on these resources

- [The Perfect Web Development Environment for Your New Mac](https://mallinson.ca/posts/5/the-perfect-web-development-environment-for-your-new-mac) by Chris Mallinson
- [macOS 10.15 Catalina Apache Setup: Multiple PHP Versions](https://getgrav.org/blog/macos-catalina-apache-multiple-php-versions) by Andy Miller
- [How To Install Apache on macOS 10.15 Catalina Using Homebrew](https://medium.com/better-programming/how-to-install-apache-on-macos-10-15-catalina-using-homebrew-78373ad962eb) by Casey McCullen
- [How To Install a PHP 7.2 on macOS 10.15 Catalina Using Homebrew and PECL](https://medium.com/better-programming/how-to-install-a-php-7-2-on-macos-10-15-catalina-using-homebrew-and-pecl-ad5b6c9ffb17) by Casey McCullen

### sphp

Script by Andy Miller: [Easy Brew PHP version switching](https://gist.github.com/rhukster/f4c04f1bf59e0b74e335ee5d186a98e2)


## Requirements

Successfully tested with a fresh installation of **MacOS Catalina** *(10.15.3)*

Probably works with earlier versions too... 🙄