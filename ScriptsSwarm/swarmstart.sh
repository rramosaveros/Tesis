#!/bin/bash
# Iniciar swarm
echo "Iniciando swarm"
for num in {1..3} ; do
    docker-machine start manager1$num
done

for num in {1..3} ; do 
    docker-machine start worker$num
done 

# Salir client docker 
echo "Saliendo Client Docker ."
eval $(docker-machine env -u)
