#!/bin/bash
set -e -o pipefail

mkdir /tmp/mytpm2
chown tss:root /tmp/mytpm2

# If no configuration file is defined (--config parameter), swtpm_setup uses by default /usr/local/etc/swtpm-localca.conf
swtpm_setup --tpmstate /tmp/mytpm2  \
            --create-ek-cert        \
            --create-platform-cert  \
            --tpm2                  \
            --overwrite             \
            --logfile /swtpm.log

# Extract endorsement root certificate and TPM state file
cp /usr/local/var/lib/swtpm-localca/issuercert.pem /tmp/output/ekroot.pem
cp /tmp/mytpm2/tpm2-00.permall /tmp/output/tpm2-00.permall

# Show logs
cat /swtpm.log
