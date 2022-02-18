#!/bin/bash

# ----------------------------------------------------------
# Dnsmasq
# ----------------------------------------------------------

do_dnsmasq ()
{
    if ! [ -x "$(command -v dnsmasq)" ]; then
        echo -e "${C_1}Installing Dnsmasq ...${C_0}"
        if ! $DRY_RUN; then
            brew install dnsmasq
            cd $(brew --prefix); mkdir -p etc; echo 'address=/.test/127.0.0.1' > etc/dnsmasq.conf
            sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
            # sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
            brew services start dnsmasq
            sudo mkdir /etc/resolver
            sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'
            cd $PWD
        fi
    else
        echo -e "${C_2}Dnsmasq already installed.${C_0}"
    fi
}
