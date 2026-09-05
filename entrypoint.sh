#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${RP_NODE_ID:-}" ]]; then
  export RP_NODE_ID=0
fi

if [[ -z "${RP_KAFKA_LISTENERS:-}" ]]; then
  export RP_KAFKA_LISTENERS="PLAINTEXT://0.0.0.0:9092,EXTERNAL://0.0.0.0:19092"
fi

if [[ -z "${RP_ADVERTISE_KAFKA_LISTENERS:-}" ]]; then
  export RP_ADVERTISE_KAFKA_LISTENERS="PLAINTEXT://localhost:9092"
fi

if [[ -z "${RP_RPC_LISTENERS:-}" ]]; then
  export RP_RPC_LISTENERS="0.0.0.0:33145"
fi

if [[ -z "${RP_ADVERTISE_RPC_LISTENERS:-}" ]]; then
  export RP_ADVERTISE_RPC_LISTENERS="localhost:33145"
fi

if [[ -z "${RP_SEEDS:-}" ]]; then
  export RP_SEEDS="${RP_ADVERTISE_RPC_LISTENERS}"
fi

if [[ -z "${RP_SMP:-}" ]]; then
  export RP_SMP=1
fi

if [[ -z "${RP_MEMORY:-}" ]]; then
  export RP_MEMORY="1G"
fi

if [[ -z "${RP_RESERVE_MEMORY:-}" ]]; then
  export RP_RESERVE_MEMORY="0M"
fi

ARGS=(
  "redpanda"
  "start"
  "--node-id=${RP_NODE_ID}"
  "--kafka-addr=${RP_KAFKA_LISTENERS}"
  "--advertise-kafka-addr=${RP_ADVERTISE_KAFKA_LISTENERS}"
  "--rpc-addr=${RP_RPC_LISTENERS}"
  "--advertise-rpc-addr=${RP_ADVERTISE_RPC_LISTENERS}"
  "--seeds=${RP_SEEDS}"
  "--smp=${RP_SMP}"
  "--memory=${RP_MEMORY}"
  "--reserve-memory=${RP_RESERVE_MEMORY}"
  "--mode=dev-container"
  "--check=false"
)

exec "${ARGS[@]}"
