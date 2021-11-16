#!/bin/bash
#Sys.setenv(R_LIBS_SITE="/scratch/PROLFQUA/r-site-library/")

reinstall = FALSE
args = commandArgs(trailingOnly = TRUE)
Rpackage = args[1]
# Rpackage = 'prolfqua'

cat(">>>>>",Rpackage, "\n")

test_dir = paste0("test_build", Rpackage,"/")
dir.create(test_dir)
setwd(test_dir)


if (!dir.exists(Rpackage)) {
  repository = paste0("https://github.com/wolski/", Rpackage)
  message(">>>> cloning repository: ", repository)
  retval = system2("git", args = c("clone", repository))

  if (retval != 0) {
    stop("Can not clone : ",repository, "\n")
  }
}

retval = system2("R", args = c("CMD","build", "--log", Rpackage))
#devtools::build("prolfqua")
if (retval != 0) {
  stop("ERROR :", Rpackage,"package build failed!")
}

message(">>> running Rpackage check on ", Rpackage)
pat = paste0(Rpackage, "_0.*.tar.gz")
packagetar = dir(".",pattern = pat)
retval = system2("R", args = c("CMD","check", packagetar))
if (retval != 0) {
  stop("ERROR : ",Rpackage , " package check failed!")
}

message(">>> running biocheck for Rpackage")
BiocCheck::BiocCheck(packagetar)
message(">>> running Rpackagedown for Rpackage")

retval = system2("R", args = c("CMD","INSTALL", packagetar))
if (retval != 0) {
  stop("ERROR : ",Rpackage , " package installation failed!")
}

cat(" >>>>>> RUN EXAMPLES <<<<< ")
devtools::run_examples(pkg = Rpackage)
cat(" >>>>>> BUILD_SITES <<<<< ")

pkgdown::build_site(pkg = Rpackage)

setwd("..")

