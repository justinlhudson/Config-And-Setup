#!/bin/bash

# Usage: <-r> <host> <username> <password>

_command=$1
_host=$2
_port=23
_username=$3
_password=$4
###
_sleep=3

if [[ $_command == -r ]]; then
  ( echo open ${_host} ${_port}
    sleep ${_sleep}
    echo ${_username}
    echo -e "\r"
    sleep ${_sleep}
    echo ${_password}
    echo -e "\r"
    sleep ${_sleep}
    echo -e "enable\r"
    sleep ${_sleep}
    echo -e "admin\r"
    sleep ${_sleep}
    echo -e "sys reboot\r"
    sleep ${_sleep}
    echo -e "y\r"
    sleep ${_sleep}
    echo "exit\r" ) | telnet
fi
