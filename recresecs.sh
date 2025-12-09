#!/bin/bash
#
# Usage: $0 [dir]
#
#   recreate cntabo secerets from files saved in dir $dir
#   default: dir=~/.secrets

#set -xe
dir=${1:-~/.secrets}
[ -r "$dir"/passwd.root ] || ./genpasswd.sh 16 passwd.root "$dir"
if [ ! -d "$dir" ] ; then
	echo Error: \"$dir\" not existed
	exit 1
fi
pushd "$dir" > /dev/null
cntb get secrets -o yaml > secrets.yaml
yq '.[]|.secretId' secrets.yaml > secretIds.all
for i in $(cat secretIds.all) ; do
	cntb delete secret $i
done
prfn=passwd.root
cntb create secret --name $prfn --type password --value "$(cat $prfn)"
for f in ssh.* ; do
	cntb create secret --name $f --type ssh --value "$(cat $f)"
done
cntb get secrets -o yaml > secrets.yaml
yq '.[]|select(.type=="password")|.secretId' secrets.yaml > secretIds.passwd
yq '.[]|select(.type=="ssh")|.secretId' secrets.yaml > secretIds.ssh
popd > /dev/null
