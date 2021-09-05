#!/bin/sh

#PBS -N 6_read_density_visual
#PBS -o 6_read_density_visual_log
#PBS -e 6_read_density_visual_err
#PBS -q middleq
#PBS -l mem=50gb,walltime=100:00:00,nodes=1:ppn=4
#HSCHED -s hschedd
#===================================================================================================================
wkdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile
shelldir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mywork
rawdatadir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/rawdata
mapdir=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mapping
genomechromsize=/leofs/mishl_group/lanyq/work/leukemia/chipSeq_h3k79profile/mm10.chrom.sizes
#===================================================================================================================
cd $mapdir
for sample in csh3_no4OHT_h3k79me2 csh3_no4OHT_input; do
	gunzip -c ${sample}.wig.gz | sed 's/chrom =/chrom=/' | gzip > ${sample}o.wig.gz
	mv ${sample}o.wig.gz ${sample}.wig.gz
done

for sample in csh3_4OHT_h3k79me2 csh3_4OHT_input csh3_no4OHT_h3k79me2 csh3_no4OHT_input; do
	EXTEND=220
	# Number of reads
        librarySize=$(samtools idxstats ${sample}.bam | awk '{total += $3}END{print total}')
	# gain chrom. size from ucsc
	  # fetchChromSizes mm10 > mm10.chrom.sizes
        # Create density file: extend reads, calculate read density at each position and normalize the library size to 1 million reads
        bamToBed -i ${sample}.bam | awk -v CHROM=$genomechromsize -v EXTEND=$EXTEND -v OFS='\t' 'BEGIN{while(getline<CHROM){chromSize[$1] = $2}}{chrom = $1;start = $2;end = $3;strand = $6;if(strand == "+"){end = start + EXTEND;if(end>chromSize[chrom]){end =chromSize[chrom]}};if(strand == "-"){start = end-EXTEND;if(start<1){start = 1}};print chrom,start,end}' | sort -k1,1 -k2,2n | genomeCoverageBed -i stdin -g $genomechromsize -d | awk -v OFS="\t" -v SIZE=$librarySize '{print $1,$2,$2 + 1,$3*1000000/SIZE}' | gzip > ${sample}.density.gz
        # Create WIG file
        gunzip -c ${sample}.density.gz | awk -v OFS='\t' '{if($4 != 0){if(!chrom[$1]){print "variableStep chrom="$1;chrom[$1] = 1};print $2,$4}}' 2>>err | gzip > ${sample}.wig.gz
        # Create BigWig file
        wigToBigWig ${sample}.wig.gz $genomechromsize ${sample}.bw 2>>err
        # Remove intermediate file
        rm ${sample}.wig.gz
        done

