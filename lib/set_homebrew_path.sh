#!/bin/bash

# ----------------------------------------------------------
# Set variables that depend on Homebrew prefix.
# ----------------------------------------------------------

set_homebrew_path ()
{
    HOMEBREW_PATH="/usr/local"

    if $HAS_BREW; then
        HOMEBREW_PATH="$(brew --prefix)"
    fi

    APACHE_PATH="$HOMEBREW_PATH/etc/httpd"
    APACHE_PATH_CONF="$APACHE_PATH/httpd.conf"
    APACHE_PATH_CONF_EXISTS=false
    if [ -f "$APACHE_PATH_CONF" ]; then
        APACHE_PATH_CONF_EXISTS=true
    fi
    APACHE_PATH_VHOSTS="$APACHE_PATH/extra/httpd-vhosts.conf"

    MYSQL_DB_PATH="$HOMEBREW_PATH/var"
}
