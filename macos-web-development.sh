#!/bin/bash

# Creator: Thomas Isberg

# Installs MacOS web development stuff:
#  • xcode-select – Xcode command line developer tools
#  • Homebrew
#  • Openldap
#  • Libiconv
#  • MySQL
#  • Dnsmasq
#  • Apache
#  • PHP versions 5.6 to 7.4
#  • sphp – a PHP switcher script


# ----------------------------------------------------------
# Options.
# ----------------------------------------------------------
HELP=false
DRY_RUN=true
INSTALL_APACHE=true
INSTALL_DNSMASQ=true
INSTALL_MYSQL=true
INSTALL_PHP=true
INSTALL_XCODE=true
ONLY_APACHE=false
ONLY_DNSMASQ=false
ONLY_MYSQL=false
ONLY_PHP=false
ONLY_XCODE=false
PHP_5_6=true
PHP_7_0=true
PHP_7_1=true
PHP_7_2=true
PHP_7_3=true
PHP_7_4=true
PHP_ENABLE=true
PRESET_COMMON=false
PRESET_MINIMAL=false
UNINSTALL=false

while test $# != 0
do
    case "$1" in
    -h)                HELP=true ;;
    --help)            HELP=true ;;
    --no-apache)       INSTALL_APACHE=false ;;
    --no-dnsmasq)      INSTALL_DNSMASQ=false ;;
    --no-dry-run)      DRY_RUN=false ;;
    --no-mysql)        INSTALL_MYSQL=false ;;
    --no-php)          INSTALL_PHP=false ;;
    --no-php-5-6)      PHP_5_6=false ;;
    --no-php-7-0)      PHP_7_0=false ;;
    --no-php-7-1)      PHP_7_1=false ;;
    --no-php-7-2)      PHP_7_2=false ;;
    --no-php-7-3)      PHP_7_3=false ;;
    --no-php-7-4)      PHP_7_4=false ;;
    --no-php-enable)   PHP_ENABLE=false ;;
    --no-xcode-select) INSTALL_XCODE=false ;;
    --only-apache)     ONLY_APACHE=true ;;
    --only-dnsmasq)    ONLY_DNSMASQ=true ;;
    --only-mysql)      ONLY_MYSQL=true ;;
    --only-php)        ONLY_PHP=true ;;
    --only-xcode)      ONLY_XCODE=true ;;
    --p-common)        PRESET_COMMON=true ;;
    --p-minimal)       PRESET_MINIMAL=true ;;
    --uninstall)       UNINSTALL=true ;;
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
C_YELLOW='\033[0;93m'
C_LIGHT_GREY='\033[0;37m'
C_DARK_GREY='\033[1;30m'
C_BOLD_BLUE='\033[1;34m'
C_BOLD_PURPLE='\033[1;35m'
C_BOLD_CYAN='\033[1;36m'

C_GOOD="$C_GREEN"
C_OK="$C_ORANGE"
C_BAD="$C_RED"

C_1="$C_PURPLE"
C_2="$C_BLUE"
C_INFO="$C_BOLD_PURPLE"
C_EM="$C_BOLD_CYAN"


# ----------------------------------------------------------
# Presets.
# ----------------------------------------------------------

# Default
if $PRESET_COMMON; then
    PHP_5_6=false
    PHP_7_0=false
    PHP_7_4=false
    INSTALL_XCODE=false
elif $PRESET_MINIMAL; then
    INSTALL_MYSQL=false
    PHP_5_6=false
    PHP_7_0=false
    PHP_7_1=false
    PHP_7_3=false
    PHP_7_4=false
    INSTALL_XCODE=false
elif $ONLY_APACHE; then
    INSTALL_DNSMASQ=false
    INSTALL_MYSQL=false
    INSTALL_PHP=false
    INSTALL_XCODE=false
elif $ONLY_DNSMASQ; then
    INSTALL_APACHE=false
    INSTALL_MYSQL=false
    INSTALL_PHP=false
    INSTALL_XCODE=false
elif $ONLY_MYSQL; then
    INSTALL_APACHE=false
    INSTALL_DNSMASQ=false
    INSTALL_PHP=false
    INSTALL_XCODE=false
elif $ONLY_PHP; then
    INSTALL_APACHE=false
    INSTALL_DNSMASQ=false
    INSTALL_MYSQL=false
    INSTALL_XCODE=false
elif $ONLY_XCODE; then
    INSTALL_APACHE=false
    INSTALL_DNSMASQ=false
    INSTALL_MYSQL=false
    INSTALL_PHP=false
fi


