#!/bin/bash
#
# Usage: $0 [reg [dir [img]]]
#
#   reinstall contabo $img instances in region $reg with secrets saved in dir $dir
#   default: reg=US-east dir=~/.secrets img=ubuntu-22.04

#set -xe
reg=${1:-"US-central"}
if [ "x$reg" != "xUS-east" -a "x$reg" != "xUS-central" ] ; then
	echo Error: region \"$reg\" not supported
	exit 1
fi
dir=${2:-~/.secrets}
if [ ! -d "$dir" ] ; then
	echo Error: \"$dir\" not existed
	exit 2
fi
img=${3:-"ubuntu-24.04"}
if [ "x$img" != "xubuntu-24.04" ] ; then
	echo Error: image \"$img\" not supported
	exit 3
fi
pushd "$dir" > /dev/null

#[ -r instances.yaml ] || \
	cntb get instances -o yaml > instances.yaml
insfn=instanceIds.$reg
#[ -r $insfn ] || \
	reg=$reg yq '.[]|select(.region==strenv(reg))|.instanceId|@json' \
		instances.yaml > $insfn

#[ -r images ] || \
	cntb get images -o yaml > images.yaml
imgfn=imageIds.$img
#[ -r $imgfn ] || \
	img=$img yq '.[]|select(.name==strenv(img))|.imageId' images.yaml > $imgfn

rpfn=secretIds.passwd
skfn=secretIds.ssh
#[[ -r $rpfn && -r $skfn ]] || ./recresecs.sh
SK="[$(head -1 $skfn)"
for k in $(tail -n +2 $skfn); do
    SK+=", $k"
done
SK+="]"
for i in $(cat $insfn) ; do 
	echo reinstalling instance $i...
	udfn=user-data-$i.yaml
	[ -r $udfn ] || ./genwgconf.sh
	cat > cntb-reins-$i.yaml <<-EOF
		defaultUser: root
		imageId: $(cat $imgfn)
		rootPassword: $(cat $rpfn)
		sshKeys: $SK
		userData: |
			$(sed -e 's/^/  /g' $udfn)
		EOF
	cntb reinstall instance $i -f cntb-reins-$i.yaml
done
popd > /dev/null

