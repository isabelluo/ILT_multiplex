#!/bin/bash
#SBATCH --job-name=canu		                        # Job name
#SBATCH --partition=batch		                            # Partition (queue) name
#SBATCH --ntasks=10			                                # Single task job
#SBATCH --cpus-per-task=6		                            # Number of cores per task - match this to the num_threads used by BLAST
#SBATCH --mem=40gb			                                # Total memory for job
#SBATCH --time=2:00:00  		                            # Time limit hrs:min:sec
#SBATCH --output=/work/gene8940/yl87482/log.%j			    # Location of standard output and error log files (replace cbergman with your myid)
#SBATCH --mail-user=yl87482@uga.edu                    # Where to send mail (replace cbergman with your myid)
#SBATCH --mail-type=END,FAIL                            # Mail events (BEGIN, END, FAIL, ALL)

mkdir /work/mg2lab/denovo_canu.dir
mkdir /work/mg2lab/denovo_canu.dir/correct_trim.dir
OUTDIR="/work/mg2lab/denovo_canu.dir/trim.dir"
REFDIR="/work/mg2lab/MinIONdata"
DATA=`ls /work/mg2lab/MinIONdata | grep *.fastq`

module load canu/1.9-GCCcore-8.3.0-Java-11 MUMmer/3.23_conda QUAST/5.0.2-foss-2019b-Python-3.7.
###########set up variables and downlaod references#########
for i in $DATA
do
  mkdir $OUTDIR/${i:0:(-6)}.dir
  canu -p ${i:0:(-6)} -d $OUTDIR/${i:0:(-6)}.dir genomeSize=13k useGrid=false -nanopore $i
  quast.py -o $OUTDIR/${i:0:(-6)}.dir -t 6 -r $REFDIR/24_sequence_USregion_cons.fasta $i
  nucmer $REFDIR/24_sequence_USregion_cons.fasta $OUTDIR/${i:0:(-6)}.dir/${i:0:(-6)}.contigs.fasta -p mum_canu_${i:0:(-6)}
  delta-filter -1 $OUTDIR/${i:0:(-6)}.dir/mum_canu_${i:0:(-6)}.delta > $OUTDIR/${i:0:(-6)}.dir/mum_canu_${i:0:(-6)}.1delta
  mummerplot --size large -layout --color -f --png $OUTDIR/${i:0:(-6)}.dir/mum_canu_${i:0:(-6)}.1delta -p mplot_${i:0:(-6)}
done
