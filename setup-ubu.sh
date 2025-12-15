#!/bin/bash

set -xe
sudo apt install -y universal-ctags silversearcher-ag snapd
sudo snap install go --classic

wget https://nodejs.org/dist/v24.12.0/node-v24.12.0-linux-x64.tar.xz
sudo tar xvf node-v24.12.0-linux-x64.tar.xz -C /opt
sudo ln -s /opt/node-v24.12.0-linux-x64/bin/* /usr/local/bin

sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
	-O /usr/local/bin/yq && sudo chmod +x /usr/local/bin/yq
