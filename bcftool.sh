#!/bin/bash
#SBATCH --job-name=bcf_consensus                       # Job name
#SBATCH --partition=batch		                            # Partition (queue) name
#SBATCH --ntasks=10			                                # Single task job
#SBATCH --cpus-per-task=6		                            # Number of cores per task - match this to the num_threads used by BLAST
#SBATCH --mem=40gb			                                # Total memory for job
#SBATCH --time=2:00:00  		                            # Time limit hrs:min:sec
#SBATCH --output=log.%j			    # Location of standard output and error log files (replace cbergman with your myid)
#SBATCH --mail-user=yl87482@uga.edu                    # Where to send mail (replace cbergman with your myid)
#SBATCH --mail-type=END,FAIL                            # Mail events (BEGIN, END, FAIL, ALL)

module load BWA/0.7.17-GCC-8.3.0 SAMtools/1.10-GCC-8.3.0 BCFtools/1.10.2-GCC-8.3.0
mkdir /work/mg2lab/bcf.dir
mkdir /work/mg2lab/bcf.dir/untrim.dir
OUTDIR="/work/mg2lab/bcf.dir/untrim.dir"
REFDIR="/work/mg2lab/MinIONdata"
DATA=`ls /work/mg2lab/MinIONdata | grep .fastq`


for i in $DATA
do
  mkdir $OUTDIR/${i:0:(-6)}.dir
  bwa mem -M -t 8 $REFDIR/cat_US/catted_USregion.fasta $REFDIR/$i | samtools sort -o $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}_sort.bam
  samtools index $OUTDIR/${i:0:(-6)}_sort.bam # you need a index file for it to find the read counts
  bcftools mpileup -Oz --threads 6 --min-MQ 60 -f $REFDIR/cat_US/catted_USregion.fasta $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}_sort.bam \
  > $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.mpileup.vcf.gz
  bcftools call -Oz -m -v --threads 6 --ploidy 1 $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.mpileup.vcf.gz > $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.mpileup.call.vcf.gz
  bcftools filter -Oz -e 'QUAL<40 || DP<10' $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.mpileup.call.vcf.gz > $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.mpileup.call.filter.vcf.gz
  bcftools index $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.mpileup.call.vcf.gz
  bcftools index $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.mpileup.call.filter.vcf.gz
  time bcftools consensus -f $REFDIR/cat_US/catted_USregion.fasta -o $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.mpileup.call.fasta $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.mpileup.call.vcf.gz
  time bcftools consensus -f $REFDIR/cat_US/catted_USregion.fasta -o $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.mpileup.filter.fasta $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.mpileup.call.filter.vcf.gz
done
