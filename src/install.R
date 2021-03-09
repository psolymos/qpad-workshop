cat("Helo!\n\nThis script will install required R packages for the\nPoint Count Data AnalysisWorkshop.\n\nHang tight ...\n\n* Checking R version ... ")
if (getRversion() < 4)
  stop(paste0("R version ", getRversion(), " detected.",
    " Please upgrade to R >= 4.0"))
cat("OK\n* Installing R packages ... \n")

pkgs <- c("bookdown", "detect", "remotes", "dismo",
  "Distance", "forecast", "glmnet", "gbm", "intrval",
  "knitr", "lme4", "maptools", "mefa4",
  "mgcv", "MuMIn", "opticut", "partykit", "pscl", "raster",
  "ResourceSelection", "shiny", "sp", "unmarked", "visreg")
gh_pkgs <- c(bSims="psolymos/bSims",
             QPAD="psolymos/QPAD",
             paired="borealbirds/paired",
             lhreg="borealbirds/lhreg")

to_inst <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_inst))
  try(install.packages(to_inst))
for (i in gh_pkgs)
  try(remotes::install_github(i, upgrade="never", force=FALSE))

still_missing <- setdiff(c(pkgs, names(gh_pkgs)), rownames(installed.packages()))
if (length(still_missing)) {
  cat("\nThe following packages could not be installed:\n",
    paste("\t-", still_missing, collapse="\n"), "\n")
} else {
  cat("\nYou are all set! See you at the workshop.\n")
}
