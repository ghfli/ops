#!/bin/bash
#
# Usage: $0 [port [dir]]
#
# 	generate wireguard configuration files

#set -xe
port=${1:-5555}
dir=${2:-~/.secrets}
pushd "$dir" > /dev/null
umask 0177
echo > instanceIds.all
readarray instances < <(yq '.[]|@json' instances.yaml)
for instance in "${instances[@]}" ; do
	eval $(echo "$instance" | \
			yq -o shell '{"ipv4": .ipv4, "instanceId": .instanceId}' -)

	echo generating wireguard config for instanceId $instanceId ipv4 $ipv4
	[[ -r wg-$instanceId-key.pri && -r wg-$instanceId-key.pub ]] || \
	wg genkey | tee wg-$instanceId-key.pri | wg pubkey > wg-$instanceId-key.pub

	cat > wg-$instanceId-interface <<-EOF
		[Interface]	
		PrivateKey = $(cat wg-$instanceId-key.pri)
		ListenPort = $port
		EOF
	cat > wg-$instanceId-peer <<-EOF
		[Peer]	
		Publickey = $(cat wg-$instanceId-key.pub)
		Endpoint = $ipv4:$port
		AllowedIPs = 0.0.0.0/0
		EOF
	echo $instanceId >> instanceIds.all
done

for instanceId in $(cat instanceIds.all) ; do 
	peerIds="$(grep -v $instanceId instanceIds.all)"
	yq ".wireguard.interfaces[0].content=\
		\"$(cat wg-$instanceId-interface; \
			for peerId in $peerIds ; \
				do cat wg-$peerId-peer; done)\"" \
		user-data-temp.yaml > user-data-$instanceId.yaml
done
popd > /dev/null
