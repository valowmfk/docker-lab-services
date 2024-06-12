#!/bin/bash
websrvs=$(find . -type d -name "SoCalwebsrv*" | wc -l)
workdir="/home/mklouda/adc-webservers-SoCal"
for (( counter=1; counter<=$websrvs; counter++ ))
do
  echo "Stopping and removing web server$counter"
  docker stop SoCalwebsrv$counter >/dev/null 2>&1
  docker rm SoCalwebsrv$counter   >/dev/null 2>&1
  rm -R $workdir/SoCalwebsrv$counter
  # sleep 1
done
docker ps -a
