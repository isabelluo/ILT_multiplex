#!/bin/bash
current_directory=$(pwd)
final_analysis=$current_directory/final_analysis
mkdir for_BWA
data=`ls $final_analysis | grep .fastq`
summery=`ls $final_analysis | grep .csv`
reads=`ls $final_analysis | grep _ReadIDs.txt`

for item in $data
do
    centrifuge -p 4 -k 50 -q -x vert_virusALL_08122022_GRCg7b_index -S $final_analysis/${item:0:4}_report.csv --report-file $final_analysis/${item:0:4}_report.tsv $item
	awk -F'\t' '$1 ~ /Gallid alphaherpesvirus 1|herpesvirus/ {print $2}' $final_analysis/${item:0:4}_report.tsv >> ILTV_TaxID.txt
done


for c in $summery
do
	awk 'NR == FNR {
		 patt[$0]; next
		}
	{
        for (p in patt)
        	if ($3 ~ p) print $1
            }' ILTV_TaxID.txt $c > "${c:0:4}"_ILTV_ReadIDs.txt
done


for Read in $reads
do
	grep -A3 -f $Read ${Read:0:4}.fastq > $current_directory/for_BWA/${Read:0:-4}.fq
	grep -v -Fx -- -- $current_directory/for_BWA/${Read:0:-4}.fq > $current_directory/for_BWA/${Read:0:-4}.fastq
  sequences=`grep -o "read" $final_analysis/${Read:0:-4}.fastq | wc -l`
	echo "${Read:0:-4} $sequences" >> $current_directory/for_BWA/output_num.txt
done
