#!/bin/bash
current_directory=$(pwd)
final_analysis=$current_directory/final_analysis
mkdir for_BWA

cd $final_analysis

for item in *.fastq
do
    centrifuge -p 4 -k 50 -q -x vert_virusALL_08122022_GRCg7b_index -S $final_analysis/${item:0:4}_report.csv --report-file $final_analysis/${item:0:4}_report.tsv $item
done
awk -F'\t' '$1 ~ /Gallid alphaherpesvirus 1|herpesvirus/ {print $2}' *_report.tsv > ILTV_TaxID.txt
for c in *.csv
do
	awk 'NR == FNR {
		 patt[$0]; next
		}
	{
        for (p in patt)
        	if ($3 ~ p) print $1
            }' ILTV_TaxID.txt $c > "${c:0:4}"_ILTV_ReadIDs.txt
done


for Read in *_ReadIDs.txt
do
	grep -A3 -f $Read ${Read:0:4}.fastq > $final_analysis/${Read:0:-4}.fq
	grep -v -Fx -- -- ${Read:0:-4}.fq > $final_analysis/${Read:0:-4}.fastq
  sequences=`grep -o "read" $final_analysis/${Read:0:-4}.fastq | wc -l`
	echo "${Read:0:-4} $sequences" >> $current_directory/for_BWA/output_num.txt
	cp $final_analysis/${Read:0:-4}.fastq $current_directory/for_BWA/.
done