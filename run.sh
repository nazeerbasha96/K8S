#!/bin/bash
set -e
nohup $TOMCAT_HOME/bin/startup.sh &
exec $@
# $1 is 1st parameter
#$# how many parameter are passed to shellscript
#$@ all parameter passed to shellscript 
# set -e is enable to the exec 
#  exec is used executing a command