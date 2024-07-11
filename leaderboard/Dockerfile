FROM golang:1.16-alpine

WORKDIR /app

COPY . .

RUN go build -o leaderboard main.go

EXPOSE 8081

CMD ["./leaderboard"]
