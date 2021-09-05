#!/bin/bash

#PBS -N 8_peak_calling
#PBS -o 8_peak_calling_log
#PBS -e 8_peak_calling_err
#PBS -q middleq
#PBS -l mem=20gb,walltime=100:00:00,nodes=1:ppn=1
#HSCHED -s hschedd
#===================================================================================================================
wkdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile
shelldir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mywork
rawdatadir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/rawdata
mapdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mapping
genomechromsize=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mm10.chrom.sizes
#===================================================================================================================
#cd $mapdir
#for pair in csh3_4OHT_h3k79me2-csh3_4OHT_input csh3_no4OHT_h3k79me2-csh3_no4OHT_input; do
#	echo -en $pair"\t"
#	chip=$(echo $pair | sed 's/-.*//')
#	input=$(echo $pair | sed 's/.*-//')
	# RUN MACS
#	GEN_SIZE=$(awk '{size+=$2}END{print size}' $genomechromsize)
#	READ_LEN=81
#	PVALUE=1e-3
#	macs14 -t ${chip}.bam -c ${input}.bam --name=${pair}_macs_p03 --format=BAM --gsize=$GEN_SIZE --tsize=$READ_LEN --pvalue=$PVALUE -mfold=10,30 2 > ${pair}_macs_p03.log
	# print shift d (2*d=genomic fragment length)
	#grep "# d=" ${pair}_macs_p05_peaks.xls |awk '{print $4}'
	# check warnings
	#grep "WARNING" ${pair}_macs_p05.log
	# Remove intermediate files
	#rm ${pair}_macs_p05{.log,_model.r,_negative_peaks.xls,_peaks.bed}
#done


# Number of peaks at different FDR thresholds
cd $wkdir
(echo -e "peaks_num_at_diff_fdr_thresholds"
echo -e "FDR\tAll\t5\t1\t0"
for pair in csh3_4OHT_h3k79me2-csh3_4OHT_input csh3_no4OHT_h3k79me2-csh3_no4OHT_input; do
	echo -en $pair
	for fdr in 100 5 1 0; do
		echo -en "\t"$(grep -v "#" ${pair}_macs_p03_peaks.xls | awk -v FDR=$fdr '(NR>1&&$9<=FDR)' | wc -l)
		done
      		echo
done) > 8_peak_calling.txt

# Define confident peaks (FDR), enriched regions (p-value<=10e-3) and control peaks
FDR=1
for pair in csh3_4OHT_h3k79me2-csh3_4OHT_input csh3_no4OHT_h3k79me2-csh3_no4OHT_input; do
	# confident peaks
	grep -v "#" ${pair}_macs_p03_peaks.xls | awk -v OFS='\t' -v fdr=$FDR '{if(NR>1&&$9<=fdr){print $1,$2,$3,$5,$7,$8,$9}}' > ${pair}_macs_confident.txt 2>>8_peakcall.err
        # Regions with significant enrichment
        grep -v "#" ${pair}_macs_p03_peaks.xls | awk -v OFS='\t' '{if(NR>1){print $1,$2,$3,$5,$7,$8,$9}}' > ${pair}_macs_enriched_regions_p03.txt 2>>8_peakcall.err
        # Control peaks
        shuffleBed -i ${pair}_macs_enriched_regions_p03.txt -g $genomechromsize -chrom | sort -k1,1 -k2,2n > ${pair}_macs_control.txt 2>>8_peakcall.err
done
