# miscellaneous commands 

cntb resetPassword instance $INSTANCEID --sshkeys $SECID
cntb start instance $INSTANCEID

openssl enc -chacha20 -pbkdf2 -a -in $RAW -out $ENC -pass file:~/.secrets/passwd.r1k
openssl enc -d -chacha20 -pbkdf2 -a -in $ENC -out $RAW -pass file:~/.secrets/passwd.r1k
cat > oenc2txt.sh <<-EOF
	#!/bin/bash
	./odec.sh "$1" -
	EOF
git config diff.oenc.textconv ./oenc2txt.sh

apt install git universal-ctags silversearcher-ag wireguard
wget https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.xz
tar xvf node-v20.10.0-linux-x64.tar.xz -C /opt
ln -s /opt/node-v20.10.0-linux-x64/bin/* /usr/local/bin

wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
	-O ~/bin/yq && chmod +x ~/bin/yq
brew install yq
pacman -Syv go ctags go-yq

ufw allow 22
ufw default deny
ufw enable

microk8s refresh-certs -c
microk8s refresh-certs -e server.crt
microk8s refresh-certs -e front-proxy-client.crt

# on node 1
umask 077
wg genkey | tee wgp1_key.pri | wg pubkey > wgp1_key.pub
wg genkey | tee wgp2_key.pri | wg pubkey > wgp2_key.pub
ip link add dev wg0 type wireguard
ip a a 192.168.2.1/24 dev wg0
wg set wg0 listen-port 5555 private-key wgp1_key.pri peer $(cat wgp2_key.pub) \
	allowed-ips 0.0.0.0/0 endpoint 10.0.0.2:5555
ip link set up dev wg0
tcpdump -nvelxxi eth1 port 5555
wg showconf wg0 | tee wgp1.conf
# on node 2, copy wgp2_key.pri from node 1
ip link add dev wg0 type wireguard
ip a a 192.168.2.2/24 dev wg0
wg set wg0 listen-port 5555 private-key wgp2_key.pri peer $(cat wgp1_key.pub) allowed-ips 0.0.0.0/0 endpoint 10.0.0.1:5555
ip link set up dev wg0
ping 192.168.2.1
wg showconf wg0 | tee wgp2.conf
