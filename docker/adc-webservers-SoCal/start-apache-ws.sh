#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Please specify the number of web servers you would like to create..."
  exit 1
fi
workdir="/home/mklouda/adc-webservers-SoCal"
for (( counter=1; counter<=$1; counter++ ))
do
  ipaddr=$(($counter+30))
  # echo $ipaddr
  mkdir $workdir/SoCalwebsrv$counter
  cp $workdir/container-files/* $workdir/SoCalwebsrv$counter
  sed -i "s/srvname/ Server Name: SoCalwebsrv$counter /g" $workdir/SoCalwebsrv$counter/index.html
  sed -i "s/ipaddr/ IP Address: 192.168.83.$ipaddr /g" $workdir/SoCalwebsrv$counter/index.html
  echo "Starting web server$counter at 192.168.83.$ipaddr"
  docker run -dit --net vlan82 --ip 192.168.83.$ipaddr --name SoCalwebsrv$counter -p 80 -v $workdir/SoCalwebsrv$counter:/usr/local/apache2/htdocs/ httpd:2.4 >/dev/null 2>&1
  sleep 1
done
docker ps