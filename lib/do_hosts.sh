#!/bin/bash

# ----------------------------------------------------------
# Hosts file
# ----------------------------------------------------------

do_hosts ()
{
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
