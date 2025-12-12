#!/bin/bash
#SBATCH --job-name=woodsorrel_ltr_finder_and_harvest	# Job name 
#SBATCH --partition=batch		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=24	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=100G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=96:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml GenomeTools/1.6.2-GCC-11.3.0
ml LTR_FINDER_parallel/1.0.7-GCCcore-11.3.0

gt suffixerator -db oxst_v3.asm.fa \
-indexname oxst_v3.asm.gt_index.fa \
-tis -suf -lcp -des -ssp -sds -dna

gt ltrharvest -index oxst_v3.asm.gt_index.fa \
-minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 -motif TGCA \
-motifmis 1 -similar 85 -vic 10 -seed 20 -seqids yes \
> ltr_harvest_results/oxst_v3.asm.fa.harvest.scn

cd ltr_finder_results/

LTR_FINDER_parallel -seq oxst_v3.asm.fa \
-threads 24 -harvest_out -size 1000000 -time 300

#Parameters
#Code from: https://github.com/oushujun/LTR_retriever under "Usage"
#

#sbatch woodsorrel_ltr_finder_and_harvest.sh
