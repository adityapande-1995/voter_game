# Use the official Golang image to create a build artifact.
FROM golang:1.16-alpine AS build

WORKDIR /app

COPY . .

RUN go build -o backend main.go

# Use the official Golang image to run the backend.
FROM golang:1.16-alpine

WORKDIR /app

COPY --from=build /app/backend /app/backend

EXPOSE 8080

CMD ["./backend"]

