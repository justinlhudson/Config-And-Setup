#!/bin/bash

# Configure
_directory="/path/to/storage/directory"
_user="USER-ID"

# backup location
mkdir -p $_directory
cd $directory

# generate private/public key-pair
#   important: remember passphrase
#gpg --gen-key

# copy public keyfile with value used for "USER-ID"
#gpg --export -a "$_user" > public.key
#gpg --import public.key

# archive
_mark=`date '+%Y_%m_%d-%H_%M_%S'`;
# https://help.ubuntu.com/community/BackupYourSystem/TAR
# Note: -h to follow smbolic lnks
tar --exclude='$_directory/..' --exclude='*.ecryptfs/*' --exclude='/ram' --exclude='/tmp' --exclude='/proc' --exclude='/sys' --exclude='/mnt' --exclude='/media' --exclude='/run' --exclude='/dev' --exclude='/proc' --exclude='/sys' -czf - / | gpg --encrypt --quiet --recipient $_user > $_directory/"$_mark".tar.gz.gpg

# extract
#   import key
#gpg --import backup.key
#gpg --no-use-agent --passphrase= --output temp.tar.gz --decrypt "$_mark".tar.gz.gpg

# keep current and prevous
cd $_directory
ls -1tr | head -n -2 | xargs -d '\n' rm -f