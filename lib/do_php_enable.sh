#!/bin/bash

# ----------------------------------------------------------
# Enable latest PHP version installed.
# ----------------------------------------------------------

do_php_enable ()
{
    if $PHP_ENABLE; then
        echo -e "${C_1}Enabling php$LATEST_PHP_VERSION ...${C_0}"
        if ! $DRY_RUN; then
            sphp $LATEST_PHP_VERSION
        fi
        # Restart Apache.
        echo -e "${C_1}Restarting Apache ...${C_0}"
        if ! $DRY_RUN; then
            brew services restart httpd
        fi
    else
        echo -e "${C_2}Will not enable php$LATEST_PHP_VERSION${C_0}"
    fi
}
