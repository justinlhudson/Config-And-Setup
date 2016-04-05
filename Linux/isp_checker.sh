#!/bin/bash

#ISP_Checker.sh <trace address> <hops> <check> <mail address>
# Notes:
  #apt-get install -f mailutils
  #mail -s "Test Text" "test@SomeDomain.com,#@messaging.sprintpcs.com"

_mail="$4"
_check="$3"
_file="/tmp/ISP-Checker-$_check"
_result=$(traceroute $1 -m $2)

_status=$ISP_Checker

echo $_result
echo

if [[ "$_result" == *"* * *"* ]]; then
  echo "error!"
  exit
fi

if [[ ! "$_result" == *"$_check"* ]]; then
  echo "ISP-Down: $_check"
  if [[ $_status == "UP" ]]; then
    _status="DOWN"
    echo "alert!"
    echo $_check | mail -s "ISP-Down: $_check" $_mail < /dev/null
  fi
else
  echo "ISP-UP: $_check"
  if [[ $_status == "DOWN" ]]; then
    _status="UP"
    echo "alert!"
    echo $_check | mail -s "ISP-Up: $_check" $_mail < /dev/null
  fi
fi

export ISP_Checker=$_status