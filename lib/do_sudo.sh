#!/bin/bash

# ----------------------------------------------------------
# Sudo
# ----------------------------------------------------------

do_sudo ()
{
    echo -e "${C_1}Acquire sudo ...${C_0}"
    sudo echo "" > /dev/null
    echo -e "${C_EM}Hello Sudoer!${C_0}"
}
