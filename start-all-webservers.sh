#!/bin/bash

# Check if the number of arguments is correct
if [ $# -ne 1 ]; then
  echo "Usage: $0 <number_of_servers>"
  exit 1
fi

number_of_servers=$1

# Function to create and start containers
create_containers() {
  local region=$1
  local workdir=$2
  local network=$3
  local subnet=$4

  # Print debugging information
  echo "Working directory: $workdir"
  echo "Number of servers to create: $number_of_servers"
  echo "Region: $region"
  echo "Network: $network"
  echo "Subnet: $subnet"

  for (( counter=1; counter<=$number_of_servers; counter++ ))
  do
    ipaddr=$(($counter+30))

    # Print current counter and IP address
    echo "Creating directory for ${region}websrv$counter"
    echo "IP Address: $subnet.$ipaddr"

    # Create the directory and check for errors
    dir_path="$workdir/${region}websrv$counter"
    mkdir -p $dir_path
    if [ $? -ne 0 ]; then
      echo "Failed to create directory $dir_path"
      exit 1
    fi

    # Copy the files and check for errors
    cp $workdir/container-files/* $dir_path
    if [ $? -ne 0 ]; then
      echo "Failed to copy files to $dir_path"
      exit 1
    fi

    # Modify index.html and check for errors
    index_file="$dir_path/index.html"
    sed -i "s/srvname/ Server Name: ${region}websrv$counter /g" $index_file
    if [ $? -ne 0 ]; then
      echo "Failed to modify $index_file for srvname"
      exit 1
    fi

    sed -i "s/ipaddr/ IP Address: $subnet.$ipaddr /g" $index_file
    if [ $? -ne 0 ]; then
      echo "Failed to modify $index_file for ipaddr"
      exit 1
    fi

    echo "Starting web server $counter at $subnet.$ipaddr"

    # Run the Docker container and check for errors
    docker run -dit \
      --net $network \
      --ip $subnet.$ipaddr \
      --name ${region}websrv$counter \
      --restart=always \
      -p 80 \
      -v $dir_path:/usr/local/apache2/htdocs/ \
      httpd:2.4 >/dev/null 2>&1
    
    if [ $? -ne 0 ]; then
      echo "Failed to start Docker container ${region}websrv$counter"
      exit 1
    fi

    sleep 1
  done
}

# Create and start DEN containers
create_containers "DEN" "$HOME/docker/adc-webservers-DEN" "vlan70" "192.168.27"

# Create and start SoCal containers
create_containers "SoCal" "$HOME/docker/adc-webservers-SoCal" "vlan82" "192.168.83"

# List running Docker containers
docker ps
