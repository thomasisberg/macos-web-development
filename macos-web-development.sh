#!/bin/bash
# Creator: Thomas Isberg

# Will prepare MacOS for web development.

# ----------------------------------------------------------
# Installation settings.
# ----------------------------------------------------------
DRY_RUN=false

# Check input flags.
while test $# != 0
do
    case "$1" in
    --dry-run) DRY_RUN=true ;;
    esac
    shift
done


DIR=$(pwd)
PHP_VERSIONS=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4")
APACHE_PATH="/usr/local/etc/httpd"
# APACHE_PATH="/private/etc/apache2"
APACHE_PATH_CONF="$APACHE_PATH/httpd.conf"
APACHE_PATH_VHOSTS="$APACHE_PATH/extra/httpd-vhosts.conf"
APACHE_LOG_DIR="/var/log/apache2"
PHP_INI_DEST="/usr/local/php/php.ini"
PHP_LOG_DIR="/var/log/php"


# ----------------------------------------------------------
# Sudo
# ----------------------------------------------------------

echo "Acquire sudo ..."
sudo echo "Hello Sudoer!"


# ----------------------------------------------------------
# Xcode
# ----------------------------------------------------------

echo "Installing Xcode ..."
if ! $DRY_RUN; then
    xcode-select --install
fi


# ----------------------------------------------------------
# Homebrew
# ----------------------------------------------------------

if ! [ -x "$(command -v brew)" ]; then
    echo "Installing Homebrew ..."
    if ! $DRY_RUN; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
else
    echo "Homebrew already installed."
fi


# ----------------------------------------------------------
# Openldap and Libiconv
# ----------------------------------------------------------

if ! [[ -n "$(brew ls --versions "openldap")" ]]; then
    echo "Installing Openldap ..."
    if ! $DRY_RUN; then
        brew install openldap
    fi
else
    echo "Openldap already installed."
fi

if ! [[ -n "$(brew ls --versions "libiconv")" ]]; then
    echo "Installing Libiconv ..."
    if ! $DRY_RUN; then
        brew install libiconv
    fi
else
    echo "Libiconv already installed."
fi


# ----------------------------------------------------------
# MySQL
# ----------------------------------------------------------

if ! [ -x "$(command -v mysql)" ]; then
    echo "Installing MySQL ..."
    if ! $DRY_RUN; then
        brew install mysql
    fi
else
    echo "MySQL already installed."
fi


# ----------------------------------------------------------
# Dnsmasq
# ----------------------------------------------------------

if ! [ -x "$(command -v mysql)" ]; then
    echo "Installing Dnsmasq ..."
    if ! $DRY_RUN; then
        brew install dnsmasq
        cd $(brew --prefix); mkdir etc; echo 'address=/.test/127.0.0.1' > etc/dnsmasq.conf
        sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
        sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
        sudo mkdir /etc/resolver
        sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'
        cd $DIR
    fi
else
    echo "Dnsmasq already installed."
fi


# ----------------------------------------------------------
# Apache (via Homebrew)
# ----------------------------------------------------------

