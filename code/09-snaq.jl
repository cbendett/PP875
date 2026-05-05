# add the packages you need
import Pkg; Pkg.add("PhyloNetworks")
import Pkg; Pkg.add("SNaQ")

# and now inside Julia
using Distributed
addprocs(4)

@everywhere using PhyloNetworks
@everywhere using SNaQ

## read table of CF
d_sp = readtableCF("09-tableCF_species.csv"); # "DataCF" object for use in snaq!
#read in the species tree from ASTRAL as a starting point
T_sp = readnewick("07-species-tree-astral4.tre")

# starting tree
# data w/ concordance factor
# number of parallel searches
# number of times to test neighbors
# output file
# seed stops
net = snaq!(T_sp, d_sp, runs=100, Nfail=200, filename= "09-snaq-h1",seed=8485);