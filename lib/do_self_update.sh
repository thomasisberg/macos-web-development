#!/bin/bash

do_self_update ()
{
    local TEMP_DIR="/tmp/macos-web-development"
    local UPDATE_DIR="$TEMP_DIR/update"

    if ! [ -z "$SCRIPT_REPO" ]; then
        local DOWNLOADED=false

        echo -e "${C_1}Downloading ...${C_0}"
        if ! $DRY_RUN; then
            rm -rf $TEMP_DIR
            mkdir $TEMP_DIR
            git clone $SCRIPT_REPO $UPDATE_DIR

            if [ -d $UPDATE_DIR ]; then
                DOWNLOADED=true
            fi
        fi

        if $DOWNLOADED || $DRY_RUN; then
            echo -e "${C_INFO}Download complete.${C_0}"    
        else
            echo -e "${C_INFO}Script could not be downloaded from repository ${C_INFO_CODE}$SCRIPT_REPO${C_INFO}.${C_0}"    
        fi

        if $DOWNLOADED || $DRY_RUN; then
            echo -e "${C_1}Installing ...${C_0}"
            if ! $DRY_RUN; then
                cd $UPDATE_DIR
                $UPDATE_DIR/self-install
                cd $PWD
            fi
            echo -e "${C_INFO}Script installed.${C_0}"
        fi

        if ! $DRY_RUN; then
            rm -rf $TEMP_DIR
        fi
    else
        echo -e "${C_2}No script repository defined (${C_1}--script-repo=${C_2})${C_0}"
    fi
}
