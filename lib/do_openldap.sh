#!/bin/bash

# ----------------------------------------------------------
# Openldap
# ----------------------------------------------------------

do_openldap ()
{
    if ! [ -x "$(command -v ldapsearch)" ]; then
        echo -e "${C_1}Installing Openldap ...${C_0}"
        if $HAS_BREW && !$DRY_RUN; then
            brew install openldap
        fi
    else
        HAS_BREW_OPENLDAP=false
        if ($HAS_BREW); then
            if [[ -n "$(brew ls --versions "openldap")" ]]; then
                HAS_BREW_OPENLDAP=true
            fi
        fi
        if $HAS_BREW_OPENLDAP; then
            echo -e "${C_2}Openldap already installed.${C_0}"
        else
            echo -e "${C_2}Found command ${C_0}ldapsearch${C_2}. Openldap not installed.${C_0}"
        fi
    fi
}
