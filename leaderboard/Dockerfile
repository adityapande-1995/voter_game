# Use the official Golang image to create a build artifact
FROM golang:1.16-alpine AS build

WORKDIR /app

COPY . .

RUN go build -o leaderboard main.go

# Use the official Golang image to run the leaderboard
FROM golang:1.16-alpine

WORKDIR /app

COPY --from=build /app/leaderboard /app/leaderboard

EXPOSE 8081

CMD ["./leaderboard"]

