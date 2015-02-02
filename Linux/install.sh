#!/bin/bash

if [ `whoami` != root ]; then
    echo Please run this script as root or using sudo
    exit
fi

apt-get install silversearcher-ag expect install gdisk htop ssh vsftpd samba vim filezilla nautilus-dropbox bind9 
# apt-get install jump 

