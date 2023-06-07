# ILT_multiplex
pipeline design for ILT_multiplex

Function of each script
  
  A_fast5_guppy.sh
    
    Script A_fast5_guppy.sh archived the raw data under the “fast5” directory in chronological order and identified these directories in numerical order. Further, the script executes Guppy(v6.4.6) for       
    basecalling the archived "fast5" files and yielded sequence containing "fastq" files archived in the same numerical order under a separate fastq directory. Guppy is also responsible of 
    quality filtering (Qscore ≥ 7) and demultiplexing the reads based on the barcodes detected to identify reads from different samples. Executing this script in the terminal shows responsive information on
    which directory it is currently base calling and in total how many fast5 files are currently being base called. 
    
  B_porechop.sh
  
    Script B_porechop.sh goes through each individual reads within each barcoded files and excise the barcode sequence as well as the adapter sequences off of each reads prior for analysis.
  
  C_Cat_Barcodes.sh
    
    Script C_Cat_Barcodes.sh serves to organize the reads demultiplexed from different archived directories and concatenate these reads with the same barcodes into the same file
    
  D_classification.sh
  
    Script D_classification.sh executives Centrifute (v1.0.4) to screen for reads specifically for ILTV virus and discard the reads sequence from host genome. Then the ILTV specific reads from each sample
    is archived before proceeding to the consensus building.
    
  E_BWA.sh
    
    Script E_BWA.sh excutes program BWA (v.0.7.17) and Samtools (v.1.6) to map the reads to reference ILTV before proceeding to consensus builder in Genious prime. 
  
