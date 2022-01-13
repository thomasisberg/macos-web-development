#!/bin/bash

# ----------------------------------------------------------
# Xcode
# ----------------------------------------------------------

do_xcode () 
{
    XCODE_STATUS="$(xcode-select -v)"
    if [ -z "$XCODE_STATUS" ]; then
        echo -e "${C_1}Installing Xcode command line tools ...${C_0}"
        if ! $DRY_RUN; then
            xcode-select --install
        fi
    else
        echo -e "${C_2}Xcode command line tools already installed${C_0}"
    fi
}
