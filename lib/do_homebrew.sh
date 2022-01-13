#!/bin/bash

# ----------------------------------------------------------
# Homebrew
# ----------------------------------------------------------

do_homebrew ()
{
    if ! $HAS_BREW; then
        echo -e "${C_1}Installing Homebrew ...${C_0}"
        if ! $DRY_RUN; then
            # ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            if [ -x "$(command -v brew)" ]; then
                HAS_BREW=true
            fi
        fi
    else
        echo -e "${C_2}Homebrew already installed.${C_0}"
    fi

    if $HAS_BREW; then
        set_homebrew_path

        HAS_BREW_SERVICES=false
        TAPS="$(brew tap)"
        TAPS_LIST=($TAPS)
        for tap in "${TAPS_LIST[@]}"; do
            if [[ $tap = "homebrew/services" ]]; then
                HAS_BREW_SERVICES=true
            fi
        done
        if ! $HAS_BREW_SERVICES; then
            echo -e "${C_1}Installing Homebrew Services ...${C_0}"
            if ! $DRY_RUN; then
                brew tap homebrew/services
            fi
        else
            echo -e "${C_2}Homebrew Services already installed.${C_0}"
        fi
    fi
}
