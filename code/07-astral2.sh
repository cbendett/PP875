#!/bin/sh
#This file is called submit-script.sh
#SBATCH --partition=shared       # default "shared", if not specified
#SBATCH --time=2-00:00:00       # run time in days-hh:mm:ss
#SBATCH --nodes=1               # require 1 nodes
#SBATCH --ntasks-per-node=1    # cpus per node (by default, "ntasks"="cpus")
#SBATCH --mem=50000            # RAM per node in megabytes
#SBATCH --error=07_astral2.err
#SBATCH --output=07_astral2.out
# Make sure to change the above two lines to reflect your appropriate
# file locations for standard error and output

# Connect to conda
source /home/bendett/miniconda3/etc/profile.d/conda.sh

conda activate astral

cd ../results

astral4 -i 04-all_gene_trees.tre -a 07-species_mapping.txt -o 07-species-tree-astral4.tre
