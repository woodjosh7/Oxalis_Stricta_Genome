#!/bin/bash
#SBATCH --job-name=woo_aa_kmer21_jellyfish		# Job name 
#SBATCH --partition=batch		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=10	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=50G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=36:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=BEGIN,END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml Jellyfish/2.3.0-GCC-8.3.0

jellyfish count -C -m 21 -s 1000000000 -t 10 \
<(zcat trimmed_reads/woo_aa_PE1_cutadapt.fq.gz)  <(zcat trimmed_reads/woo_aa_PE2_cutadapt.fq.gz) \
-o jellyfish/woo_aa_kmer21.jf

jellyfish histo -t 10 \
jellyfish/woo_aa_kmer21.jf \
> jellyfish/woo_aa_kmer21.histo

#Parameters
#jellyfish count: count kmers
#jellyfish histo: plot kmer counts
#-C: Count Canonical Kmers
#-m: Kmer Size
#-s: RAM to Use
#-t: threads
#use <(zcat file1.fastq.gz) to read in zipped files
#can place multiple files in a line to read each one

#sbatch woo_aa_kmer21_jellyfish.sh
