#!/bin/bash
#
# Usage: $0 [reg [dir [img]]]
#
#   reinstall contabo $img instances in region $reg with secrets saved in dir $dir
#   default: reg=US-east dir=~/.secrets img=ubuntu-22.04

#set -xe
reg=${1:-"US-east"}
if [ "x$reg" != "xUS-east" ] ; then
	echo Error: region \"$reg\" not supported
	exit 1
fi
dir=${2:-~/.secrets}
if [ ! -d "$dir" ] ; then
	echo Error: \"$dir\" not existed
	exit 2
fi
img=${3:-"ubuntu-22.04"}
if [ "x$img" != "xubuntu-22.04" ] ; then
	echo Error: image \"$img\" not supported
	exit 3
fi
pushd "$dir" > /dev/null

# workaround cntb keeps complaining when [-o jsonpath='$..instanceId[?(@.region=="US-east")]'] is requested
[ -r instances ] || cntb get instances > instances
insfn=instanceIds.$reg
[ -r $insfn ] || awk "/$reg/ {print \$1}" instances > $insfn
# some fields such as DISPLAYNAME and IMAGEID are empty before reinstallation
# so the following line does not work
# awk "(\$5 ~ \"^$reg$\") {print \$1}" instances > $insfn

[ -r images ] || cntb get images > images
imgfn=imageIds.$img
[ -r $imgfn ] || awk "(\$2 ~ \"^$img$\") {print \$1}" images > $imgfn

rpfn=secretIds.passwd 
skfn=secretIds.ssh 
SK="[$(head -1 $skfn)"
for k in $(tail -n +2 $skfn); do
    SK+=", $k"
done
SK+="]"
udfn=user-data.yaml 

cat > cntb-reins.yaml <<-EOF
	defaultUser: root
	imageId: $(cat $imgfn)
	rootPassword: $(cat $rpfn)
	sshKeys: $SK
	userData: |
		$(sed -e 's/^/  /g' $udfn)
	EOF

for i in $(cat $insfn) ; do 
	echo reinstalling $i...
	cntb reinstall instance $i -f cntb-reins.yaml
done
popd > /dev/null  

