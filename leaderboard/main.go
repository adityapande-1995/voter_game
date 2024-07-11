package main

import (
    "encoding/json"
    "log"
    "net/http"
    "sync"
)

type Vote struct {
    Direction string `json:"direction"`
}

var (
    voteCounts = map[string]int{
        "up":    0,
        "down":  0,
        "left":  0,
        "right": 0,
    }
    mutex sync.Mutex
)

func voteHandler(w http.ResponseWriter, r *http.Request) {
    enableCors(&w)
    var v Vote
    if err := json.NewDecoder(r.Body).Decode(&v); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        log.Printf("Failed to decode vote: %v\n", err)
        return
    }
    mutex.Lock()
    voteCounts[v.Direction]++
    log.Printf("Received vote: %s, Current counts: %v\n", v.Direction, voteCounts)
    mutex.Unlock()
    w.WriteHeader(http.StatusOK)
}

func leaderboardHandler(w http.ResponseWriter, r *http.Request) {
    enableCors(&w)
    mutex.Lock()
    response := struct {
        Votes map[string]int `json:"votes"`
    }{
        Votes: voteCounts,
    }
    mutex.Unlock()
    json.NewEncoder(w).Encode(response)
    log.Printf("Leaderboard state sent: %v\n", voteCounts)
}

func enableCors(w *http.ResponseWriter) {
    (*w).Header().Set("Access-Control-Allow-Origin", "*")
    (*w).Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
    (*w).Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
}

func main() {
    http.HandleFunc("/vote", voteHandler)
    http.HandleFunc("/leaderboard", leaderboardHandler)
    log.Println("Leaderboard server started at :8081")
    log.Fatal(http.ListenAndServe(":8081", nil))
}

