

# general plot utility functions
source("plot.R", local=TRUE)

# display labels for regions, clusters, subclusters
source("display_labels.R", local=TRUE)

# filtering on [sub]clusters
source("cell_types.R", local=TRUE)

# choosing a current [sub]cluster selection among the filtered options
# for marker filtering and plotting
source("user_cluster_selection.R", local=TRUE)  

# filtering on differentially expressed genes for the current [sub]cluster selection
source("markers.R", local=TRUE)    

# plots for both cluster and subcluster with overlays for labels, gene expression and components
source("tSNE.R", local=TRUE)  

# differential expression
source("diffex.R", local=TRUE)

# metacells - scatter plots, heatmaps
source("metacells.R", local=TRUE)

# independent components
source("components.R", local=TRUE)

