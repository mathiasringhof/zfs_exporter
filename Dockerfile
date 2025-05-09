# ──────────────── 1. Build the binary ────────────────
FROM golang:1.20-alpine AS builder

# Turn the resulting binary into a fully-static executable
ENV CGO_ENABLED=0 \
    GOOS=linux

# Grab build dependencies
RUN apk add --no-cache git

# Build the requested version (default = latest)
ARG ZFS_EXPORTER_VERSION=latest
RUN go install github.com/pdf/zfs_exporter@${ZFS_EXPORTER_VERSION}

# ──────────────── 2. Minimal runtime image ────────────────
FROM alpine:latest

# Optional: libraries / utilities you need at runtime
RUN apk add --no-cache zfs

# Copy the binary produced in the first stage
COPY --from=builder /go/bin/zfs_exporter /usr/local/bin/zfs_exporter

EXPOSE 9134
ENTRYPOINT ["/usr/local/bin/zfs_exporter"]
