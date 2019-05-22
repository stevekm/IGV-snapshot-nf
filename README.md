# IGV-snapshot-nf

An example Nextflow workflow for creating automated IGV snapshots of .bam files based on a list of target regions.

This workflow is designed to show how to integrate [automated IGV snapshotting](https://github.com/stevekm/IGV-snapshot-automator) into a Nextflow workflow.

## Installation

First, clone this repository:

```
git clone https://github.com/stevekm/IGV-snapshot-automator.git
cd IGV-snapshot-automator
```

### Containers

Docker and/or Singularity containers are used to package IGV, X11, and `xvfb` required for functionality. Docker is required to build Singularity containers

To build the Docker container for IGV:

```
cd containers
make docker-build VAR=IGV
```

To test out the IGV Docker container:

```
make docker-test VAR=IGV
```

(optional) To build a Singuarity container for IGV, first build the Singularity Docker container:

```
make docker-build VAR=Singularity-2.4
```

- This container is used to build Singularity containers

To build the Singularity container for IGV:

```
make singularity-build VAR=IGV

# test the container:
make singularity-test VAR=IGV
```

- The Singularity container will be saved to `containers/IGV/IGV.simg`, which you can upload to your remote server for usage

# Usage

Run the included demo workflow (from the parent repo directory):

```
make run
```

Should look something like this:

```
IGV-snapshot-nf$ make run
./nextflow run main.nf -profile "docker"
N E X T F L O W  ~  version 19.04.1
Launching `main.nf` [kickass_cray] - revision: 1823b32e4f
~~~~~~~ IGV Pipeline ~~~~~~~
* Project dir:        /Users/steve/projects/IGV-snapshot-nf
* Launch dir:         /Users/steve/projects/IGV-snapshot-nf
* Work dir:           /Users/steve/projects/IGV-snapshot-nf/work
* Profile:            docker
* Script name:        main.nf
* Script ID:          1823b32e4f4fbc1caa63b0c12b2d4340
* Container engine:   docker
* Workflow session:   843f9541-9cc2-46c8-9005-89659c67ed80
* Nextflow run name:  kickass_cray
* Nextflow version:   19.04.1, build 5072 (03-05-2019 12:29 UTC)
* Launch command:
nextflow run main.nf -profile docker
[warm up] executor > local
executor >  local (1)
[91/852794] process > run_IGV [100%] 1 of 1 ✔
Completed at: 22-May-2019 15:27:46
Duration    : 1m 20s
CPU hours   : (a few seconds)
Succeeded   : 1
```
