#! /bin/bash

current_directory=$(pwd)
refdir='/home/garcialab/BWA_reference'
source activate ngs_env
BWA=$current_directory/for_BWA

# cat *.fasta | bwa index -p catted .commands to create concatenated index out of 16 files
#faidx catted fasta files to create indexing for mpileup
cd $BWA
for i in *.fastq
do
	bwa mem -M -t 8 $refdir/cat_US/catted_USregion.fasta $i | samtools sort -o ${i:0:4}_sort.bam
	samtools index ${i:0:4}_sort.bam # you need a index file for it to find the read counts
done
	 # converting alignment sam to binary bam, -S specify input sam, -b specify output bam

#sort command will sort the imput reads in genome order
 # going straight to bam should be faster. Works in less than 3 min. I have compared, there is no difference.
# try this in the future: samtools coverage -r chr1:1M-12M input.bam
while read -r line
do
	for j in *.bam
	do
		mkdir ${J:0:4}_statistics
		echo " " >${J:0:4}/${j:0:-4}_hits.txt
		reads=`samtools view $j $line | wc -l`
		echo " $reads is the hit of $line" >> ${J:0:4}/${j:0:-4}_hits.txt
		samtools flagstat $j >> ${J:0:4}/${j:0:-4}_hits.txt
		samtools depth -a $j | awk '{c++;s+=$3}END{print s/c " average depth"}' >> ${J:0:4}/${j:0:-4}_hits.txt
		samtools depth -a $j | awk '{c++; if($3>20) total+=1}END{print (total/c)*100 " breadth of 20x coverage"}' >> ${J:0:4}/${j:0:-4}_hits.txt
done<$refdir/cat_US/US_16_name.txt


while read -r line
do
	for i in *.bam
	do
		mkdir contig/${i:0:4}_contig
		cd contig/${i:0:4}_contig
		samtools mpileup -aa -A -d 10000000 -Q 20 -r $line $i | ivar consensus -t .8 -m 20 -p ${i:0:4}_$line
	done
done<$refdir/cat_US/US_16_name.txt
