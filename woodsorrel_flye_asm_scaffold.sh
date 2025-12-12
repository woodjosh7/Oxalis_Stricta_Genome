#!/bin/bash
#SBATCH --job-name=woodsorrel_flye_asm_scaffold		# Job name 
#SBATCH --partition=buell_p		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=20	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=500G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=48:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml Miniconda3/4.10.3

#Active conda environment
source /apps/eb/Miniconda3/4.10.3/etc/profile.d/conda.sh

conda activate software/conda_envs/flye_asm

flye --resume-from contigger --nano-raw basecalled_data/woo_all_guppy5.0.14_10kb.fastq \
--out-dir flye_assemblies/woodsorrel --threads 20 --iterations 0 --scaffold

#Parameters 
#flye (--pacbio-raw | --pacbio-corr | --pacbio-hifi | --nano-raw | --nano-corr | --nano-hq ) file1 [file_2 ...] --out-dir PATH
#--nano-raw: ONT regular reads, pre-Guppy5 (<20% error)
#--out-dir: output directory
#--threads: number of parallel threads [1]
#--iterations: number of polishing iterations [1]
#--resume-from: name of stage to resume from

#sbatch woodsorrel_flye_asm_scaffold.sh
