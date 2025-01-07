FROM golang:1.17-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o zfs_exporter

FROM alpine:latest
COPY --from=builder /app/zfs_exporter /usr/local/bin/
EXPOSE 9134
ENTRYPOINT ["/usr/local/bin/zfs_exporter"]
