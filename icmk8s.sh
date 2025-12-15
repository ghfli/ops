#!/bin/bash
#
# Usage: $0 [ip [usr]]
#   install and customize microk8s

set -xe
ip=${1:-10.0.0.1}
usr=$2
pwd=$(pwd)
sudo snap install microk8s --classic --channel=latest/stable
sudo sh -c 'cd /var/snap/microk8s/current/args > /dev/null'
sudo cat >>kube-apiserver <<-EOF
	# customize interface
	--advertise-address=$ip
	--bind-address=0.0.0.0
	EOF
sudo cat >>kube-controller-manager <<-EOF
	# customize interface
	--bind-address=0.0.0.0
	EOF
sudo cat >>kube-scheduler <<-EOF
	# customize interface
	--bind-address=0.0.0.0
	EOF
sudo cat >>kube-proxy <<-EOF
	# customize interface
	--bind-address=0.0.0.0
	EOF
sudo cat >>kubelet <<-EOF
	--address=0.0.0.0
	--node-ip=$ip
	--healthz-bind-address=127.0.0.1
	EOF
sudo snap restart microk8s
[ -n $usr ] && sudo usermod -a -G microk8s $usr
sudo sh -c 'cd $pwd > /dev/null'
