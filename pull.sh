#!/bin/bash
git add .
git commit -m "$1"
git push origin-github main
git push origin-gitee main
