# Models

# Cluster Analysis on all countries

# Load required package
library(cluster)

df_cluster <- df_transformed%>%
  select(-v2x_regime, -regime_type)

# Select the columns to be used for clustering
cluster_cols <- c("most_recent_perc", "v2x_freexp_altinf", "v2cldiscm", "v2cldiscw", "v2mecenefi", "v2smgovdom", "v2smgovshutcap", "v2smgovshut", "v2smgovsmmon", "v2smgovsmcenprc", "v2smarrest", "v2smorgavgact", "v2smorgelitact", "smorg_st_protests", "smorg_particip", "smorg_violence")

# Scale the data
scaled_data <- scale(df_cluster[, cluster_cols])

# Determine the optimal number of clusters (elbow method)
wss <- sapply(1:10, function(k) {
  kmeans(scaled_data, k, nstart = 10)$tot.withinss})

plot(1:10, wss, type = "b", xlab = "Number of clusters", ylab = "Within groups sum of squares")

# Run k-means clustering with the chosen number of clusters
num_clusters <- 4
kmeans_result <- kmeans(scaled_data, centers = num_clusters, nstart = 25)

# Add the cluster assignments to the original dataframe
df_cluster$cluster <- kmeans_result$cluster


#Plot 
cluster_plot <- ggplot(df_cluster, aes(x = most_recent_perc, y = v2x_freexp_altinf, color = factor(cluster))) + 
  geom_point() +
  labs(x = "Internet Access", y = "Freedom of Speech", color = "Cluster") #+
#geom_text(aes(label = Economy), hjust = 0, vjust = 0)

cluster_plot







# Perform PCA
pca <- prcomp(normalized_data_autocracies, center = TRUE, scale. = TRUE)
# Extract the loadings
loadings <- pca$rotation[, 1:2]
# Compute the scores
scores <- as.data.frame(pca$x[, 1:2])
# Add the Economy and cluster information
scores <- cbind(Economy = df_cluster_autocracies$Economy, 
                scores, 
                cluster = df_cluster_autocracies$cluster)


cluster_plot_autocracies <- ggplot(scores, aes(x = PC1, y = PC2, color = factor(cluster))) + 
  geom_point() +
  labs(x = "PC1", y = "PC2", color = "Cluster") +
  geom_text(aes(label = Economy), hjust = 0, vjust = 0)

cluster_plot_autocracies
