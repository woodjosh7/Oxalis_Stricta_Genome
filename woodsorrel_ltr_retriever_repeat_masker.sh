#!/bin/bash
#SBATCH --job-name=woodsorrel_ltr_retriever_repeat_masker	# Job name 
#SBATCH --partition=batch		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=32	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=100G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=48:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml RepeatMasker/4.1.5-foss-2022a

cd ltr_retriever/repeat_masker

RepeatMasker -pa 32 -e ncbi -q -no is -norna \
-nolow -div 40 -cutoff 225 \
-dir ltr_retriever/repeat_masker \
-lib ltr_retriever/oxst_v2.asm.fa.rawLTR.scn \
oxst_v3.asm.fa

#Parameters
#Code from: Assessing genome assembly quality using the LTR Assembly Index (LAI) Paper
#All possible LTR sequences in a given genome were annotated by RepeatMasker using the non-redundant LTR-RT library constructed by LTR retriever and with parameters ‘-e ncbi -q -no is -norna -nolow -div 40 -cutoff 225’

#sbatch woodsorrel_ltr_retriever_repeat_masker.sh
