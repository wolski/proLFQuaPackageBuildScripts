set /A Install = 1

if %Install% == 1 (
    mkdir "d:\prolfquaPackageBuilds\r-site-library_tidyqpcr"
)

set R_LIBS_USER=
set "R_LIBS_SITE=d:\prolfquaPackageBuilds\r-site-library_tidyqpcr"

mkdir "d:\prolfquaPackageBuilds\test_build_tidyqpcr"

if %Install% == 1 (
    rm -Rf d:/prolfquaPackageBuilds/test_build_tidyqpcr/*
    rm -Rf d:/prolfquaPackageBuilds/r-site-library_tidyqpcr*
    R -e "install.packages('BiocManager', repos = 'https://cloud.r-project.org')"
    Rscript.exe InstallDependencies.R ewallace tidyqpcr reinst > InstallDependencies_tidyqpcr.log 2>&1
)


rm -Rf d:/prolfquaPackageBuilds/test_build_tidyqpcr/*
Rscript.exe runBuild.R ewallace tidyqpcr > runBuild_tidyqpcr.log 2>&1

pause
