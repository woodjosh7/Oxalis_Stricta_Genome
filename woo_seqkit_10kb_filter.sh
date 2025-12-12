#!/bin/bash
#SBATCH --job-name=woo_10kb_filter		# Job name 
#SBATCH --partition=buell_p		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=1	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=5G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=6:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

#Load seqkit
ml purge
ml seqkit/0.16.1

seqkit seq -m 10000 basecalled_data/woo_all_guppy5.0.14.fastq \
> basecalled_data/woo_all_guppy5.0.14_10kb.fastq

#sbatch woo_seqkit_10kb_filter.sh
