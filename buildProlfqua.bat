set /A Install = 1

if %Install% == 1 (
    mkdir "d:\prolfquaPackageBuilds\r-site-library_prolfqua"
)

set R_LIBS_USER=
set "R_LIBS_SITE=d:\prolfquaPackageBuilds\r-site-library_prolfqua"

mkdir "d:\prolfquaPackageBuilds\test_build_prolfqua\"


if %Install% == 1 (
    rm -Rf d:/prolfquaPackageBuilds/r-site-library_prolfqua/*
    rm -Rf d:/prolfquaPackageBuilds/test_build_prolfqua/*

    R -e "install.packages('remotes', repos = 'https://cloud.r-project.org' )"
    R -e "remotes::install_gitlab('wolski/prolfquaData', host = 'gitlab.bfabric.org')"
    R -e "BiocManager::install('vsn')"
    R -e "remotes::install_github('wolski/prozor')"
  
    Rscript.exe InstallDependencies.R wolski prolfqua reinst > InstallDependencies_prolfqua.log 2>&1
)

rm -Rf d:/prolfquaPackageBuilds/test_build_prolfqua/*
Rscript.exe runBuild.R wolski prolfqua > runBuild_prolfqua.log 2>&1

rm -Rf d:/prolfquaPackageBuilds/test_build_prolfquaBenchmark/*
Rscript.exe runBuild.R wolski prolfquaBenchmark  > runBuild_prolfquaBenchmark.log 2>&1



pause
