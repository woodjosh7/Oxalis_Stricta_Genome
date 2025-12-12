#!/bin/bash
#SBATCH --job-name=woo_raw_ont_minimap2_aln_woodsorrel_v0.1_racon_x1		# Job name 
#SBATCH --partition=buell_p,batch		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=20	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=80G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=24:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml minimap2/2.22-GCC-8.3.0
ml SAMtools/1.10-GCC-8.3.0

minimap2 -ax map-ont -t 20 polishing/woodsorrel/woodsorrel_v0.1_racon_x1.fasta \
basecalled_data/woo_all_guppy5.0.14_10kb.fastq \
> minimap2_aln/woodsorrel/woo_all_guppy5.0.14_10kb_on_woodsorrel_v0.1_racon_x1.sam

#Racon needs SAM so no point in sorting and compressing into BAM

#samtools sort -@ 20 -o minimap2_aln/woodsorrel/woo_all_guppy5.0.14_10kb_on_woodsorrel_v0.sorted.bam \
#minimap2_aln/woodsorrel/woo_all_guppy5.0.14_10kb_on_woodsorrel_v0.sam

#FILE=minimap2_aln/woodsorrel/woo_all_guppy5.0.14_10kb_on_woodsorrel_v0.sorted.bam
#if [ -f "$FILE" ] && [ -s "$FILE" ]; then
#    echo "$FILE exists and is not empty. Deleting sam file."
#    rm minimap2_aln/woodsorrel/woo_all_guppy5.0.14_10kb_on_woodsorrel_v0.sam
#else 
#    echo "$FILE does not exist or is empty. Error in SAMTools sort."
#fi

#Parameters - Map long noisy genomic reads
#minimap2 -ax map-ont ref.fa ont-reads.fq > aln.sam      # for Oxford Nanopore reads
#-a: Generate CIGAR and output alignments in the SAM format. Minimap2 outputs in PAF by default.
#-x: Preset []. This option applies multiple options at the same time. It should be applied before other options because options applied later will overwrite the values set by -x.
#-x map-ont: map-ont uses ordinary minimizers as seeds (The default setting is the same as map-ont) Slightly more sensitive for Oxford Nanopore to reference mapping (-k15). For PacBio reads, HPC minimizers consistently leads to faster performance and more sensitive results in comparison to normal minimizers. For Oxford Nanopore data, normal minimizers are better, though not much. The effectiveness of HPC is determined by the sequencing error mode
#--sam-hit-only: In SAM, don’t output unmapped reads.
#-t: Number of Threads

#sbatch woo_raw_ont_minimap2_aln_woodsorrel_v0.1_racon_x1.sh
