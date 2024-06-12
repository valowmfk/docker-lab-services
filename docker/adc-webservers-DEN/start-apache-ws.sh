#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Please specify the number of web servers you would like to create..."
  exit 1
fi
workdir="/home/mklouda/adc-webservers-DEN"
for (( counter=1; counter<=$1; counter++ ))
do
  ipaddr=$(($counter+30))
  # echo $ipaddr
  mkdir $workdir/DENwebsrv$counter
  cp $workdir/container-files/* $workdir/DENwebsrv$counter
  sed -i "s/srvname/ Server Name: DENwebsrv$counter /g" $workdir/DENwebsrv$counter/index.html
  sed -i "s/ipaddr/ IP Address: 192.168.27.$ipaddr /g" $workdir/DENwebsrv$counter/index.html
  echo "Starting web server$counter at 192.168.27.$ipaddr"
  docker run -dit --net vlan70 --ip 192.168.27.$ipaddr --name DENwebsrv$counter -p 80 -v $workdir/DENwebsrv$counter:/usr/local/apache2/htdocs/ httpd:2.4 >/dev/null 2>&1
  sleep 1
done
docker ps