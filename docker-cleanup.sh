#!/usr/bin/bash

echo "Cleaning up unused Docker resources..."


echo "Removing stopped containers..."
docker container prune -f


echo "Removing unused images..."
docker image prune -a -f

echo "Removing unused networks..."
docker network prune -f

echo "Removing unused volumes..."
docker volume prune -f

echo "Docker cleanup completed."
