FROM golang:1.20-alpine AS builder

RUN apk add --no-cache git make

WORKDIR /app
COPY go.* ./
RUN go mod download
COPY . .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o zfs_exporter

FROM alpine:latest

RUN apk add --no-cache zfs

COPY --from=builder /app/zfs_exporter /usr/local/bin/

EXPOSE 9134

ENTRYPOINT ["/usr/local/bin/zfs_exporter"]
