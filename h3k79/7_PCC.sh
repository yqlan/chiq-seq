



#!/bin/sh

#PBS -N PCC
#PBS -o PCC_log
#PBS -e PCC_err
#PBS -q bioque
#===============================================================================================================
cd /leofs/mishl_group/zhangjian/work/leukemia/CHIP-Seq/20110922_S210_00064_FC70EHRAAXX/
for pair in csh3_4HT_MLL-csh3_4HT_input csh3_4HT_H3K79me2-csh3_4HT_input csh3_no4HT_MLL-csh3_no4HT_input csh3_no4HT_H3K79me2-csh3_no4HT_input csh3_4HT_MLL-csh3_no4HT_MLL csh3_4HT_H3K79me2-csh3_no4HT_H3K79me2 ;do
       echo -en $sample"\t"
       chip=$(echo $pair | sed 's/-.*//')
       input=$(echo $pair | sed 's/.*-//')


       gunzip -c ${chip}.density.gz > 1.density
       gunzip -c ${input}.density.gz > 2.density

       paste 1.density 2.density  > 3.density
       awk '{if($2!=$6){exit 1};if($4!=0||$8!=0){print $4,$8}}' 3.density | correlation.awk

       rm 1.density
       rm 2.density
       rm 3.density
done



