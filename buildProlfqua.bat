set /A Install = 0

if %Install% == 1 (
    mkdir "d:\prolfquaPackageBuilds\r-site-library_prolfqua"
)

set R_LIBS_USER=
set "R_LIBS_SITE=d:\prolfquaPackageBuilds\r-site-library_prolfqua"

mkdir "d:\prolfquaPackageBuilds\test_build_prolfqua\"


if %Install% == 1 (
    remotes::install_gitlab("wolski/prolfquaData",
                            host = "gitlab.bfabric.org")

    rm -Rf d:/prolfquaPackageBuilds/r-site-library_prolfqua/*
    Rscript.exe InstallDependencies.R wolski prolfqua reinst > InstallDependencies_prolfqua.log 2>&1
)

rm -Rf d:/prolfquaPackageBuilds/test_build_prolfqua/*
Rscript.exe runBuild.R wolski prolfqua > runBuild_prolfqua.log 2>&1

rm -Rf d:/prolfquaPackageBuilds/test_build_prolfquaBenchmark/*
Rscript.exe runBuild.R wolski prolfquaBenchmark  > runBuild_prolfquaBenchmark.log 2>&1



pause
