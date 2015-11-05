#!/bin/bash

# backup location
directory=/external/backup
mkdir -p $directory
cd $directory

# generate private/public key-pair
#   important: remember passphrase
#gpg --gen-key

# copy public keyfile with value used for "USER-ID"
#gpg --export -a "USER-ID" > public.key
#gpg --import public.key

# archive
cd /
mark=`date '+%Y_%m_%d-%H_%M_%S'`;
tar --exclude='./external' -czf - / | gpg --encrypt --quiet --recipient 'USER-ID' > $directory/"$mark".tar.gz.gpg

# extract
#   import key
#gpg --import backup.key
#gpg --no-use-agent --passphrase= --output temp.tar.gz --decrypt "$mark".tar.gz.gpg