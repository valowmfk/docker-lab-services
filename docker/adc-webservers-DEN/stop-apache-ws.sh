#!/bin/bash
websrvs=$(find . -type d -name "DENwebsrv*" | wc -l)
workdir="/home/mklouda/adc-webservers-DEN"
for (( counter=1; counter<=$websrvs; counter++ ))
do
  echo "Stopping and removing web server$counter"
  docker stop DENwebsrv$counter >/dev/null 2>&1
  docker rm DENwebsrv$counter   >/dev/null 2>&1
  rm -R $workdir/DENwebsrv$counter
  # sleep 1
done
docker ps -a
