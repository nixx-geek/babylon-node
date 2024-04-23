#!/bin/bash

echo "Checking required environment variables..."
# Define a list of required environment variables
required_vars=("DAEMON_HOME" "MONIKER" "BABYLON_DATA_HOST_PATH" "DAEMON_NAME")

# Loop over required environment variables and check if they are set
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then 
        echo "$var not set. Exiting..."
        exit 1
    fi
done

echo "Initializing the node directory..."
# Initialize the node directory
babylond init $MONIKER --chain-id bbn-test-3

echo "Downloading and preparing the genesis file..."
# Download and prepare the genesis file
wget https://github.com/babylonchain/networks/raw/main/bbn-test-3/genesis.tar.bz2 -O /tmp/genesis.tar.bz2 \
&& tar -xjf /tmp/genesis.tar.bz2 -C $DAEMON_HOME/config \
&& rm /tmp/genesis.tar.bz2

echo "Creating necessary directories and copying the babylond binary..."
# Create necessary directories and copy the babylond binary
mkdir -p $DAEMON_HOME/cosmovisor/genesis/bin
cp /usr/bin/babylond $DAEMON_HOME/cosmovisor/genesis/bin

echo "Initialization complete."
