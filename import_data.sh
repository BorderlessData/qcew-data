#!/bin/bash

PATH=$(pwd)
DATABASE="test"
TABLE="data"
DATA_FILES=$PATH/data/*.singlefile.csv

for f in $DATA_FILES
do
    /bin/date
    echo $f

    COPY_QUERY="
        COPY $TABLE
        FROM '$f' DELIMITER ',' CSV HEADER;
    "

    /usr/local/bin/psql -q "$DATABASE" -c "$COPY_QUERY";
done
