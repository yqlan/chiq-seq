#!/bin/bash

#PBS -N raw_read_count
#PBS -o raw_read_count_log
#PBS -e raw_read_count_err
#PBS -q lowq
#PBS -l mem=20gb,walltime=100:00:00,nodes=1:ppn=1
#HSCHED -s hschedd
#===================================================================================================================
wkdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mywork
#===================================================================================================================
cd /leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/rawdata/
echo -e "sample\ttotal\tunique\tunique*100/total\tcount[maxRead]\tcount[maxRead]*100/total\tmaxRead" >> $wkdir/2_raw_read_count.txt
for sample in csh3_4OHT_h3k79me2.fastq csh3_4OHT_input.fastq csh3_no4OHT_h3k79me2.fastq csh3_no4OHT_input.fastq; do
	echo -en ${sample}"\t"
	# Number of unique reads and most repeated read
	awk -v OFS="\t" '{if((NR-2)%4==0){
			read=$1;total++;count[read]++
			}
		}END{
			for(read in count){
					if(!max||count[read]>max){max=count[read];maxRead=read};
					if(count[read]==1){unique++}
					};
			print total,unique,unique*100/total,count[maxRead],count[maxRead]*100/total,maxRead
			}' ${sample}
done >> $wkdir/2_raw_read_count.txt

