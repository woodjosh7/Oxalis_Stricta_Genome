#!/bin/bash
#SBATCH --job-name=Guppy5.0.14_WOO_AD_ONT		# Job name
#SBATCH --partition=gpu_p		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --gres=gpu:P100:1			#Requests 1 GPU devices; 
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=6	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=30G			# Memory per node (4GB); by default using M as unit
#SBATCH --time=24:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --export=NONE                   # Do not export any user’s explicit environment variables to compute node
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)


cd $SLURM_SUBMIT_DIR			# Change directory to job submission directory (Optional!)

ml purge
ml CUDAcore/11.1.1
export PATH=/software/Guppy_v5.0.14/bin:$PATH

guppy_basecaller --input_path WOO_AD_ONT_01/WOO_AD_ONT_01/20210406_1811_MN25780_FAP44387_0e3a6ab7/fast5 \
    --save_path basecalled_data/WOO_AD_ONT_01/WOO_AD_ONT_01_Guppy5.0.14_fastq \
    --config software/Guppy_v5.0.14/data/dna_r9.4.1_450bps_hac.cfg \
    --num_callers 1 \
    --cpu_threads_per_caller 6 \
    --trim_strategy dna \
    --calib_detect \
    -x auto --gpu_runners_per_device 18

#Below are now default after Guppy v5
#--qscore_filtering 
#--min_qscore 9 or 10 (9 for HAC and 10 for SUP)

#sbatch WOO_AD_ONT_01_guppy5.0.14_hac.sh
