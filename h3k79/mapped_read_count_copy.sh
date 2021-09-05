



#!/bin/sh

#PBS -N map_read_count
#PBS -o map_read_count_copy_log_plus
#PBS -e map_read_count_copy_err_plus
#PBS -q bioque

#===============================================================================================================
cd /leofs/mishl_group/zhangjian/work/leukemia/CHIP-Seq/20110922_S210_00064_FC70EHRAAXX/
for sample in csh3_4HT_MLL csh3_4HT_H3K79me2 csh3_4HT_input csh3_no4HT_MLL csh3_no4HT_H3K79me2 csh3_no4HT_input; do
        echo -en $sample"\t";
        #Number of raw reads
     #   raw=$(/software/biosoft/bin/samtools view ${sample}.bam |wc -l)
        
        #Number of raw ,unique and most repeated reads
     #  /software/biosoft/bin/bamToBed -i ${sample}.bam > ${sample}.bed.zj
     #  awk -v RAW=$raw '{coordinates=$1":"$2"-"$3;total++;count[coordinates]++}END{for(coordinates in count){if(!max||count[coordinates]>max){max=count[coordinates];maxCoor=coordinates};if (count[coordinates]==1){unique++}};print RAW,total, total*100/RAW,unique, unique*100/total,maxCoor,count[maxCoor],count[maxCoor]*100/total}' ${sample}.bed.zj
        # Total and top 10 of non-mapped reads
     #  /software/biosoft/bin/samtools view -f 0x0004 ${sample}.bam > ${sample}.tem_nonmapped
     #   awk '{read=$10;total++;count[read]++}END{print "Total_non-mapped_reads" ,total ; for(read in count){print read, count[read]+0}}' ${sample}.tem_nonmapped > ${sample}.presort
        sort -k2,2nr ${sample}.presort |head -11 
done


