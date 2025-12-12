#!/bin/bash
#SBATCH --job-name=woodsorrel_v0.1_racon_x2_medaka_x1		# Job name 
#SBATCH --partition=buell_p,highmem_p		# Partition name (batch, highmem_p, or gpu_p)
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

conda activate software/conda_envs/medaka_v1.4.4

medaka_consensus -m r941_min_hac_g507 -t 20 \
-i basecalled_data/woo_all_guppy5.0.14_10kb.fastq \
-d polishing/woodsorrel/woodsorrel_v0.1_racon_x2.fasta \
-o polishing/woodsorrel/medaka_x1/

#Parameters 
#medaka_consensus -i ${BASECALLS} -d ${DRAFT} -o ${OUTDIR} -m {MODEL}
#-i: basecalled data
#-d: draft genome
#-o: output_directory
#--threads: threads
#-m, --model: model to use
#		Medaka models are named to indicate i) the pore type, ii) the sequencing device (MinION or PromethION), iii) the basecaller variant, and iv) the basecaller version, with the format: 
#		{pore}_{device}_{caller variant}_{caller version}

#sbatch woodsorrel_v0.1_racon_x2_medaka_x1.sh
