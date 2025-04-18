#!/bin/bash
#
# prepare fast-disks for local volume provisioner


set -ex
n=${1:-1}
md=/mnt/fdv$n
mp=/mnt/fast-disks/v$n
mkdir -p $md
chmod go+w $md
mkdir -p $mp
mount -B $md $mp
if ! grep ^$md /etc/fstab ; then
	echo "$md $mp none bind 0 0" >> /etc/fstab
fi

