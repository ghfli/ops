# ops

Utilize contabo cntb and ubuntu multipass to set up production and dev environments

## Automate [contabo](https://contabo.com) ubuntu instance configuration 

### get familiar with the [cloud-init](https://cloudinit.readthedocs.io) framework and [config examples](https://cloudinit.readthedocs.io/en/latest/reference/examples.html); prepare the customized cloud-config user-data.yaml

### install and configure the latest [cntb](https://github.com/contabo/cntb/releases) and [rclone](https://rclone.org/install/) on the local machine

### use [genpasswd.sh](genpasswd.sh) to generate random passwords for root
```
    $ ./genpasswd.sh 16 passwd.root
```
modify the generated passwd.root to satisfy the requirement listed in the [contabo createSecret API](https://api.contabo.com/#tag/Secrets/operation/createSecret) document:
> In case of a password it must match a pattern with at least one upper and lower case character and either one number with two special characters `!@#$^&*?_~` or at least three numbers with one special character `!@#$^&*?_~`. This is expressed in the following regular expression: `^((?=.*?[A-Z]{1,})(?=.*?[a-z]{1,}))(((?=(?:[^d]*d){1})(?=([^^&*?_~]*[!@#$^&*?_~]){2,}))|((?=(?:[^d]*d){3})(?=.*?[!@#$^&*?_~]+))).{8,}$`

[apg](https://linux.die.net/man/1/apg) can also be used to generate the password:
```
    $ apg -a 1 -c cl_seed -n 1 -m 16 -x 16 -M sncl > ~/.secrets/passwd.root
```

### use [recresecs.sh](recresecs.sh) to recreate secrets
```
    $ ./recresecs.sh
```

### use [reinstall.sh](reinstall.sh) to reinstall/reconfigure the selected instances
```
    $ ./reinstall.sh
```

### refer [misc.sh](misc.sh) for miscellaneous commands

### disable vnc access on the contabo vps control panel
