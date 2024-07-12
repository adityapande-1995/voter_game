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
    xdg-open http://localhost:3000
}

# Function to start the spam voting script
start_spam_script() {
    echo "Starting spam voting script..."
    if [ -f "./bot_players/spam_votes.sh" ]; then
        cd bot_players
        ./spam_votes.sh &
        SPAM_PID=$!
        cd ..
    else
        echo "spam_votes.sh not found!"
        exit 1
    fi
}

# Function to stop all running processes and containers
stop_all() {
    echo "Stopping all processes and containers..."
    docker compose down
    if [ -n "$SPAM_PID" ] && kill -0 $SPAM_PID 2>/dev/null; then
        kill $SPAM_PID
    fi
    exit 0
}

# Trap CTRL+C to stop all processes and containers
trap stop_all SIGINT

# Build Docker images
build_images

# Start all containers
start_containers

# Follow backend, frontend, and leaderboard logs in the background
docker compose logs -f backend frontend leaderboard &

start_spam_script

# Wait indefinitely to keep script running
wait

