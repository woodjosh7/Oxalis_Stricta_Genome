#!/bin/bash
#SBATCH --job-name=woodsorrel_busco		# Job name 
#SBATCH --partition=batch		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=24	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=75G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=6:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml BUSCO/5.5.0-foss-2022a

busco -i oxst_v3.asm.fa \
-c 24 \
-o oxst_v3_busco_v5.5.0_odb10 \
--out_path busco/ \
-m genome \
-l software/BUSCO/2024_01_08/embryophyta_odb10

busco -i oxst_v3.asm.subgenome1.fa \
-c 24 \
-o oxst_v3_subgenome1_busco_v5.5.0_odb10 \
--out_path busco/ \
-m genome \
-l software/BUSCO/2024_01_08/embryophyta_odb10

busco -i oxst_v3.asm.subgenome2.fa \
-c 24 \
-o oxst_v3_subgenome2_busco_v5.5.0_odb10 \
--out_path busco/ \
-m genome \
-l software/BUSCO/2024_01_08/embryophyta_odb10


#Parameters 
#busco -i [SEQUENCE_FILE] -l [LINEAGE] -o [OUTPUT_NAME] -m [MODE] [OTHER OPTIONS]
#-i FASTA FILE, --in FASTA FILE: Input sequence file in FASTA format. Can be an assembled genome or transcriptome (DNA), or protein sequences from an annotated gene set.
#-c N, --cpu N: Specify the number (N=integer) of threads/cores to use.
#-o OUTPUT, --out OUTPUT: Give your analysis run a recognisable short name. Output folders and files will be labelled with this name. WARNING: do not provide a path
#--out_path OUTPUT_PATH: Optional location for results folder, excluding results folder name. Default is current working directory.
#-e N, --evalue N: E-value cutoff for BLAST searches. Allowed formats, 0.001 or 1e-03 (Default: 1e-03)
#-m MODE, --mode MODE  Specify which BUSCO analysis mode to run.
#                        There are three valid modes:
#                        - geno or genome, for genome assemblies (DNA)
#                        - tran or transcriptome, for transcriptome assemblies (DNA)
#                        - prot or proteins, for annotated gene sets (protein)
#-l LINEAGE, --lineage_dataset LINEAGE: Specify the name of the BUSCO lineage to be used.
#--config CONFIG_FILE: Provide a config file


#sbatch woodsorrel_busco.sh
