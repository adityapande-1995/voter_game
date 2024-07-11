#!/bin/bash

# Backend server URL
URL="http://localhost:8080/vote"

# Possible directions to vote for
DIRECTIONS=("up" "down" "left" "right")

# Function to send a vote
send_vote() {
    local direction=$1
    curl -X POST $URL -d "{\"direction\": \"$direction\"}" -H "Content-Type: application/json" >/dev/null 2>&1
}

# Number of clients to simulate
NUM_CLIENTS=10

# Function to simulate a client
simulate_client() {
    while true; do
        local random_direction=${DIRECTIONS[$RANDOM % ${#DIRECTIONS[@]}]}
        send_vote $random_direction
        sleep $(echo "scale=2; $RANDOM/32767" | bc) # Random sleep between 0 and 1 second
    done
}

# Start the clients
for ((i=0; i<NUM_CLIENTS; i++)); do
    simulate_client &
done

# Trap CTRL+C and kill all child processes
trap "pkill -P $$; exit 1" SIGINT

# Keep the script running
wait
