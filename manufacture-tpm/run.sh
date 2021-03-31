#!/bin/bash
set -e -o pipefail

# Default arguments
DEFAULT_OUT_DIR="./output"

# Usage
if [ "$1" == "-h" ]; then
    echo >&2 "Usage: ${0} <out_directory>"
    exit 1
fi

# Use default values if not set
out_dir="$DEFAULT_OUT_DIR"
if ! [ -z "$1" ]; then
    out_dir="$1"
fi

# Ensure container image is built
container_id=$(
    cd $(dirname $(realpath "${0}"))
    docker build -q --iidfile "${container_iidfile}" .
)

# Run the container
docker run --privileged -v $(realpath "$out_dir"):/tmp/output --rm --name swtpm "${container_id}"

echo ""
echo "Find TPM state file and EK root certificate at: $(realpath "$out_dir")"
