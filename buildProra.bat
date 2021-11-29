set /A Install = 1

if %Install% == 1 (
    mkdir "d:\prolfquaPackageBuilds\r-site-library_prora"
)

set R_LIBS_USER=
set "R_LIBS_SITE=d:\prolfquaPackageBuilds\r-site-library_prora"

mkdir "d:\prolfquaPackageBuilds\test_build_prora"

if %Install% == 1 (
    
    rm -Rf d:/prolfquaPackageBuilds/test_build_prora/*
    rm -Rf d:/prolfquaPackageBuilds/r-site-library_prora/*
    R -e "install.packages('BiocManager')"
    R -e "BiocManager::install(c('GenomeInfoDbData', 'GO.db', 'DO.db', 'reactome.db', 'org.Hs.eg.db', 'clusterProfiler'))"
    R -e "remotes::install_github('wolski/sigora')"
    Rscript.exe InstallDependencies.R protViz prora reinst > InstallDependencies_prora.log 2>&1
)


rm -Rf d:/prolfquaPackageBuilds/test_build_prora/*
Rscript.exe runBuild.R protViz prora > runBuild_prora.log 2>&1

pause
