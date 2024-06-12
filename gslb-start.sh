#!/bin/bash

workdir="$HOME/docker/gslb-den-socal"

# Start DEN-bind9 Server
site="DEN-bind9"
echo "Starting $site Server..."
docker run \
        -dit \
        --net vlan50 \
        --ip 192.168.50.53  \
        --name=$site \
        --restart=always \
        --publish 53:53/udp \
        --publish 53:53/tcp \
        --publish 127.0.0.1:953:953/tcp \
        --volume $workdir/containerfiles/$site:/tmp \
        internetsystemsconsortium/bind9:9.18

# docker exec $site cp /tmp/named.conf.local /etc/bind/
# docker exec $site cp /tmp/db.example.com /etc/bind/
# docker exec $site cp /tmp/named.conf.options /etc/bind/
docker exec $site cp /tmp/named.conf.local /etc/bind/
docker exec $site cp /tmp/db.a10.klouda.lab /etc/bind/
docker exec $site cp /tmp/named.conf.options /etc/bind/
docker exec $site service named restart >/dev/null 2>&1

# Start SoCal-bind9 Server
site="SoCal-bind9"
echo "Starting $site Server..."
docker run \
        -dit \
        --net vlan60 \
        --ip 192.168.60.53  \
        --name=$site \
        --restart=always \
        --publish 53:53/udp \
        --publish 53:53/tcp \
        --publish 127.0.0.1:953:953/tcp \
        --volume $workdir/containerfiles/$site:/tmp \
        internetsystemsconsortium/bind9:9.18

# docker exec $site cp /tmp/named.conf.local /etc/bind/
# docker exec $site cp /tmp/db.example.com /etc/bind/
# docker exec $site cp /tmp/named.conf.options /etc/bind/
docker exec $site cp /tmp/named.conf.local /etc/bind/
docker exec $site cp /tmp/db.a10.klouda.lab /etc/bind/
docker exec $site cp /tmp/named.conf.options /etc/bind/
docker exec $site service named restart >/dev/null 2>&1
docker ps