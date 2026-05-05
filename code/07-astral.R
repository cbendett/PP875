library(ape)

setwd("../results/")

### Individual Level
tre = read.tree(file="07-individual-species-tree-astral4.tre")
plot(tre)
rtre = root(tre,outgroup="H_vulgare_HVens23", resolve.root=TRUE)
plot(rtre)


### Species Level
##First we get all the individual names
genes_dir <- "../data/Wheat_Relative_History_Data_Glemin_et_al/OneCopyGenes/"
gene_files<-paste(genes_dir,list.files(genes_dir,pattern='\\.aln$'),sep='')

all_individuals <- character()
i<-1
for(f in gene_files){
  headers <- rownames(read.dna(f, format = "fasta"))
  all_individuals <- unique(c(all_individuals, headers))
}
all_individuals <- sort(all_individuals) # Sort alphabetically for consistency
all_individuals

cleaned_individuals <- sub("_[^_]+$", "", all_individuals)

#map all individuals to species
mapping <- paste(all_individuals,cleaned_individuals)
writeLines(mapping, "../results/07-species_mapping.txt") ## write to file