set /A Install = 0

if %Install% == 1 (
    mkdir "d:\prolfquaPackageBuilds\r-site-library_prolfqua"
)

set R_LIBS_USER=
set "R_LIBS_SITE=d:\prolfquaPackageBuilds\r-site-library_prolfqua"


if %Install% == 1 (
    rm -Rf d:/prolfquaPackageBuilds/r-site-library_prolfqua/*
    Rscript.exe InstallDependencies.R prolfqua reinst > InstallDependencies_prolfqua.log 2>&1
)


rm -Rf d:/prolfquaPackageBuilds/test_buildprolfqua/*
Rscript.exe runBuild.R prolfqua > runBuild_prolfqua.log 2>&1

rm -Rf d:/prolfquaPackageBuilds/test_buildprolfquaBenchmark/*
Rscript.exe runBuild.R prolfquaBenchmark  > runBuild_prolfquaBenchmark.log 2>&1


pause
