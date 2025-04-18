
# customize ubuntu instances through [multipass](https://multipass.run/docs)
```
multipass find
multipass list
# launch default ubuntu LTS release image
# failed two times with --cloud-init
# multipass launch -vvvv -c 4 -d 64G -m 8G -n ub1 --cloud-init user-data.yaml
multipass delete -p ub1
multipass launch -vvvv -c 4 -d 64G -m 8G -n ub1
multipass stop ub2 ub3
multipass set local.ub2.disk=64G
multipass set local.ub3.cpus=4
multipass set local.ub3.disk=64G
multipass set local.ub3.memory=8G
multipass start ub2 ub3
for i in ub1 ub2 ub3 ; do
    multipass exec $i -- sudo apt update
    multipass exec $i -- sudo apt upgrade -y --no-install-recommends
    multipass exec $i -- sudo apt install screen git universal-ctags silversearcher-ag wireguard
    multipass exec $i -- sudo apt auto-remove
    # multipass exec $i -- sudo timedatectl set-timezone America/Vancouver
    multipass exec $i -- sudo reboot
done
```
