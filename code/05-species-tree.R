library(ape)
library(phangorn)
library(phytools)

tre = read.tree(file="triticeae_allindividuals_OneCopyGenes.fasta.raxml.bestTree")
plot(tre)
nodelabels()

rtre = root(tre,node = 51, resolve.root=TRUE)
plot(ladderize(rtre))

tre2 = read.tree(file="../../../data/Wheat_Relative_History_Data_Glemin_et_al/MLtree_OneCopyGenes.tree")
plot(tre2)
rtre2 = root(tre2,node = 51, resolve.root=TRUE)
plot(ladderize(rtre2))

library(phangorn)
RF.dist(tre,tre2)
