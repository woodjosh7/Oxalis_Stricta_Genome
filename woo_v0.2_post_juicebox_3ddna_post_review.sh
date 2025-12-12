#!/bin/bash
#SBATCH --job-name=woo_v0.2_post_juicebox_3ddna_post_review	# Job name 
#SBATCH --partition=batch		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=32	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=75G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=8:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml 3D-DNA/201008-foss-2019b-Python-2.7.16

cd woodsorrel/3ddna_post_juicebox

run-asm-pipeline-post-review.sh \
-r woodsorrel/3ddna_post_juicebox/woodsorrel_v0.2.rawchrom.review_1.assembly \
woodsorrel/genome_files/woodsorrel_v0.2.fasta \
woodsorrel/run_juicer/aligned/merged_nodups.txt 

#Parameters 
#*****************************************************
#3D de novo assembly: version 190716
#The script will not only generate the final fasta (labeled with a “FINAL” suffix), but also rebuild the final .hic map for quality control. Check help for available options to customize output.
#./run-asm-pipeline-post-review.sh –r draft.review.assembly draft.fa merged_nodups.txt
#*****************************************************

#sbatch woo_v0.2_post_juicebox_3ddna_post_review.sh
