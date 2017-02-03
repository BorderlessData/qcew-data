#!/bin/bash

path=$(pwd)

query="
    CREATE TABLE area_titles (
        area_fips varchar,
        area_title varchar
    );

    CREATE UNIQUE INDEX area_fips_lookup_index ON area_titles (area_fips);

    COPY area_titles(area_fips, area_title)
        FROM '$path/area_titles.csv' DELIMITER ',' CSV HEADER;
"

psql -q qcew -c "$query"
