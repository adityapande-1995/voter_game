# A simple voting based game.

## Introduction
This is a simple game I wrote to learn about REST APIS, ReactJS, etc. The UI consists of a simple floating square,
which can go up, down, right , or left. The backend receives votes on the direction through the frontend buttons, or
REST API calls. At the end of each second, the votes are tallied, and the direction with the most vote dictates
where the square will move.

## System design
This consists of the following services, that are containerized using docker.
1. *Backend* : Processes votes, and communicates with the leaderboard for the tally so far.
2. *Frontend* : Serves the react based app UI, has buttons to vote for a direction.
3. *Bots* : A bunch of random curl requests to the backend, i.e. mock voting players.
4. *Leaderboard* : Keeps track of the total votes received so far.

## Usage
You should have docker installed. Run the following on the terminal : 
```
./run_all.sh
```

Killing this script using Ctrl + C should stop all the containers.

## TODO
- Add a systematic logging mechanism instead of spamming prints on the console.
- Isolate the network communication so that the host does not need to know what is happening.
