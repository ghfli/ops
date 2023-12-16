#!/bin/bash
#
# Usage: $0 [ip [usr]]
#   install and customize microk8s

set -xe
ip=${1:-10.0.0.1}
usr=$2
snap install microk8s --classic --channel=latest/stable
pushd /var/snap/microk8s/current > /dev/null
cat >>args/kube-apiserver <<-EOF
	# customize interface
	--advertise-address=$ip
	--bind-address=0.0.0.0
	EOF
cat >>args/kube-controller-manager <<-EOF
	# customize interface
	--bind-address=0.0.0.0
	EOF
cat >>args/kube-scheduler <<-EOF
	# customize interface
	--bind-address=0.0.0.0
	EOF
cat >>args/kube-proxy <<-EOF
	# customize interface
	--bind-address=0.0.0.0
	EOF
cat >>args/kubelet <<-EOF
	--address=0.0.0.0
	--node-ip=$ip
	--healthz-bind-address=127.0.0.1
	EOF
snap restart microk8s
[ -n $usr ] && usermod -a -G microk8s $usr
popd > /dev/null
