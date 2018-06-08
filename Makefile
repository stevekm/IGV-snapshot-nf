SHELL:=/bin/bash

# ~~~~~ SETUP PIPELINE ~~~~~ #
./nextflow:
	curl -fsSL get.nextflow.io | bash

install: ./nextflow IGV

update: ./nextflow
	./nextflow self-update

IGV: bin/igv.sh

bin/igv.sh:
	cd bin && \
	wget http://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.10.zip && \
	unzip IGV_2.4.10.zip && \
	rm -f unzip IGV_2.4.10.zip && \
	mv IGV_2.4.10/* . && \
	rm -rf IGV_2.4.10

# ~~~~~ RUN PIPELINE ~~~~~ #
run: install
	./nextflow run main.nf -resume $(EP)


# ~~~~~ CLEANUP ~~~~~ #
clean-traces:
	rm -f trace*.txt.*

clean-logs:
	rm -f .nextflow.log.*

clean-reports:
	rm -f *.html.*

clean-flowcharts:
	rm -f *.dot.*

clean-output:
	[ -d output ] && mv output oldoutput && rm -rf oldoutput &

clean-work:
	[ -d work ] && mv work oldwork && rm -rf oldwork &

# deletes files from previous runs of the pipeline, keeps current results
clean: clean-logs clean-traces clean-reports clean-flowcharts

# deletes all pipeline output
clean-all: clean clean-output clean-work
	[ -d .nextflow ] && mv .nextflow .nextflowold && rm -rf .nextflowold &
	rm -f .nextflow.log
	rm -f *.png
	rm -f trace*.txt*
	rm -f *.html*
	rm -f flowchart.dot*
