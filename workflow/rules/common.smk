def is_single_end(sample, unit):
    return pd.isnull(units.loc[(sample, unit), "fq2"])


def get_fastq(wildcards):
    return units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()


def get_fq(wildcards):
     if config["trimming"]["skip"]:
         # no trimming, use raw reads
         u = units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
         if is_single_end(**wildcards):
             return { 'fq1': f"{u.fq1}" }
         else:
             return { 'fq1': f"{u.fq1}",
                      'fq2': f"{u.fq2}" }
     else:
         # yes trimming, use trimmed data
         if not is_single_end(**wildcards):
             # paired-end sample
             return dict(zip(
                 ['fq1', 'fq2' ],
                 expand("../data/processed/trimmed/{sample}-{unit}.{group}.fastq.gz", group=[1, 2], **wildcards)))
         # single end sample
         return { 'fq1': "../data/processed/trimmed/{sample}-{unit}.fastq.gz".format(**wildcards) }


def get_strandedness(units):
    if "strandedness" in units.columns:
        return units["strandedness"].tolist()
    else:
        strand_list = ["none"]
        return strand_list * units.shape[0]


# def get_star_counts(wildcards):
#     if not is_single_end(**wildcards):
#         return expand(
#             "../data/processed/star/{unit.sample}-{unit.unit}/ReadsPerGene.out.tab", 
#             unit = units.itertuples()
#             )
#     else:
#         # single-end
#         return expand(
#             "../data/processed/star/{unit.sample}-{unit.unit}/ReadsPerGene.out.tab", 
#             unit = units.itertuples()
#             )
#     return None


# def get_star_bam(wildcards):
#     if not is_single_end(**wildcards):
#         return expand(
#             "../data/processed/star/pe/{unit.sample}-{unit.unit}/Aligned.out.bam", 
#             unit = units.itertuples(), 
#             **wildcards
#             )
#     else:
#         # single-end
#         return expand(
#             "../data/processed/star/{unit.sample}-{unit.unit}/Aligned.out.bam", 
#             unit = units.itertuples(), 
#             **wildcards
#             )
#     return None


def get_deseq2_threads(wildcards=None):
    # https://twitter.com/mikelove/status/918770188568363008
    few_coeffs = False if wildcards is None else len(get_contrast(wildcards)) < 10
    return 1 if len(samples) < 100 or few_coeffs else 6


def strip_suffix(pattern, suffix):
    return pattern[: -len(suffix)]


def get_contrast(wildcards):
    return config["diffexp"]["contrasts"][wildcards.contrast]
