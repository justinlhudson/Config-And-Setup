#!/bin/bash

#ISP_Checker.sh <trace address> <hops> <check> <mail address>
# Notes:
  #apt-get install -f mailutils
  #mail -s "Test Text" "test@SomeDomain.com,#@messaging.sprintpcs.com"

_directory=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
_mail="$4"
_check="$3"
_file="/tmp/ISP-Checker-$_check"
_result=$(traceroute $1 -m $2)

echo $_result
echo

if [[ "$_result" == *"* * *"* ]]; then
  echo "error!"
  exit
fi

if [[ ! "$_result" == *"$_check"* ]]; then
  echo "ISP-Down: $_check"
  if [ ! -f $_file ]; then
    touch $_file
    if [ -f $_directory/isp_down.sh ]; then
      $_directory/isp_down.sh
    fi
    if [-f $_directory/reboot_loadbalancer.sh ]; then
      $_directory/reboot_loadbalancer.sh <ip> <user> <pass>
    fi
    echo "alert!"
    echo $_check | mailx -s "ISP-Down: $_check" $_mail < /dev/null
  fi
else
  echo "ISP-UP: $_check"
  if [ -f $_file ]; then
    rm -f $_file
    if [ -f $_directory/isp_up.sh ]; then
      $_directory/isp_up.sh
    fi
    echo "alert!"
    echo $_check | mailx -s "ISP-Up: $_check" $_mail < /dev/null
  fi
fi
