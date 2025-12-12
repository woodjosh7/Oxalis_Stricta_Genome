#!/bin/bash
#SBATCH --job-name=woodsorrel_rnaseq_exp_ab_cutadapt		# Job name 
#SBATCH --partition=batch		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=20	 	# CPU core count per task, by default 1 CPU core per task
#SBTACH --array=1-57	 		# Array element range from 0 to 1, i.e. 2 element jobs
#SBATCH --mem=50G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=6:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

#INFILE=woodsorrel_rnaseq_exp_ab_filelist.txt

READ=`head -n ${SLURM_ARRAY_TASK_ID} ${INFILE} | cut -f 1 | tail -n 1`
LIB=`head -n ${SLURM_ARRAY_TASK_ID} ${INFILE} | cut -f 2 | tail -n 1`
DECODE=`head -n ${SLURM_ARRAY_TASK_ID} ${INFILE} | cut -f 3 | tail -n 1`

ml purge
ml Miniconda3/4.10.3

#Active conda environment
source /apps/eb/Miniconda3/4.10.3/etc/profile.d/conda.sh

conda activate software/conda_envs/cutadapt_v4.4

cutadapt --cores=20 -q 30 -m 40 --trim-n -n 2 \
-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
-A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
-o woodsorrel/trimmed_reads/${DECODE}_PE1_cutadapt.fq.gz \
-p woodsorrel/trimmed_reads/${DECODE}_PE2_cutadapt.fq.gz \
woodsorrel/raw_data/${READ}_R1_001.fastq.gz \
woodsorrel/raw_data/${READ}_R2_001.fastq.gz

#Parameters 
#file type fastq (autodetects)
#-q: trim bases with a quality score less than 30 from the beginning of the read (3' end)
#-m: minimum length of 100nt for each read 
#--trim-n: trim all N bases (bases with no call) (done after adapter trimming)
#-n 2: remove up to two adapters 
#-a: remove 3' adapter sequence from read 1 AGATCGGAAGAGCACACGTCTGAACTCCAGTCA (Illumina TruSeq Adapter, Read 1) 
#-A: remove 3' adapter sequence from read 2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT (Illumina TruSeq Adapter, Read 2)
#-o: output file 
#-p: second output file for paired end cleaning

#sbatch --array 1-57 --export=INFILE=woodsorrel_rnaseq_exp_ab_filelist.txt woodsorrel_rnaseq_exp_ab_cutadapt.sh
