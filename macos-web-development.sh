#!/bin/bash
# Creator: Thomas Isberg


# Installs MacOS web development stuff:
#  • Xcode
#  • Homebrew
#  • Openldap and Libiconv
#  • MySQL
#  • Dnsmasq
#  • Apache (via Homebrew)
#  • PHP versions 5.6 to 7.4 (optional)
#  • sphp – a PHP switcher script


# ----------------------------------------------------------
# Options.
# ----------------------------------------------------------
HELP=false
DRY_RUN=true
PHP_5_6=true
PHP_7_0=true
PHP_7_1=true
PHP_7_2=true
PHP_7_3=true
PHP_7_4=true

while test $# != 0
do
    case "$1" in
    --help) HELP=true ;;
    -h)     HELP=true ;;
    --no-dry-run) DRY_RUN=false ;;
    --no-php-5-6) PHP_5_6=false ;;
    --no-php-7-0) PHP_7_0=false ;;
    --no-php-7-1) PHP_7_1=false ;;
    --no-php-7-2) PHP_7_2=false ;;
    --no-php-7-3) PHP_7_3=false ;;
    --no-php-7-4) PHP_7_4=false ;;
    esac
    shift
done


# ----------------------------------------------------------
# Colors.
# ----------------------------------------------------------
C_0='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_ORANGE='\033[0;33m'
C_BLUE='\033[0;34m'
C_PURPLE='\033[0;35m'
C_CYAN='\033[0;36m'
C_LIGHT_PURPLE='\033[1;35m'

C_GOOD="$C_GREEN"
C_OK="$C_ORANGE"
C_BAD="$C_RED"

C_1="$C_CYAN"
C_2="$C_BLUE"
C_INFO="$C_OK"
C_EM="$C_LIGHT_PURPLE"


# ----------------------------------------------------------
# Help.
# ----------------------------------------------------------
if [ $HELP = true ]; then
    echo ""
    echo -e "${C_1}Installs MacOS web development stuff:${C_0}"
    echo -e "${C_EM} • Xcode${C_0}"
    echo -e "${C_EM} • Homebrew${C_0}"
    echo -e "${C_EM} • Openldap and Libiconv${C_0}"
    echo -e "${C_EM} • MySQL${C_0}"
    echo -e "${C_EM} • Dnsmasq${C_0}"
    echo -e "${C_EM} • Apache (via Homebrew)${C_0}"
    echo -e "${C_EM} • PHP versions 5.6 to 7.4 (optional)${C_0}"
    echo -e "${C_EM} • sphp – a PHP switcher script${C_0}"
    echo ""
    echo -e "${C_1}By default ${C_EM}macos-web-development${C_1} performs a dry run and installs nothing. Use ${C_INFO}--no-dry-run${C_1} to actually do stuff.${C_0}"
    echo ""
    echo -e "${C_1}After installation you can run ${C_0}sphp 7.2${C_1} to switch PHP version (7.2 in this example). ${C_EM}sphp${C_1} only works with Apache installed with Homebrew.${C_0}"
    echo ""
    echo -e "${C_1}Options:${C_0}"
    echo -e "${C_INFO}-h, --help      ${C_GOOD}Display this help${C_0}"
    echo -e "${C_INFO}--no-dry-run    ${C_GOOD}Disable dry run and actually install stuff${C_0}"
    echo -e "${C_INFO}--no-php-5-6    ${C_GOOD}Skip PHP 5.6${C_0}"
    echo -e "${C_INFO}--no-php-7-0    ${C_GOOD}Skip PHP 7.0${C_0}"
    echo -e "${C_INFO}--no-php-7-1    ${C_GOOD}Skip PHP 7.1${C_0}"
    echo -e "${C_INFO}--no-php-7-2    ${C_GOOD}Skip PHP 7.2${C_0}"
    echo -e "${C_INFO}--no-php-7-3    ${C_GOOD}Skip PHP 7.3${C_0}"
    echo -e "${C_INFO}--no-php-7-4    ${C_GOOD}Skip PHP 7.4${C_0}"
    echo ""
    exit
fi


PWD=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# PHP_VERSIONS=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4")
APACHE_PATH="/usr/local/etc/httpd"
# APACHE_PATH="/private/etc/apache2"
APACHE_PATH_CONF="$APACHE_PATH/httpd.conf"
APACHE_PATH_VHOSTS="$APACHE_PATH/extra/httpd-vhosts.conf"
APACHE_LOG_DIR="/var/log/apache2"
PHP_INI_DEST="/usr/local/php/php.ini"
PHP_LOG_DIR="/var/log/php"


# Create list of PHP versions, based on options.
ALL_PHP_VERSIONS=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4")
ALL_PHP_FLAGS=($PHP_5_6 $PHP_7_0 $PHP_7_1 $PHP_7_2 $PHP_7_3 $PHP_7_4)
PHP_VERSIONS=()
for i in "${!ALL_PHP_FLAGS[@]}"; do
    if [ ${ALL_PHP_FLAGS[$i]} = true ]; then
        PHP_VERSIONS+=("${ALL_PHP_VERSIONS[$i]}")
    fi
done



# ----------------------------------------------------------
# Sudo
# ----------------------------------------------------------

echo -e "${C_1}Acquire sudo ...${C_0}"
sudo echo "" > /dev/null
echo -e "${C_EM}Hello Sudoer!${C_0}"


# ----------------------------------------------------------
# Xcode
# ----------------------------------------------------------
XCODE_STATUS="$(xcode-select -v)"
if [ -z "$XCODE_STATUS" ]; then
    echo -e "${C_1}Installing Xcode command line tools ...${C_0}"
    if ! $DRY_RUN; then
        xcode-select --install
    fi
else
    echo -e "${C_2}Xcode command line tools already installed${C_0}"
fi


# ----------------------------------------------------------
# Homebrew
# ----------------------------------------------------------

if ! [ -x "$(command -v brew)" ]; then
    echo -e "${C_1}Installing Homebrew ...${C_0}"
    if ! $DRY_RUN; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
else
    echo -e "${C_2}Homebrew already installed.${C_0}"
fi


# ----------------------------------------------------------
# Openldap and Libiconv
# ----------------------------------------------------------

if ! [[ -n "$(brew ls --versions "openldap")" ]]; then
    echo -e "${C_1}Installing Openldap ...${C_0}"
    if ! $DRY_RUN; then
        brew install openldap
    fi
else
    echo -e "${C_2}Openldap already installed.${C_0}"
fi

if ! [[ -n "$(brew ls --versions "libiconv")" ]]; then
    echo -e "${C_1}Installing Libiconv ...${C_0}"
    if ! $DRY_RUN; then
        brew install libiconv
    fi
else
    echo -e "${C_2}Libiconv already installed.${C_0}"
fi


# ----------------------------------------------------------
# MySQL
# ----------------------------------------------------------

if ! [ -x "$(command -v mysql)" ]; then
    echo -e "${C_1}Installing MySQL ...${C_0}"
    if ! $DRY_RUN; then
        brew install mysql
    fi
else
    echo -e "${C_2}MySQL already installed.${C_0}"
fi


# ----------------------------------------------------------
# Dnsmasq
# ----------------------------------------------------------

if ! [ -x "$(command -v dnsmasq)" ]; then
    echo -e "${C_1}Installing Dnsmasq ...${C_0}"
    if ! $DRY_RUN; then
        brew install dnsmasq
        cd $(brew --prefix); mkdir etc; echo 'address=/.test/127.0.0.1' > etc/dnsmasq.conf
        sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
        sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
        sudo mkdir /etc/resolver
        sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'
        cd $PWD
    fi
else
    echo -e "${C_2}Dnsmasq already installed.${C_0}"
fi


# ----------------------------------------------------------
# Apache (via Homebrew)
# ----------------------------------------------------------

APACHE_INSTALLED=false
if ! [[ -n "$(brew ls --versions "httpd")" ]]; then
    # Prepare custom log directory.
    echo -e "${C_1}Preparing Apache log directory ...${C_0}"
    if ! $DRY_RUN; then
        sudo mkdir -p $APACHE_LOG_DIR
        sudo chgrp -R staff $APACHE_LOG_DIR
        sudo chmod -R ug+w $APACHE_LOG_DIR
    fi
    # Stop current Apache server.
    echo -e "${C_1}Stopping potentially running Apache ...${C_0}"
    if ! $DRY_RUN; then
        sudo apachectl stop
        sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null
    fi
    echo -e "${C_1}Installing Apache (via Homebrew) ...${C_0}"
    if ! $DRY_RUN; then
        brew install httpd
        brew services start httpd
    fi
    $APACHE_INSTALLED=true
    APACHE_PATH_CONF_EXISTS=false
    if [ -f "$APACHE_PATH_CONF" ]; then
        APACHE_PATH_CONF_EXISTS=true
    fi
    # Apache User / Group.
    read -p "Apache User [$USER]: " APACHE_USER
    APACHE_USER=${APACHE_USER:-$USER}
    read -p "Apache Group [staff]: " APACHE_GROUP
    APACHE_GROUP=${APACHE_GROUP:-staff}
    # Apache admin e-mail
    read -p "Apache Admin e-mail [admin@example.test]: " APACHE_ADMIN_EMAIL
    APACHE_ADMIN_EMAIL=${APACHE_ADMIN_EMAIL:-admin@example.test}
    # Apache server name
    read -p "Apache Server Name [localhost]: " APACHE_SERVER_NAME
    APACHE_SERVER_NAME=${APACHE_SERVER_NAME:-localhost}
    # Apache document root.
    read -p "Apache Document Root [/Users/$APACHE_USER/WebServer]: " APACHE_DOC_ROOT
    APACHE_DOC_ROOT=${APACHE_DOC_ROOT:-"/Users/$APACHE_USER/WebServer"}
    APACHE_DOC_ROOT_REGEX="^DocumentRoot \"..*\"$"
    # Modify Apache conf.
    if $APACHE_PATH_CONF_EXISTS; then
        if ! $DRY_RUN; then
            # Listen on port 80.
            sudo sed -i.bak "s|^Listen ..*$|Listen 80|g" $APACHE_PATH_CONF
            # Enable rewrite module.
            sudo sed -i "s|^\#LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so$|LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so|g" $APACHE_PATH_CONF
            sudo sed -i "s|^User ..*$|User $APACHE_USER|g" $APACHE_PATH_CONF
            sudo sed -i "s|^Group ..*$|Group $APACHE_GROUP|g" $APACHE_PATH_CONF
            sudo sed -i "s|^ServerAdmin ..*@..*\...*$|ServerAdmin $APACHE_ADMIN_EMAIL|g" $APACHE_PATH_CONF
            sudo sed -i "s|^\#*ServerName ..*$|ServerName $APACHE_SERVER_NAME|g" $APACHE_PATH_CONF
            sudo sed -i "s|$APACHE_DOC_ROOT_REGEX|DocumentRoot $APACHE_DOC_ROOT|g" $APACHE_PATH_CONF
            sudo perl -i -0pe "s|^(DocumentRoot .*)\n<Directory ..*>|\1\n<Directory \"$APACHE_DOC_ROOT\">|mg" $APACHE_PATH_CONF
            # Error log.
            sudo sed -i "s|^ErrorLog ..*|ErrorLog \"$APACHE_LOG_DIR/error_log\"|g" $APACHE_PATH_CONF
        else
            echo "Will change Apache config lines ..."
            sudo sed -n "s|^Listen ..*$|Listen 80|gp" $APACHE_PATH_CONF
            sudo sed -n "s|^\#*LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so$|LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so|gp" $APACHE_PATH_CONF
            sudo sed -n "s|^User ..*$|User $APACHE_USER|gp" $APACHE_PATH_CONF
            sudo sed -n "s|^Group ..*$|Group $APACHE_GROUP|gp" $APACHE_PATH_CONF
            sudo sed -n "s|^ServerAdmin ..*@..*\...*$|ServerAdmin $APACHE_ADMIN_EMAIL|gp" $APACHE_PATH_CONF
            sudo sed -n "s|^\#*ServerName ..*$|ServerName $APACHE_SERVER_NAME|gp" $APACHE_PATH_CONF
            sudo sed -n "s|$APACHE_DOC_ROOT_REGEX|DocumentRoot \"$APACHE_DOC_ROOT\"|gp" $APACHE_PATH_CONF
            # Disabled until I figure out how to print changed lines only with perl.
            # sudo perl -0pe "s|^(DocumentRoot .*)\n<Directory ..*>|\1\n<Directory \"$APACHE_DOC_ROOT\">|mg" $APACHE_PATH_CONF
            sudo sed -n "s|^ErrorLog ..*|ErrorLog \"$APACHE_LOG_DIR/error_log\"|gp" $APACHE_PATH_CONF
        fi
    fi

    # Setup virtual hosts.
    echo -e "${C_1}Installing Apache vhosts configuration ...${C_0}"
    if ! $DRY_RUN; then
        APACHE_VHOSTS=$(<httpd-vhosts.conf)
        APACHE_VHOSTS="${APACHE_VHOSTS//\{APACHE_DOC_ROOT\}/$APACHE_DOC_ROOT}"
        APACHE_PATH_VHOSTS_BACKUP="$APACHE_PATH_VHOSTS.bak"
        if ! [ -f "$APACHE_PATH_VHOSTS_BACKUP" ]; then
            echo "Moved current Apache vhosts configuration to $APACHE_PATH_VHOSTS_BACKUP"
            sudo cp $APACHE_PATH_VHOSTS $APACHE_PATH_VHOSTS_BACKUP
        fi
        echo "$APACHE_VHOSTS" | sudo tee $APACHE_PATH_VHOSTS > /dev/null
    fi
    
    # Restart Apache.
    echo -e "${C_1}Restarting Apache ...${C_0}"
    if ! $DRY_RUN; then
        sudo apachectl -k restart
    fi

    # Server root.
    echo -e "${C_1}Creating server root ...${C_0}"
    if ! $DRY_RUN; then
        mkdir -p "$APACHE_DOC_ROOT"
        echo "<?php phpinfo();" > "$APACHE_DOC_ROOT/index.php"
    fi
else
    echo -e "${C_2}Apache (via Homebrew) already installed.${C_0}"
    APACHE_DOC_ROOT=$(sed -n "s|DocumentRoot \"\(.*\)\"|\1|gp" $APACHE_PATH_CONF)
fi


# ----------------------------------------------------------
# PHP
# ----------------------------------------------------------

# Prepare custom log directory.
echo -e "${C_1}Preparing PHP log directory ...${C_0}"
if ! $DRY_RUN; then
    sudo mkdir -p $PHP_LOG_DIR
    sudo chgrp -R staff $PHP_LOG_DIR
    sudo chmod -R ug+w $PHP_LOG_DIR
fi

# Install PHP ini file.
echo -e "${C_1}Installing PHP ini ...${C_0}"
if ! $DRY_RUN; then
    sudo mkdir -p /usr/local/php
    sudo cp "$DIR/php.ini" $PHP_INI_DEST
fi

# Enable deprecated Homebrew PHP packages.
echo -e "${C_1}Enable deprecated Homebrew PHP packages ...${C_0}"
if ! $DRY_RUN; then
    brew tap exolnet/homebrew-deprecated
fi

# Install PHP versions.
for php_version in ${PHP_VERSIONS[*]}; do
    if ! [[ -n "$(brew ls --versions "php@$php_version")" ]]; then
        echo -e "${C_1}Installing php$php_version ...${C_0}"
        if ! $DRY_RUN; then
            brew install "php@$php_version"
        fi
    else
        echo -e "${C_2}php$php_version already installed.${C_0}"
    fi
    if ! $DRY_RUN; then
        ln -s $PHP_INI_DEST "/usr/local/etc/php/$php_version/conf.d/php.ini"
    fi
done

# Apache PHP config.
echo -e "${C_1}Apache PHP config ...${C_0}"
APACHE_PHP_INJECT='<IfModule dir_module>\n    DirectoryIndex index.php index.html\n</IfModule>\n<FilesMatch \.php\$>\n    SetHandler application/x-httpd-php\n</FilesMatch>'
if $APACHE_PATH_CONF_EXISTS; then
    if ! $DRY_RUN; then
        sudo perl -i -0pe "s|^<IfModule dir_module>\n.*DirectoryIndex index.html\n</IfModule>|$APACHE_PHP_INJECT|mg" $APACHE_PATH_CONF
        echo -e "${C_2}Restarting Apache ...${C_0}"
        sudo apachectl -k restart
    # else
        # Disabled until I figure out how to print changed lines only with perl.
        # sudo perl -0pe "s|^<IfModule dir_module>\n.*DirectoryIndex index.html\n</IfModule>|$APACHE_PHP_INJECT|mg" $APACHE_PATH_CONF
    fi
fi


# Install sphp script.
if ! [ -x "$(command -v sphp)" ]; then
    echo -e "${C_1}Installing sphp ...${C_0}"
    if ! $DRY_RUN; then
        cp "$DIR/sphp.sh" /usr/local/bin/sphp
        chmod +x /usr/local/bin/sphp
        echo -e "${C_EM}Switch PHP version using for example ${C_0}sphp 7.2"
    fi
else
    echo -e "${C_2}sphp already installed.${C_0}"
fi


# Finish.
echo ""
if ! $DRY_RUN; then
    echo -e "${C_EM}Done!${C_0}"
    echo ""
    if $APACHE_INSTALLED; then
        echo -e "${C_GOOD}You should now be able to browse ${C_INFO}http://{any}.test${C_GOOD} to visit ${C_INFO}$APACHE_DOC_ROOT/sites/{any}/public${C_GOOD}. Additional vhost entries may be defined in ${C_INFO}$APACHE_PATH_VHOSTS${C_GOOD}.${C_0}"
        echo ""
    fi
    echo -e "${C_GOOD}Next: you should enable a PHP version by running ${C_0}sphp 7.2${C_GOOD} (use desired version).${C_0}"
else
    echo -e "${C_GOOD}Did nothing since script defaults to dry run. Use ${C_INFO}--no-dry-run${C_GOOD} to actually do stuff.${C_0}"
    echo -e "${C_GOOD}See ${C_INFO}--help${C_GOOD} for all options.${C_0}"
fi
echo ""