#!/bin/bash

# ----------------------------------------------------------
# Installs MacOS web development stuff:
#  • xcode-select – Xcode command line developer tools
#  • Homebrew
#  • Openldap
#  • Libiconv
#  • MySQL
#  • Dnsmasq
#  • Apache
#  • PHP versions 5.6 to 8.4
#  • sphp – a PHP switcher script
# ----------------------------------------------------------

# ----------------------------------------------------------
# Creator: Thomas Isberg
# ----------------------------------------------------------


# Stop execution if an error is encountered.
set -e


# Resolve project path and config folder.
PWD=$(pwd)
PWD_DIRNAME=${PWD##*/}


# Resolve script folder.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ -L ${BASH_SOURCE[0]} ]; then
    DIR="$(dirname "$(readlink "$0")")"
fi


# Import bash files.
for f in $DIR/lib/*.sh; do
    source $f
done


# Print help.
if $HELP; then
    print_help
    exit
fi


do_dry_run_message
do_sudo


# Self update
if $SELF_UPDATE; then
    do_self_update
    exit
fi


# Set common variables.
set_variables


# Set Homebrew prefix (path) and related variables.
set_homebrew_path


# Uninstall
if $UNINSTALL; then
    do_uninstall
    exit
fi

# Install
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
