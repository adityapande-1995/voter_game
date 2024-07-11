package main

import (
    "encoding/json"
    "log"
    "net/http"
    "sync"
    "time"
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
    direction string
)

func voteHandler(w http.ResponseWriter, r *http.Request) {
    enableCors(&w)
    var v Vote
    if err := json.NewDecoder(r.Body).Decode(&v); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }
    mutex.Lock()
    voteCounts[v.Direction]++
    mutex.Unlock()
    w.WriteHeader(http.StatusOK)
}

func votesHandler(w http.ResponseWriter, r *http.Request) {
    enableCors(&w)
    mutex.Lock()
    response := struct {
        Direction string         `json:"direction"`
        Votes     map[string]int `json:"votes"`
    }{
        Direction: direction,
        Votes:     voteCounts,
    }
    mutex.Unlock()
    json.NewEncoder(w).Encode(response)
}

func resetVotes() {
    for {
        time.Sleep(1 * time.Second)
        mutex.Lock()
        maxDirection := "up"
        maxCount := 0
        for direction, count := range voteCounts {
            if count > maxCount {
                maxCount = count
                maxDirection = direction
            }
        }
        log.Printf("Votes - Up: %d, Down: %d, Left: %d, Right: %d", voteCounts["up"], voteCounts["down"], voteCounts["left"], voteCounts["right"])
        log.Printf("Majority Direction: %s", maxDirection)
        direction = maxDirection
        for direction := range voteCounts {
            voteCounts[direction] = 0
        }
        mutex.Unlock()
    }
}

func enableCors(w *http.ResponseWriter) {
    (*w).Header().Set("Access-Control-Allow-Origin", "*")
    (*w).Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
    (*w).Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
}

func main() {
    http.HandleFunc("/vote", voteHandler)
    http.HandleFunc("/votes", votesHandler)
    go resetVotes()
    log.Println("Server started at :8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}
