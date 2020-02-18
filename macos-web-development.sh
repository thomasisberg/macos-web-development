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


# osx_major_version=$(sw_vers -productVersion | cut -d. -f1)
# osx_minor_version=$(sw_vers -productVersion | cut -d. -f2)
# osx_patch_version=$(sw_vers -productVersion | cut -d. -f3)
# osx_patch_version=${osx_patch_version:-0}
# osx_version=$((${osx_major_version} * 10000 + ${osx_minor_version} * 100 + ${osx_patch_version}))

# native_osx_php_apache_module="LoadModule php5_module libexec\/apache2\/libphp5.so"
# if [ "${osx_version}" -ge "101300" ]; then
#     native_osx_php_apache_module="LoadModule php7_module libexec\/apache2\/libphp7.so"
# fi


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
# dnsmasq
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
    fi
else
    echo "Dnsmasq already installed."
fi


# ----------------------------------------------------------
# Apache
# ----------------------------------------------------------

if ! [[ -n "$(brew ls --versions "httpd")" ]]; then
    echo "Installing Apache (via Homebrew) ..."
    if ! $DRY_RUN; then
        # Prepare custom log directory.
        sudo mkdir -p /usr/local/log/httpd
        sudo chgrp -R staff /usr/local/log/httpd
        sudo chmod -R ug+w /usr/local/log/httpd/
        # Stop current Apache server.
        echo "Stopping potentially running Apache ..."
        sudo apachectl stop
        sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null
        brew install httpd
        brew services start httpd
    fi
    # Modify Apache conf.
    APACHE_CONF_PATH="/usr/local/etc/httpd/httpd.conf"
    if ! $DRY_RUN; then
        # Listen on port 80.
        sudo sed -i.bak "s|^Listen ..*$|Listen 80|g" $APACHE_CONF_PATH
        # Enable rewrite module.
        sudo sed -i "s|^\#LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so$|LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so|g" $APACHE_CONF_PATH
    else
        sudo sed -n "s|^Listen ..*$|Listen 80|gp" $APACHE_CONF_PATH
        sudo sed -n "s|^\#*LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so$|LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so|gp" $APACHE_CONF_PATH
    fi
    # Apache User / Group.
    read -p "Apache User [_www]: " APACHE_USER
    APACHE_USER=${APACHE_USER:-_www}
    read -p "Apache Group [staff]: " APACHE_GROUP
    APACHE_GROUP=${APACHE_GROUP:-staff}
    # Apache admin e-mail
    read -p "Apache Admin e-mail [admin@example.test]: " APACHE_ADMIN_EMAIL
    APACHE_ADMIN_EMAIL=${APACHE_ADMIN_EMAIL:-admin@example.test}
    if ! $DRY_RUN; then
        sudo sed -i "s|^User ..*$|User $APACHE_USER|g" $APACHE_CONF_PATH
        sudo sed -i "s|^Group ..*$|Group $APACHE_GROUP|g" $APACHE_CONF_PATH
        sudo sed -i "s|^ServerAdmin ..*@..*\...*$|ServerAdmin $APACHE_ADMIN_EMAIL|g" $APACHE_CONF_PATH
    else
        sudo sed -n "s|^User ..*$|User $APACHE_USER|gp" $APACHE_CONF_PATH
        sudo sed -n "s|^Group ..*$|Group $APACHE_GROUP|gp" $APACHE_CONF_PATH
        sudo sed -n "s|^ServerAdmin ..*@..*\...*$|ServerAdmin $APACHE_ADMIN_EMAIL|gp" $APACHE_CONF_PATH
    fi
    # Apache server name
    read -p "Apache Server Name [localhost]: " APACHE_SERVER_NAME
    APACHE_SERVER_NAME=${APACHE_SERVER_NAME:-localhost}
    if ! $DRY_RUN; then
        sudo sed -i "s|^\#*ServerName ..*$|ServerName $APACHE_SERVER_NAME|g" $APACHE_CONF_PATH
    else
        sudo sed -n "s|^\#*ServerName ..*$|ServerName $APACHE_SERVER_NAME|gp" $APACHE_CONF_PATH
    fi
    # Apache document root.
    read -p "Apache Document Root [/Users/$APACHE_USER/WebServer]: " APACHE_DOC_ROOT
    APACHE_DOC_ROOT=${APACHE_DOC_ROOT:-"/Users/$APACHE_USER/WebServer"}
    apache_doc_root_regex="^DocumentRoot \"..*\"$"
    if ! $DRY_RUN; then
        sudo sed -i "s|$apache_doc_root_regex|DocumentRoot $APACHE_DOC_ROOT|g" $APACHE_CONF_PATH
        sudo perl -i -0pe "s|^(DocumentRoot .*)\n<Directory ..*>|\1\n<Directory \"$APACHE_DOC_ROOT\">|mg" $APACHE_CONF_PATH
    else
        sudo sed -n "s|$apache_doc_root_regex|DocumentRoot \"$APACHE_DOC_ROOT\"|gp" $APACHE_CONF_PATH
        # sudo perl -0pe "s|^(DocumentRoot .*)\n<Directory ..*>|\1\n<Directory \"$APACHE_DOC_ROOT\">|mg" $APACHE_CONF_PATH
    fi
    # Apache error log.
    if ! $DRY_RUN; then
        sudo sed -i "s|^ErrorLog ..*|ErrorLog \"/usr/local/log/httpd/error_log\"|g" $APACHE_CONF_PATH
    else
        sudo sed -n "s|^ErrorLog ..*|ErrorLog \"/usr/local/log/httpd/error_log\"|gp" $APACHE_CONF_PATH
    fi
else
    echo "Apache (via Homebrew) already installed."
fi


# ----------------------------------------------------------
# Server root.
# ----------------------------------------------------------

echo "Creates server root ..."
if ! $DRY_RUN; then
    mkdir -p "$APACHE_DOC_ROOT"
    echo "<?php phpinfo();" > "$APACHE_DOC_ROOT/index.php"
fi