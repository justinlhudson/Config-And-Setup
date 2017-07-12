#!/bin/bash

## Setup 
# chown root:<user>, chmod 775, crontab: @weekly /usr/bin/sudo /opt/backup.sh <USER-ID> /<path>/backup
## Note
# Run as normal user with sudo permissions

## Configure ##
_directory="$2"
_user="$1" # "USER-ID" value given during gpg --gen-key (i.e. hostname, per directions below)
if [ -z $3 ]; then
  _history=3
else
  _history=$3
fi

for _vm in `VBoxManage list runningvms|cut -d" " -f 1`; do
  vboxmanage controlvm $_vm poweroff soft
done
sleep 60
# HARD shutdown VMs
sudo pkill VirtualBox || true

_base="/"$(echo "$_directory" | awk -F "/" '{print $2}')

# backup location
#mkdir -p $_directory
cd $_directory

## Backup ##

## Generate private/public key-pair
# Important: remember passphrase
# gpg --gen-key
## ?'s: default, default, 10y, no passphrase, Real name: hostname
## Generating...
  # find / | xargs file
  ## or just wait...

## copy public keyfile with value used for "USER-ID"
# gpg --export -a <USER-ID> > ~/backup.key
# gpg --import backup.key

## archive
_mark=`date '+%Y_%m_%d-%H_%M_%S'`;
## https://help.ubuntu.com/community/BackupYourSystem/TAR
## Note: -h to follow symbolic links
sudo tar --exclude="$_directory" --exclude='*.ecryptfs/*' --exclude='/tmp' --exclude='/proc' --exclude='/sys' --exclude='/media' --exclude='/run' --exclude='/dev' --exclude='/proc' --exclude='/sys' -zcvpf - / | sudo gpg --encrypt --quiet --recipient $_user > "$_mark".tar.gz.gpg

## extract
##   import key
#gpg --import backup.key
#gpg --no-use-agent --passphrase= --output temp.tar.gz --decrypt "$_mark".tar.gz.gpg
#tar xvzf --no-same-permissions temp.tar.gz --directory /tmp/temp

## Post ##

# keep current and prevous
cd $_directory
if [[ $(pwd) == $_directory ]]; then
  ls -1tr | head -n -$_history | xargs -d '\n' sudo rm -f
fi

sudo shutdown -r +5 "Backup Complete (rebooting...)"
