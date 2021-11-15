mkdir d:\\prolfquaPackageBuilds\\r-site-library_prolfquaBenchmark
rm -Rf d:/prolfquaPackageBuilds/r-site-library_prolfquaBenchmark/*
set R_LIBS_USER=
set "R_LIBS_SITE=d:\prolfquaPackageBuilds\r-site-library_prolfquaBenchmark"

Rscript runBuild.R prolfquaBenchmark > runBuild_prolfqua.log 2>&1
pause