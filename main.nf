params.outputDir = "output"

// setup file input channels
// target regions
params.regions = 'input/regions.bed'

log.info "~~~~~~~ IGV Pipeline ~~~~~~~"
log.info "* Project dir:        ${workflow.projectDir}"
log.info "* Launch dir:         ${workflow.launchDir}"
log.info "* Work dir:           ${workflow.workDir.toUriString()}"
log.info "* Profile:            ${workflow.profile ?: '-'}"
log.info "* Script name:        ${workflow.scriptName ?: '-'}"
log.info "* Script ID:          ${workflow.scriptId ?: '-'}"
log.info "* Container engine:   ${workflow.containerEngine?:'-'}"
log.info "* Workflow session:   ${workflow.sessionId}"
log.info "* Nextflow run name:  ${workflow.runName}"
log.info "* Nextflow version:   ${workflow.nextflow.version}, build ${workflow.nextflow.build} (${workflow.nextflow.timestamp})"
log.info "* Launch command:\n${workflow.commandLine}\n"

// tumor-normal pairs
Channel.from([
    [
    file('input/Tumor-1.dd.ra.rc.bam'),
    file('input/Tumor-1.dd.ra.rc.bam.bai'),
    file('input/Normal-1.dd.ra.rc.bam'),
    file('input/Normal-1.dd.ra.rc.bam.bai')
    ],
    ])
    .set { input_bams }
Channel.fromPath(params.regions).set { regions_file }

process run_IGV {
    input:
    set file(tumor_bam), file(tumor_bai), file(normal_bam), file(normal_bai), file(regions) from input_bams.combine(regions_file)

    // output:
    // set file(snapshotDirectory)

    script:
    batchscript = "snapshots.bat"
    snapshotDirectory = "snapshots"
    image_height = 500
    genome = 'hg19'
    """
    mkdir "${snapshotDirectory}"
    
    # make batchscript for IGV to run
    make-batchscript.py "${tumor_bam}" "${normal_bam}" \
    -r "${regions}" \
    -d "${snapshotDirectory}" \
    -b "${batchscript}" \
    --height "${image_height}" \
    --genome "${genome}"

    # run IGV headlessly with xvfb
    xvfb-run \
    --auto-servernum \
    --server-num=1 \
    igv.sh \
    -b "${batchscript}"
    """
    // if [ "\$(uname)"=="Darwin" ];  then
    //     # use the copy of the script included
    //     xvfb-run-macOS --auto-servernum --server-num=1 igv.sh -b "${batchscript}"
    // else
    //     # use the system copy of the script
    //     xvfb-run --auto-servernum --server-num=1 igv.sh -b "${batchscript}"
    // fi
}
