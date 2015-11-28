#!/bin/bash

#ISP_Checker.sh <trace address> <hops> <check> <mail address>

# Notes:
  #apt-get install -f mailutils
  #mail -s "Test Text" "test@SomeDomain.com,#@messaging.sprintpcs.com"

_mail="$4"
_check="$3"
_file="/tmp/ISP-Checker-$_check"
_result=$(traceroute $1 -m $2 -F)

echo $_result
echo

if [[ ! $_result = *$_check* ]]; then
  echo "ISP-Down: $_check"
  if [ ! -f $_file ]; then  
    echo "alert!"
    touch $_file
    echo $_check | mail -s "ISP-Down: $_check" $_mail < /dev/null
  fi
else
  echo "ISP-UP: $_check"
  if [ -f $_file ]; then
    echo "alert!"
    rm -f $_file
    echo $_check | mail -s "ISP-Up: $_check" $_mail < /dev/null
  fi
fi
