#!/bin/bash
current_directory=$(pwd)
mkdir for_BWA

cd final_analysis
for item in *fastq
do
  centrifuge -p 4 -k 50 -q -x vert_virusALL_08122022_GRCg7b_index -S ${item:0:4}_report.csv --report-file ${item:0:4}_report.tsv $item
  awk -F'\t' '$1 ~ /Gallid alphaherpesvirus 1|herpesvirus/ {print $2}' ${item:0:4}_report.tsv >> ILTV_TaxID.txt
done


for c in *csv
do
	awk 'NR == FNR {
		 patt[$0]; next
		}
	{
        for (p in patt)
        	if ($3 ~ p) print $1
            }' ILTV_TaxID.txt $c > "${c:0:4}"_ILTV_ReadIDs.txt
done


for Read in  *_ReadIDs.txt
do
	grep -A3 -f $Read ${Read:0:4}.fastq > $current_directory/for_BWA/${Read:0:-4}.fq
	grep -v -Fx -- -- $current_directory/for_BWA/${Read:0:-4}.fq > $current_directory/for_BWA/${Read:0:-4}.fastq
  	LINES=`cat $current_directory/for_BWA/${Read:0:-4}.fastq | wc -l`
  	SEQUENCES=`expr $LINES / 4`
  	echo "${Read:0:-4} $SEQUENCES" >> $current_directory/for_BWA/output_num.txt
done
