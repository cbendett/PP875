library(ape)
library(phangorn)
library(phytools)
library(ggplot2)

pdf("../figures/08-Fig1B.pdf") # set the graphics device for all plots

setwd("../results/RAxML/10Mb-concatenation/")


### From Fig1A
tree1 = read.tree(file="../full-concatenation/triticeae_allindividuals_OneCopyGenes.fasta.raxml.bestTree")
tree1 = root(tree1,outgroup="H_vulgare_HVens23", resolve.root=TRUE)
tree1 <- ladderize(tree1)


tree_files <-list.files(pattern="\\.raxml.bestTree$") #List all .bestTree files. $ ensures the end of the name

trees<- list() # list with all the trees
class(trees)<- "multiPhylo" #make it a multiphylo object for ease of use with other 

i<-1
for(tree_file in tree_files){ ##go thru each file and read the tree
  trees[[i]]<- read.tree(tree_file)
  i<-i+1
}

#re-reroot all our gene trees by the respective outgroup
for(i in 1:length(trees)){
  trees[[i]]<- root(trees[[i]],
                         outgroup = "H_vulgare_HVens23",
                         resolve.root=TRUE)
  trees[[i]]<-chronos(trees[[i]]) ## make ultrametric for nicer densitree
}

st<-superTree(trees)
st<-root(st,"H_vulgare_HVens23",resolve.root = T)

tree1ultra = chronos(tree1)

png(filename="../../../figures/figure1b.png", width = 1800, height = 900, units = "px")
par(mfrow=c(1,2), mar = c(0.1, 0.1, 0.1, 0.1))
plot(tree1ultra, show.tip.label = FALSE)
densiTree(trees,consensus=tree1, direction='leftwards', scaleX=T,type='cladogram', alpha=0.1)
dev.off()


### ASTRAL Tree
tree3 = read.tree(file="../../07-individual-species-tree-astral4.tre")
tree3 = root(tree3,outgroup="H_vulgare_HVens23", resolve.root=TRUE)

par(mfrow=c(1,2), mar = c(0.1, 0.1, 0.1, 0.1))
plot(tree1)
plot(tree3)

RF.dist(tree1,tree3)

tree4 = read.tree(file="../../07-species-tree-astral4.tre")
tree4 = root(tree4,outgroup="H_vulgare", resolve.root=TRUE)

par(mfrow=c(1,2), mar = c(0.1, 0.1, 0.1, 0.1))
plot(tree1)
plot(tree4)

dev.off() # close the graphics device - the pdf we named at the beginning