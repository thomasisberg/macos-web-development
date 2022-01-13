#!/bin/bash

# ----------------------------------------------------------
# Uninstall.
# ----------------------------------------------------------

do_uninstall ()
{
    HAS_APACHE=false
    if [[ -n "$(brew ls --versions "httpd")" ]]; then
        HAS_APACHE=true
        APACHE_SERVER_NAME=$(sed -n "s|^ServerName \(.*\)|\1|gp" $APACHE_PATH_CONF)
        APACHE_DOC_ROOT=$(sed -n "s|DocumentRoot \"\(.*\)\"|\1|gp" $APACHE_PATH_CONF)
    fi

    # Stop running Apache
    echo -e "${C_1}Stopping potentially running Apache ...${C_0}"
    if ! $DRY_RUN; then
        # sudo apachectl -k stop
        if ($HAS_BREW); then
            if $HAS_APACHE; then
                brew services stop httpd
            fi
        fi
    fi

    # sphp
    if [ -x "$(command -v sphp)" ]; then
        echo -e "${C_1}Uninstalling sphp ...${C_0}"
        if ! $DRY_RUN; then
            rm -f /usr/local/bin/sphp
        fi
    else
        echo -e "${C_2}sphp not installed.${C_0}"
    fi

    # PHP versions.
    if $HAS_BREW; then
        for php_version in ${ALL_PHP_VERSIONS[*]}; do
            if [[ -n "$(brew ls --versions "php@$php_version")" ]]; then
                echo -e "${C_1}Uninstalling php$php_version ...${C_0}"
                if ! $DRY_RUN; then
                    brew uninstall "php@$php_version"
                    sudo rm -rf $HOMEBREW_PATH/etc/php/$php_version
                fi
            else
                echo -e "${C_2}php$php_version not installed.${C_0}"
            fi
        done

        if ! $DRY_RUN; then
            sudo rm $HOMEBREW_PATH/etc/php
        fi
    fi

    # PHP ini file.
    if [ -f "$PHP_INI_DEST" ]; then
        echo -e "${C_1}Uninstalling PHP ini ...${C_0}"
        if ! $DRY_RUN; then
            sudo rm $PHP_INI_DEST
        fi
    else
        echo -e "${C_2}PHP ini not installed.${C_0}"
    fi

    # Hosts file
    if [ "$APACHE_SERVER_NAME" != "localhost" ]; then
        HOSTS_PATH="/private/etc/hosts"
        if ! $DRY_RUN; then
            sudo sed -i.bak "s|^$APACHE_SERVER_NAME \(..*\)|#$APACHE_SERVER_NAME \1|g" $HOSTS_PATH
        else
            sudo sed -n "s|^$APACHE_SERVER_NAME \(..*\)|#$APACHE_SERVER_NAME \1|gp" $HOSTS_PATH
        fi
    fi

    # Apache
    if $HAS_BREW; then
        if $HAS_APACHE; then
            echo -e "${C_1}Uninstalling Apache (via Homebrew) ...${C_0}"
            if ! $DRY_RUN; then
                brew uninstall httpd
                sudo rm -rf $APACHE_PATH
            fi
        else
            echo -e "${C_2}Apache (via Homebrew) not installed.${C_0}"
        fi
    fi

    # Dnsmasq
    if ($HAS_BREW); then
        if [[ -n "$(brew ls --versions "dnsmasq")" ]]; then
            echo -e "${C_1}Uninstalling Dnsmasq ...${C_0}"
            if ! $DRY_RUN; then
                # sudo launchctl unload -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist 2>/dev/null
                # sudo rm /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
                sudo brew services stop dnsmasq
                sudo rm -rf /etc/resolver
                sudo rm $HOMEBREW_PATH/etc/dnsmasq.conf
                sudo rm $HOMEBREW_PATH/etc/dnsmasq.d
                brew uninstall dnsmasq
                sudo rm -rf $HOMEBREW_PATH/var/run/dnsmasq
            fi
        else
            echo -e "${C_2}Dnsmasq (via Homebrew) not installed.${C_0}"
        fi
    fi

    # MySQL
    if $HAS_BREW; then
        if [[ -n "$(brew ls --versions "$MYSQL_PACKAGE")" ]]; then
            echo -e "${C_1}Uninstalling MySQL ...${C_0}"
            if ! $DRY_RUN; then
                brew services stop $MYSQL_PACKAGE
                brew uninstall $MYSQL_PACKAGE
            fi
            echo -e "${C_EM}Uninstalled package, but did not remove database files. Remove them with ${C_0}rm -rf ${MYSQL_DB_PATH}/mysql${C_EM} if desired."
        else
            echo -e "${C_2}MySQL (via Homebrew) not installed.${C_0}"
        fi
    fi

    # Libiconv
    if ! $HAS_BREW; then
        echo -e "${C_1}Would look for Libiconv if Homebrew was actually installed.${C_0}"
    elif [[ -n "$(brew ls --versions "libiconv")" ]]; then
        echo -e "${C_1}Uninstalling Libiconv ...${C_0}"
        if ! $DRY_RUN; then
            brew uninstall libiconv
        fi
    else
        echo -e "${C_2}Libiconv (via Homebrew) not installed.${C_0}"
    fi

    # Openldap
    if ! $HAS_BREW; then
        echo -e "${C_1}Would look for Openldap if Homebrew was actually installed.${C_0}"
    elif [[ -n "$(brew ls --versions "openldap")" ]]; then
        echo -e "${C_2}Will not uninstall Openldap, since it's commonly used by other packages.${C_0}"
    else
        echo -e "${C_2}Openldap not installed with Homebrew.${C_0}"
    fi

    # Homebrew
    echo -e "${C_2}Will not uninstall Homebrew.${C_0}"

    # Xcode
    echo -e "${C_2}Will not uninstall Xcode command line developer tools.${C_0}"
    
    # Finish.
    echo ""
    if ! $DRY_RUN; then
        echo -e "${C_EM}Done!${C_0}"
    else
        echo -e "${C_EM}Did nothing since script defaults to dry run. Use ${C_INFO}--no-dry-run${C_EM} to actually do stuff.${C_0}"
        echo -e "${C_EM}See ${C_INFO}--help${C_EM} for all options.${C_0}"
    fi
    echo ""
}
