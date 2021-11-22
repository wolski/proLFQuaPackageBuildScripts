#!/bin/bash
#Sys.setenv(R_LIBS_SITE="/scratch/PROLFQUA/r-site-library/")

reinstall = FALSE
args = commandArgs(trailingOnly = TRUE)
Rpackage = args[1]

cat(">>>>>",Rpackage, "\n")
cat(">>>>> reinstall", reinstall , "\n")

if (length(args) == 2) {
    reinstall = TRUE
}

paths <- .libPaths()[1]

if (!grepl(Rpackage, paths)) {
    cat(paths)
    stop("ERROR : no custom install directory!")
}

if (dir.exists(paths) && reinstall) {
    cat(">>> reinstalling packages")
    install.packages(c("devtools", "remotes","pkgdown","BiocManager"),
                     repos = "https://cloud.r-project.org",verbose = 'FALSE',type="binary")
    BiocManager::install("BiocCheck")
    remotes::install_gitlab("wolski/prolfquaData",
                            host = "gitlab.bfabric.org")
}

test_dir = paste0("test_build", Rpackage,"/")
cat(">>>> setting up the build directory ", Rpackage, "in folder :", test_dir,"\n")

if (dir.exists(test_dir)) {
    cat(">>>> removing dir")
    tmp <- unlink(test_dir,recursive = TRUE)
    tmp
}

dir.create(test_dir)
setwd(test_dir)

# setting site library to check also that all dependencies are correctly installed.

repository = paste0("https://github.com/wolski/", Rpackage)
message(">>>> cloning repository: ", repository)
retval = system2("git", args = c("clone", repository))

if (retval != 0) {
    stop("Can not clone : ",repository, "\n")
}


if (dir.exists(paths) && reinstall) {
    message(">>> installing package dependencies for : ", Rpackage)
    devtools::install_dev_deps(Rpackage, quiet = TRUE, type="binary")
}

cat("\n\n\n >>>> PREINSTALLED DEPENDENCIES <<<< \n\n\n")
