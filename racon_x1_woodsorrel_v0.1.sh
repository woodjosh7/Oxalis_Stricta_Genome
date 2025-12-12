#!/bin/bash
#SBATCH --job-name=racon_x1_woodsorrel_v0.1		# Job name 
#SBATCH --partition=buell_p		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=20	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=200G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=36:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml Miniconda3/4.10.3

#Active conda environment
source /apps/eb/Miniconda3/4.10.3/etc/profile.d/conda.sh

conda activate /software/conda_envs/racon_polish

racon -t 20 -m 8 -x -6 -g -8 -w 500 -u \
basecalled_data/woo_all_guppy5.0.14_10kb.fastq \
minimap2_aln/woodsorrel/woo_all_guppy5.0.14_10kb_on_woodsorrel_v0.1.sam \
flye_assemblies/woodsorrel/woodsorrel_v0.1.fasta > polishing/woodsorrel/woodsorrel_v0.1_racon_x1.fasta

#Parameters 
#racon [options ...] <sequences> <overlaps> <target sequences>
#Recommended parameters for input into medaka: racon -m 8 -x -6 -g -8 -w 500 ...
# default output is stdout
#    <sequences>
#        input file in FASTA/FASTQ format (can be compressed with gzip)
#        containing sequences used for correction
#    <overlaps>
#        input file in MHAP/PAF/SAM format (can be compressed with gzip)
#        containing overlaps between sequences and target sequences
#    <target sequences>
#        input file in FASTA/FASTQ format (can be compressed with gzip)
#        containing sequences which will be corrected
#-m:  -m, --match <int>. default: 3. score for matching bases
#-x:  -x, --mismatch <int>. default: -5. score for mismatching bases
#-g:  -g, --gap <int>. default: -4. gap penalty (must be negative)
#-w:  -w, --window-length <int>. default: 500. size of window on which POA is performed
#-u, --include-unpolished. output unpolished target sequences
#-t: Threads

#sbatch racon_x1_woodsorrel_v0.1.sh
