#!/bin/bash
#
# Usage: $0 [len [file [dir]]]
#
#   generate a random password with length $len, saved in file $file under dir $dir
#   and displayed on stdout
#   default: len=12 file=password.r$len dir=~/.secrets

#set -xe
len=${1:-12}
if [ $len -lt 8 ] ; then
	echo password length must not be less than 8
	exit 1
fi
if [ $len -gt 64 ] ; then
	echo password length must not be greater than 64
	exit 2
fi
file=${2:-passwd.r$len}
dir=${3:-~/.secrets}
[ -d "$dir" ] || mkdir "$dir" && chmod go-rwx "$dir"
pushd "$dir" > /dev/null
LANG=C tr -dc 'A-Za-z0-9!@#$^&*?_~' < /dev/urandom \
        | head -c 1024 > passwd.r1k 
let i=0x$(openssl rand -hex 2)%953+1
let j=$i+$len-1
cut -b $i-$j passwd.r1k | tee $file
popd > /dev/null
