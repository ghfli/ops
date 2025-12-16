#!/bin/bash
#
# Usage: $0 [ip [usr]]
#   install and customize microk8s

set -xe
ip=${1:-10.0.0.1}
usr=$2
mca=/var/snap/microk8s/current/args
sudo snap install microk8s --classic --channel=latest/stable
sudo sh -c "cat >>$mca/kube-apiserver <<-EOF
	# customize interface
	--advertise-address=$ip
	--bind-address=0.0.0.0
	EOF"
sudo sh -c "cat >>$mca/kube-controller-manager <<-EOF
	# customize interface
	--bind-address=0.0.0.0
	EOF"
sudo sh -c "cat >>$mca/kube-scheduler <<-EOF
	# customize interface
	--bind-address=0.0.0.0
	EOF"
sudo sh -c "cat >>$mca/kube-proxy <<-EOF
	# customize interface
	--bind-address=0.0.0.0
	EOF"
sudo sh -c "cat >>$mca/kubelet <<-EOF
	--address=0.0.0.0
	--node-ip=$ip
	--healthz-bind-address=127.0.0.1
	EOF"
sudo snap restart microk8s
[ -n $usr ] && sudo usermod -a -G microk8s $usr
