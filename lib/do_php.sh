#!/bin/bash

# ----------------------------------------------------------
# PHP
# ----------------------------------------------------------

do_php ()
{
    # Prepare custom log directory.
    echo -e "${C_1}Preparing PHP log directory ...${C_0}"
    if ! $DRY_RUN; then
        sudo mkdir -p $PHP_LOG_DIR
        sudo chgrp -R staff $PHP_LOG_DIR
        sudo chmod -R ug+w $PHP_LOG_DIR
    fi

    # Install PHP ini file.
    if ! [ -f "$PHP_INI_DEST" ]; then
        echo -e "${C_1}Installing PHP ini ...${C_0}"
        if ! $DRY_RUN; then
            sudo mkdir -p $PHP_INI_DIR
            sudo cp "$DIR/php.ini" $PHP_INI_DEST
        fi
    else
        echo -e "${C_2}PHP ini already installed. Will not overwrite.${C_0}"
    fi

    # Enable deprecated Homebrew PHP packages.
    if ! $HAS_BREW; then
        echo -e "${C_1}Would enable deprecated Homebrew PHP packages if Homebrew was actually installed.${C_0}"
    else
        echo -e "${C_1}Enable deprecated Homebrew PHP packages ...${C_0}"
        if ! $DRY_RUN; then
            brew tap exolnet/homebrew-deprecated
        fi
    fi

    # Install PHP versions.
    for php_version in ${PHP_VERSIONS[*]}; do
        if ! $HAS_BREW; then
            echo -e "${C_1}Would install php$php_version if Homebrew was actually installed.${C_0}"
        elif ! [[ -n "$(brew ls --versions "php@$php_version")" ]]; then
            echo -e "${C_1}Installing php$php_version ...${C_0}"
            if ! $DRY_RUN; then
                brew install "php@$php_version"
            fi
        else
            echo -e "${C_2}php$php_version already installed.${C_0}"
        fi
        PHP_VERSION_INI_DIR="$HOMEBREW_PATH/etc/php/$php_version/conf.d"
        PHP_VERSION_INI_PATH="$PHP_VERSION_INI_DIR/macos-web-development.ini"
        if ! [ -f "$PHP_VERSION_INI_PATH" ]; then
            echo -e "${C_1}Installing PHP ini for php$php_version ...${C_0}"
            if ! $DRY_RUN; then
                if ! [ -d "$PHP_VERSION_INI_DIR" ]; then
                    mkdir "$PHP_VERSION_INI_DIR"
                fi
                ln -s $PHP_INI_DEST "$PHP_VERSION_INI_PATH"
            fi
        else
            echo -e "${C_2}PHP ini for php$php_version already installed. Will not overwrite.${C_0}"
        fi
    done

    # Apache PHP config.
    echo -e "${C_1}Installing Apache PHP config ...${C_0}"
    APACHE_PHP_INJECT='<IfModule dir_module>\n    DirectoryIndex index.php index.html\n</IfModule>\n<FilesMatch \.php\$>\n    SetHandler application/x-httpd-php\n</FilesMatch>'
    if $APACHE_PATH_CONF_EXISTS; then
        if ! $DRY_RUN; then
            sudo perl -i -0pe "s|^<IfModule dir_module>\n.*DirectoryIndex index.html\n</IfModule>|$APACHE_PHP_INJECT|mg" $APACHE_PATH_CONF
            echo -e "${C_1}Restarting Apache ...${C_0}"
            brew services restart httpd
        # else
            # Disabled until I figure out how to print changed lines only with perl.
            # sudo perl -0pe "s|^<IfModule dir_module>\n.*DirectoryIndex index.html\n</IfModule>|$APACHE_PHP_INJECT|mg" $APACHE_PATH_CONF
        fi
    else
        if ! $DRY_RUN; then
            echo -e "${C_INFO}Apache configuration file was not found at $APACHE_PATH_CONF. PHP configuration not installed. Wanted to inject:\n${C_0}$APACHE_PHP_INJECT"
        fi
    fi

    # PHP info page.
    if $INSTALL_APACHE; then
        if ! [ -f "$APACHE_DOC_ROOT/info.php" ]; then
            echo -e "${C_1}Installing ${C_INFO}http://$APACHE_SERVER_NAME/info.php${C_0}"
            if ! $DRY_RUN; then
                echo "<?php phpinfo();" > "$APACHE_DOC_ROOT/info.php"
            fi
        else
            echo -e "${C_INFO}http://$APACHE_SERVER_NAME/info.php${C_2} already installed. Will not overwrite.${C_0}"
        fi
    fi

    # Install sphp script.
    if ! [ -x "$(command -v sphp)" ]; then
        echo -e "${C_1}Installing sphp ...${C_0}"
        if ! $DRY_RUN; then
            cp "$DIR/sphp.sh" /usr/local/bin/sphp
            chmod +x /usr/local/bin/sphp
            echo -e "${C_EM}Switch PHP version using for example ${C_0}sphp $PHP_EXAMPLE_VERSION"
        fi
    else
        echo -e "${C_2}sphp already installed.${C_0}"
    fi
}
