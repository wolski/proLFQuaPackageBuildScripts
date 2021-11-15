#!/bin/bash
#Sys.setenv(R_LIBS_SITE="/scratch/PROLFQUA/r-site-library/")

Rpackage = commandArgs(trailingOnly = TRUE)

install.packages("devtools", "remotes", repos="https://cloud.r-project.org")
remotes::install_gitlab("wolski/prolfquaData", host="gitlab.bfabric.org")


test_dir = paste0("./test_build", Rpackage,"/")
cat("running package checks for ", Rpackage, "in folder :", test_dir,"\n")

if(dir.exists(test_dir)){
  cat("removing dir")
  unlink(test_dir,recursive = TRUE, force = TRUE )
}

dir.create(test_dir)
setwd(test_dir)

# setting site library to check also that all dependencies are correctly installed.

repository = paste0("https://github.com/wolski/", Rpackage)
message(">>> cloning repository: ",repository)
retval = system2("git", args = c("clone", repository))
if(retval != 0){
  stop("Can not clone : ",repository, "\n")
}

message(">>> building Rpackage: ", Rpackage)


devtools::install_dev_deps("prolfqua", quiet = TRUE)
retval = system2("R", args = c("CMD","build", "--log", Rpackage))
#devtools::build("prolfqua")
if(retval != 0){
  stop("Could not build: ", Rpackage,"!")
}

message(">>> running Rpackage check on ", Rpackage)
pat = paste0(Rpackage, "0.*.tar.gz")
packagetar = dir(".",pattern = pat)
retval = system2("R", args = c("CMD","check", packagetar))
if(retval != 0){
  stop("Rpackage check failed")
}

message(">>> running biocheck for Rpackage")
BiocCheck::BiocCheck(packagetar)
message(">>> running Rpackagedown for Rpackage")

pkgdown::build_site(pkg = Rpackage)

setwd("..")

