# macos-web-development

Installs MacOS web development AMP stack (Apache, MySQL and PHP).


## Features

- Browse `http://{any}.test` to visit `~/{user}/WebServer/sites/{any}/public` (customizable path).
- Switch between PHP versions 5.6 to 7.4 using command `sphp 7.2` (use desired version).
- Opt out of features (Apache, MySQL, PHP etc).
- Defaults to dry run – see what the script will do before actually doing it.


## Installed software

- xcode-select – Xcode command line developer tools
- Homebrew
- Openldap
- Libiconv
- MySQL
- Dnsmasq
- Apache (via Homebrew)
- PHP versions 5.6 to 7.4 (optional)
- sphp – a PHP switcher script


### Usage

See the help for details.

```bash
./macos-web-development.sh --help
```