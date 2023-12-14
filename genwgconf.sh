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
let i=1
echo > instanceIds.all
readarray instances < <(yq 'sort_by(.ipv4)|.[]|@json' instances.yaml)
for instance in "${instances[@]}" ; do
	eval $(echo "$instance" | \
			yq -o shell '{"ipv4": .ipv4, "instanceId": .instanceId}' -)

	echo generating wireguard config for instanceId $instanceId with ip $ipv4
	#[[ -r wg-key-$instanceId.pri && -r wg-key-$instanceId.pub ]] || \
	wg genkey | tee wg-key-$instanceId.pri | wg pubkey > wg-key-$instanceId.pub

	# assuming the total number of instances is less than 256
	wg0_ip=10.0.0.$i
	cat > wg-interface-$instanceId <<-EOF
		[Interface]
		Address = $wg0_ip/24
		PrivateKey = $(cat wg-key-$instanceId.pri)
		ListenPort = $port
		EOF
	cat > wg-peer-$instanceId <<-EOF
		[Peer]
		Publickey = $(cat wg-key-$instanceId.pub)
		Endpoint = $ipv4:$port
		AllowedIPs = $wg0_ip/32 
		EOF
	echo $instanceId >> instanceIds.all
	let i++
done

for instanceId in $(cat instanceIds.all) ; do 
	peerIds="$(grep -v $instanceId instanceIds.all)"
	yq ".wireguard.interfaces[0].content=\
		\"$(cat wg-interface-$instanceId; \
			for peerId in $peerIds ; \
				do cat wg-peer-$peerId; done)\"" \
		user-data-temp.yaml > user-data-$instanceId.yaml
done
popd > /dev/null
