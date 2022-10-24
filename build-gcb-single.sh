#!/bin/sh
set -e
# set -x

#melange build ./1590-cups.yaml --arch amd64 --keyring-append /secrets/local-melange.rsa.pub --signing-key /secrets/local-melange.rsa --out-dir /work/packages


FROM=${1:-000}    
FILES=`ls | sort -n -t - -k 1`
echo here $FILES

for f in $FILES
do
  if [[ "$f" == "*.yaml" ]]; then
    echo "Processing $f file..."
    # take action on each file. $f store current file name
    ORDER=$(echo $f | cut -d'-' -f 1)
    echo checking $ORDER
    #if (( "${ORDER#0}" >= "$FROM" )); then
    if [ $ORDER -ge $FROM ]; then
        echo would process $f
        melange build ./$f --arch amd64 --keyring-append /secrets/local-melange.rsa.pub --signing-key /secrets/local-melange.rsa --out-dir /work/packages
    fi
  fi

done
