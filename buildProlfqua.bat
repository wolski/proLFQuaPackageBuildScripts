Install=1

if [ Install = 1 ]; then
    mkdir $HOME/__checkout/proLFQuaPackageBuildScripts/r-site-library_prolfqua
fi

R_LIBS_USER=
export R_LIBS_SITE="$HOME/__checkout/proLFQuaPackageBuildScripts/r-site-library_prolfqua"

mkdir $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prolfqua


if %Install% == 1 (
    rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/r-site-library_prolfqua/*
    rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prolfqua/*
    
    R --vanilla -e "install.packages('remotes', repos = 'https://cloud.r-project.org' )"
    R --vanilla -e "remotes::install_gitlab('wolski/prolfquadata', host = 'gitlab.bfabric.org')"
    R --vanilla -e "BiocManager::install('vsn')"
    R --vanilla -e "remotes::install_github('wolski/prozor')"
    R --vanilla -e "install.packages('pander', repos = 'https://cloud.r-project.org' )"
    
    Rscript InstallDependencies.R wolski prolfqua reinst > InstallDependencies_prolfqua.log 2>&1
)

rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prolfqua/*
Rscript runBuild.R wolski prolfqua > runBuild_prolfqua.log 2>&1

mkdir $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prolfquabenchmark
rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prolfquabenchmark/*
Rscript runBuild.R wolski prolfquabenchmark  > runBuild_prolfquabenchmark.log 2>&1

pause
