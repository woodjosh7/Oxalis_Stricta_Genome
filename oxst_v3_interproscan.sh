#!/bin/bash
#SBATCH --job-name=oxst_v3_interproscan	# Job name 
#SBATCH --partition=highmem_p		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=24	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=500G			# Memory per node (30GB); by default using M as unit
#SBATCH --time=72:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --output=%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)

ml purge
ml InterProScan/5.69-101.0-foss-2022a

interproscan.sh -i oxst_v3.working_models.pep.for_interproscan.fa \
-f tsv -cpu 24 \
-goterms \
-o oxst_v3.working_models.iprscan_output.tsv

#Parameters
#interproscan.sh -i test_all_appl.fasta -f tsv
#-i: input file (defaults to proteins)
#-o: output
#-f: output format
#-cpu: threads to use
#-goterms: Optional, switch on lookup of corresponding Gene Ontology annotation 

#sbatch oxst_v3_interproscan.sh
