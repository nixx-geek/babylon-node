# Babylon Node Deployment Guide

This guide provides detailed instructions on how to set up and run a Babylon blockchain node using Docker. Below you'll find information on configuring your environment, building the Docker image, initializing your node, and starting the node.

## Prerequisites

Before starting, ensure you edit the `.env` file with appropriate values according to your setup needs.

## Variables in `.env` File

### `DAEMON_HOME`

- **Description**: The location within the Docker container where the Cosmovisor directory is kept. This directory contains the genesis binary, upgrade binaries, and any additional auxiliary files associated with each binary.
- **Example**: `/root/.babylond`

### `BABYLON_DATA_HOST_PATH`

- **Description**: The location on the host machine where blockchain data and configuration are persisted. This can be a local filesystem path or a Docker volume, mounted through Docker Compose.
- **Example**: `/persistent/host/path/.data/`

### `MONIKER`

- **Description**: A unique name or identifier that a node operator assigns to their node on the blockchain network.
- **Example**: `my-babylon-node`

### `DAEMON_NAME`

- **Description**: The name of the binary itself. This is the executable that will run the blockchain node.
- **Example**: `babylond`

## Building the Docker Image

To build the Docker image for your node, use the following command, specifying the Babylon version you wish to build:

```bash
export VERSION=v0.8.5
docker build --build-arg BABYLON_VERSION=$VERSION -t babylon-full-node:$VERSION .
```

## Initializing the Node Directory

To initialize the node directory with the required configuration and data files, run the following command:

```bash
source .env
docker run --rm --name babylon-init -v $BABYLON_DATA_HOST_PATH:$DAEMON_HOME --env-file .env babylon-full-node:v0.8.5 /init.sh
```

## Post-Initialization

After initializing the node, the configuration files will be located in `$BABYLON_DATA_HOST_PATH/config`. You must edit these configuration files according to your network and operational requirements. Make sure to follow the guides provided below for detailed instructions on configuring your node:

- [Adding Peers and Modifying Configuration](https://docs.babylonchain.io/docs/user-guides/btc-staking-testnet/setup-node#2-add-peers-and-modify-configuration)
- [Getting Testnet Tokens](https://docs.babylonchain.io/docs/user-guides/btc-staking-testnet/getting-funds)
- [Becoming a Validator](https://docs.babylonchain.io/docs/user-guides/btc-staking-testnet/become-validator)

## Running Your Node

To start your node, use the following Docker Compose command:

```bash
docker-compose up -d
```

## Monitoring and Management

### Logs

To view real-time logs for your node, execute:

```bash
docker-compose logs -f babylon-node
```

## Accessing the Container Shell

To access the shell of your node for further configuration or management, use the following command:

```bash
docker-compose exec babylon-node bash
```

## Conclusion

This guide covers the initial setup, configuration, and management of a Babylon node using Docker.
For further information and troubleshooting, refer to the [official Babylon documentation](https://docs.babylonchain.io/).
