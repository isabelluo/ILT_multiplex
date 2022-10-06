#!/bin/bash
current_directory=$(pwd)
i=1
while [ $i -le 100 ]
do
    if test -d $current_directory/fastq/$i
    then
        cd $current_directory/fastq/$i/pass/ # copy and paste your current path before i
        cat *.fastq > ${i}_all.fastq
        porechop -i ${i}_all.fastq -b ${i}_chop_fastq \
        --require_two_barcodes --extra_end_trim 21 --adapter_threshold 50 --check_reads 1000000 > ${i}_porechopped_output.txt
        echo "${i} fastq folder done"
        ((i++))
    else
        echo "current fastq folder ${i}"
        sleep 10
    fi
    #try 200 seconds to begin with
done
