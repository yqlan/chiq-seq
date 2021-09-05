#!/bin/sh

#PBS -N 5_map_read_count
#PBS -o 5_map_read_count_log
#PBS -e 5_map_read_count_err
#PBS -q lowq
#PBS -l mem=20gb,walltime=100:00:00,nodes=1:ppn=1
#HSCHED -s hschedd
#===================================================================================================================
wkdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mywork
rawdatadir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/rawdata
mapdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mapping
#===================================================================================================================
cd $mapdir

echo -e "sample\tRAW\ttotal\ttotal*100/RAW\tunique\tunique*100/total\tmaxCoor\tcount[maxCoor]\tcount[maxCoor]*100/total\tnonmapped_total" >> $wkdir/5_map_read_count.txt

for sample in csh3_4OHT_h3k79me2 csh3_4OHT_input csh3_no4OHT_h3k79me2 csh3_no4OHT_input; do
	echo -en "$sample\t"
        # Number of raw reads
        raw=$(samtools view ${sample}.bam | wc -l)
        # Number of raw, unique and most repeated reads
        bamToBed -i ${sample}.bam | awk -v RAW=$raw '{coordinates = $1":"$2"-"$3;total ++;count[coordinates] ++}END{for(coordinates in count){if(!max||count[coordinates]>max){max = count[coordinates];maxCoor = coordinates};if(count[coordinates] == 1){unique ++}};printf RAW "\t" total "\t" total*100/RAW "\t" unique "\t" unique*100/total "\t" maxCoor "\t" count[maxCoor] "\t" count[maxCoor]*100/total "\t"}'
        # Total and top 10 of non-mapped reads
        samtools view -f 0x0004 ${sample}.bam | awk '{read = $10;total ++;count[read] ++}END{print total}'
done >> $wkdir/5_map_read_count.txt

