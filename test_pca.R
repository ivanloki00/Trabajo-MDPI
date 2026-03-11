load("09B_Diabetes.RData")
library(PLSandO)
library(gridExtra)

num_cols <- sapply(Diabetes_B, is.numeric)
datos_pca <- Diabetes_B[, num_cols]

cat("Applying Preparing...\n")
datos_pca_prep <- Preparing(datos_pca, CVfilter = 0.01, excludeNA = 0.2)
datos_pca_clean <- datos_pca_prep$x

cat("Dimensions of cleaned data:\n")
print(dim(datos_pca_clean))
cat("Summary of removed features/observations:\n")
print(datos_pca_prep$removed)
