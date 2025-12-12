#!/bin/bash
#SBATCH --job-name=woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x3		# Job name 
#SBATCH --partition=buell_p,highmem_p		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=20	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=600G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=36:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml Pilon/1.24-Java-11

java -Xmx600G -jar $EBROOTPILON/pilon-1.24.jar --genome polishing/woodsorrel/pilon_x2/woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.fasta \
--frags bwa_mem_mapping/woo_aa_aln_to_woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x2.marked_dup.sorted.bam \
--fix bases \
--output woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x3 \
--outdir polishing/woodsorrel/pilon_x3/

#Parameters 
#pilon --genome genome.fasta [--frags frags.bam] [--jumps jumps.bam] [--unpaired unpaired.bam] [...other options...]
#--genome genome.fasta
#          The input genome we are trying to improve, which must be the reference used
#          for the bam alignments.  At least one of --frags or --jumps must also be given.
#--frags frags.bam
#          A bam file consisting of fragment paired-end alignments, aligned to the --genome
#          argument using bwa or bowtie2.  This argument may be specifed more than once.
#--jumps jumps.bam
#          A bam file consisting of jump (mate pair) paired-end alignments, aligned to the
#          --genome argument using bwa or bowtie2.  This argument may be specifed more than once.
#--unpaired unpaired.bam
#          A bam file consisting of unpaired alignments, aligned to the --genome argument 
#          using bwa or bowtie2.  This argument may be specifed more than once.
#--bam any.bam
#         A bam file of unknown type; Pilon will scan it and attempt to classify it as one
#          of the above bam types.
#--output prefix
#          Prefix for output files
#--outdir directory
#          Use this directory for all output files.
#--fix fixlist
#          A comma-separated list of categories of issues to try to fix:
#            "snps": try to fix individual base errors;
#            "indels": try to fix small indels;
#            "gaps": try to fill gaps;
#            "local": try to detect and fix local misassemblies;
#            "all": all of the above (default);
#            "bases": shorthand for "snps" and "indels" (for back compatibility);
#            "none": none of the above; new fasta file will not be written.
#Notes: Larger genomes will require more memory to process; exactly how much is very data-dependent, but as a rule of thumb, try to allocate 1GB per megabase of input genome to be processed.

#sbatch woodsorrel_v0.1_racon_x2_medaka_x2_pilon_x3.sh
