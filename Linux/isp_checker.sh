#!/bin/bash

#ISP_Checker.sh <trace address> <hops> <check> <mail address>
# Notes:
  #apt-get install -f mailutils
  #mail -s "Test Text" "test@SomeDomain.com,#@messaging.sprintpcs.com"

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
    echo "alert!"
    echo $_check | mail -s "ISP-Down: $_check" $_mail < /dev/null
  fi
else
  echo "ISP-UP: $_check"
  if [ -f $_file ]; then
    rm -f $_file
    echo "alert!"
    echo $_check | xmail -s "ISP-Up: $_check" $_mail < /dev/null
  fi
fi