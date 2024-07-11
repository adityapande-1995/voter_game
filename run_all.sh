#!/bin/bash

# Function to start the backend server
start_backend() {
    echo "Starting backend server..."
    cd game-backend
    go run main.go &
    BACKEND_PID=$!
    cd ..
}

# Function to start the frontend server
start_frontend() {
    echo "Starting frontend server..."
    cd game-frontend
    npm start &
    FRONTEND_PID=$!
    cd ..
}

# Function to start the spam voting script
start_spam_script() {
    echo "Starting spam voting script..."
    ./spam_votes.sh &
    SPAM_PID=$!
}

# Function to stop all running processes
stop_all() {
    echo "Stopping all processes..."
    kill $BACKEND_PID
    kill $FRONTEND_PID
    kill $SPAM_PID
    exit 0
}

# Trap CTRL+C to stop all processes
trap stop_all SIGINT

# Start all services
start_backend
start_frontend
start_spam_script

# Wait indefinitely to keep script running
wait

