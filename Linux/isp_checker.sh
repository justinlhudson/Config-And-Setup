#!/bin/bash

#ISP_Checker.sh <trace address> <hops> <check>

_directory=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
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
  if [ ! -f $_file ] || [[ $@ == *-f* ]] ; then
    touch $_file
    if [ -f $_directory/isp_down.sh ]; then
      $_directory/isp_down.sh
    fi

    if [ -f $_directory/loadbalancer.sh ]; then
      $_directory/loadbalancer.sh -r <ip> <username> <password>
    fi

    echo "-  $(Date) \a" >> /tmp/isp_status
  fi
else
  echo "ISP-UP: $_check"
  if [ -f $_file ]; then
    rm -f $_file
    if [ -f $_directory/isp_up.sh ]; then
      $_directory/isp_up.sh
    fi

    echo "+  $(Date) " >> /tmp/isp_status
  fi
fi
