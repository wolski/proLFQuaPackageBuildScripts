mkdir d:\\prolfquaPackageBuilds\\r-site-library_prolfqua
rm -Rf d:/prolfquaPackageBuilds/r-site-library_prolfqua/*
set R_LIBS_USER=
set "R_LIBS_SITE=d:\prolfquaPackageBuilds\r-site-library_prolfqua"

Rscript.exe runBuild.R prolfqua > runBuild_prolfqua.log 2>&1
pause