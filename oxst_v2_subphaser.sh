#!/bin/bash
#SBATCH --job-name=oxst_v2_subphaser	# Job name 
#SBATCH --partition=highmem_p		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=32	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=200G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=48:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml Miniforge3/24.11.3-0

#Active conda environment
source /apps/eb/Miniforge3/24.11.3-0/etc/profile.d/conda.sh 

conda activate SubPhaser

cd subphaser

subphaser -p 32 \
-i oxst_v2.asm.fa \
-c oxst_v2_sg.config -pre oxst_v2 2>&1 | tee oxst_v2.log

#Parameters
#options: subphaser -i genome.fasta.gz -c sg.config

#sbatch oxst_v2_subphaser.sh
