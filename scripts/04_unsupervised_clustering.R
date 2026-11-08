# ==============================================================================
# Script:      04_unsupervised_clustering.R
# Description: Unsupervised clustering comparing K-Means and Ward's Hierarchical
#              clustering with Silhouette coefficient validation.
# ==============================================================================

library(cluster)

data(iris)
iris_features <- iris[, 1:4]
true_species  <- iris$Species

cat("\n========================================================================\n")
cat("  UNSUPERVISED LEARNING: K-MEANS VS. WARD'S HIERARCHICAL CLUSTERING\n")
cat("========================================================================\n")

# 1. K-Means (k = 3)
set.seed(123)
km_res <- kmeans(iris_features, centers = 3, nstart = 25)
cat("K-Means Konvergenz erreicht mit Between/Total SS Ratio:",
    round(km_res$betweenss / km_res$totss * 100, 2), "%\n")

# 2. Hierarchische Clusteranalyse (Ward.D2)
dist_mat <- dist(iris_features)
hclust_ward <- hclust(dist_mat, method = "ward.D2")
hclust_clusters <- cutree(hclust_ward, k = 3)

# 3. Silhouette-Validierung
sil_km <- silhouette(km_res$cluster, dist_mat)
sil_hc <- silhouette(hclust_clusters, dist_mat)

avg_sil_km <- mean(sil_km[, 3])
avg_sil_hc <- mean(sil_hc[, 3])

cat(sprintf("Mittlere Silhouette-Breite - K-Means: %.4f | Hierarchisch (Ward): %.4f\n",
            avg_sil_km, avg_sil_hc))

# Kreuztabellen mit tatsächlichen Klassen
cat("\nKreuztabelle K-Means vs. Tatsächliche Spezies:\n")
print(table(Cluster = km_res$cluster, Species = true_species))

cat("\nKreuztabelle Hierarchisch vs. Tatsächliche Spezies:\n")
print(table(Cluster = hclust_clusters, Species = true_species))
