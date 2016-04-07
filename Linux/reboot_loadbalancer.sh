#!/bin/bash

_host=$1
_port=23
_username=$2
_password=$3

( echo open ${_host} ${_port}
  sleep 1
  echo ${_username}
  sleep 1
  echo -e "\r"
  sleep 1
  echo ${_password}
  sleep 1
  echo -e "\r"
  sleep 3
  echo "enable"
  sleep 1
  echo -e "\r"
  sleep 1
  echo "admin"
  sleep 1
  echo -e "\r"
  sleep 3
  echo "sys reboot"
  sleep 1
  echo -e "\r"
  sleep 1
  echo -e "y\r"
  sleep 1
  echo exit ) | telnet
