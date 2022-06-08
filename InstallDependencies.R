#!/bin/bash
#Sys.setenv(R_LIBS_SITE="/scratch/PROLFQUA/r-site-library/")

args = commandArgs(trailingOnly = TRUE)
gitProject = args[1]
Rpackage = args[2]


if(length(args) == 0){
    gitProject = "wolski"
    Rpackage = "prolfqua"
} else {
    gitProject = args[1]
    Rpackage = args[2]
}

cat(">>>>>",Rpackage, "\n")
paths <- .libPaths()[1]

if (!grepl(Rpackage, paths)) {
    cat(paths)
    stop("ERROR : no custom install directory!")
}

if (dir.exists(paths)) {
    cat(">>> reinstalling packages")
    install.packages(c("devtools", "remotes", "pkgdown", "BiocManager"),
                     repos = "https://cloud.r-project.org", verbose = 'FALSE', type = 'source')

    BiocManager::install("BiocCheck")
    remotes::install_github("russHyde/dupree")

}

test_dir = paste0("test_build_", Rpackage,"/")
cat(">>>> setting up the build directory ", Rpackage, "in folder :", test_dir,"\n")

dir.create(test_dir)
setwd(test_dir)

# setting site library to check also that all dependencies are correctly installed.

repository = paste0("https://github.com/", gitProject, "/", Rpackage)
message(">>>> cloning repository: ", repository)
retval = system2("git", args = c("clone", repository))

if (retval != 0) {
    stop("Can not clone : ", repository, "\n")
}

if (dir.exists(Rpackage)) {
    message(">>> installing package dependencies for : ", Rpackage)
    install.packages("devtools", repos = 'https://cloud.r-project.org' )
    devtools::install_dev_deps(Rpackage, quiet = FALSE, type = "source", repos = "https://cloud.r-project.org" )
    devtools::install_dev_deps(Rpackage, quiet = FALSE, type = "binary", repos = "https://cloud.r-project.org" )
}

cat("\n\n\n >>>> PREINSTALLED DEPENDENCIES <<<< \n\n\n")

