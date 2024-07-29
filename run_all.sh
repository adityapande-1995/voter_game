#!/bin/bash

# Function to build Docker images
build_images() {
    echo "Building Docker images..."
    docker compose build
}

# Function to start the containers
start_containers() {
    echo "Starting containers..."
    docker compose up -d
    sleep 5
    xdg-open http://localhost:3000
}

# Function to stop all running processes and containers
stop_all() {
    echo "Stopping all processes and containers..."
    docker compose down
    exit 0
}

# Trap CTRL+C to stop all processes and containers
trap stop_all SIGINT

# Ensure Docker daemon is running
if ! pgrep -x "dockerd" > /dev/null; then
    echo "Docker daemon is not running. Starting it..."
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Build Docker images
build_images

# Start all containers
start_containers

# Follow logs of all services in the background
docker compose logs -f backend frontend leaderboard bot &

# Wait indefinitely to keep script running
wait