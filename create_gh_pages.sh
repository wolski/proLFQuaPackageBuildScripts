project="protviz"
repo="prozor"
# first setup
git clone https://github.com/$project/$repo gh-pages-$repo
cd gh-pages-$repo
git checkout --orphan gh-pages
git rm -rf .

 
git clone -b gh-pages  https://github.com/$project/$repo gh-pages-$repo
cd gh-pages-$repo

cp -Rf /d/prolfquaPackageBuilds/test_build_$repo/$repo/docs/* .
git add .
git commit -m "next doc version"
git push