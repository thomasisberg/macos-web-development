#!/bin/bash

# ----------------------------------------------------------
# MySQL
# ----------------------------------------------------------

do_mysql ()
{
    if ! [ -x "$(command -v $MYSQL_PACKAGE)" ]; then
        echo -e "${C_1}Installing MySQL ...${C_0}"
        if ! $DRY_RUN; then
            brew install $MYSQL_PACKAGE
            brew services start $MYSQL_PACKAGE

            # By default sudo is required to login as root. Disable by setting empty password.
            # Make sure server is really available.
            mysql.server start
            sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password USING PASSWORD('');"
            sudo mysql -u root -e "FLUSH PRIVILEGES;"
        fi
    else
        echo -e "${C_2}MySQL already installed.${C_0}"
    fi
}
