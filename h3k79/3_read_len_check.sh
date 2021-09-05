#!/bin/bash

#PBS -N 3_read_len_check
#PBS -o 3_read_len_check_log
#PBS -e 3_read_len_check_err
#PBS -q lowq
#PBS -l mem=20gb,walltime=100:00:00,nodes=1:ppn=1
#HSCHED -s hschedd
#===================================================================================================================
wkdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mywork
rawdatadir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/rawdata
mapdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mapping
#===================================================================================================================
cd $rawdatadir
echo -e "sample\tread_length\tread_num" >> $wkdir/3_read_len_check.txt
for sample in csh3_4OHT_h3k79me2.fastq csh3_4OHT_input.fastq csh3_no4OHT_h3k79me2.fastq csh3_no4OHT_input.fastq; do
	echo -en ${sample}"\t"
	# Read length
	awk -v OFS="\t" '{if((NR-2)%4==0){count[length($1)]++}}END{for(len in count){print len,count[len]}}' ${sample}
	# truncate longer reads to 36bp (if nesessary)
	#LEN=36
	#awk -v LEN=$LEN '{if((NR-2)%2==0){print substr($1,1,LEN)}else{print $0}}' ${sample}.fastq | gzip > ${sample}_36bp.fastq.gz
done >> $wkdir/3_read_len_check.txt

