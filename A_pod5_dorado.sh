#!/bin/bash
#fast5_pod5_dorado.sh
current_directory=$(pwd) # no spaces when defining a variable
dorado download --model dna_r9.4.1_e8_hac@v3.3
THREAD=4
QFILTER=10

## dorado ... \
      #  | samtools bam2fq -@ ${THREADS} -T 1 \
     # | tee >( grep '[qs] < ${QFILTER}}' -o ${OUTPUT}.fail.bam - ) \
     #   | grep '[qs] >= ${QFILTER}' -o ${OUTPUT}.pass.bam -
     ### not sure what will emit fastq file like. 
i=1
while [ $i -le 100 ] # to call out a variable in the commands, use dollar sign
do
    pod5files=`ls $current_directory/pod5/ | grep ".pod5" | wc -l`
    if [ ! -d $current_directory/pod5/$i ]  #make directory if none
    then
        mkdir $current_directory/pod5/$i # copy and paste your path for the current directory
        if [ $pod5files -ge 2 ] # move the files when there are two fast5 files, just helps me count
        then
            mv $current_directory/pod5/*.pod5 $current_directory/pod5/$i/.
            dorado basecaller  --min-qscore 7 --emit-fastq --device cuda:auto dna_r9.4.1_e8_hac@v3.3 $current_directory/pod5/$i/. > $current_directory/fastq/$i/.
            echo "${i} folder ${pod5files} files"
            ((i++))
        else
          sleep 30 # sleep if there is no files generated
        fi
    elif test -d $current_directory/fastq/$i #just in case some one close the terminal in the middle of running guppy, this line will finish the work
    then
        dorado basecaller --min_qscore 7 --emit-fastq --device cuda:auto dna_r9.4.1_e8_hac@v3.3 $current_directory/pod5/$i/. > $current_directory/fastq/$i/.
        ((i++))
    elif [ $fast5files -ge 2 ] # move the files onece there are more the 2 fast5 files generated to preven empty folder
    then
        mv $current_directory/pod5/*.pod5 $current_directory/pod5/$i/.
        dorado basecaller --min-qscore 7 --emit-fastq --device cuda:auto dna_r9.4.1_e8_hac@v3.3 $current_directory/pod5/$i/. > $current_directory/fastq/$i/.
        echo "${i} folder ${pod5files} files " # optional,but it will tell you how many folders is in each files
        ((i++)) # increases i by 1 each time
    else
        sleep 30
        echo "current basecalling folder ${i}" # you could know whether things are still running
    fi
done
# what if you turn off the window accidentally, how can you start basecalling again?
