#!/bin/Rscript
#Sys.setenv(R_LIBS_SITE="/scratch/PROLFQUA/r-site-library/")

args = commandArgs(trailingOnly = TRUE)
branchname = NULL
if (length(args) > 0) {
  Gitproject = args[1]
  Rpackage = args[2]
  if ( length(args) == 3 ) {
    branchname = args[3]
  }
} else {
  Gitproject = "wolski"
  Rpackage = "prolfquabenchmark"
  branchname = "main"
}



cat(">>>>>",Rpackage, "\n")

test_dir = paste0("test_build_", Rpackage, "/")
setwd(test_dir)
repository = paste0("https://github.com/", Gitproject, "/", Rpackage)

if (TRUE) {

  if (!dir.exists(Rpackage)) {
    message(">>>> cloning repository: ", repository)
    if (is.null(branchname)) {
      args = c("clone", repository)
    } else {
      args = c("clone", repository, "-b", branchname)
    }
    retval = system2("git", args = args)

    if (retval != 0) {
      stop("Can not clone : ", repository, "\n")
    }
  }

  retval = system2("R", args = c("CMD", "build", "--log", Rpackage))
  if (retval != 0) {
    stop("ERROR :", Rpackage, "package build failed!")
  }

  message(">>> running Rpackage check on: ", Rpackage)
  pat = paste0(Rpackage, "_[0-9].*.tar.gz")
  packagetar = dir(".", pattern = pat)
  retval = system2("R", args = c("CMD", "check", packagetar))
  if (retval != 0) {
    stop("ERROR : ", Rpackage, " package check failed!")
  }

  if (TRUE) {
    message(">>> running Rpackage check CRAN on: ", Rpackage)
    pat = paste0(Rpackage, "_[0-9].*.tar.gz")
    packagetar = dir(".", pattern = pat)
    retval = system2("R", args = c("CMD", "check", "--as-cran", packagetar))
    if (retval != 0) {
      stop("ERROR : ", Rpackage, " package check failed!")
    }
    message(">>> running BiocCheck for Rpackage :", packagetar)
    BiocCheck::BiocCheck(packagetar)

  }


  message(">>> installing the package ", packagetar, "\n")
  retval = system2("R", args = c("CMD", "INSTALL", packagetar))
  if (retval != 0) {
    stop("ERROR : ", Rpackage, " package installation failed!")
  }
  wd = getwd()
  setwd(Rpackage)
  cat(" >>>>>> RUN EXAMPLES <<<<< ")
  devtools::run_examples(pkg = ".")
  cat(" >>>>>> BUILD_SITES <<<<< ")
  message(">>> running Rpackagedown for Rpackage",  Rpackage)
  pkgdown::build_site_github_pages(pkg = ".", dest_dir = "docs")
  setwd(wd)
}


## checking in the gh-pages
if (TRUE) {
  message(">>>> cloning gh-pages branch repository: ", repository)
  ghpagesFolder = paste0("gh-pages-", Rpackage)
  if (dir.exists(ghpagesFolder)) {
    unlink(ghpagesFolder, recursive = TRUE, force = TRUE)
  }
  retval = system2("git",
   args = c("clone", "-b", "gh-pages",  repository, ghpagesFolder))
  if (retval != 0) {
    stop("ERROR : could not clone gh-pages ", ghpagesFolder)
  }
  system(paste0("rm -r ", ghpagesFolder, "/*"))
  file.copy(dir(file.path(Rpackage, "docs"), full.names=TRUE), ghpagesFolder, recursive = TRUE)
  setwd(ghpagesFolder)
  system("git add .")
  system('git commit -m "next doc version"')
  system("git push")

  setwd("..")

}
setwd("..")
