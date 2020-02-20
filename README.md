# macos-web-development

Installs MacOS web development AMP stack (Apache, MySQL and PHP).


## Features

- Browse `http://{any}.test` to visit `~/{user}/WebServer/sites/{any}/public` (customizable path).
- Switch between PHP versions 5.6 to 7.4 using command `sphp 7.2` (use desired version).
- Only install desired software (Apache, MySQL, PHP etc).
- Defaults to dry run – see what the script will do before actually doing it.


## Installed software

The following software is included in a full installation.

- xcode-select – Xcode command line developer tools
- Homebrew
- Openldap
- Libiconv
- MySQL
- Dnsmasq
- Apache (via Homebrew)
- PHP versions 5.6 to 7.4 (optional)
- sphp – a PHP switcher script


## Usage

See the help for details.

```bash
./macos-web-development.sh --help
```


## Credit

### Setup is based on these resources

- [The Perfect Web Development Environment for Your New Mac](https://mallinson.ca/posts/5/the-perfect-web-development-environment-for-your-new-mac) by Chris Mallinson
- [macOS 10.15 Catalina Apache Setup: Multiple PHP Versions](https://getgrav.org/blog/macos-catalina-apache-multiple-php-versions) by Andy Miller
- [How To Install Apache on macOS 10.15 Catalina Using Homebrew](https://medium.com/better-programming/how-to-install-apache-on-macos-10-15-catalina-using-homebrew-78373ad962eb) by Casey McCullen
- [How To Install a PHP 7.2 on macOS 10.15 Catalina Using Homebrew and PECL](https://medium.com/better-programming/how-to-install-a-php-7-2-on-macos-10-15-catalina-using-homebrew-and-pecl-ad5b6c9ffb17) by Casey McCullen

### sphp by Andy Miller

- [Easy Brew PHP version switching](https://gist.github.com/rhukster/f4c04f1bf59e0b74e335ee5d186a98e2)