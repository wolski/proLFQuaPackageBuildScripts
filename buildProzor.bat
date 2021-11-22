set /A Install = 1

if %Install% == 1 (
    mkdir "d:\prolfquaPackageBuilds\r-site-library_prozor"
)

set R_LIBS_USER=
set "R_LIBS_SITE=d:\prolfquaPackageBuilds\r-site-library_prozor"

mkdir "d:\prolfquaPackageBuilds\test_buildprozor"

if %Install% == 1 (
    rm -Rf d:/prolfquaPackageBuilds/test_buildprozor/*
    rm -Rf d:/prolfquaPackageBuilds/r-site-library_prozor/*
    Rscript.exe InstallDependencies.R prozor reinst 
)

rm -Rf d:/prolfquaPackageBuilds/test_buildprozor/*
Rscript.exe runBuild.R prozor  > runBuild_prozor.log 2>&1
