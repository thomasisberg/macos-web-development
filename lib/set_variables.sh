#!/bin/bash

# ----------------------------------------------------------
# Variables.
# ----------------------------------------------------------

set_variables ()
{
    MACOS_VERSION="$(sw_vers -productVersion)"
    MACOS_VERSION_MAJOR="$(echo $MACOS_VERSION | cut -d. -f1)"

    HAS_BREW=false
    if [ -x "$(command -v brew)" ]; then
        HAS_BREW=true
    fi

    APACHE_LOG_DIR="/var/log/apache2"
    APACHE_INSTALLED=false
    PHP_INI_DIR="/usr/local/php"
    PHP_INI_DEST="$PHP_INI_DIR/php.ini"
    PHP_LOG_DIR="/var/log/php"

    # Create list of PHP versions, based on options.
    ALL_PHP_VERSIONS=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.0" "8.1" "8.2" "8.3" "8.4")
    ALL_ONLY_PHP_FLAGS=($ONLY_PHP_5_6 $ONLY_PHP_7_0 $ONLY_PHP_7_1 $ONLY_PHP_7_2 $ONLY_PHP_7_3 $ONLY_PHP_7_4 $ONLY_PHP_8_0 $ONLY_PHP_8_1 $ONLY_PHP_8_2 $ONLY_PHP_8_3 $ONLY_PHP_8_4)
    ALL_PHP_FLAGS=($PHP_5_6 $PHP_7_0 $PHP_7_1 $PHP_7_2 $PHP_7_3 $PHP_7_4 $PHP_8_0 $PHP_8_1 $PHP_8_2 $PHP_8_3 $PHP_8_4)
    PHP_VERSIONS=()
    for i in "${!ALL_ONLY_PHP_FLAGS[@]}"; do
        if ${ALL_ONLY_PHP_FLAGS[$i]}; then
            PHP_VERSIONS+=("${ALL_PHP_VERSIONS[$i]}")
        fi
    done
    NUM_PHP_VERSIONS=${#PHP_VERSIONS[@]}
    if [ $NUM_PHP_VERSIONS == 0 ]; then
        for i in "${!ALL_PHP_FLAGS[@]}"; do
            if ${ALL_PHP_FLAGS[$i]}; then
                PHP_VERSIONS+=("${ALL_PHP_VERSIONS[$i]}")
            fi
        done

        NUM_PHP_VERSIONS=${#PHP_VERSIONS[@]}
    fi

    DEPRECATED_PHP_VERSIONS=("5.6" "7.0" "7.1", "7.2", "7.3", "7.4", "8.0")

    PHP_EXAMPLE_VERSION="7.4"
    if [ $NUM_PHP_VERSIONS -gt 0 ]; then
        LATEST_PHP_VERSION="${PHP_VERSIONS[$NUM_PHP_VERSIONS-1]}"
        PHP_EXAMPLE_VERSION="$LATEST_PHP_VERSION"
    fi

    # Use MariaDB instead of MySQL.
    # MYSQL_PACKAGE="mysql"
    MYSQL_PACKAGE="mariadb"
}
