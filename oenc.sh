#!/bin/bash

# Usage: $0 [infn [outfn] [pwfn]]
# 	decrypt input file infn into output file outfn with openssl chacha20 
#   and password file pwfn
# 

set -xe
infn=${1:--}
if [ x$infn = 'x-' ] ; then
	outfn=${2:--}
else
	outfn=${2:-$infn.enc}
fi
pwfn=${3:-~/.secrets/passwd.oenc}
[ -r $pwfn ] || ./genpasswd.sh 16 $(basename $pwfn) $(dirname $pwfn)

openssl enc -chacha20 -pbkdf2 -in $infn -out $outfn -pass file:$pwfn
