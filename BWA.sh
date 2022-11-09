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
	seqkit rmdup $i -s -o ${i}_clean_.fastq
	bwa mem -M -t 8 $refdir/cat_US/catted_USregion.fasta ${i}_clean_.fastq | samtools sort -o ${i:0:4}_clean_sort.bam
	samtools index ${i:0:4}_clean_sort.bam # you need a index file for it to find the read counts
done
	 # converting alignment sam to binary bam, -S specify input sam, -b specify output bam

#sort command will sort the imput reads in genome order
 # going straight to bam should be faster. Works in less than 3 min. I have compared, there is no difference.
# try this in the future: samtools coverage -r chr1:1M-12M input.bam
while read -r line
do
	for j in *.bam
	do
		mkdir ${j:0:4}_statistics
		echo " " >${j:0:4}_statistics/${j:0:-4}_hits.txt
		reads=`samtools view $j $line | wc -l`
		echo " $reads is the hit of $line" >> ${j:0:4}_statistics/${j:0:-4}_hits.txt
	done
done<$refdir/cat_US/US_16_name.txt

for j in *.bam
do
	samtools depth -a $j | awk '{c++;s+=$3}END{print s/c " average depth"}' > ${j:0:4}_statistics/${j:0:-4}_stats.txt
	samtools depth -a $j | awk '{c++; if($3>20) total+=1}END{print (total/c)*100 " breadth of 20x coverage"}' > ${j:0:4}_statistics/${j:0:-4}_stats.txt
	samtools flagstat $j >> ${j:0:4}_statistics/${j:0:-4}_hits.txt
done

while read -r line
do
	for i in *.bam
	do
		mkdir ${i:0:4}_contig
		samtools mpileup -aa -A -d 10000000 -Q 20 -r $line $i | ivar consensus -t .8 -m 20 -p ${i:0:4}_$line
		cat *.fa > ${i:0:4}.fa
		mv *.fa ${i:0:4}_contig
		mv *.txt ${i:0:4}_contig
	done
done<$refdir/cat_US/US_16_name.txt

# samtools tview -p US01:100 *bam -- reference /home/garcialab/BWA_reference/cat_US/catted_USregion.fasta
# viewing alignment, can specify the primer pairs that wants to view and the location of that particular pair to start.
