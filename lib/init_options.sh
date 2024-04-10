#!/bin/bash

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
ONLY_PHP_5_6=false
ONLY_PHP_7_0=false
ONLY_PHP_7_1=false
ONLY_PHP_7_2=false
ONLY_PHP_7_3=false
ONLY_PHP_7_4=false
ONLY_PHP_8_0=false
ONLY_PHP_8_1=false
ONLY_PHP_8_2=false
ONLY_PHP_8_3=false
ONLY_XCODE=false
PHP_5_6=true
PHP_7_0=true
PHP_7_1=true
PHP_7_2=true
PHP_7_3=true
PHP_7_4=true
PHP_8_0=true
PHP_8_1=true
PHP_8_2=true
PHP_8_3=true
PHP_ENABLE=true
PRESET_COMMON=false
PRESET_MINIMAL=false
SCRIPT_REPO="git@github.com:thomasisberg/macos-web-development.git"
SELF_UPDATE=false
UNINSTALL=false

while test $# != 0
do
    case "$1" in
    -h)                   HELP=true ;;
    --help)               HELP=true ;;
    --no-apache)          INSTALL_APACHE=false ;;
    --no-dnsmasq)         INSTALL_DNSMASQ=false ;;
    --no-dry-run)         DRY_RUN=false ;;
    --no-mysql)           INSTALL_MYSQL=false ;;
    --no-php)             INSTALL_PHP=false ;;
    --no-php-5-6)         PHP_5_6=false ;;
    --no-php-7-0)         PHP_7_0=false ;;
    --no-php-7-1)         PHP_7_1=false ;;
    --no-php-7-2)         PHP_7_2=false ;;
    --no-php-7-3)         PHP_7_3=false ;;
    --no-php-7-4)         PHP_7_4=false ;;
    --no-php-8-0)         PHP_8_0=false ;;
    --no-php-8-1)         PHP_8_1=false ;;
    --no-php-8-2)         PHP_8_2=false ;;
    --no-php-8-3)         PHP_8_3=false ;;
    --no-php-enable)      PHP_ENABLE=false ;;
    --no-xcode-select)    INSTALL_XCODE=false ;;
    --only-apache)        ONLY_APACHE=true ;;
    --only-dnsmasq)       ONLY_DNSMASQ=true ;;
    --only-mysql)         ONLY_MYSQL=true ;;
    --only-php)           ONLY_PHP=true ;;
    --only-php-5-6)       ONLY_PHP_5_6=true ;;
    --only-php-7-0)       ONLY_PHP_7_0=true ;;
    --only-php-7-1)       ONLY_PHP_7_1=true ;;
    --only-php-7-2)       ONLY_PHP_7_2=true ;;
    --only-php-7-3)       ONLY_PHP_7_3=true ;;
    --only-php-7-4)       ONLY_PHP_7_4=true ;;
    --only-php-8-0)       ONLY_PHP_8_0=true ;;
    --only-php-8-1)       ONLY_PHP_8_1=true ;;
    --only-php-8-2)       ONLY_PHP_8_2=true ;;
    --only-php-8-3)       ONLY_PHP_8_3=true ;;
    --only-xcode-select)  ONLY_XCODE=true ;;
    --p-common)           PRESET_COMMON=true ;;
    --p-minimal)          PRESET_MINIMAL=true ;;
    --script-repo=*)      SCRIPT_REPO="${1#*=}" ;;
    --self-update)        SELF_UPDATE=true ;;
    --uninstall)          UNINSTALL=true ;;
    esac
    shift
done


# ----------------------------------------------------------
# Presets.
# ----------------------------------------------------------

if $PRESET_COMMON; then
    ONLY_PHP_8_1=true
    INSTALL_XCODE=false
elif $PRESET_MINIMAL; then
    INSTALL_MYSQL=false
    ONLY_PHP_8_1=true
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
