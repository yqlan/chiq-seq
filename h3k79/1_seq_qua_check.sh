#!/bin/sh

#PBS -N seq_qua_check
#PBS -o seq_qua_check_log
#PBS -e seq_qua_check_err
#PBS -q lowq
#PBS -l mem=20gb,walltime=100:00:00
#HSCHED -s hschedd

#===============================================================================================================
#cd /leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/chipseq_pipeline_simulation/testdata_chipseqsimu/
#for sample in chip_dmel input_dmel chip_dyak input_dyak; do
       #FASTA Statistics
#      fastx_quality_stats -i <(gunzip -c ${sample}.fastq.gz) -o ${sample}_stats.txt
       #FASTX quality score
#      fastq_quality_boxplot_graph.sh -i ${sample}_stats.txt -o ${sample}_quality.png -t ${sample} 
       #FASTX nucleotide distribution
#      fastx_nucleotide_distribution_graph.sh -i ${sample}_stats.txt -o ${sample}_nuc.png -t ${sample}
       #Remove intermediate file
#       rm ${sample}_stats.txt
#       done
cd /leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/rawdata/
for sample in  csh3_4OHT_h3k79me2.fastq csh3_4OHT_input.fastq csh3_no4OHT_h3k79me2.fastq csh3_no4OHT_input.fastq; do
	fastqc ${sample}
done

