#!/bin/bash
ARCH=$(uname -i | cut -c 5-6)
AGENTURL=$(curl --silent "https://api.github.com/repos/Microsoft/OMS-Agent-for-Linux/releases/latest" | grep '"browser_download_url":' | grep $ARCH | cut -d '"' -f 4)
AGENTINSTALLER=$(curl --silent "https://api.github.com/repos/Microsoft/OMS-Agent-for-Linux/releases/latest" | grep '"name":' | grep $ARCH | cut -d '"' -f 4)
OMSGATEWAY="http://OMSGW_FQDN:PORT"
WORKSPACEID="YOUR_WORKSPACEID"
SHAREDKEY="YOUR_SHARED_KEY"

curl -L -s $AGENTURL -o $AGENTINSTALLER \
&& curl -L -s https://aka.ms/dependencyagentlinux -o InstallDependencyAgent-Linux64.bin \
&& sh ./$AGENTINSTALLER --upgrade -p $OMSGATEWAY -w $WORKSPACEID -s $SHAREDKEY \
&& sh InstallDependencyAgent-Linux64.bin -s
