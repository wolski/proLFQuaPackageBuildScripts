set /A Install = 1

if %Install% == 1 (
    mkdir "d:\prolfquaPackageBuilds\r-site-library_sigora"
)

set R_LIBS_USER=
set "R_LIBS_SITE=d:\prolfquaPackageBuilds\r-site-library_sigora"

mkdir "d:\prolfquaPackageBuilds\test_build_sigora"

if %Install% == 1 (
    
    rm -Rf d:/prolfquaPackageBuilds/test_build_sigora/*
    rm -Rf d:/prolfquaPackageBuilds/r-site-library_sigora/*
    R -e "install.packages('BiocManager')"
    Rscript.exe InstallDependencies.R wolski sigora reinst > InstallDependencies_sigora.log 2>&1
)


rm -Rf d:/prolfquaPackageBuilds/test_build_sigora/*
Rscript.exe runBuild.R wolski sigora > runBuild_sigora.log 2>&1

pause
