#!/bin/sh
#PBS -N 4_read_map
#PBS -o 4_read_map_log
#PBS -e 4_read_map_err
#PBS -q lowq
#PBS -l mem=20gb,walltime=100:00:00,nodes=1:ppn=1
#HSCHED -s hschedd
#===================================================================================================================
wkdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mywork
rawdatadir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/rawdata
mapdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mapping
bowtieindexdir=/leofs/database/public/Reference/Mouse/ucsc/mm10/Sequence/BowtieIndex
#===============================================================================================================
cd $rawdatadir
for sample in csh3_4OHT_h3k79me2 csh3_4OHT_input csh3_no4OHT_h3k79me2 csh3_no4OHT_input; do
	bowtie -q -m 1 -v 3 --sam --best --strata  $bowtieindexdir/mm10 $sample.fastq > ${sample}.sam
done
for sample in csh3_4OHT_h3k79me2 csh3_4OHT_input csh3_no4OHT_h3k79me2 csh3_no4OHT_input; do
        # Convert file from SAM to BAM format
        samtools view -Sb ${sample}.sam > ${sample}_nonSorted.bam
        # Sort BAM file
        samtools sort ${sample}_nonSorted.bam ${sample}
        #Creat index file (BAI)
        samtools index ${sample}.bam
        #Remove intermediate files
        rm ${sample}.sam ${sample}_nonSorted.bam
done
