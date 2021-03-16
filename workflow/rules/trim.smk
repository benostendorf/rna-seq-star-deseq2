rule cutadapt_pe:
    input:
        get_fastq
    output:
        fastq1="../data/processed/trimmed/{sample}-{unit}.1.fastq.gz",
        fastq2="../data/processed/trimmed/{sample}-{unit}.2.fastq.gz",
        qc="qc/trimmed/{sample}-{unit}.qc.txt",
    params:
        adapters = "-a {} -A {}".format(
            config["trimming"]["adapter_r1"], config["trimming"]["adapter_r2"]
            ),
        extra="--minimum-length 1 -q 20 {}".format(
             config["params"]["cutadapt-pe"])
    log:
        "logs/cutadapt/{sample}-{unit}.log",
    threads: 8
    wrapper:
        "0.72.0/bio/cutadapt/pe"


rule cutadapt:
    input:
        get_fastq,
    output:
        fastq="../data/processed/trimmed/{sample}-{unit}.fastq.gz",
        qc="qc/trimmed/{sample}-{unit}.qc.txt",
    params:
        adapters = "-a {}".format(config["trimming"]["adapter_r1"]), 
        extra = "-q 20 {}".format(config["params"]["cutadapt-se"])
    log:
        "logs/cutadapt/{sample}-{unit}.log"
    threads: 8
    wrapper:
        "0.72.0/bio/cutadapt/se"
