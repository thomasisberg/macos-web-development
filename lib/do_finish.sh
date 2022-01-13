#!/bin/bash

# ----------------------------------------------------------
# Finish.
# ----------------------------------------------------------

do_finish ()
{
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
