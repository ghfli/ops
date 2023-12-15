#!/bin/bash
#
# Usage: $0 [ip]
#   install and customize microk8s

ip=${1:-10.0.0.1}

snap install microk8s --classic --channel=latest/stable
pushd /var/snap/microk8s/current > /dev/null
cat >>args/kube-apiserver <<-EOF
	# customize interface
	--advertise-address=$ip
	--bind-address=$ip
	#--secure-port=16443
	EOF
for f in credentials/*.config ; do
	sed -i.old -e "s/127.0.0.1/$ip/" $f
done
cat >>args/kube-controller-manager <<-EOF
	# customize interface
	--bind-address=$ip
	#--secure-port=10257
	EOF
cat >>args/kube-controller-manager <<-EOF
	# customize interface
	--bind-address=$ip
	#--secure-port=10257
	EOF
popd > /dev/null
