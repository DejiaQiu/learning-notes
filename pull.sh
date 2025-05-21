#!/bin/bash
msg=$1
if [ -z "$msg" ]; then
    msg="更新于 $(date '+%Y-%m-%d %H:%M:%S')"
fi
git add .
git commit -m "$msg"
git push origin-github main
git push origin-gitee main
