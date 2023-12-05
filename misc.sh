# miscellaneous commands 

cntb resetPassword instance $INSTANCEID --sshkeys $SECID
cntb start instance $INSTANCEID
openssl enc -chacha20 -pbkdf2 -a -i $RAW -o $ENC -pass file:~/.secrets/passwd.r1k
openssl enc -d -chacha20 -pbkdf2 -a -i $ENC -o $RAW -pass file:~/.secrets/passwd.r1k
