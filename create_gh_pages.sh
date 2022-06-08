project="protviz"
repo="prozor"
# first setup
git clone https://github.com/$project/$repo gh-pages-$repo
cd gh-pages-$repo
git checkout --orphan gh-pages
git rm -rf .
git branch --set-upstream-to=origin/gh-pages gh-pages
git push
 
project="wolski"
repo="prolfquabenchmark"

git clone -b gh-pages  https://github.com/$project/$repo gh-pages-$repo
cd gh-pages-$repo


cp -Rf $HOME/__checkout/proLFQuaPackageBuildScripts/test_build_$repo/$repo/docs/* .
git add .
git commit -m "next doc version"
git push
