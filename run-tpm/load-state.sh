#!/bin/bash

tpmstate_file="${1}"

# Restore tpmstate file
mkdir -p /var/swtpm
cp "${tpmstate_file}" /var/swtpm/tpm2-00.permall

# Start vTPM
echo "Starting TPM emulator..."
swtpm socket --tpm2                                         \
            --tpmstate dir=/var/swtpm                       \
            --seccomp action=none                           \
            --pid file=/swtpm.pid                           \
            --ctrl type=tcp,port=10000                      \
            --server type=tcp,port=10001,bindaddr=0.0.0.0   \
            --log file=/swtpm.log,level=5                   \
            --daemon

# Wait for vTPM service to start
while [ ! -f /swtpm.pid ]; do sleep 0; done

# Device initialization
swtpm_ioctl --tcp :10000 -i
swtpm_bios --tpm2 --tcp :10001 

# Show swtmp logs
tail -f /swtpm.log
