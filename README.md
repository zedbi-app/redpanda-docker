# redpanda-docker

Custom Docker image of [Redpanda](https://github.com/redpanda-data/redpanda) packaged for Railway deployments.

## Why

The official Redpanda image expects a multi-flag CLI invocation like:

```
redpanda start --kafka-addr=... --advertise-kafka-addr=... --smp=...
```

Railway Runtime V2 injects each `REDPANDA_*` variable as a single argument to the default command, which fails because the image does not parse flags that way. This image ships a thin `entrypoint.sh` that reads Railway-friendly environment variables and constructs the full `redpanda start` command at container start.

## Configuration

| Variable | Default | Description |
| --- | --- | --- |
| `RP_NODE_ID` | `0` | Cluster node id. |
| `RP_KAFKA_LISTENERS` | `PLAINTEXT://0.0.0.0:9092` | Listeners for the Kafka API. |
| `RP_ADVERTISE_KAFKA_LISTENERS` | `PLAINTEXT://localhost:9092` | Advertised Kafka listeners for clients. |
| `RP_RPC_LISTENERS` | `0.0.0.0:33145` | Listeners for the internal RPC API. |
| `RP_ADVERTISE_RPC_LISTENERS` | `localhost:33145` | Advertised RPC listeners. |
| `RP_SEEDS` | same as advertised RPC | Seed broker list. |
| `RP_SMP` | `1` | Logical cores used by Seastar. |
| `RP_MEMORY` | `1G` | Resident memory budget. |
| `RP_RESERVE_MEMORY` | `0M` | Memory reserved off the budget. |

## Ports

| Port | Purpose |
| --- | --- |
| `9092` | Kafka API |
| `8082` | HTTP Proxy |
| `8081` | Schema Registry |
| `33145` | Internal RPC |
| `9644` | Admin API |
