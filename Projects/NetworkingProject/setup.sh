#!/bin/bash
 docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)&& docker network prune

docker-compose up -d

docker exec application_server apt-get update
docker exec application_server apt-get install -y iproute2 iputils-ping traceroute

docker exec application_server ip route del 10.0.1.0/24

docker exec application_server ip route add 10.0.1.0/24 via 10.0.0.1

#docker exec student_workspace apt-get update
#docker exec student_workspace apt-get install -y iproute2 iputils-ping traceroute