#!/bin/bash
#SBATCH --job-name=woo_wgs_aln_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2		# Job name 
#SBATCH --partition=buell_p,highmem_p		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=30	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=250G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=36:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=BEGIN,END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml BWA/0.7.17-GCC-8.3.0
ml SAMtools/1.10-GCC-8.3.0
ml picard/2.21.6-Java-11

#Check for BWA index & create if missing
FILE=polishing/woodsorrel/pilon_x2/woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.fasta.bwt
if [ -f "$FILE" ] && [ -s "$FILE" ]; then
    echo "$FILE exists and is not empty. Start Alignment."
else 
    echo "$FILE does not exist or is empty. Creating Index."
    bwa index polishing/woodsorrel/pilon_x2/woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.fasta
fi

#BWA MEM alignment
bwa mem -t 30 polishing/woodsorrel/pilon_x2/woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.fasta \
trimmed_reads/woo_aa_PE1_cutadapt.fq.gz \
trimmed_reads/woo_aa_PE2_cutadapt.fq.gz \
> bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.sam

#QueryName Sort Input
java -Xmx200G -jar $EBROOTPICARD/picard.jar SortSam \
I=bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.sam  \
O=bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.picard_qname_sorted.sam \
SORT_ORDER=queryname


#Mark duplicates with PICARD tools
java -Xmx100G -jar $EBROOTPICARD/picard.jar MarkDuplicates \
I=bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.picard_qname_sorted.sam \
O=bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.picard_qname_sorted.marked_dup.sam \
M=bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.marked_dup_metrics.txt \
ASSUME_SORT_ORDER=queryname

samtools sort -@ 30 \
-o bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.marked_dup.sorted.bam \
bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.picard_qname_sorted.marked_dup.sam

#FILE=bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2.marked_dup.sorted.bam
#if [ -f "$FILE" ] && [ -s "$FILE" ]; then
#    echo "$FILE exists and is not empty. Deleting sam files."
#    rm bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2.sam
#    rm bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2.marked_dup.sam
#else 
#    echo "$FILE does not exist or is empty. Error in SAMTools sort or MarkDuplicates."
#fi

#Index marked duplicate BAM
samtools index -@ 30 bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.marked_dup.sorted.bam

#Parameters
#bwa index [-p prefix] [-a algoType] <in.db.fasta>

#bwa mem [-t nThreads] db.prefix reads.fq [mates.fq]
#-t: Number of Threads

#samtools sort -o aln.sorted.bam aln.sam 
#-@: Number of Threads
#-o: Output to a file
#-O: Output format (Default: BAM)

#java -jar picard.jar MarkDuplicates \
#I=input.bam \
#O=marked_duplicates.bam \
#M=marked_dup_metrics.txt

#samtools index (defaults to BAI)
#-@: Number of Threads

#sbatch woo_wgs_aln_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.sh
