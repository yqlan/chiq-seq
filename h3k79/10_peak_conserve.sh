


#!/bin/sh

#PBS -N peak_conserve
#PBS -o peak_conserve_log
#PBS -e peak_conserve_err
#PBS -q bioque
#===============================================================================================================
cd /leofs/mishl_group/zhangjian/work/leukemia/CHIP-Seq/20110922_S210_00064_FC70EHRAAXX/
#reference= csh3_no4HT_MLL-csh3_no4HT_input
#sample= csh3_4HT_MLL-csh3_4HT_input
#overlap summit of reference confident peaks with sample enriched regions and reference control peaks
TOTAL= $(cat  csh3_no4HT_MLL-csh3_no4HT_input_macs_confident.txt |wc -l) 
#awk -v OFS='\t' '{$2=$2+$4;$3=$2+1;print $0}' csh3_no4HT_MLL-csh3_no4HT_input_macs_confident.txt |intersectBed -a stdin -b csh3_4HT_MLL-csh3_4HT_input_macs_enrichment.txt > MLL_conserve_confivsenrich.txt
wc -l MLL_conserve_confivsenrich.txt | awk -v TOTAL=$TOTAL '{print TOTAL, $1,$1*100/TOTAL}'  >statistics_MLL_conserve_confivsenrich
#intersectBed -a temp0 -b csh3_4HT_MLL-csh3_4HT_input_macs_enrichment.txt >temp1
#echo -en "$TOTAL\t$enrich\t$enrich*100/$TOTAL"

#awk -v OFS='\t' '{$2=$2+$4;$3=$2+1;print $0}' csh3_no4HT_MLL-csh3_no4HT_input_macs_confident.txt |intersectBed -a stdin -b csh3_no4HT_MLL-csh3_no4HT_input_macs_control.txt > MLL_conserve_confivscontr.txt
wc -l MLL_conserve_confivscontr.txt | awk -v TOTAL=$TOTAL '{print TOTAL, $1,$1*100/TOTAL}' > statistics_MLL_conserve_confivscontr



#reference1= csh3_no4HT_H3K79me2-csh3_no4HT_input
#sample1=csh3_4HT_H3K79me2-csh3_4HT_input
#overlap summit of reference confident peaks with sample enriched regions and reference control peaks
TOTAL1= $(cat  csh3_no4HT_H3K79me2-csh3_no4HT_input_macs_confident.txt |wc -l)
#awk -v OFS='\t' '{$2=$2+$4;$3=$2+1;print $0}'  csh3_no4HT_H3K79me2-csh3_no4HT_input_macs_confident.txt |intersectBed -a stdin -b csh3_4HT_H3K79me2-csh3_4HT_input_macs_enrichment.txt > H3K79me2_conserve_confivsenrich.txt
wc -l H3K79me2_conserve_confivsenrich.txt | awk -v TOTAL1=$TOTAL1 '{print TOTAL1,$1,$1*100/TOTAL1}' > statistics_H3K79me2_conserve_confivsenrich

#awk -v OFS='\t' '{$2=$2+$4;$3=$2+1;print $0}'  csh3_no4HT_H3K79me2-csh3_no4HT_input_macs_confident.txt |intersectBed -a stdin -b csh3_4HT_H3K79me2-csh3_4HT_input_macs_control.txt > H3K79me2_conserve_confivscontr.txt
wc -l H3K79me2_conserve_confivscontr.txt | awk -v TOTAL1=$TOTAL1 '{print TOTAL1,$1,$1*100/TOTAL1}' > statistics_H3K79me2_conserve_confivscontr



#awk -v OFS1='\t' '{$2=$2+$4;$3=$2+1;print $0}'  csh3_no4HT_H3K79me2-csh3_no4HT_input_macs_confident.txt >temp5
#enRICH=$(intersectBed -a temp5 -b csh3_no4HT_H3K79me2-csh3_no4HT_input_macs_control.txt |wc -l)
#echo -en "$TOTAL1\t$enRICH\t$enRICH*100/$TOTAL1"




