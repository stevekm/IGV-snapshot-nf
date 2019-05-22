// setup file input channels

// target regions
params.regions = 'input/regions.bed'

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
    make-batchscript.py "${tumor_bam}" "${normal_bam}" \
    -r "${regions}" \
    -d "${snapshotDirectory}" \
    -b "${batchscript}" \
    --height "${image_height}" \
    --genome "${genome}"
    """
    // if [ "\$(uname)"=="Darwin" ];  then
    //     # use the copy of the script included
    //     xvfb-run-macOS --auto-servernum --server-num=1 igv.sh -b "${batchscript}"
    // else
    //     # use the system copy of the script
    //     xvfb-run --auto-servernum --server-num=1 igv.sh -b "${batchscript}"
    // fi
}
