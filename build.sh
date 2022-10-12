#!/bin/bash
set -e

FROM=675
FILES="*.yaml"
for f in $FILES
do
  echo "Processing $f file..."
  # take action on each file. $f store current file name
  ORDER=$(echo $f | cut -d'-' -f 1)
  echo checking $ORDER
  if (( ${ORDER#0} >= $FROM )); then
    docker run --platform linux/arm64 --privileged -v "$PWD":/work cgr.dev/chainguard/melange build /work/$f --arch amd64 --keyring-append local-melange.rsa.pub --signing-key local-melange.rsa
  fi
done



