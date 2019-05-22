SHELL:=/bin/bash
export NXF_VER:=19.04.1

# install nextflow in current directory
nextflow:
	curl -fsSL get.nextflow.io | bash

# pass extra command line parameters to nextflow here with `EP=`
EP:=
run: nextflow
	./nextflow run main.nf $(EP)

# deletes all pipeline output
clean:
	[ -d .nextflow ] && mv .nextflow .nextflowold && rm -rf .nextflowold &
	[ -d work ] && mv work workold && rm -rf workold &
	rm -f .nextflow.log*
	rm -f *.png
	rm -f trace*.txt*
	rm -f *.html*
	rm -f flowchart.dot*
