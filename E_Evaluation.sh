#!/bin/bash
#SBATCH --job-name=Homework_5		                        # Job name
#SBATCH --partition=batch		                            # Partition (queue) name
#SBATCH --ntasks=10			                                # Single task job
#SBATCH --cpus-per-task=6		                            # Number of cores per task - match this to the num_threads used by BLAST
#SBATCH --mem=40gb			                                # Total memory for job
#SBATCH --time=10:00:00  		                            # Time limit hrs:min:sec
#SBATCH --output=/work/gene8940/yl87482/log.%j			    # Location of standard output and error log files (replace cbergman with your myid)
#SBATCH --mail-user=yl87482@uga.edu                    # Where to send mail (replace cbergman with your myid)
#SBATCH --mail-type=END,FAIL                            # Mail events (BEGIN, END, FAIL, ALL)
