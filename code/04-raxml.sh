#!/bin/sh
#This file is called submit-script.sh
#SBATCH --partition=shared       # default "shared", if not specified
#SBATCH --time=2-00:00:00       # run time in days-hh:mm:ss
#SBATCH --nodes=1               # require 1 nodes
#SBATCH --ntasks-per-node=1    # cpus per node (by default, "ntasks"="cpus")
#SBATCH --mem=50000            # RAM per node in megabytes
#SBATCH --error=04_raxml.err
#SBATCH --output=04_raxml.out
# Make sure to change the above two lines to reflect your appropriate
# file locations for standard error and output

# Connect to conda
source /home/bendett/miniconda3/etc/profile.d/conda.sh

conda activate raxml

DATADIR="../data/Wheat_Relative_History_Data_Glemin_et_al/OneCopyGenes"

mkdir ../results/
mkdir ../results/RAxML/

for file in "$DATADIR"/*; do
    raxml-ng --msa $file --model GTR+G4
    mv ${file}**raxml** ../results/RAxML/
done