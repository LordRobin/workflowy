#!/bin/sh
rm -f dist/*
npm run build
# scp dist/index.* jiyuhang@120.26.164.35:~/iamyuhang_dva/
# cp dist/index.js dist/index.js.bak
# cp dist/index.css dist/index.css.bak
cp dist/index.js dist/workflowy.js
cp dist/index.css dist/workflowy.css
gzip -9 -N dist/workflowy.js
gzip -9 -N dist/workflowy.css
cp dist/index.js dist/workflowy.js
cp dist/index.css dist/workflowy.css
# mv dist/index.js.bak dist/index.js
# mv dist/index.css.bak dist/index.css
#scp dist/workflowy.* jiyuhang@memorysheep.com:/var/www/workflowy/current
#scp dist/workflowy.* jiyuhang@memorysheep.com:/var/www/iamyuhang/current/public/assets/react/
# openssl dgst -sha256 index.js.gz


system=$(uname)
if [ "$system"x = "Linux"x ]; then
    echo "检测到使用 Linux 系统"
    release_md5=$(md5sum dist/index.js | awk '{print $1}')
elif [ "$system"x = "Darwin"x ]; then
    echo "检测到使用 Mac 系统"
    release_md5=$(md5 dist/index.js | awk '{print $4}')
else
    echo "不知道是什么系统"
fi
echo $release_md5
cp dist/index.js dist/workflowy_${release_md5}.js
cp dist/index.css dist/workflowy_${release_md5}.css
gzip -9 -N dist/workflowy_${release_md5}.js
gzip -9 -N dist/workflowy_${release_md5}.css
cp dist/index.js dist/workflowy_${release_md5}.js
cp dist/index.css dist/workflowy_${release_md5}.css

# mv dist/index.js.bak dist/index.js
# mv dist/index.css.bak dist/index.css

scp dist/workflowy_* jiyuhang@memorysheep.com:/var/www/iamyuhang/current/public/assets/react/

# openssl dgst -sha256 index.js.gz

curl -X POST --header 'Content-Type: application/x-www-form-urlencoded' --header 'Accept: application/json' --header 'Authentication-Token: cjETVWtfzWey_KpSyYMs' -d "project=workflowy&md5=${release_md5}" 'https://memorysheep.com/api/v1/react_deploy'
