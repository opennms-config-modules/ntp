#!/bin/bash
# 
# License: GPLv3
# --------------
#
# Script to monitor ntp statistics with Net-SNMP and extend directive
# Part of the OpenNMS NTP monitoring configuration package from
# 
#   git clone git@gitorious.org:opennms-snmp-extend/ntp-monitoring.git
# 
# Issues:
# -------
# Requires three fork() for each metric. ntpq -pn, grep and awk
#
# created: 02/13/2012 <ronny@opennms.org> 02/13/2012
# fix:     02/15/2012 F.Bartnitzki removed forks for sed, calculate time in awk
#
# Preferred directory: /usr/local/bin
# --
#
# Uncomment for debug
# set -x  

NTP_CMD="/usr/bin/ntpq"
NTP_OPT="-pn"

if [ ! -f ${NTP_CMD} ]; then
  echo "Required command ${NTP_CMD} not found." 1>&2
  exit 1
fi

if [ $# -eq 0 ]; then
	echo "Usage: $0 <delay | offset | jitter>"
	echo ""
	echo "OpenNMS - http://www.opennms.org"
	exit 1
fi

RESULT=`${NTP_CMD} ${NTP_OPT} | grep \*`
if [ ! $? -eq 0 ]; then
    echo "No primary ntp server found"
    exit 1
fi

while [ $# -gt 0 ]; do
  case "$1" in
    "delay")
        echo ${RESULT} | awk {'print $8 * 1000'}
        exit 0
        ;;
    "offset")
        echo ${RESULT} | awk {'print $9 * 1000'}
        exit 0
        ;;
    "jitter")
        echo ${RESULT} | awk {'print $10 * 1000'}
        exit 0
        ;;
    *)
        echo "Usage: $0 <delay | offset | jitter>"
        echo ""
        echo "OpenNMS - http://www.opennms.org"
        exit 1
        ;;
  esac
done
# EOF
