# docker-lab-services
HTTP and DNS/GSLB Lab Services Inside Docker - A10 Networks

Scripts assume you're running them from the ~/ directory.

Working directories should be updated to reflect changes you make locally, but they assume ~/docker then a sub directory.

docker networks are required. The host this runs on has multiple interfaces in VMware, one for each subnet/vlan. You will need to create a docker network for each. Example:
docker network create -d ipvlan --subnet 192.168.83.0/24 --gateway 192.168.83.1 -o parent=ens193 vlan82
There is IPv6 Support in the docker network create command, but not used here.

Scripts will need to be modified for your local env.

To start and stop GSLB DNS respectively, just run ./gslb-start.sh or gslb-stop.sh
Web servers require a number, but will start the number for each site (DEN and SoCal, in my example).
./start-all-webservers.sh 5 (Starts 5 web servers in each site, with corresponding IPs)
./stop-all-webservers.sh stops all running servers/containers.
