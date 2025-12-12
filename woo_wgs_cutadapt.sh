#!/bin/bash
#SBATCH --job-name=woo_wgs_cutadapt		# Job name 
#SBATCH --partition=buell_p		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=20	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=80G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=24:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml Miniconda3/4.10.3

#Active conda environment
source /apps/eb/Miniconda3/4.10.3/etc/profile.d/conda.sh

conda activate software/conda_envs/cutadapt_v3.5

cutadapt --cores=20 -q 30 -m 100 --trim-n -n 2 \
-a AATGATACGGCGACCACCGAGATCTACAC \
-a CAAGCAGAAGACGGCATACGAGAT \
-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
-A GTGTAGATCTCGGTGGTCGCCGTATCATT \
-A ATCTCGTATGCCGTCTTCTGCTTG \
-A GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT \
-o trimmed_reads/woo_aa_PE1_cutadapt.fq.gz \
-p trimmed_reads/woo_aa_PE2_cutadapt.fq.gz \
raw_data/20342Bue_WOO-AA_S7_L004_R1_001.fastq.gz \
raw_data/20342Bue_WOO-AA_S7_L004_R2_001.fastq.gz

#This library uses the adapters from the PerkinElmer NEXTFLEX Rapid XP DNA-Seq Kit

#Parameters 
#file type fastq (autodetects)
#-q: trim bases with a quality score less than 30 from the beginning of the read (3' end)
#-m: minimum length of 100nt for each read 
#--trim-n: trim all N bases (bases with no call) (done after adapter trimming)
#-n 2: remove up to two adapters 
#-a: remove 3' adapter sequence from read 1 AATGATACGGCGACCACCGAGATCTACAC (NEXTFLEX™ DNA-Seq Adapter 1) 
#-a: remove 3' adapter adapter from read 1 CAAGCAGAAGACGGCATACGAGAT (NEXTFLEX™ DNA-Seq Adapter 1) 
#-a: remove 3' adapter adapter from read 1 AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC (truseq adapter)
#-A: remove 3' reverse compliment adapter sequence from read 2 GTGTAGATCTCGGTGGTCGCCGTATCATT (NEXTFLEX™ DNA-Seq Adapter 1) 
#-A: remove 3' reverse compliment adapter sequence from read 2 ATCTCGTATGCCGTCTTCTGCTTG (NEXTFLEX™ DNA-Seq Adapter 1) 
#-A: remove 3' reverse compliment adapter sequence from read 2 ATCTCGTATGCCGTCTTCTGCTTG (truseq adapter) 
#-o: output file 
#-p: second output file for paired end cleaning

#sbatch woo_wgs_cutadapt.sh
