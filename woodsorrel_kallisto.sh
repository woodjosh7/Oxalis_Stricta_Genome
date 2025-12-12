#!/bin/bash
#SBATCH --job-name=woodsorrel_kallisto		# Job name 
#SBATCH --partition=batch		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=10	 	# CPU core count per task, by default 1 CPU core per task
#SBTACH --array=1-57				# Array element range from 0 to 1, i.e. 2 element jobs
#SBATCH --mem=50G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=24:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

#INFILE=woodsorrel_rnaseq_exp_ab_kallisto_filelist.txt

SAMPLE=`head -n ${SLURM_ARRAY_TASK_ID} ${INFILE} | cut -f 1 | tail -n 1`
TOTAL_CLEANED_READS=`head -n ${SLURM_ARRAY_TASK_ID} ${INFILE} | cut -f 2 | tail -n 1`

ml purge
ml kallisto/0.48.0-gompi-2020b
ml seqtk/1.3-GCC-10.2.0

#Pseudoalignment requires processing a transcriptome file to create a “transcriptome index”
#Example: kallisto index -i oxst_v3.working_models.repr.cdna.fa.idx oxst_v3.working_models.repr.cdna.fa

if [ $TOTAL_CLEANED_READS -gt 62000000 ]; then 
    seqtk sample -s100 trimmed_reads/${SAMPLE}_PE1_cutadapt.fq.gz 62000000 > trimmed_reads/${SAMPLE}_PE1_cutadapt_subsampled.fq.gz
    seqtk sample -s100 trimmed_reads/${SAMPLE}_PE2_cutadapt.fq.gz 62000000 > trimmed_reads/${SAMPLE}_PE2_cutadapt_subsampled.fq.gz
	
	#Working Models - k31
	kallisto quant -i oxst_v3.working_models.repr.cdna.fa.idx \
	-o working_models_k31/${SAMPLE} \
	--rf-stranded -t 10 \
	trimmed_reads/${SAMPLE}_PE1_cutadapt_subsampled.fq.gz \
	trimmed_reads/${SAMPLE}_PE2_cutadapt_subsampled.fq.gz

	#HC Models - k31
	kallisto quant -i oxst_v3.hc_gene_models.repr.cdna.fa.idx \
	-o hc_models_k31/${SAMPLE} \
	--rf-stranded -t 10 \
	trimmed_reads/${SAMPLE}_PE1_cutadapt_subsampled.fq.gz \
	trimmed_reads/${SAMPLE}_PE2_cutadapt_subsampled.fq.gz
else
	#Working Models - k31
	kallisto quant -i oxst_v3.working_models.repr.cdna.fa.idx \
	-o working_models_k31/${SAMPLE} \
	--rf-stranded -t 10 \
	trimmed_reads/${SAMPLE}_PE1_cutadapt.fq.gz \
	trimmed_reads/${SAMPLE}_PE2_cutadapt.fq.gz

	#HC Models - k31
	kallisto quant -i oxst_v3.hc_gene_models.repr.cdna.fa.idx \
	-o hc_models_k31/${SAMPLE} \
	--rf-stranded -t 10 \
	trimmed_reads/${SAMPLE}_PE1_cutadapt.fq.gz \
	trimmed_reads/${SAMPLE}_PE2_cutadapt.fq.gz
fi

#Parameters
#seqtk sample subsamples reads to value. Be sure to use same seed (-s) for paired end files 
#kallisto quant runs the quantification algorithm: kallisto quant -i -o 
#-i: Filename for the kallisto index to be used for quantification
#-o:  Directory to write output to
#--single: Quantify single-end reads
#--rf-stranded: Strand specific reads, first read reverse
#-t: threads to use

#Single End Mode
#For single-end mode you supply the --single flag, as well as the -l and -s options
#In the case of single-end reads, the -l option must be used to specify the average fragment length. Typical Illumina libraries produce fragment lengths ranging from 180–200 bp but it’s best to determine this from a library quantification with an instrument such as an Agilent Bioanalyzer. For paired-end reads, the average fragment length can be directly estimated from the reads and the program will do so if -l is not used (this is the preferred run mode). For reads that are produced by 3’-end sequencing, the --single-overhang option does not discard reads where the expected fragment size goes beyond the transcript start.

#sbatch --array 1-57 --export=INFILE=woodsorrel_rnaseq_exp_ab_kallisto_filelist.txt woodsorrel_kallisto.sh
