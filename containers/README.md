# Containers

Docker and Singularity containers for the software needed in the project

Docker for running locally (e.g. on Mac), Singularity for running on remote Linux server (no admin access).

# Usage

- If using Singularity container output, first build the Singularity Docker container

```
make docker-build VAR=Singularity-2.4
```

- To build the IGV container with Docker:

```
make docker-build VAR=IGV
```

- Test the container:

```
make docker-test VAR=IGV
```
