#!/bin/bash

# Function to build Docker image for backend
build_backend_image() {
    echo "Building backend Docker image..."
    docker compose build
}

# Function to start the backend container
start_backend() {
    echo "Starting backend container..."
    docker compose up -d
}

# Function to start the leaderboard server
start_leaderboard() {
    echo "Starting leaderboard server..."
    cd leaderboard
    go run main.go &
    LEADERBOARD_PID=$!
    cd ..
}

# Function to start the frontend server
start_frontend() {
    echo "Starting frontend server..."
    cd game-frontend
    npm start &
    FRONTEND_PID=$!
    cd ..
    sleep 5 # Give the frontend some time to start
}

# Function to start the spam voting script
start_spam_script() {
    echo "Starting spam voting script..."
    ./bot_players/spam_votes.sh &
    SPAM_PID=$!
}

# Function to stop all running processes and containers
stop_all() {
    echo "Stopping all processes and containers..."
    docker compose down
    kill $LEADERBOARD_PID
    kill $FRONTEND_PID
    kill $SPAM_PID
    exit 0
}

# Trap CTRL+C to stop all processes and containers
trap stop_all SIGINT

# Build Docker image for backend
build_backend_image

# Start all services
start_backend
# Follow backend logs in the background
docker compose logs -f backend &

start_leaderboard
start_frontend
start_spam_script

# Wait indefinitely to keep script running
wait

