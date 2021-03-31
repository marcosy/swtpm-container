#!/bin/bash
set -e -o pipefail

DEFAULT_TPM_SOCKET="/tmp/swtpm.sock"
DEFAULT_TPM_STATE="../manufacture-tpm/output/tpm2-00.permall"

# Usage
if [ "$1" == "-h" ]; then
    echo >&2 "Usage: ${0} <tpm_state> <tpm_socket>"
    exit 1
fi

# Use default values if not set
tpm_state="$DEFAULT_TPM_STATE"
if ! [ -z "$1" ]; then
    tpm_state="$1"
fi

tpm_socket="$DEFAULT_TPM_SOCKET"
if ! [ -z "$2" ]; then
    tpm_socket="$2"
fi

# Ensure container image is built
container_id=$(
    cd $(dirname $(realpath "${0}"))
    docker build -q --iidfile "${container_iidfile}" .
)

# Run the container in the background
docker run  -d                                          \
            --privileged                                \
            --rm                                        \
            --name swtpm                                \
            -v $(realpath "$tpm_state"):/tpmstate:ro    \
            -p 10000:10000                              \
            -p 10001:10001                              \
            -p 10002:10002                              \
            "${container_id}" /tpmstate

# Create local socket to bind the TPM emulator
socat   -v                                                                     \
        -d -d -d                                                               \
        UNIX-LISTEN:$(realpath "$tpm_socket"),reuseaddr,fork TCP:localhost:10001
