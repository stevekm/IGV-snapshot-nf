params.regions = "regions.bed"
Channel.from([
    [file('input/Normal-1.dd.ra.rc.bam'), file('input/Normal-1.dd.ra.rc.bam.bai')],
    [file('input/Tumor-1.dd.ra.rc.bam'), file('input/Tumor-1.dd.ra.rc.bam.bai')],
    ])
    .set { input_bams }
Channel.fromPath(params.regions).set { regions_file }

process run_IGV {
    input:
    set file(bam), file(bai), file(regions) from input_bams.combine(regions_file)

    output:
    set file(snapshotDirectory)

    script:
    batchscript = "IGV_snapshots.bat"
    snapshotDirectory = "snapshotDirectory"
    """
    make-batchscript.py "${bam}" -r "${regions}"

    if [ "\$(uname)"=="Darwin" ];  then
        # use the copy of the script included
        xvfb-run-macOS --auto-servernum --server-num=1 igv.sh -b "${batchscript}"
    else
        # use the system copy of the script
        xvfb-run --auto-servernum --server-num=1 igv.sh -b "${batchscript}"
    fi
    """
}
