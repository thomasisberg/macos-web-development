#!/bin/bash

# ----------------------------------------------------------
# Apache (via Homebrew)
# ----------------------------------------------------------

do_apache ()
{
    if ! $HAS_BREW; then
        echo -e "${C_1}Would look for Apache if Homebrew was actually installed.${C_0}"
    elif ! [[ -n "$(brew ls --versions "httpd")" ]]; then
        # Prepare custom log directory.
        echo -e "${C_1}Preparing Apache log directory ...${C_0}"
        if ! $DRY_RUN; then
            sudo mkdir -p $APACHE_LOG_DIR
            sudo chgrp -R staff $APACHE_LOG_DIR
            sudo chmod -R ug+w $APACHE_LOG_DIR
        fi
        # Stop current Apache server.
        echo -e "${C_1}Stopping potentially running Apache ...${C_0}"
        if ! $DRY_RUN; then
            sudo apachectl -k stop
            sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null
        fi
        echo -e "${C_1}Installing Apache (via Homebrew) ...${C_0}"
        if ! $DRY_RUN; then
            brew install httpd
            brew services start httpd
            # sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist
            if [ -f "$APACHE_PATH_CONF" ]; then
                APACHE_PATH_CONF_EXISTS=true
            fi
        fi
        APACHE_INSTALLED=true
        # Apache User / Group.
        read -p "Apache User [$USER]: " APACHE_USER
        APACHE_USER=${APACHE_USER:-$USER}
        read -p "Apache Group [staff]: " APACHE_GROUP
        APACHE_GROUP=${APACHE_GROUP:-staff}
        # Apache admin e-mail
        read -p "Apache Admin e-mail [admin@example.test]: " APACHE_ADMIN_EMAIL
        APACHE_ADMIN_EMAIL=${APACHE_ADMIN_EMAIL:-admin@example.test}
        # Apache server name
        read -p "Apache Server Name [localhost]: " APACHE_SERVER_NAME
        APACHE_SERVER_NAME=${APACHE_SERVER_NAME:-localhost}
        # Apache document root.
        read -p "Apache Document Root [/Users/$APACHE_USER/WebServer/sites]: " APACHE_DOC_ROOT
        APACHE_DOC_ROOT=${APACHE_DOC_ROOT:-"/Users/$APACHE_USER/WebServer/sites"}
        APACHE_DOC_ROOT_REGEX="^DocumentRoot ..*$"
        # Modify Apache conf.
        if $APACHE_PATH_CONF_EXISTS; then
            if ! $DRY_RUN; then
                sudo sed -i.bak "s|^Listen ..*$|Listen 80|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^\#LoadModule vhost_alias_module \(.*\)$|LoadModule vhost_alias_module \1|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^\#LoadModule rewrite_module \(.*\)$|LoadModule rewrite_module \1|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^User ..*$|User $APACHE_USER|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^Group ..*$|Group $APACHE_GROUP|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^ServerAdmin ..*@..*\...*$|ServerAdmin $APACHE_ADMIN_EMAIL|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^\#*ServerName ..*$|ServerName $APACHE_SERVER_NAME|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|$APACHE_DOC_ROOT_REGEX|DocumentRoot \"$APACHE_DOC_ROOT\"|g" $APACHE_PATH_CONF
                sudo perl -i.bak -0pe "s|^(DocumentRoot .*)\n<Directory ..*>|\1\n<Directory \"$APACHE_DOC_ROOT\">|mg" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^ErrorLog ..*|ErrorLog \"$APACHE_LOG_DIR/error_log\"|g" $APACHE_PATH_CONF
                sudo sed -i.bak "s|^\#*#Include \(.*\)/extra/httpd-vhosts.conf|Include \1/extra/httpd-vhosts.conf|g" $APACHE_PATH_CONF
            else
                echo "Will change Apache config lines ..."
                sudo sed -n "s|^Listen ..*$|Listen 80|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^\#LoadModule vhost_alias_module \(.*\)$|LoadModule vhost_alias_module \1|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^\#LoadModule rewrite_module \(.*\)$|LoadModule rewrite_module \1|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^User ..*$|User $APACHE_USER|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^Group ..*$|Group $APACHE_GROUP|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^ServerAdmin ..*@..*\...*$|ServerAdmin $APACHE_ADMIN_EMAIL|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^\#*ServerName ..*$|ServerName $APACHE_SERVER_NAME|gp" $APACHE_PATH_CONF
                sudo sed -n "s|$APACHE_DOC_ROOT_REGEX|DocumentRoot \"$APACHE_DOC_ROOT\"|gp" $APACHE_PATH_CONF
                # Disabled until I figure out how to print changed lines only with perl.
                # sudo perl -0pe "s|^(DocumentRoot .*)\n<Directory ..*>|\1\n<Directory \"$APACHE_DOC_ROOT\">|mg" $APACHE_PATH_CONF
                sudo sed -n "s|^ErrorLog ..*|ErrorLog \"$APACHE_LOG_DIR/error_log\"|gp" $APACHE_PATH_CONF
                sudo sed -n "s|^\#*#Include .*/extra/httpd-vhosts.conf|Include $APACHE_PATH_VHOSTS|gp" $APACHE_PATH_CONF
            fi
        fi

        # Setup virtual hosts.
        echo -e "${C_1}Installing Apache vhosts configuration ...${C_0}"
        if ! $DRY_RUN; then
            APACHE_VHOSTS=$(<"$DIR/httpd-vhosts.conf")
            APACHE_VHOSTS="${APACHE_VHOSTS//\{APACHE_DOC_ROOT\}/$APACHE_DOC_ROOT}"
            APACHE_VHOSTS="${APACHE_VHOSTS//\{APACHE_SERVER_NAME\}/$APACHE_SERVER_NAME}"
            APACHE_PATH_VHOSTS_BACKUP="$APACHE_PATH_VHOSTS.bak"
            if ! [ -f "$APACHE_PATH_VHOSTS_BACKUP" ]; then
                echo -e "${C_INFO}Moving current Apache vhosts configuration to $APACHE_PATH_VHOSTS_BACKUP ...${C_0}"
                cp $APACHE_PATH_VHOSTS $APACHE_PATH_VHOSTS_BACKUP
            fi
            echo "$APACHE_VHOSTS" | sudo tee $APACHE_PATH_VHOSTS > /dev/null
        fi
        
        # Server root.
        if ! [ -d "$APACHE_DOC_ROOT" ]; then
            echo -e "${C_1}Creating server root ...${C_0}"
            if ! $DRY_RUN; then
                mkdir -p "$APACHE_DOC_ROOT"
            fi
        else
            echo -e "${C_2}Server root already created.${C_0}"
        fi
        if ! [ -f "$APACHE_DOC_ROOT/index.html" ]; then
            echo -e "${C_1}Installing ${C_INFO}http://$APACHE_SERVER_NAME${C_1} (index.html)${C_0}"
            if ! $DRY_RUN; then
                echo "<h1>I am website</h1><p>Check PHP info at <a href='info.php'>info.php</a>" > "$APACHE_DOC_ROOT/index.html"
            fi
        else
            echo -e "${C_INFO}http://$APACHE_SERVER_NAME${C_2} (index.html) already installed. Will not overwrite.${C_0}"
        fi

        # Restart Apache.
        echo -e "${C_1}Restarting Apache ...${C_0}"
        if ! $DRY_RUN; then
            brew services restart httpd
        fi
    else
        echo -e "${C_2}Apache (via Homebrew) already installed.${C_0}"
        APACHE_SERVER_NAME=$(sed -n "s|^ServerName \(.*\)|\1|gp" $APACHE_PATH_CONF)
        APACHE_DOC_ROOT=$(sed -n "s|DocumentRoot \"\(.*\)\"|\1|gp" $APACHE_PATH_CONF)
    fi
}