if ! [[ -n "$(brew ls --versions "httpd")" ]]; then
    # Prepare custom log directory.
    echo "Preparing Apache log directory ..."
    if ! $DRY_RUN; then
        sudo mkdir -p $APACHE_LOG_DIR
        sudo chgrp -R staff $APACHE_LOG_DIR
        sudo chmod -R ug+w $APACHE_LOG_DIR
    fi
    # Stop current Apache server.
    echo "Stopping potentially running Apache ..."
    if ! $DRY_RUN; then
        sudo apachectl stop
        sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null
    fi
    echo "Installing Apache (via Homebrew) ..."
    if ! $DRY_RUN; then
        brew install httpd
        brew services start httpd
    fi
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
    apache_doc_root_regex="^DocumentRoot \"..*\"$"
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
            sudo sed -i "s|$apache_doc_root_regex|DocumentRoot $APACHE_DOC_ROOT|g" $APACHE_PATH_CONF
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
            sudo sed -n "s|$apache_doc_root_regex|DocumentRoot \"$APACHE_DOC_ROOT\"|gp" $APACHE_PATH_CONF
            # Disabled until I figure out how to print changed lines only with perl.
            # sudo perl -0pe "s|^(DocumentRoot .*)\n<Directory ..*>|\1\n<Directory \"$APACHE_DOC_ROOT\">|mg" $APACHE_PATH_CONF
            sudo sed -n "s|^ErrorLog ..*|ErrorLog \"$APACHE_LOG_DIR/error_log\"|gp" $APACHE_PATH_CONF
        fi
    fi

    # Setup virtual hosts.
    echo "Installing Apache vhosts configuration ..."
    if ! $DRY_RUN; then
        apache_vhosts=$(<httpd-vhosts.conf)
        apache_vhosts="${apache_vhosts//\{APACHE_DOC_ROOT\}/$APACHE_DOC_ROOT}"
        APACHE_PATH_VHOSTS_BACKUP="$APACHE_PATH_VHOSTS.bak"
        if ! [ -f "$APACHE_PATH_VHOSTS_BACKUP" ]; then
            echo "Moved current Apache vhosts configuration to $APACHE_PATH_VHOSTS_BACKUP"
            sudo cp $APACHE_PATH_VHOSTS $APACHE_PATH_VHOSTS_BACKUP
        fi
        echo "$apache_vhosts" | sudo tee $APACHE_PATH_VHOSTS > /dev/null
    fi
    
    # Restart Apache.
    echo "Restarting Apache ..."
    if ! $DRY_RUN; then
        sudo apachectl -k restart
    fi
else
    echo "Apache (via Homebrew) already installed."
fi


# ----------------------------------------------------------
# Server root.
# ----------------------------------------------------------

echo "Creating server root ..."
if ! $DRY_RUN; then
    mkdir -p "$APACHE_DOC_ROOT"
    echo "<?php phpinfo();" > "$APACHE_DOC_ROOT/index.php"
fi


# ----------------------------------------------------------
# PHP
# ----------------------------------------------------------

# Prepare custom log directory.
echo "Preparing PHP log directory ..."
if ! $DRY_RUN; then
    sudo mkdir -p $PHP_LOG_DIR
    sudo chgrp -R staff $PHP_LOG_DIR
    sudo chmod -R ug+w $PHP_LOG_DIR
fi

# Install PHP ini file.
echo "Installing PHP ini ..."
if ! $DRY_RUN; then
    sudo mkdir -p /usr/local/php
    sudo cp "$DIR/php.ini" $PHP_INI_DEST
fi

# Enable deprecated Homebrew PHP packages.
echo "Enable deprecated Homebrew PHP packages ..."
if ! $DRY_RUN; then
    brew tap exolnet/homebrew-deprecated
fi

# Install PHP versions.
for php_version in ${PHP_VERSIONS[*]}; do
    if ! [[ -n "$(brew ls --versions "php@$php_version")" ]]; then
        echo "Installing php$php_version ..."
        if ! $DRY_RUN; then
            brew install "php@$php_version"
        fi
    else
        echo "php$php_version already installed."
    fi
    if ! $DRY_RUN; then
        ln -s $PHP_INI_DEST "/usr/local/etc/php/$php_version/conf.d/php.ini"
    fi
done

# Apache PHP config.
echo "Apache PHP config ..."
apache_php_inject='<IfModule dir_module>\n    DirectoryIndex index.php index.html\n</IfModule>\n<FilesMatch \.php\$>\n    SetHandler application/x-httpd-php\n</FilesMatch>'
if $APACHE_PATH_CONF_EXISTS; then
    if ! $DRY_RUN; then
        sudo perl -i -0pe "s|^<IfModule dir_module>\n.*DirectoryIndex index.html\n</IfModule>|$apache_php_inject|mg" $APACHE_PATH_CONF
        echo "Restarting Apache ..."
        sudo apachectl -k restart
    # else
        # Disabled until I figure out how to print changed lines only with perl.
        # sudo perl -0pe "s|^<IfModule dir_module>\n.*DirectoryIndex index.html\n</IfModule>|$apache_php_inject|mg" $APACHE_PATH_CONF
    fi
fi


# Install sphp script.
if ! [ -x "$(command -v sphp)" ]; then
    echo "Installing sphp ..."
    if ! $DRY_RUN; then
        cp "$DIR/sphp.sh" /usr/local/bin/sphp
        chmod +x /usr/local/bin/sphp
        echo "Switch PHP version using for example 'sphp 7.2'"
    fi
else
    echo "sphp already installed."
fi
