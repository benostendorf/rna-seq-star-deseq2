rule get_genome:
    output:
        "resources/genome.fasta"
    params:
        species = config["ref"]["species"],
        datatype = config["ref"]["datatype"],
        build = config["ref"]["build"],
        release = config["ref"]["release"]
    log:
        "logs/get-genome.log"
    cache: True
    wrapper:
        "0.72.0/bio/reference/ensembl-sequence"


rule get_annotation:
    output:
        "resources/annotation.gtf"
    params:
        species = config["ref"]["species"],
        release = config["ref"]["release"],
        build = config["ref"]["build"],
        fmt = "gtf",
        flavor = "" # optional, e.g. chr_patch_hapl_scaff, see Ensembl FTP.
    log:
        "logs/get_annotation.log"
    cache: True
    wrapper:
        "0.72.0/bio/reference/ensembl-annotation"


rule star_index:
    input:
        fasta = "resources/genome.fasta"
    output:
        directory("resources/STARindex")
    message:
        "Testing STAR index"
    params:
        extra = ""
    threads: 8
    log:
        "logs/star_index_genome.log"
    cache: True
    wrapper:
        "0.72.0/bio/star/index"


# rule correct_genomeIndex:
#     input:
#         "resources/STARindex"
#     output:
#         "checkpoint.txt"
#     shell:
#         """
#         cat {input} | grep -v 'genomeType' > resources/STARindex/genomeParameters.txt 
#         echo 'genomeParameters.txt corrected' > {output}
#         """