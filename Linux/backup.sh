#!/bin/bash

## Configure ##
_directory="$2"
_user="$1" #"USER-ID" value given during gpg --gen-key
if [ -z $3 ]; then
  _history=2
else
  _history=$3
fi

# shutdown VMs first if have virtualbox installed
if hash vboxmanage 2>/dev/null; then
  vboxmanage list runningvms | sed -r 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} VBoxManage controlvm {} poweroff soft
fi

_base="/"$(echo "$_directory" | awk -F "/" '{print $2}')

# backup location
#mkdir -p $_directory
cd $_directory

## Backup ##

# generate private/public key-pair
# important: remember passphrase
#gpg --gen-key
# Note:  write down uid given at the end of generation
# ?'s: default, 10y, no passphrase, Real name: hostnam
# Generating...
  # find / | xargs file
  # or just wait...

# copy public keyfile with value used for "USER-ID"
#gpg --export -a "USER-ID" > backup.key
#gpg --import public.key

# archive
_mark=`date '+%Y_%m_%d-%H_%M_%S'`;
# https://help.ubuntu.com/community/BackupYourSystem/TAR
# Note: -h to follow symbolic links
tar --exclude='*.ecryptfs/*' --exclude='/ram' --exclude='/tmp' --exclude='/home' --exclude='/proc' --exclude='/sys' --exclude='/mnt' --exclude='/media' --exclude='/run' --exclude='/dev' --exclude='/proc' --exclude='/sys' -czvf - / | gpg --encrypt --quiet --recipient $_user > "$_mark".tar.gz.gpg

# extract
#   import key
#gpg --import backup.key
#gpg --no-use-agent --passphrase= --output temp.tar.gz --decrypt "$_mark".tar.gz.gpg

## Post ##

# keep current and prevous
cd $_directory
if [[ $(pwd) == $_directory ]]; then
  ls -1tr | head -n -$_history | xargs -d '\n' rm -f
fi

sudo shutdown -r +1 "Backup Complete (rebooting...)"
