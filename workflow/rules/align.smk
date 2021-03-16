rule star_align:
    input:
        unpack(get_fq), 
        index = "resources/STARindex", 
        annotation = "resources/annotation.gtf"
    output:
        # see STAR manual for additional output files
        "../data/processed/star/{sample}-{unit}/Aligned.sortedByCoord.out.bam", 
        "../data/processed/star/{sample}-{unit}/ReadsPerGene.out.tab"
    log:
        "logs/star/{sample}-{unit}.log"
    params:
        # path to STAR reference genome index
        index = "resources/STARindex",
        # optional parameters
        extra="--quantMode GeneCounts --outSAMtype BAM SortedByCoordinate --sjdbGTFfile {} {}".format(
              config["ref"]["annotation"], config["params"]["star"])
    threads: 24
    wrapper:
        "0.72.0/bio/star/align"