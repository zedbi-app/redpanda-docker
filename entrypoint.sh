#!/usr/bin/env bash
set -euo pipefail

# Avoid process restart loops when /proc/sys/fs/aio-max-nr is read-only.
AIO_MIN="${AIO_MIN:-1024}"
if [[ -w /proc/sys/fs/aio-max-nr ]]; then
  CURRENT=$(cat /proc/sys/fs/aio-max-nr 2>/dev/null || echo 0)
  if [[ "${CURRENT}" -lt "${AIO_MIN}" ]]; then
    echo "${AIO_MIN}" > /proc/sys/fs/aio-max-nr || true
  fi
fi

# Build Redpanda flags from one var per flag to keep Railway Runtime V2 happy.
# Railway injects each variable as a single CLI argument; Redpanda does neither
# parse the multi-listener comma list inside a single flag nor accept repeated
# uses of the same flag.
ARGS=("redpanda" "start" "--mode=dev-container")

ARGS+=("--node-id=${RP_NODE_ID:-0}")
ARGS+=("--smp=${RP_SMP:-1}")
ARGS+=("--memory=${RP_MEMORY:-1G}")
ARGS+=("--reserve-memory=${RP_RESERVE_MEMORY:-0M}")
ARGS+=("--overprovisioned")
ARGS+=("--check=false")

if [[ -n "${RP_KAFKA_LISTENERS:-}" ]]; then
  IFS=',' read -ra LISTENERS <<< "${RP_KAFKA_LISTENERS}"
  for L in "${LISTENERS[@]}"; do
    ARGS+=("--kafka-addr" "${L}")
  done
fi

if [[ -n "${RP_ADVERTISE_KAFKA_LISTENERS:-}" ]]; then
  IFS=',' read -ra ADVS <<< "${RP_ADVERTISE_KAFKA_LISTENERS}"
  for L in "${ADVS[@]}"; do
    ARGS+=("--advertise-kafka-addr" "${L}")
  done
fi

if [[ -n "${RP_RPC_LISTENERS:-}" ]]; then
  IFS=',' read -ra RPCS <<< "${RP_RPC_LISTENERS}"
  for L in "${RPCS[@]}"; do
    ARGS+=("--rpc-addr" "${L}")
  done
fi

if [[ -n "${RP_ADVERTISE_RPC_LISTENERS:-}" ]]; then
  IFS=',' read -ra ADVRPCS <<< "${RP_ADVERTISE_RPC_LISTENERS}"
  for L in "${ADVRPCS[@]}"; do
    ARGS+=("--advertise-rpc-addr" "${L}")
  done
fi

ARGS+=("--seeds=${RP_SEEDS:-localhost:33145}")

exec "${ARGS[@]}"
