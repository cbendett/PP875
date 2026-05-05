#!/bin/sh
#This file is called submit-script.sh
#SBATCH --partition=shared       # default "shared", if not specified
#SBATCH --time=2-00:00:00       # run time in days-hh:mm:ss
#SBATCH --nodes=1               # require 1 nodes
#SBATCH --ntasks-per-node=1    # cpus per node (by default, "ntasks"="cpus")
#SBATCH --mem=50000            # RAM per node in megabytes
#SBATCH --error=10_hyde_windows.err
#SBATCH --output=10_hyde_windows.out
# Make sure to change the above two lines to reflect your appropriate
# file locations for standard error and output

# Connect to conda
source /home/bendett/miniconda3/etc/profile.d/conda.sh


DATADIR="10concatenation10Mb_OneCopy-phylip-ch3"
mkdir HyDe/
mkdir HyDe/10Mb-concatenation-ch3

for file in "$DATADIR"/*; do
	echo "Processing file: $file"
    
    # 1. Extract the filename from the path
    filename=$(basename "$file")
    
    # 2. Remove the extension
    base="${filename%.*}"

    run_hyde.py -i "$file" -m 07-species_mapping.txt -o H_vulgare -n 47 -t 17 -s 11354214 --prefix "HyDe/10Mb-concatenation-ch3/$base"
done

ls -lh