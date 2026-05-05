#!/bin/sh
#This file is called submit-script.sh
#SBATCH --partition=shared       # default "shared", if not specified
#SBATCH --time=2-00:00:00       # run time in days-hh:mm:ss
#SBATCH --nodes=1               # require 1 nodes
#SBATCH --ntasks-per-node=1    # cpus per node (by default, "ntasks"="cpus")
#SBATCH --mem=50000            # RAM per node in megabytes
#SBATCH --error=07_supertree.err
#SBATCH --output=07_supertree.out
# Make sure to change the above two lines to reflect your appropriate
# file locations for standard error and output

# Connect to conda
source /home/bendett/miniconda3/etc/profile.d/conda.sh

conda activate supertree

cd ../results

java -jar SuperTriplets_v1.1.jar 04-all_gene_trees.tre 07-supertree.tre
