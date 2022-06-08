Install=1

if [ $Install = 1 ]; then 
    echo "dummm"
    mkdir $HOME/__checkout/proLFQuaPackageBuildScripts/r-site-library_prozor
fi

R_LIBS_USER=
export R_LIBS_SITE="$HOME/__checkout/proLFQuaPackageBuildScripts/r-site-library_prozor"

mkdir $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prozor


if [ $Install = 1 ]; then
    rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_prozor/*
    rm -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/r-site-library_prozor/*

    R --vanilla -e "install.packages(c('rmarkdown','remotes', 'AhoCorasickTrie', 'docopt', 'readr', 'seqinr'), repos = 'https://cloud.r-project.org' )"
    
    Rscript InstallDependencies.R protViz prozor reinst 
fi

rm -Rf d:/prolfquaPackageBuilds/test_build_prozor/*
Rscript runBuild.R protViz prozor  > runBuild_prozor.log 2>&1
