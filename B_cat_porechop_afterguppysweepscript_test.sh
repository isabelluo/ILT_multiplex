#!/bin/bash
current_directory=$(pwd)
i=1
while [ $i -le 100 ]
do # I am trying to avoid changing working directories but I dont know how to do it
  cat $current_directory/fastq/$i/pass/*.fastq > ${i}_all.fastq
  porechop -i ${i}_all.fastq -b ${i}_chop_fastq \
  --check_reads 1000000 > ${i}_porechopped_output.txt
  echo "${i} fastq folder done"
  ((i++))
done
