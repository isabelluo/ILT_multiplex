#! /bin/bash

current_directory=$(pwd)
refdir=$(/home/garcialab/BWA_reference/)
mkdir $current_directory/cat_Assembly
mkdir $current_directory/cat_Assembly
source activate ngs_env

# cat *.fasta | bwa index -p catted .commands to create concatenated index out of 16 files
for i in *.fastq
do
	bwa mem -M -t 8 $refdir/cat_US/catted_USregion.fasta $i | samtools sort -o cat_${i}_sort.bam
done
	 # converting alignment sam to binary bam, -S specify input sam, -b specify output bam
#sort command will sort the imput reads in genome order
 # going straight to bam should be faster. Works in less than 3 min. I have compared, there is no difference.

while read i
do
	reads=`samtools 24seqref.sort.bam $i | wc -l`
	echo " $reads is the hit of $i" >> hits.txt
done < /home/garcialab/BWA_reference/cat_US/US_16_name.txt
tail -16 hits.txt > hits.txt


for i in *.bam
do
	samtools flagsta $i > ${i:0:-4}_sams_stat.txt
	samtools depth -a $i | awk '{c++;s+=$3}END{print s/c " average depth"}' >> ${i:0:-4}_sams_stat.txt
	samtools depth -a $i | awk '{c++; if($3>200) total+=1}END{print (total/c)*100 " breadth of 200x coverage"}' >> ${i:0:-4}_sams_stat.txt
	#samtools mpileup -aa -A -d 10000000 -Q 20 $i  | bcftools consensus -f $refdir/cat_US/catted_USregion.fasta > ${i:0:-4}_consensus.fa
done