# ----------------------------------------------------------
# Help.
# ----------------------------------------------------------
if $HELP; then
    echo ""
    echo -e "${C_1}Installs MacOS web development stuff:${C_0}"
    echo -e "${C_EM} • xcode-select (Xcode command line developer tools)${C_0}"
    echo -e "${C_EM} • Homebrew${C_0}"
    echo -e "${C_EM} • Openldap${C_0}"
    echo -e "${C_EM} • Libiconv${C_0}"
    echo -e "${C_EM} • MySQL${C_0}"
    echo -e "${C_EM} • Dnsmasq${C_0}"
    echo -e "${C_EM} • Apache (via Homebrew)${C_0}"
    echo -e "${C_EM} • PHP versions 5.6 to 7.4 (optional)${C_0}"
    echo -e "${C_EM} • sphp – a PHP switcher script${C_0}"
    echo ""
    echo -e "${C_1}By default ${C_EM}macos-web-development${C_1} performs a dry run and installs nothing. Use ${C_INFO}--no-dry-run${C_1} to actually do stuff.${C_0}"
    echo ""
    echo -e "${C_1}After installation you can run ${C_0}sphp 7.2${C_1} to switch PHP version (use desired version). ${C_0}sphp${C_1} only works with Apache from Homebrew.${C_0}"
    echo ""
    echo -e "${C_1}Options:${C_0}"
    echo -e "${C_INFO}-h, --help         ${C_EM}Display this help${C_0}"
    echo -e "${C_INFO}--no-apache        ${C_EM}Skip Apache${C_0}"
    echo -e "${C_INFO}--no-dnsmasq       ${C_EM}Skip Dnsmasq${C_0}"
    echo -e "${C_INFO}--no-dry-run       ${C_EM}Disable dry run and actually install stuff${C_0}"
    echo -e "${C_INFO}--no-mysql         ${C_EM}Skip MySQL${C_0}"
    echo -e "${C_INFO}--no-php           ${C_EM}Skip PHP${C_0}"
    echo -e "${C_INFO}--no-php-5-6       ${C_EM}Skip PHP 5.6${C_0}"
    echo -e "${C_INFO}--no-php-7-0       ${C_EM}Skip PHP 7.0${C_0}"
    echo -e "${C_INFO}--no-php-7-1       ${C_EM}Skip PHP 7.1${C_0}"
    echo -e "${C_INFO}--no-php-7-2       ${C_EM}Skip PHP 7.2${C_0}"
    echo -e "${C_INFO}--no-php-7-3       ${C_EM}Skip PHP 7.3${C_0}"
    echo -e "${C_INFO}--no-php-7-4       ${C_EM}Skip PHP 7.4${C_0}"
    echo -e "${C_INFO}--no-php-enable    ${C_EM}Will not enable the latest PHP version installed${C_0}"
    echo -e "${C_INFO}--no-xcode-select  ${C_EM}Skip xcode-select${C_0}"
    echo -e "${C_INFO}--only-dnsmasq     ${C_EM}Only install Dnsmasq${C_0}"
    echo -e "${C_INFO}--p-common         ${C_EM}Sets options ${C_0}--no-php-5-6 --no-php-7-0 --no--php-7-4 --no-xcode-select"
    echo -e "${C_INFO}--p-minimal        ${C_EM}Sets options ${C_0}--no-mysql --no-php-5-6 --no-php-7-0 --no-php-7-1 --no-php-7-3 --no--php-7-4 --no-xcode-select"
    echo -e "${C_INFO}--uninstall        ${C_EM}Uninstall stuff, but leave some stuff${C_0}"
    echo ""
    exit
fi


# ----------------------------------------------------------
# Common variables.
# ----------------------------------------------------------

PWD=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
APACHE_PATH="/usr/local/etc/httpd"
APACHE_PATH_CONF="$APACHE_PATH/httpd.conf"
APACHE_PATH_CONF_EXISTS=false
if [ -f "$APACHE_PATH_CONF" ]; then
    APACHE_PATH_CONF_EXISTS=true
fi
APACHE_PATH_VHOSTS="$APACHE_PATH/extra/httpd-vhosts.conf"
APACHE_LOG_DIR="/var/log/apache2"
APACHE_INSTALLED=false
PHP_INI_DIR="/usr/local/php"
PHP_INI_DEST="$PHP_INI_DIR/php.ini"
PHP_LOG_DIR="/var/log/php"

# Create list of PHP versions, based on options.
ALL_PHP_VERSIONS=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4")
ALL_PHP_FLAGS=($PHP_5_6 $PHP_7_0 $PHP_7_1 $PHP_7_2 $PHP_7_3 $PHP_7_4)
PHP_VERSIONS=()
for i in "${!ALL_PHP_FLAGS[@]}"; do
    if ${ALL_PHP_FLAGS[$i]}; then
        PHP_VERSIONS+=("${ALL_PHP_VERSIONS[$i]}")
    fi
