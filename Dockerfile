# Stage 1: Build the babylond binary
FROM golang:1.21 AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y git build-essential curl jq

# Download and unpack the Babylon source
ARG BABYLON_VERSION=v0.8.5
RUN curl -L https://github.com/babylonchain/babylon/archive/refs/tags/${BABYLON_VERSION}.tar.gz | tar xz --strip-components=1

# Build the babylond binary
RUN make install

# Stage 2: Setup the node
FROM golang:1.21 AS runtime

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y curl jq wget bzr libltdl7 bzip2 && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV LD_LIBRARY_PATH=/usr/local/lib

# Copy the babylond binary from the builder stage
COPY --from=builder /go/bin/babylond /usr/bin/babylond

# Copy the library file from the builder stage
COPY --from=builder /go/pkg/mod/github.com/!cosm!wasm/wasmvm@v1.5.2/internal/api/libwasmvm.x86_64.so /usr/local/lib/

# Install Cosmovisor
RUN go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest

# Copy the init script into the image
COPY init.sh /init.sh
RUN chmod +x /init.sh

# Set up the command to run the node using Cosmovisor
CMD ["cosmovisor", "run", "start"]
