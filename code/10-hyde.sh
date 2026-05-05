#!/bin/sh
#This file is called submit-script.sh
#SBATCH --partition=shared       # default "shared", if not specified
#SBATCH --time=2-00:00:00       # run time in days-hh:mm:ss
#SBATCH --nodes=1               # require 1 nodes
#SBATCH --ntasks-per-node=1    # cpus per node (by default, "ntasks"="cpus")
#SBATCH --mem=50000            # RAM per node in megabytes
#SBATCH --error=10_hyde.err
#SBATCH --output=10_hyde.out
# Make sure to change the above two lines to reflect your appropriate
# file locations for standard error and output

# Connect to conda
source /home/bendett/miniconda3/etc/profile.d/conda.sh

conda activate hyde

run_hyde.py -i 10-triticeae_allindividuals_OneCopyGenes.phylip \
-m 07-species_mapping.txt \
-o H_vulgare -n 47 -t 17 -s 11354214 --prefix 10-hyde-job

ls -lh