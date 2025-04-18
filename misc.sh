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

apt install git universal-ctags silversearcher-ag wireguard snapd
snap install go --classic
wget https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.xz
tar xvf node-v20.10.0-linux-x64.tar.xz -C /opt
ln -s /opt/node-v20.10.0-linux-x64/bin/* /usr/local/bin

wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
	-O ~/bin/yq && chmod +x ~/bin/yq
#mac
brew install yq
#arch
pacman -Syv go ctags go-yq
#debian
update-alternatives --config editor

ufw allow 22
ufw default deny
ufw enable

# on node 1
umask 077
wg genkey | tee wgp1_key.pri | wg pubkey > wgp1_key.pub
wg genkey | tee wgp2_key.pri | wg pubkey > wgp2_key.pub
ip link add dev wg0 type wireguard
ip a a 10.0.0.1/24 dev wg0
wg set wg0 listen-port 5555 private-key wgp1_key.pri peer $(cat wgp2_key.pub) \
	allowed-ips 10.0.0.2/32 endpoint 192.168.2.2:5555
ip link set up dev wg0
tcpdump -nvelxxi eth1 port 5555
wg showconf wg0 | tee wgp1.conf
# on node 2, copy wgp2_key.pri from node 1
ip link add dev wg0 type wireguard
ip a a 10.0.0.2/24 dev wg0
wg set wg0 listen-port 5555 private-key wgp2_key.pri peer $(cat wgp1_key.pub) allowed-ips 10.0.0.1/32 endpoint 192.168.2.1:5555
ip link set up dev wg0
ping 10.0.0.1
wg showconf wg0 | tee wgp2.conf

snap info microk8s
for i in 1 2 3; do
	scp -P $port ./icmk8s.sh root@svr$i:
	ssh -p $port root@svr1 /root/icmk8s.sh 10.0.0.$i
done
#on node 1:
microk8s add-node # each node needs its own token to join the master node
#on node 2
microk8s join 10.0.0.1:...
#on node 1:
microk8s add-node
#on node 3
microk8s join 10.0.0.1:...
microk8s kubectl drain $node
microk8s kubectl uncordon $node
microk8s refresh-certs -c
microk8s refresh-certs -e server.crt
microk8s refresh-certs -e front-proxy-client.crt

#on each node
for i in $(seq 4) ; do ./prelvp.sh $i ; done
#on node 1
microk8s helm repo add sig-storage-local-static-provisioner https://kubernetes-sigs.github.io/sig-storage-local-static-provisioner
microk8s helm template --debug sig-storage-local-static-provisioner/local-static-provisioner > lvp.generated.yaml
microk8s kubectl create -f lvp.generated.yaml
cat > sc-default-lvp.yaml <<-EOF
	apiVersion: storage.k8s.io/v1
	kind: StorageClass
	metadata:
	  name: fast-disks
	  annotations:
	    storageclass.kubernetes.io/is-default-class: "true"
	provisioner: kubernetes.io/no-provisioner
	volumeBindingMode: WaitForFirstConsumer
	# Supported policies: Delete, Retain
	reclaimPolicy: Delete
	EOF
microk8s kubectl apply -f sc-default-lvp.yaml
microk8s helm install $release . -n $namespace --create-namespace --debug
cat > update-$release-tls-secret.sh <<-EOF
	#!/bin/bash
	microk8s kubectl delete secret/$release-tls-secret -n $namespace
	microk8s kubectl create secret/$release-tls-secret -n $namespace \
		--key $path_to_key_file --cert $path_to_cert_file
	EOF
chmod +x update-$release-tls-secret.sh
./update-$release-tls-secret.sh
microk8s kubectl rollout restart statefulset/minio-service -n $namespace
microk8s kubectl rollout restart statefulset/hyi-couchdb -n $namespace
microk8s kubectl rollout restart deployment/app-service -n $namespace
microk8s kubectl rollout restart deployment/worker-service -n $namespace
microk8s helm uninstall $release -n $namespace

# No need to drain and uncordon
microk8s kubectl get nodes -o wide
# microk8s kubectl drain --ignore-daemonsets $node
# microk8s kubectl uncordon $node

# fix couchdb
microk8s kubectl exec -n $namespace -it pod/$couchdb -- /bin/bash
	for db in _users _replicator _global_changes ; do
		curl -X PUT http://127.0.0.1:5984/$db -u $admin:$password
	done

