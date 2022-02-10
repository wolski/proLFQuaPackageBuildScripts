#!/bin/Rscript
#Sys.setenv(R_LIBS_SITE="/scratch/PROLFQUA/r-site-library/")

args = commandArgs(trailingOnly = TRUE)
if (length(args) > 0) {
  Gitproject = args[1]
  Rpackage = args[2]
  # Rpackage = 'prolfqua'

} else {
  Gitproject = "wolski"
  Rpackage = "prolfquabenchmark"
}

cat(">>>>>",Rpackage, "\n")

test_dir = paste0("test_build_", Rpackage, "/")
setwd(test_dir)


if (!dir.exists(Rpackage)) {
  repository = paste0("https://github.com/", Gitproject, "/", Rpackage)
  message(">>>> cloning repository: ", repository)
  retval = system2("git", args = c("clone", repository))

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

if (FALSE) {
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

cat(" >>>>>> RUN EXAMPLES <<<<< ")
devtools::run_examples(pkg = Rpackage)
cat(" >>>>>> BUILD_SITES <<<<< ")

message(">>> running Rpackagedown for Rpackage",  Rpackage)

pkgdown::build_site(pkg = Rpackage)



## checking in the gh-pages
if(FALSE){
  message(">>>> cloning gh-pages branch repository: ", repository)
  ghpagesFolder <- paste0("gh-pages-",Rpackage)
  retval = system2("git", args = c("clone", "-b", "gh-pages",  repository, ghpagesFolder))
  if (retval != 0) {
    stop("ERROR : could not clone gh-pages ", ghpagesFolder)
  }
  file.copy(file.path(Rpackage,"docs"), ghpagesFolder , recursive=TRUE)
  setwd(ghpagesFolder)
  system("git add .")
  system('git commit -m "next doc version"')
  system("git push")

  setwd("..")

} 
setwd("..")
