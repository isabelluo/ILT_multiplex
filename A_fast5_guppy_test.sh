#!/bin/bash
#fast5_guppy_sweep.sh
#last variable (currently 30 sec) for the guppy command is the seconds of delay
current_directory=$(pwd) # no spaces when defining a variable

i=1
while [ $i -le 100 ] # to call out a variable in the commands, use dollar sign
do
    if [ ! -d $current_directory/fast5/$i ]
    then
        mkdir $current_directory/fast5/$i # copy and paste your path for the current directory
        fast5files=`ls $current_directory/fast5/ | grep ".fast5" | wc -l`
    elif [ $fast5files -ge 2 ] # move the files onece there are more the 2 fast5 files generated
    then
        mv $current_directory/fast5/*.fast5 $current_directory/fast5/$i/. # copy and paste your path for the current directory
        guppy_basecaller --input_path $current_directory/fast5/$i --save_path $current_directory/fastq/$i --flowcell FLO-MIN106 --kit SQK-LSK109 --device auto --calib_detect
        # the save path should be in fastq folder # specify your kit and flowcell
        echo "${i} folder ${fast5files} files " # optional,but it will tell you how many folders is in each files
        ((i++)) # increases i by 1 each time
    elif test -d $current_directory/fastq/$i #try to let it skip to the largest one?
    then
        guppy_basecaller --input_path $current_directory/fast5/$i --save_path $current_directory/fastq/$i --flowcell FLO-MIN106 --kit SQK-LSK109 --device auto --calib_detect
        ((i++))
    else
        sleep 5
        echo "current basecalling folder ${i}"
    fi
done
# what if you turn off the window accidentally, how can you start basecalling again?
