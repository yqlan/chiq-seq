#!/bin/bash

#PBS -N 9_peak_visual
#PBS -o 9_peak_visual_log
#PBS -e 9_peak_visual_err
#PBS -q middleq
#PBS -l mem=50gb,walltime=10:00:00,nodes=1:ppn=4
#HSCHED -s hschedd
#===================================================================================================================
wkdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile
shelldir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mywork
rawdatadir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/rawdata
mapdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mapping
genomechromsize=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mm10.chrom.sizes
#===================================================================================================================
cd $wkdir
for pair in csh3_4OHT_h3k79me2-csh3_4OHT_input csh3_no4OHT_h3k79me2-csh3_no4OHT_input; do
	# Create BED files
	(echo -e "track name=\"${pair}_confident_peaks\" description=\"${pair}_confident_peaks\" visibility=2"
	sort -k5,5gr ${pair}_macs_confident.txt | awk -v OFS='\t' '{print $1,$2,$3,"PEAK_"NR,$5,"."}' | sort -k1,1 -k2,2n) | gzip > ${pair}_macs_confident.bed.gz
	(echo -e "track name=\"${pair}_enriched_regions\" description=\"${pair}_enriched_regions\" visibility=2"
	sort -k5,5gr ${pair}_macs_enriched_regions_p03.txt | awk -v OFS='\t' '{print $1,$2,$3,"PEAK_"NR,$5,"."}' | sort -k1,1 -k2,2n) | gzip > ${pair}_macs_enrichment.bed.gz
done
