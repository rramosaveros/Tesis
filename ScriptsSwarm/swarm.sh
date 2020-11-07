#!/bin/bash 

# Crear los 6 nodos 
echo "Creando nodos "
for num in {1..3} ; do
    docker-machine create -d virtualbox manager$num
done

for num in {1..3} ; do 
    docker-machine create -d virtualbox worker$num
done 

# Obtener IP del nodo lider
leader_ip=$(docker-machine ip manager1)

# Inicializar docker swarm
echo "Inicializando swarm "
eval $(docker-machine env manager1)
docker swarm init --advertise-addr $leader_ip

# Swarm tokens
manager_token=$(docker swarm join-token manager -q)
worker_token=$(docker swarm join-token worker -q)

# Unir nodos manager al swarm
echo "Uniendo nodos manager al swarm "
for num in {2..3} ; do
    eval $(docker-machine env manager$num)
    docker swarm join --token $manager_token $leader_ip:2377
done

# Unir nodos worker al swarm 
echo "Uniendo nodos worker al swarm "
for num in {1..3} ; do
    eval $(docker-machine env worker$num)
    docker swarm join --token $worker_token $leader_ip:2377
done

# Salir del ambiente del manager
echo "Limpiando ambiente docker client "
eval $(docker-machine env -u)
