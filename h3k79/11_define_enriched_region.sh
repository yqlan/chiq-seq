#!/bin/sh

#PBS -N 11_def_enri_region
#PBS -o 11_def_enri_region_log
#PBS -e 11_def_enri_region_err
#PBS -q largeq
#PBS -l mem=120gb,walltime=100:00:00,nodes=1:ppn=2
#HSCHED -s hschedd
#===================================================================================================================
#===================================================================================================================
wkdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile
shelldir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mywork
rawdatadir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/rawdata
mapdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mapping
genomechromsize=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mm10.chrom.sizes
#===================================================================================================================
#===================================================================================================================
cd $wkdir
# Define regions with a confident peak in any sample as the region around the peak summit
SIZE=150  #around peak summit =300bp ~ genomic fragment length
for pair in csh3_4OHT_h3k79me2-csh3_4OHT_input csh3_no4OHT_h3k79me2-csh3_no4OHT_input; do
	awk -v OFS='\t' -v SIZE=$SIZE '{s=$2+$4-SIZE;e=$2+$4+SIZE;print $1,s,e}' ${pair}_macs_confident.txt
done | sort -k1,1 -k2,2n | mergeBed -i stdin > peak_regions.txt
# For each sample and each region add the ration of chip_read_density /input_read_density
awk 'BEGIN{chrom["X"]="chrX";chrom["Y"]="chrY";for(i=1;i<=19;i++){chrom[i]="chr"i}}{for(chr in chrom){if($1==chrom[chr]){print $0 >> chrom[chr]"_peak_regions.txt"}}}' peak_regions.txt

#===================================================================================================================
#===================================================================================================================

for pair in csh3_4OHT_h3k79me2-csh3_4OHT_input csh3_no4OHT_h3k79me2-csh3_no4OHT_input; do
	chip=$(echo $pair |sed 's/-.*//')
	input=$(echo $pair |sed 's/.*-//')
#===================================================================================================================
	# Maximum chip read density for each region
	gunzip -c ${chip}.density.gz 2>>err1 | awk -v CHIP=$chip 'BEGIN{chrom["X"]="chrX";chrom["Y"]="chrY";for(i=1;i<=19;i++){chrom[i]="chr"i}}{for(chr in chrom){if($1==chrom[chr]){print $0 >> CHIP"_"chrom[chr]".density"}}}' 2>>err2
	for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chrX chrY; do 
	intersectBed -a ${chr}_peak_regions.txt -b ${chip}_${chr}.density -wao 2>>err3 | awk '{peak=$1":"$2":"$3;if(old&&peak!=old){print max[old]+0; delete max[old]};if((!max[peak])||max[peak]<$(NF-1)){max[peak]=$(NF-1)};old=peak}END{print max[old]+0}' 2>>err4 >tmp_${chip}_${chr}
	gzip ${chip}_${chr}.density
	done
	mkdir ${chip}.density_allchr
	mv ${chip}_chr*.density.gz ${chip}.density_allchr
	for chr in chr1 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19  chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chrX chrY; do
	cat tmp_${chip}_${chr}
	done > tmp_${chip}
	mkdir tmp_csh3_${chip}_allchr
	mv tmp_${chip}_chr* tmp_csh3_${chip}_allchr
#===================================================================================================================
	# Maxmum input read density for each region  
	gunzip -c ${input}.density.gz 2>>err5 | awk -v INPUT=$input 'BEGIN{chrom["X"]="chrX";chrom["Y"]="chrY";for(i=1;i<=19;i++){chrom[i]="chr"i}}{for(chr in chrom){if($1==chrom[chr]){print $0 >> INPUT"_"chrom[chr]".density"}}}' 2>>err6
	for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chrX chrY; do
 	intersectBed -a ${chr}_peak_regions.txt -b ${input}_${chr}.density -wao 2>>err7 | awk '{peak=$1":"$2":"$3;if(old&&peak!=old){print max[old]+0; delete max[old]};if((!max[peak])||max[peak]<$(NF-1)){max[peak]=$(NF-1)};old=peak}END{print max[old]+0}' 2>>err8 >tmp_${input}_${chr}
	gzip ${input}_${chr}.density
	done
	mkdir ${input}.density_allchr
	mv ${input}_chr*.density.gz ${input}.density_allchr
	for chr in chr1 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19  chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chrX chrY; do
        cat tmp_${input}_${chr}
        done > tmp_${input}
        mkdir tmp_csh3_${input}_allchr
        mv tmp_${input}_chr* tmp_csh3_${input}_allchr
#===================================================================================================================
	# Ratio chip/input
	paste tmp_${chip} tmp_${input}| awk '{if($2==0){print "NA""(chip_max_read_densi:"$1")"}else{print $1/$2}}' | paste peak_regions.txt - > tmp_${pair}
	mv tmp_${pair} peak_regions_${pair}_ratio.txt
#	rm tmp_${chip} tmp_${input}
done
