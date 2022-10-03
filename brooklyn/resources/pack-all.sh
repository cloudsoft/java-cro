#!/bin/bash
RES_PATH=$(pwd)
cd ${RES_PATH}
dirs=($(ls -l ${RES_PATH} | awk '/^d/ {print $9}'))

for dir in "${dirs[@]}"; do
  dirPath="${RES_PATH}/${dir}"
  echo "Processing dir: ${dirPath}"
  cd $dirPath
  zip -r "${dirPath}.zip" ./*
done
echo "Here are your terraform deployments, but uploading them to a remote server (if necessary) requires your able fingers."