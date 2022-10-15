Install=0


if [[ $Install = 1 ]]
then
  rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/r-site-library_prolfqua/*
  rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prolfqua/*  
  mkdir $HOME/__checkout/proLFQuaPackageBuildScripts/r-site-library_prolfqua
else
  echo "trash"
fi

export R_LIBS_SITE="$HOME/__checkout/proLFQuaPackageBuildScripts/r-site-library_prolfqua"
mkdir $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prolfqua


if [[ $Install = 1 ]]
then
    rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/r-site-library_prolfqua/*
    rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prolfqua/*
    
    R --vanilla -e "install.packages(c('remotes','BiocManager','kableExtra') , repos = 'https://cloud.r-project.org' )"
    R --vanilla -e "install.packages('pander', repos = 'https://cloud.r-project.org' )"
    R --vanilla -e "remotes::install_gitlab('wolski/prolfquadata', host='gitlab.bfabric.org')"
    R --vanilla -e "BiocManager::install('BiocStyle')"
    Rscript InstallDependencies.R fgcz prolfqua reinst > InstallDependencies_prolfqua.log 2>&1
fi

rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prolfqua/*
Rscript runBuild.R fgcz prolfqua Modelling2R6 > runBuild_prolfqua.log 2>&1



mkdir $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prolfquabenchmark
rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prolfquabenchmark/*
Rscript runBuild.R wolski prolfquabenchmark main  > runBuild_prolfquabenchmark.log 2>&1

pause
