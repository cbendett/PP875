library(MSCquartets)

setwd("../results/") #replace PathTo with the correct path and run if not in the correct folder

gtrees=read.tree(file="09-all_gene_trees_snaq.tre")
tnames <- unique(unlist(lapply(gtrees, function(x) x$tip.label)))

QT=quartetTable(gtrees,tnames)
RQT=quartetTableResolved(QT)

pTable3=quartetTreeTestInd(RQT,"T3")
quartetTablePrint(pTable3[1:6,])

write.csv(pTable3, "11-mscquartets-ptable.csv")

df = read.csv("11-mscquartets-ptable.csv", header=TRUE)

library(dplyr)

# find the columns for each species
p1_cols   <- grep("^Ae_mutica", names(df), value = TRUE)
p2_cols     <- grep("^T_boeoticum", names(df), value = TRUE)
bicornis_cols <- grep("^Ae_bicornis", names(df), value = TRUE)


# filter rows that have exactly one "1" in each group
df_filtered <- df %>%
  filter(
    rowSums(select(., all_of(p1_cols))   == 1, na.rm = TRUE) == 1,
    rowSums(select(., all_of(p2_cols))     == 1, na.rm = TRUE) == 1,
    rowSums(select(., all_of(bicornis_cols)) == 1, na.rm = TRUE) == 1
  )

> sum(df_filtered$p_T3<0.05)/length(df_filtered$p_T3)


# Create a dataframe with p-values

outdf = data.frame(p1 = "Ae_mutica", p2 = "T_boeoticum", hybrid = "Ae_bicornis", pval = df_filtered$p_T3)

## Loop over hybrid species

hybrids = c("Ae_longissima", "Ae_sharonensis", "Ae_searsii", "Ae_tauschii", "Ae_caudata", "Ae_umbellulata", "Ae_comosa", "Ae_uniaristata")

for(h in hybrids){
    hyb_cols <- grep(h, names(df), value = TRUE)
    tmp <- df %>%
    filter(
    rowSums(select(., all_of(p1_cols))   == 1, na.rm = TRUE) == 1,
    rowSums(select(., all_of(p2_cols))     == 1, na.rm = TRUE) == 1,
    rowSums(select(., all_of(hyb_cols)) == 1, na.rm = TRUE) == 1
    )
    tmpdf = data.frame(p1 = "Ae_mutica", p2 = "T_boeoticum", hybrid=h, pval=tmp$p_T3)
    outdf = rbind(outdf,tmpdf)
}

Up until now, we have the code to reproduce the top right panel of Figure 3A, but if we want to do the whole Figure, we need to change the parents too.

```r
parents1 = c("Ae_mutica", "Ae_speltoides")
parents2 = c("T_boeoticum", "T_urartu")
hybrids = c("Ae_bicornis", "Ae_longissima", "Ae_sharonensis", "Ae_searsii", "Ae_tauschii", "Ae_caudata", "Ae_umbellulata", "Ae_comosa", "Ae_uniaristata")

for(pp1 in parents1){
    for(pp2 in parents2){
        if(pp1 == "Ae_mutica" && pp2 == "T_boeoticum") next

        p1_cols   <- grep(pp1, names(df), value = TRUE)
        p2_cols     <- grep(pp2, names(df), value = TRUE)
        for(h in hybrids){
            hyb_cols <- grep(h, names(df), value = TRUE)
            tmp <- df %>%
                filter(
                rowSums(select(., all_of(p1_cols))   == 1, na.rm = TRUE) == 1,
                rowSums(select(., all_of(p2_cols))     == 1, na.rm = TRUE) == 1,
                rowSums(select(., all_of(hyb_cols)) == 1, na.rm = TRUE) == 1
                )
            tmpdf = data.frame(p1 = pp1, p2 = pp2, hybrid=h, pval=tmp$p_T3)
            outdf = rbind(outdf,tmpdf)
        }
    }
}


## Make a violin plot 

library(ggplot2)

## Setting the hybrid order (x axis):
hybrid_order <- c(
  "Ae_bicornis", "Ae_longissima", "Ae_sharonensis",
  "Ae_searsii", "Ae_tauschii", "Ae_caudata",
  "Ae_umbellulata", "Ae_comosa", "Ae_uniaristata"
)

outdf$hybrid <- factor(outdf$hybrid, levels = hybrid_order)

hybrid_colors <- c(
  "Ae_bicornis"     = "blue3",
  "Ae_longissima"  = "hotpink",
  "Ae_sharonensis" = "darkorchid1",
  "Ae_searsii"     = "deeppink",
  "Ae_tauschii"    = "red",
  "Ae_caudata"     = "goldenrod1",
  "Ae_umbellulata" = "yellow",
  "Ae_comosa"      = "orange2",
  "Ae_uniaristata" = "sienna4"
)



ggplot(outdf, aes(x = hybrid, y = pval, fill = hybrid)) +
  geom_violin(
    trim = FALSE,
    scale = "width",
    color = NA
  ) +
  geom_boxplot(
    width = 0.12,
    outlier.shape = NA,
    alpha = 0.85
  ) +
  facet_grid(
    rows = vars(p2),
    cols = vars(p1)
  ) +
  scale_fill_manual(values = hybrid_colors, drop = FALSE) +
  scale_x_discrete(drop = FALSE) +
  geom_hline(
    yintercept = 0.05,
    linetype = "dotted",
    color = "black"
  ) +
  labs(
    x = "D focal species",
    y = "MSCQuartets p-value"
  ) +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    panel.grid.major.x = element_blank(),
    legend.position = "none"
  )