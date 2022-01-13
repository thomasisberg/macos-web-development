#!/bin/bash

# ----------------------------------------------------------
# Libiconv
# ----------------------------------------------------------

do_libiconv ()
{
    if ! [ -x "$(command -v iconv)" ]; then
        echo -e "${C_1}Installing Libiconv ...${C_0}"
        if $HAS_BREW && !$DRY_RUN; then
            brew install libiconv
        fi
    else
        HAS_BREW_LIBICONV=false
        if ($HAS_BREW); then
            if [[ -n "$(brew ls --versions "libiconv")" ]]; then
                HAS_BREW_LIBICONV=true
            fi
        fi
        if $HAS_BREW_LIBICONV; then
            echo -e "${C_2}Libiconv already installed.${C_0}"
        else
            echo -e "${C_2}Found iconv on machine. Libiconv not installed.${C_0}"
        fi
    fi
}
