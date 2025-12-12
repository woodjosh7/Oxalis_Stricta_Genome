#!/bin/bash
#SBATCH --job-name=woo_3ddna_10kb_min		# Job name 
#SBATCH --partition=highmem_p		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=32	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=120G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=96:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml 3D-DNA/201008-foss-2019b-Python-2.7.16

cd woodsorrel/3ddna_10kb_min

run-asm-pipeline.sh -i 10000 -r 5 \
woodsorrel/genome_files/woodsorrel_v0.2.fasta \
woodsorrel/run_juicer/aligned/merged_nodups.txt 

#Parameters 
#*****************************************************
#3D de novo assembly: version 190716
#
#USAGE: ./run-asm-pipeline.sh [options] <path_to_input_fasta> <path_to_input_mnd> 
#
#DESCRIPTION:
#This is a script to assemble draft assemblies (represented in input by draft fasta and deduplicated list of alignments of Hi-C reads to this fasta as produced by the Juicer pipeline) into chromosome-length scaffolds. The script will produce an output fasta file, a Hi-C map of the final assembly, and a few supplementary annotation files to help review the result in Juicebox.
#
#ARGUMENTS:
#path_to_input_fasta			Specify file path to draft assembly fasta file.
#path_to_input_mnd			Specify path to deduplicated list of alignments of Hi-C reads to the draft assembly fasta as produced by the Juicer pipeline: the merged_nodups file (mnd).
#
#OPTIONS:
#-m|--mode haploid/diploid			Runs in specific mode, either haploid or diploid (default is haploid).
#-i|--input input_size			Specifies threshold input contig/scaffold size (default is 15000). Contigs/scaffolds smaller than input_size are going to be ignored.
#-r|--rounds number_of_edit_rounds			Specifies number of iterative rounds for misjoin correction (default is 2).
#-s|--stage stage					Fast forward to later assembly steps, can be polish, split, seal, merge and finalize.
#-h|--help			Shows this help. Type --help for a full set of options.
#*****************************************************

#sbatch woo_3ddna_10kb_min.sh
