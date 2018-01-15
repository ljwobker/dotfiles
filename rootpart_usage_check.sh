#!/bin/bash

# this gets the amount of available space on the root filesystem.
# if it's less than a configured value, we send a nastygram.

TO_WHOM=ljwobker@pobox.com
DF_OUTPUT=$(df -m --output=used,avail /)                ## in MEGABYTES.  ;-)
WARN_LIMIT=20000
CRIT_LIMIT=5000
HOST=$(hostname)
ROOT_USAGE=$(echo $DF_OUTPUT | cut -f4 -d' ')

# echo "current disk usage is $ROOT_USAGE"




if    ((ROOT_USAGE > WARN_LIMIT)); then
        # above warning level
        exit 0 
elif  ((ROOT_USAGE < WARN_LIMIT)); then 
        # below warning level
        echo "$DF_OUTPUT" | mail -s "WARNING: root partition disk space low on $HOST" $TO_WHOM
        exit 1 
elif  ((ROOT_USAGE < CRIT_LIMIT)); then
        # below critical level
        echo "$DF_OUTPUT" | mail -s "-- CRITICAL -- : root partition disk space low on $HOST -- CRITICAL " $TO_WHOM
        exit 2
fi 


