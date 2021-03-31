# swtpm-container

This repository contains scripts and containers to facilitate the
use of the Sofware TPM Emulator ([SWTPM](https://github.com/stefanberger/swtpm)).

Scripts were tested on Mac but should be straightforward to use on Linux. 

## 1. Create a new Software TPM
The `manufacture-tpm/run.sh` script simulates the process of manufacturing a new
TPM. It creates the initial state of the TPM, including, among other things, 
the EK certificate generation.

To create ("manufacture") a new software TPM run:
```bash
cd manufacture-tpm 
./run.sh <output-directory>
```

The script outputs a TPM state file and the EK signing certificate. 
If `<output-directory>` is not set, the data is saved to the 
default directory `./output/`.
The SWTPM default configuration file is used to generate the CA.

## 2. Start the software TPM emulator 
The `run-tpm/run.sh` script loads a TPM state file into the TPM and
starts the emulator in a docker container.

To start the software TPM emulator:
```bash
cd run-tpm
./run.sh <tpm-state> <tpm-socket>
```

By default the script takes the state (`<tpm-state>`) generated in the default 
manufacture output directory (`../manufacture-tpm/output/tpm2-00.permall`).

The default for `<tpm-socket>` is `/var/swtpm.sock`.

The script runs the container in the background and then start `socat` to bind
a container port to a unix socket in the host.

## 3. Stop the software TPM emulator
Stop socat process: `ctrl + c`.


Stop the docker container:
```bash
docker container stop swtpm
```