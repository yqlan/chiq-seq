



#!/bin/sh

#PBS -N aeq_qua_check
#PBS -o seq_qua_check_log
#PBS -e seq_qua_check_err
#PBS -q medque
#PBS -l nodes=2:ppn=8
#===============================================================================================================
#calculate log2(change)
grep -v "NA" peak_regions_norm.txt |awk -vOFS='\t' '{print $0,log($4/$5)/log(2)}' > peak_regions_norm_log2.txt
#regions 2 fold higher in 4ht than no4ht
awk '($6>=2)' peak_regions_norm_log2.txt > peak_regions_norm_log2_decrease.txt 
#regions with no quantitative changes (within 2 fold)
awk '{$6>-2&&$6>2}' peak_regions_norm_log2.txt > peak_regions_norm_log2_invariant.txt
#regions 2 fold lower in 4ht than no4ht
awk '{$6>=-2}' peak_regions_norm_log2.txt > peak_regions_norm_log2_increase.txt
# count number of regions 
wc -l peak_regions_norm_log2_*.txt