done
PHP_EXAMPLE_VERSION="7.2"
NUM_PHP_VERSIONS=${#PHP_VERSIONS[@]}
if [ $NUM_PHP_VERSIONS -gt 0 ]; then
    LATEST_PHP_VERSION="${PHP_VERSIONS[$NUM_PHP_VERSIONS-1]}"
    PHP_EXAMPLE_VERSION="$LATEST_PHP_VERSION"
fi


# ----------------------------------------------------------
# Initial message for dry run.
# ----------------------------------------------------------

do_dry_run_message () {
    echo ""
    if $DRY_RUN; then
        if $UNINSTALL; then
            echo -e "${C_EM}Cool down – this is a dry run. Nothing will actually be uninstalled.${C_0}"
        else
            echo -e "${C_EM}Cool down – this is a dry run. Nothing will actually be installed.${C_0}"
        fi
        echo ""
    fi
}


# ----------------------------------------------------------
# Sudo
# ----------------------------------------------------------

do_sudo () {
    echo -e "${C_1}Acquire sudo ...${C_0}"
    sudo echo "" > /dev/null
    echo -e "${C_EM}Hello Sudoer!${C_0}"
}


# ----------------------------------------------------------
# Uninstall.
# ----------------------------------------------------------

do_uninstall () {
    HAS_BREW=false
    if [ -x "$(command -v brew)" ]; then
        HAS_BREW=true
    fi

    HAS_APACHE=false
    if [[ -n "$(brew ls --versions "httpd")" ]]; then
        HAS_APACHE=true
        APACHE_SERVER_NAME=$(sed -n "s|^ServerName \(.*\)|\1|gp" $APACHE_PATH_CONF)
        APACHE_DOC_ROOT=$(sed -n "s|DocumentRoot \"\(.*\)\"|\1|gp" $APACHE_PATH_CONF)
    fi

    # Stop running Apache
    echo -e "${C_1}Stopping potentially running Apache ...${C_0}"
    if ! $DRY_RUN; then
        sudo apachectl -k stop
        if ($HAS_BREW); then
            if $HAS_APACHE; then
                brew services stop httpd
            fi
        fi
    fi

    # sphp
    if [ -x "$(command -v sphp)" ]; then
        echo -e "${C_1}Uninstalling sphp ...${C_0}"
        if ! $DRY_RUN; then
            rm -f /usr/local/bin/sphp
        fi
    else
        echo -e "${C_2}sphp not installed.${C_0}"
    fi

    # PHP versions.
    if $HAS_BREW; then
        for php_version in ${ALL_PHP_VERSIONS[*]}; do
            if [[ -n "$(brew ls --versions "php@$php_version")" ]]; then
                echo -e "${C_1}Uninstalling php$php_version ...${C_0}"
                if ! $DRY_RUN; then
                    brew uninstall "php@$php_version"
                    sudo rm -rf /usr/local/etc/php/$php_version
                fi
            else
                echo -e "${C_2}php$php_version not installed.${C_0}"
            fi
        done
    fi

    # PHP ini file.
    if [ -f "$PHP_INI_DEST" ]; then
        echo -e "${C_1}Uninstalling PHP ini ...${C_0}"
        if ! $DRY_RUN; then
            sudo rm $PHP_INI_DEST
        fi
    else
        echo -e "${C_2}PHP ini not installed.${C_0}"
    fi

    # Hosts file
    if [ "$APACHE_SERVER_NAME" != "localhost" ]; then
        HOSTS_PATH="/private/etc/hosts"
        if ! $DRY_RUN; then
            sudo sed -i.bak "s|^$APACHE_SERVER_NAME \(..*\)|#$APACHE_SERVER_NAME \1|g" $HOSTS_PATH
        else
            sudo sed -n "s|^$APACHE_SERVER_NAME \(..*\)|#$APACHE_SERVER_NAME \1|gp" $HOSTS_PATH
        fi
    fi

    # Apache
    if $HAS_BREW; then
        if $HAS_APACHE; then
            echo -e "${C_1}Uninstalling Apache (via Homebrew) ...${C_0}"
            if ! $DRY_RUN; then
                brew uninstall httpd
                sudo rm -rf $APACHE_PATH
            fi
        else
            echo -e "${C_2}Apache (via Homebrew) not installed.${C_0}"
        fi
    fi

    # Dnsmasq
    if ($HAS_BREW); then
        if [[ -n "$(brew ls --versions "dnsmasq")" ]]; then
            echo -e "${C_1}Uninstalling Dnsmasq ...${C_0}"
            if ! $DRY_RUN; then
                sudo launchctl unload -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist 2>/dev/null
                sudo rm /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
                sudo rm -rf /etc/resolver
                sudo rm $(brew --prefix)/etc/dnsmasq.conf
                brew uninstall dnsmasq
                sudo rm -rf /usr/local/var/run/dnsmasq
            fi
        else
            echo -e "${C_2}Dnsmasq (via Homebrew) not installed.${C_0}"
        fi
    fi

    # MySQL
    if $HAS_BREW; then
        if [[ -n "$(brew ls --versions "mysql")" ]]; then
            echo -e "${C_1}Uninstalling MySQL ...${C_0}"
            if ! $DRY_RUN; then
                brew services stop mysql
                brew uninstall mysql
            fi
            echo -e "${C_EM}Uninstalled package, but did not remove database files. Remove them with ${C_0}rm -rf /usr/local/var/mysql${C_EM} if desired."
        else
            echo -e "${C_2}MySQL (via Homebrew) not installed.${C_0}"
        fi
    fi

    # Libiconv
    if ! $HAS_BREW; then
        echo -e "${C_1}Would look for Libiconv if Homebrew was actually installed.${C_0}"
    elif [[ -n "$(brew ls --versions "libiconv")" ]]; then
        echo -e "${C_1}Uninstalling Libiconv ...${C_0}"
        if ! $DRY_RUN; then
            brew uninstall libiconv
        fi
    else
        echo -e "${C_2}Libiconv (via Homebrew) not installed.${C_0}"
    fi

    # Openldap
    if ! $HAS_BREW; then
        echo -e "${C_1}Would look for Openldap if Homebrew was actually installed.${C_0}"
    elif [[ -n "$(brew ls --versions "openldap")" ]]; then
        echo -e "${C_2}Will not uninstall Openldap, since it's commonly used by other packages.${C_0}"
    else
        echo -e "${C_2}Openldap not installed with Homebrew.${C_0}"
    fi

    # Homebrew
    echo -e "${C_2}Will not uninstall Homebrew.${C_0}"

    # Xcode
    echo -e "${C_2}Will not uninstall Xcode command line developer tools.${C_0}"
    
    # Finish.
    echo ""
    if ! $DRY_RUN; then
        echo -e "${C_EM}Done!${C_0}"
    else
        echo -e "${C_EM}Did nothing since script defaults to dry run. Use ${C_INFO}--no-dry-run${C_EM} to actually do stuff.${C_0}"
        echo -e "${C_EM}See ${C_INFO}--help${C_EM} for all options.${C_0}"
    fi
    echo ""
}


# ----------------------------------------------------------
# Xcode
# ----------------------------------------------------------

do_xcode () {
    XCODE_STATUS="$(xcode-select -v)"
    if [ -z "$XCODE_STATUS" ]; then
        echo -e "${C_1}Installing Xcode command line tools ...${C_0}"
        if ! $DRY_RUN; then
            xcode-select --install
        fi
    else
        echo -e "${C_2}Xcode command line tools already installed${C_0}"
    fi
}


# ----------------------------------------------------------
# Homebrew
# ----------------------------------------------------------

do_homebrew () {
    if ! [ -x "$(command -v brew)" ]; then
        echo -e "${C_1}Installing Homebrew ...${C_0}"
        if ! $DRY_RUN; then
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
    else
        echo -e "${C_2}Homebrew already installed.${C_0}"
    fi

    HAS_BREW=false
    if [ -x "$(command -v brew)" ]; then
        HAS_BREW=true
    fi

    if $HAS_BREW; then
        HAS_BREW_SERVICES=false
        TAPS="$(brew tap)"
        TAPS_LIST=($TAPS)
        for tap in "${TAPS_LIST[@]}"; do
            if [[ $tap = "homebrew/services" ]]; then
                HAS_BREW_SERVICES=true
            fi
        done
        if ! $HAS_BREW_SERVICES; then
            echo -e "${C_1}Installing Homebrew Services ...${C_0}"
            if ! $DRY_RUN; then
                brew tap homebrew/services
            fi
        else
            echo -e "${C_2}Homebrew Services already installed.${C_0}"
        fi
    fi
}


# ----------------------------------------------------------
# Openldap
# ----------------------------------------------------------

do_openldap () {
    if ! [ -x "$(command -v ldapsearch)" ]; then
        echo -e "${C_1}Installing Openldap ...${C_0}"
        if $HAS_BREW && !$DRY_RUN; then
            brew install openldap
        fi
    else
        HAS_BREW_OPENLDAP=false
        if ($HAS_BREW); then
            if [[ -n "$(brew ls --versions "openldap")" ]]; then
                HAS_BREW_OPENLDAP=true
            fi
        fi
        if $HAS_BREW_OPENLDAP; then
            echo -e "${C_2}Openldap already installed.${C_0}"
        else
            echo -e "${C_2}Found command ${C_0}ldapsearch${C_2}. Openldap not installed.${C_0}"
        fi
    fi
}


# ----------------------------------------------------------
# Libiconv
# ----------------------------------------------------------

do_libiconv () {
    if ! [ -x "$(command -v iconv)" ]; then
        echo -e "${C_1}Installing Libiconv ...${C_0}"
        if $HAS_BREW && !$DRY_RUN; then
            brew install libiconv
        fi
    else
        HAS_BREW_LIBICONV=false
        if ($HAS_BREW); then
            if [[ -n "$(brew ls --versions "libiconv")" ]]; then
                HAS_BREW_LIBICONV=true
            fi
        fi
        if $HAS_BREW_LIBICONV; then
            echo -e "${C_2}Libiconv already installed.${C_0}"
        else
            echo -e "${C_2}Found iconv on machine. Libiconv not installed.${C_0}"
        fi
    fi
}


# ----------------------------------------------------------
# MySQL
# ----------------------------------------------------------

do_mysql () {
    if ! [ -x "$(command -v mysql)" ]; then
        echo -e "${C_1}Installing MySQL ...${C_0}"
        if ! $DRY_RUN; then
            brew install mysql
            brew services start mysql
        fi
    else
        echo -e "${C_2}MySQL already installed.${C_0}"
    fi
}


# ----------------------------------------------------------
# Dnsmasq
# ----------------------------------------------------------

do_dnsmasq () {
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
}


# ----------------------------------------------------------
# Apache (via Homebrew)
# ----------------------------------------------------------

do_apache () {
    if ! $HAS_BREW; then
        echo -e "${C_1}Would look for Apache if Homebrew was actually installed.${C_0}"
    elif ! [[ -n "$(brew ls --versions "httpd")" ]]; then
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
            sudo apachectl -k stop
            sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null
        fi
        echo -e "${C_1}Installing Apache (via Homebrew) ...${C_0}"
        if ! $DRY_RUN; then
            brew install httpd
            brew services start httpd
            if [ -f "$APACHE_PATH_CONF" ]; then
                APACHE_PATH_CONF_EXISTS=true
            fi
        fi
        APACHE_INSTALLED=true
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
        read -p "Apache Document Root [/Users/$APACHE_USER/WebServer/sites]: " APACHE_DOC_ROOT
        APACHE_DOC_ROOT=${APACHE_DOC_ROOT:-"/Users/$APACHE_USER/WebServer/sites"}
        APACHE_DOC_ROOT_REGEX="^DocumentRoot ..*$"
        # Modify Apache conf.
        if $APACHE_PATH_CONF_EXISTS; then
            if ! $DRY_RUN; then
                sudo sed -i.bak "s|^Listen ..*$|Listen 80|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^\#LoadModule vhost_alias_module \(.*\)$|LoadModule vhost_alias_module \1|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^\#LoadModule rewrite_module \(.*\)$|LoadModule rewrite_module \1|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^User ..*$|User $APACHE_USER|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^Group ..*$|Group $APACHE_GROUP|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^ServerAdmin ..*@..*\...*$|ServerAdmin $APACHE_ADMIN_EMAIL|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^\#*ServerName ..*$|ServerName $APACHE_SERVER_NAME|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|$APACHE_DOC_ROOT_REGEX|DocumentRoot \"$APACHE_DOC_ROOT\"|g" $APACHE_PATH_CONF
                sudo perl -i.bak -0pe "s|^(DocumentRoot .*)\n<Directory ..*>|\1\n<Directory \"$APACHE_DOC_ROOT\">|mg" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^ErrorLog ..*|ErrorLog \"$APACHE_LOG_DIR/error_log\"|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^\#*#Include \(.*\)/extra/httpd-vhosts.conf|Include \1/extra/httpd-vhosts.conf|g" $APACHE_PATH_CONF
            else
                echo "Will change Apache config lines ..."
                sudo sed -n "s|^Listen ..*$|Listen 80|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^\#LoadModule vhost_alias_module \(.*\)$|LoadModule vhost_alias_module \1|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^\#LoadModule rewrite_module \(.*\)$|LoadModule rewrite_module \1|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^User ..*$|User $APACHE_USER|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^Group ..*$|Group $APACHE_GROUP|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^ServerAdmin ..*@..*\...*$|ServerAdmin $APACHE_ADMIN_EMAIL|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^\#*ServerName ..*$|ServerName $APACHE_SERVER_NAME|gp" $APACHE_PATH_CONF
                sudo sed -n "s|$APACHE_DOC_ROOT_REGEX|DocumentRoot \"$APACHE_DOC_ROOT\"|gp" $APACHE_PATH_CONF
                # Disabled until I figure out how to print changed lines only with perl.
                # sudo perl -0pe "s|^(DocumentRoot .*)\n<Directory ..*>|\1\n<Directory \"$APACHE_DOC_ROOT\">|mg" $APACHE_PATH_CONF
                sudo sed -n "s|^ErrorLog ..*|ErrorLog \"$APACHE_LOG_DIR/error_log\"|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^\#*#Include .*/extra/httpd-vhosts.conf|Include $APACHE_PATH_VHOSTS|gp" $APACHE_PATH_CONF
            fi
        fi

        # Setup virtual hosts.
        echo -e "${C_1}Installing Apache vhosts configuration ...${C_0}"
        if ! $DRY_RUN; then
            APACHE_VHOSTS=$(<"$DIR/httpd-vhosts.conf")
            APACHE_VHOSTS="${APACHE_VHOSTS//\{APACHE_DOC_ROOT\}/$APACHE_DOC_ROOT}"
            APACHE_VHOSTS="${APACHE_VHOSTS//\{APACHE_SERVER_NAME\}/$APACHE_SERVER_NAME}"
            APACHE_PATH_VHOSTS_BACKUP="$APACHE_PATH_VHOSTS.bak"
            if ! [ -f "$APACHE_PATH_VHOSTS_BACKUP" ]; then
                echo -e "${C_INFO}Moving current Apache vhosts configuration to $APACHE_PATH_VHOSTS_BACKUP ...${C_0}"
                cp $APACHE_PATH_VHOSTS $APACHE_PATH_VHOSTS_BACKUP
            fi
            echo "$APACHE_VHOSTS" | sudo tee $APACHE_PATH_VHOSTS > /dev/null
        fi
        
        # Server root.
        if ! [ -d "$APACHE_DOC_ROOT" ]; then
            echo -e "${C_1}Creating server root ...${C_0}"
            if ! $DRY_RUN; then
                mkdir -p "$APACHE_DOC_ROOT"
            fi
        else
            echo -e "${C_2}Server root already created.${C_0}"
        fi
        if ! [ -f "$APACHE_DOC_ROOT/index.html" ]; then
            echo -e "${C_1}Installing ${C_INFO}http://$APACHE_SERVER_NAME${C_1} (index.html)${C_0}"
            if ! $DRY_RUN; then
                echo "<h1>I am website</h1><p>Check PHP info at <a href='info.php'>info.php</a>" > "$APACHE_DOC_ROOT/index.html"
            fi
        else
            echo -e "${C_INFO}http://$APACHE_SERVER_NAME${C_2} (index.html) already installed. Will not overwrite.${C_0}"
        fi

        # Restart Apache.
        echo -e "${C_1}Restarting Apache ...${C_0}"
        if ! $DRY_RUN; then
            sudo apachectl -k restart
        fi
    else
        echo -e "${C_2}Apache (via Homebrew) already installed.${C_0}"
        APACHE_SERVER_NAME=$(sed -n "s|^ServerName \(.*\)|\1|gp" $APACHE_PATH_CONF)
        APACHE_DOC_ROOT=$(sed -n "s|DocumentRoot \"\(.*\)\"|\1|gp" $APACHE_PATH_CONF)
    fi
}


# ----------------------------------------------------------
# Hosts file
# ----------------------------------------------------------

do_hosts () {
    # Make sure the selected server name points to local machine.
    if [ "$APACHE_SERVER_NAME" != "localhost" ]; then
        HOSTS_PATH="/private/etc/hosts"
        if grep -q "$APACHE_SERVER_NAME" "$HOSTS_PATH"; then
            echo -e "${C_INFO}$APACHE_SERVER_NAME${C_2} already in ${C_INFO}$HOSTS_PATH${C_0}"
        else
            echo -e "${C_1}Adding ${C_INFO}$APACHE_SERVER_NAME${C_1} to ${C_INFO}$HOSTS_PATH${C_1} since other than ${C_INFO}localhost${C_1} ...${C_0}"
            if ! $DRY_RUN; then
                echo "
    # $APACHE_SERVER_NAME installed by macos-web-development
    127.0.0.1       $APACHE_SERVER_NAME" | sudo tee -a "$HOSTS_PATH" > /dev/null
            fi
        fi
    fi
}



# ----------------------------------------------------------
# PHP
# ----------------------------------------------------------

do_php () {
    # Prepare custom log directory.
    echo -e "${C_1}Preparing PHP log directory ...${C_0}"
    if ! $DRY_RUN; then
        sudo mkdir -p $PHP_LOG_DIR
        sudo chgrp -R staff $PHP_LOG_DIR
        sudo chmod -R ug+w $PHP_LOG_DIR
    fi

    # Install PHP ini file.
    if ! [ -f "$PHP_INI_DEST" ]; then
        echo -e "${C_1}Installing PHP ini ...${C_0}"
        if ! $DRY_RUN; then
            sudo mkdir -p $PHP_INI_DIR
            sudo cp "$DIR/php.ini" $PHP_INI_DEST
        fi
    else
        echo -e "${C_2}PHP ini already installed. Will not overwrite.${C_0}"
    fi

    # Enable deprecated Homebrew PHP packages.
    if ! $HAS_BREW; then
        echo -e "${C_1}Would enable deprecated Homebrew PHP packages if Homebrew was actually installed.${C_0}"
    else
        echo -e "${C_1}Enable deprecated Homebrew PHP packages ...${C_0}"
        if ! $DRY_RUN; then
            brew tap exolnet/homebrew-deprecated
        fi
    fi

    # Install PHP versions.
    for php_version in ${PHP_VERSIONS[*]}; do
        if ! $HAS_BREW; then
            echo -e "${C_1}Would install php$php_version if Homebrew was actually installed.${C_0}"
        elif ! [[ -n "$(brew ls --versions "php@$php_version")" ]]; then
            echo -e "${C_1}Installing php$php_version ...${C_0}"
            if ! $DRY_RUN; then
                brew install "php@$php_version"
            fi
        else
            echo -e "${C_2}php$php_version already installed.${C_0}"
        fi
        PHP_VERSION_INI_DIR="/usr/local/etc/php/$php_version/conf.d"
        PHP_VERSION_INI_PATH="$PHP_VERSION_INI_DIR/macos-web-development.ini"
        if ! [ -f "$PHP_VERSION_INI_PATH" ]; then
            echo -e "${C_1}Installing PHP ini for php$php_version ...${C_0}"
            if ! $DRY_RUN; then
                if ! [ -d "$PHP_VERSION_INI_DIR" ]; then
                    mkdir "$PHP_VERSION_INI_DIR"
                fi
                ln -s $PHP_INI_DEST "$PHP_VERSION_INI_PATH"
            fi
        else
            echo -e "${C_2}PHP ini for php$php_version already installed. Will not overwrite.${C_0}"
        fi
    done

    # Apache PHP config.
    echo -e "${C_1}Installing Apache PHP config ...${C_0}"
    APACHE_PHP_INJECT='<IfModule dir_module>\n    DirectoryIndex index.php index.html\n</IfModule>\n<FilesMatch \.php\$>\n    SetHandler application/x-httpd-php\n</FilesMatch>'
    if $APACHE_PATH_CONF_EXISTS; then
        if ! $DRY_RUN; then
            sudo perl -i -0pe "s|^<IfModule dir_module>\n.*DirectoryIndex index.html\n</IfModule>|$APACHE_PHP_INJECT|mg" $APACHE_PATH_CONF
            echo -e "${C_1}Restarting Apache ...${C_0}"
            sudo apachectl -k restart
        # else
            # Disabled until I figure out how to print changed lines only with perl.
            # sudo perl -0pe "s|^<IfModule dir_module>\n.*DirectoryIndex index.html\n</IfModule>|$APACHE_PHP_INJECT|mg" $APACHE_PATH_CONF
        fi
    else
        if ! $DRY_RUN; then
            echo -e "${C_INFO}Apache configuration file was not found at $APACHE_PATH_CONF. PHP configuration not installed. Wanted to inject:\n${C_0}$APACHE_PHP_INJECT"
        fi
    fi

    # PHP info page.
    if $INSTALL_APACHE; then
        if ! [ -f "$APACHE_DOC_ROOT/info.php" ]; then
            echo -e "${C_1}Installing ${C_INFO}http://$APACHE_SERVER_NAME/info.php${C_0}"
            if ! $DRY_RUN; then
                echo "<?php phpinfo();" > "$APACHE_DOC_ROOT/info.php"
            fi
        else
            echo -e "${C_INFO}http://$APACHE_SERVER_NAME/info.php${C_2} already installed. Will not overwrite.${C_0}"
        fi
    fi

    # Install sphp script.
    if ! [ -x "$(command -v sphp)" ]; then
        echo -e "${C_1}Installing sphp ...${C_0}"
        if ! $DRY_RUN; then
            cp "$DIR/sphp.sh" /usr/local/bin/sphp
            chmod +x /usr/local/bin/sphp
            echo -e "${C_EM}Switch PHP version using for example ${C_0}sphp $PHP_EXAMPLE_VERSION"
        fi
    else
        echo -e "${C_2}sphp already installed.${C_0}"
    fi
}


# ----------------------------------------------------------
# Enable latest PHP version installed.
# ----------------------------------------------------------

do_php_enable () {
    if $PHP_ENABLE; then
        echo -e "${C_1}Enabling php$LATEST_PHP_VERSION ...${C_0}"
        if ! $DRY_RUN; then
            sphp $LATEST_PHP_VERSION
        fi
        # Restart Apache.
        echo -e "${C_1}Restarting Apache ...${C_0}"
        if ! $DRY_RUN; then
            sudo apachectl -k restart
        fi
    else
        echo -e "${C_2}Will not enable php$LATEST_PHP_VERSION${C_0}"
    fi
}


# ----------------------------------------------------------
# Finish.
# ----------------------------------------------------------

do_finish () {
    echo ""
    if ! $DRY_RUN; then
        echo -e "${C_EM}Done!${C_0}"
        echo ""
        echo -e "${C_EM}You should now be able to browse ${C_INFO}http://$APACHE_SERVER_NAME${C_EM}, and ${C_INFO}http://$APACHE_SERVER_NAME/info.php${C_EM} for PHP info.${C_0}"
        echo ""
        if $APACHE_INSTALLED; then
            if $INSTALL_DNSMASQ; then
                echo -e "${C_EM}You should also be able to browse ${C_INFO}http://{any}.test${C_EM} to visit ${C_INFO}$APACHE_DOC_ROOT/{any}/public${C_EM}. Additional vhost entries may be defined in ${C_INFO}$APACHE_PATH_VHOSTS${C_0}"
            else
                echo -e "${C_EM}Since you didn't install Dnsmasq, you may not be able to browse ${C_INFO}http://{any}.test${C_EM} to visit ${C_INFO}$APACHE_DOC_ROOT/{any}/public${C_EM}. Additional vhost entries may be defined in ${C_INFO}$APACHE_PATH_VHOSTS${C_0}"
            fi
            echo ""
        else
            echo -e "${C_EM}Apache was already installed and not configured during this run. If Apache and Dnsmasq was previously installed by ${C_INFO}macos-web-development${C_EM}, you should be able to browse ${C_INFO}http://{any}.test${C_EM} to visit ${C_INFO}$APACHE_DOC_ROOT/{any}/public${C_EM}. Additional vhost entries may be defined in ${C_INFO}$APACHE_PATH_VHOSTS${C_0}"
            echo ""
        fi
        if [ $NUM_PHP_VERSIONS -gt 0 ]; then
            if ! $PHP_ENABLE; then
                echo -e "${C_EM}If you haven't already, you should enable a PHP version by running ${C_0}sphp $PHP_EXAMPLE_VERSION"
                echo ""
            fi
        fi
        if $INSTALL_MYSQL; then
            echo -e "${C_EM}Connect to MySQL using ${C_0}mysql -uroot${C_EM} (no password). If you want to secure your development database you can run ${C_0}mysql_secure_installation"
            echo ""
        fi
    else
        echo -e "${C_EM}Did nothing since script defaults to dry run. Use ${C_INFO}--no-dry-run${C_EM} to actually do stuff.${C_0}"
        echo -e "${C_EM}See ${C_INFO}--help${C_EM} for all options.${C_0}"
        echo ""
    fi
}


# ----------------------------------------------------------
# Execute functions based on options.
# ----------------------------------------------------------

# Uninstall
if $UNINSTALL; then
    do_dry_run_message
    do_sudo
    do_uninstall
    exit
fi

# Install
do_dry_run_message
do_sudo
if $INSTALL_CXODE; then
    do_xcode
fi
do_homebrew
do_openldap
do_libiconv
if $INSTALL_MYSQL; then
    do_mysql
fi
if $INSTALL_DNSMASQ; then
    do_dnsmasq
fi
if $INSTALL_APACHE; then
    do_apache
    do_hosts
fi
if $INSTALL_PHP; then
    do_php
    if [ $NUM_PHP_VERSIONS -gt 0 ]; then
        do_php_enable
    fi
fi
do_finish
