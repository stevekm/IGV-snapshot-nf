def os_name = System.properties['os.name'] // Linux
params.output_dir = "output"
params.regions = "regions.bed"

// path to bin dir needed for macOS
bin_dir = new File("bin").getCanonicalPath()

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
        mkdir "${snapshotDirectory}"
        make-batchscript.py "${bam}" -r "${regions}" --output-dir "${snapshotDirectory}"

        # use system installed xvfb-run
        xvfb-run --auto-servernum igv.sh -b "${batchscript}"
        """
        // Command error:
        //   /usr/bin/xvfb-run: line 186: kill: (3710) - No such process
    // else if(os_name == "Mac OS X")
        // """
        // set -x
        // # mkdir "${snapshotDirectory}"
        // make-batchscript.py "${bam}" -r "${regions}" --output-dir "${snapshotDirectory}"
        //
        // find_server_number () {
        //     # Search for an open Xvfb port to render into
        //     for _serv_num in \$(seq 1 100000); do
        //         if ! (xdpyinfo -display :\${_serv_num})&>/dev/null; then
        //             echo "\$_serv_num" && break
        //         fi
        //     done
        // }
        // serv_num=\$(find_server_number)
        // echo "server num: \${serv_num}"
        //
        // Xvfb :\${serv_num} &
        // xvfb_pid=\$!
        // """
        // # xvfb-run.sh --auto-servernum igv.sh -b "${batchscript}"
        // find_free_servernum() {
        //     local i=99
        //     while [ -f /tmp/.X\$i-lock ]; do
        //         i=\$((\$i + 1))
        //     done
        //     echo \$i
        // }
        //
        // serv_num="\$(find_free_servernum)"
        // Xvfb :\${serv_num} &
        // xvfb_pid=\$!
        // sleep 3
        // DISPLAY=:\${serv_num} igv.sh -b "${batchscript}"
        // # xvfb-run-macOS --auto-servernum "${bin_dir}"/igv.sh -b "${batchscript}"
        // find_server_number () {
        //     # Search for an open Xvfb port to render into
        //     for _serv_num in \$(seq 1 100000); do
        //         if ! (xdpyinfo -display :\${_serv_num})&>/dev/null; then
        //             echo "\$_serv_num" && break
        //         fi
        //     done
        // }
        //
        // # create Xvfb on server port and run IGV
        // # serv_num="\$(find_server_number)"
        // # (Xvfb :\${serv_num} &) && DISPLAY=:\${serv_num} igv.sh -b "${batchscript}"
    else
        error "Unsupported operating system detected: ${os_name}"
    //
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
