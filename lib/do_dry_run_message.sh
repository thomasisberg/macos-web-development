#!/bin/bash

# ----------------------------------------------------------
# Initial message for dry run.
# ----------------------------------------------------------

do_dry_run_message ()
{
    echo ""
    if $DRY_RUN; then
        if $UNINSTALL; then
            echo -e "${C_EM}Cool down – this is a dry run. Nothing will actually be uninstalled.${C_0}"
        else
            echo -e "${C_EM}Cool down – this is a dry run. Nothing will actually be installed.${C_0}"
        fi
        echo ""
    fi
}
