#!/bin/bash

# Salir client docker
echo "Saliendo cliente docker"
eval $(docker-machine env -u)

# Eliminar nodos
echo "Eliminando nodos "
for num in {1..3} ; do
    docker-machine rm manager$num --force
done

for num in {1..3} ; do 
    docker-machine rm worker$num --force
done 
