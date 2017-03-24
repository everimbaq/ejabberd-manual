#!/bin/bash
log_date=`date "+%Y-%m-%d"` 
log_time=`date "+%H:%M:%S"` 
mkdir -p ~/backup/$log_date/$log_time
cp -r /var/log/ejabberd/ ~/backup/$log_date/$log_time
find /var/log/ejabberd/ -name "*.log.*" |xargs rm -f