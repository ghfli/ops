#!/bin/bash

# Usage: $0 [infn [outfn] [pwfn]]
# 	encrypt input file infn into output file outfn with openssl chacha20 
#   and password file pwfn
# 

set -xe
infn=${1:--}
if [ x$infn = 'x-' ] ; then
	outfn=${2:--}
else
	outfn=${2:-$(basename $infn .enc)}
fi
pwfn=${3:-~/.secrets/passwd.oenc}

if [ ! -r $pwfn ] ; then
	echo Error: $pwfn not existed
	exit 1
fi
openssl enc -d -chacha20 -pbkdf2 -in $infn -out $outfn -pass file:$pwfn
