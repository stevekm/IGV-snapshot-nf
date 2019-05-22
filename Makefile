SHELL:=/bin/bash
export NXF_VER:=19.04.1
UNAME:=$(shell uname)

# install nextflow in current directory
nextflow:
	curl -fsSL get.nextflow.io | bash

# pass extra command line parameters to nextflow here with `EP=`
EP:=
PROFILE:=standard
# choose a profile based on the current system OS
ifeq ($(UNAME), Darwin)
PROFILE:=docker
endif

ifeq ($(UNAME), Linux)
PROFILE:=singularity
endif

run: nextflow
	./nextflow run main.nf -profile "$(PROFILE)" $(EP)

# deletes all pipeline output
clean:
	[ -d .nextflow ] && mv .nextflow .nextflowold && rm -rf .nextflowold &
	[ -d work ] && mv work workold && rm -rf workold &
	rm -f .nextflow.log*
	rm -f *.png
	rm -f trace*.txt*
	rm -f *.html*
	rm -f flowchart.dot*
