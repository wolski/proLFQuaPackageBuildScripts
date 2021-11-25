set /A Install = 1

if %Install% == 1 (
    mkdir "d:\prolfquaPackageBuilds\r-site-library_prozor"
)

set R_LIBS_USER=
set "R_LIBS_SITE=d:\prolfquaPackageBuilds\r-site-library_prozor"

mkdir "d:\prolfquaPackageBuilds\test_build_prozor"

if %Install% == 1 (
    rm -Rf d:/prolfquaPackageBuilds/test_build_prozor/*
    rm -Rf d:/prolfquaPackageBuilds/r-site-library_prozor/*
    Rscript.exe InstallDependencies.R protViz prozor reinst 
)

rm -Rf d:/prolfquaPackageBuilds/test_build_prozor/*
Rscript.exe runBuild.R protViz prozor  > runBuild_prozor.log 2>&1
