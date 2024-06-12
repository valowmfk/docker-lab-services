#!/bin/bash

# Function to stop and remove containers
cleanup_containers() {
  local prefix=$1
  local containers=$(docker ps -a -q --filter "name=${prefix}")

  if [ -z "$containers" ]; then
    echo "No containers found with prefix $prefix"
  else
    echo "Stopping and removing containers with prefix $prefix"
    docker stop $containers
    docker rm $containers
  fi
}

# Function to delete directories
cleanup_directories() {
  local workdir=$1
  local prefix=$2

  echo "Deleting directories with prefix $prefix in $workdir"
  find $workdir -type d -name "${prefix}*" -exec rm -rf {} +
}

# Cleanup DENwebsrv containers and directories
DEN_workdir="$HOME/docker/adc-webservers-DEN"
cleanup_containers "DENwebsrv"
cleanup_directories $DEN_workdir "DENwebsrv"

# Cleanup SoCalwebsrv containers and directories
SoCal_workdir="$HOME/docker/adc-webservers-SoCal"
cleanup_containers "SoCalwebsrv"
cleanup_directories $SoCal_workdir "SoCalwebsrv"

# List running Docker containers to verify cleanup
docker ps -a
