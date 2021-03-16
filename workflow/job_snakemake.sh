#! /bin/bash
#SBATCH --job-name=Combes
#SBATCH --mail-user=bostendorf@rockefeller.edu
#SBATCH --mail-type=ALL


snakemake \
	--cache \
	--use-conda \
	--jobs 42 \
	--rerun-incomplete \
	--restart-times 3 \
	--keep-going \
	--conda-frontend mamba \
	--cluster "sbatch" \
	--printshellcmds
