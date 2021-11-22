set /A Install = 1

if %Install% == 1 (
    mkdir "d:\prolfquaPackageBuilds\r-site-library_prora"
)

set R_LIBS_USER=
set "R_LIBS_SITE=d:\prolfquaPackageBuilds\r-site-library_prora"


if %Install% == 1 (
    rm -Rf d:/prolfquaPackageBuilds/r-site-library_prora/*
    Rscript.exe InstallDependencies.R prora reinst > InstallDependencies_prora.log 2>&1
)


rm -Rf d:/prolfquaPackageBuilds/test_buildprora/*
Rscript.exe runBuild.R prora > runBuild_prora.log 2>&1

pause
