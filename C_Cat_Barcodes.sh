#!/bin/bash
current_directory=$(pwd)
mkdir $current_directory/final_analysis
i=1
while [ $i -le 100 ] # set the -le as the amount of folders you wanted to analyze
do
    if test -d $current_directory/fastq/$i/pass/${i}_chop_fastq # I have run into problems once with this line and meant to change in the future
    then
        cd $current_directory/fastq/$i/pass/${i}_chop_fastq/ # change the path prior fastq to the current directory
        for item in *.fastq
        do
            cat $item >> $current_directory/final_analysis/$item # change the path prior final_anlaysis to the current directory
        done
        echo "concatenated ${i}_chop_fastq folders "
        ((i++))
    else
        echo "current working folder ${i}_chop_fastq folders "
        sleep 60
    fi
done
