SHELL:=/bin/bash
VAR:=

STAGEDIR:=$(shell python -c 'import os; print(os.path.realpath("staging"))')

# ~~~~~ DOCKER ~~~~~ #
DOCKERFILE:=$(VAR)/Dockerfile
DOCKERREPO:=stevekm/igv-nf
DOCKERTAG:=$(DOCKERREPO):$(VAR)
docker-build:
	cd $(VAR) && \
	docker build -t "$(DOCKERTAG)" .

docker-test:
	docker run \
	--rm -ti \
	-v "$(STAGEDIR):/staging" \
	"$(DOCKERTAG)" bash

# ~~~~~ SINGULARITY ~~~~~ #
SINGULARITYFILE:=$(VAR)/Singularity.$(VAR)
IMG:=$(VAR)/$(VAR).simg
TEST:=

# build a Singularity container using the Docker image containing Singularity
# need to have built the Docker Singularity container first
SINGULARITYDIR:=$(shell python -c 'import os; print(os.path.realpath("$(VAR)"))')
SINGULARITYIMGDOCKER:=$(VAR).simg
SINGULARITYFILEDOCKER:=Singularity.$(VAR)
SINGULARITYDOCKERTAG:=$(DOCKERREPO):Singularity-2.4
singularity-build:
	[ -f "$(IMG)" ] && { echo ">>> Removing previous image file: $(IMG)" ; rm -f "$(IMG)" ; wait $$! ; } ; \
	docker run --privileged \
	--rm -ti \
	-v "$(SINGULARITYDIR):/image" \
	"$(SINGULARITYDOCKERTAG)" \
	bash -c 'cd /image && sudo singularity build $(SINGULARITYIMGDOCKER) $(SINGULARITYFILEDOCKER)'

singularity-test:
	docker run --privileged \
	--rm -ti \
	-v "$(SINGULARITYDIR):/image" \
	-v "$(STAGEDIR):/staging" \
	"$(SINGULARITYDOCKERTAG)" \
	bash -c "singularity shell --bind /staging:/staging /image/$(VAR).simg"
