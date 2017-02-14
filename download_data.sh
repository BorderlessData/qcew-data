#!/bin/bash

# URLs for the QCEW single table zip files
urls=""
for year in `seq 1990 2016`; do
  urls="${urls} http://www.bls.gov/cew/data/files/${year}/csv/${year}_qtrly_singlefile.zip"
done

# Download all of these zip files
curl -L --remote-name-all $urls

# Unzip all the zip files, each containing one csv
unzip "*_singlefile.zip"

mv *_singlefile.zip data
mv *_singlefile.csv data
