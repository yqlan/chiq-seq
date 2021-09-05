




#!/bin/sh

#PBS -N aeq_qua_check
#PBS -o seq_qua_check_log
#PBS -e seq_qua_check_err
#PBS -q medque
#PBS -l nodes=2:ppn=8
#===============================================================================================================
#Remove regions with no reads
awk '{$4!=0&&$5!=0}' peak_regions.txt >peak_regions_no0.txt
R #enter R
library (preprocessCore)
table_pre_norm=read.table("peak_regions_no0.txt")
table_post_norm=normalize.quantiles(as.matrix(table_pre_norm[,4:5]))
write.table(cbind(table_pre_norm[,1:3],signif(table_post_norm)),"peak_regions_norm.txt",quote=F,sep="\t",row.names=F,col.names=F)
q()
n


#Remove regions with no reads
awk '{$4!=0&&$5!=0}' peak_regions1.txt >peak1_regions_no0.txt
R #enter R
library (preprocessCore)
table_pre_norm=read.table("peak1_regions_no0.txt")
table_post_norm=normalize.quantiles(as.matrix(table_pre_norm[,4:5]))
write.table(cbind(table_pre_norm[,1:3],signif(table_post_norm)),"peak1_regions_norm.txt",quote=F,sep="\t",row.names=F,col.names=F)
q()
n

