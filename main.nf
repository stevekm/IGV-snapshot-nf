def os_name = System.properties['os.name'] // Linux
params.output_dir = "output"
params.regions = "regions.bed"
Channel.from([
    [file('input/Normal-1.dd.ra.rc.bam'), file('input/Normal-1.dd.ra.rc.bam.bai')],
    [file('input/Tumor-1.dd.ra.rc.bam'), file('input/Tumor-1.dd.ra.rc.bam.bai')],
    ])
    .set { input_bams }
Channel.fromPath(params.regions).set { regions_file }


process run_IGV {
    publishDir "${params.output_dir}", mode: "copy"
    input:
    set file(bam), file(bai), file(regions) from input_bams.combine(regions_file)

    output:
    file(snapshotDirectory)

    script:
    batchscript = "IGV_snapshots.bat"
    snapshotDirectory = "${bam}_snapshots"
    if (os_name == "Linux")
        """
        echo "${os_name}"
        mkdir "${snapshotDirectory}"
        make-batchscript.py "${bam}" -r "${regions}" --output-dir "${snapshotDirectory}"
        which xvfb-run
        xvfb-run --auto-servernum igv.sh -b "${batchscript}"
        """
        // Command error:
        //   /usr/bin/xvfb-run: line 186: kill: (3710) - No such process
    else
        error "Unsupported operating system detected: ${os_name}"
    // # Search for an open Xvfb port to render into
    // for serv_num in \$(seq 1 100000); do
    //     if ! (xdpyinfo -display :\${serv_num})&>/dev/null; then
    //         echo "serv_num:\$serv_num" && break
    //     fi
    // done
    //
    // # create Xvfb on server port and run IGV
    // set -x
    // xvfb_pid="\$( Xvfb :\${serv_num} & echo "\$!" )"
    // echo "xvfb_pid:\$xvfb_pid"
    // DISPLAY=:\${serv_num} igv.sh -b "${batchscript}"
    // kill "\${xvfb_pid}"
    //
    // # killall Xvfb
     // igv_command = "(Xvfb :{} &) && DISPLAY=:{} java -Xmx{}m -jar {} -b {} && killall Xvfb".format(x_serv_port, x_serv_port, memMB, igv_jar, igv_script)
    // if [ "\$(uname)"=="Darwin" ];  then
    //     # use the copy of the script included
    //     xvfb-run-macOS --auto-servernum --server-num=1 igv.sh -b "${batchscript}"
    // else
    //     # use the system copy of the script
    //     xvfb-run --auto-servernum --server-num=1 igv.sh -b "${batchscript}"
    // fi
}
