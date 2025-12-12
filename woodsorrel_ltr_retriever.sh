#!/bin/bash
#SBATCH --job-name=woodsorrel_ltr_retriever	# Job name 
#SBATCH --partition=batch		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=24	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=100G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=96:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml LTR_retriever/2.9.0-foss-2022a

LTR_retriever -genome oxst_v3.asm.fa \
-inharvest oxst_v3.asm.fa.rawLTR.scn \
-threads 24

#Parameters
#Code from: https://github.com/oushujun/LTR_retriever under "Usage"
#

#sbatch woodsorrel_ltr_retriever.sh
