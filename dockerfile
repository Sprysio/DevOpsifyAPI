FROM golang:1.24 AS build

ARG CGO_ENABLED=0

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o myapp .

FROM alpine:latest

WORKDIR /app

COPY --from=build /app/myapp .

RUN apk --no-cache add ca-certificates tzdata

ENTRYPOINT ["/app/myapp"]