#!/bin/bash
#
# Usage: $0 [dir]
#
#   recreate cntabo secerets from files saved in dir $dir
#   default: dir=~/.secrets

#set -xe
dir=${1:-~/.secrets}
[ -r "$dir"/passwd.root ] || genpasswd.sh 16 passwd.root "$dir"
if [ ! -d "$dir" ] ; then
	echo Error: \"$dir\" not existed
	exit 1
fi
pushd "$dir" > /dev/null
cntb get secrets | awk '($3 !~ "TYPE") {print $1}' > secretIds.all
for i in $(cat secretIds.all) ; do
	cntb delete secret $i
done
prfn=passwd.root
cntb create secret --name $prfn --type password --value "$(cat $prfn)"
for f in ssh.* ; do
	cntb create secret --name $f --type ssh --value "$(cat $f)"
done
cntb get secrets > secrets
awk '($3 ~ "password") {print $1}' secrets > secretIds.passwd
awk '($3 ~ "ssh") {print $1}' secrets > secretIds.ssh
popd > /dev/null
