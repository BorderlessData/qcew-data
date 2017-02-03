#!/bin/bash

path=$(pwd)

# query="
#     CREATE TABLE area_titles (
#         area_fips varchar,
#         area_title varchar
#     );
#
#     CREATE UNIQUE INDEX area_fips_lookup_index ON area_titles (area_fips);
#
#     COPY area_titles(area_fips, area_title)
#         FROM '$path/area_titles.csv' DELIMITER ',' CSV HEADER;
# "
#
# psql -q qcew -c "$query"

query="
    CREATE TABLE ownership_titles (
        own_code varchar,
        own_title varchar
    );

    CREATE UNIQUE INDEX own_code_lookup_index ON ownership_titles (own_code);

    COPY ownership_titles(own_code, own_title)
        FROM '$path/ownership_titles.csv' DELIMITER ',' CSV HEADER;
"

psql -q qcew -c "$query"

query="
    CREATE TABLE industry_titles (
        industry_code varchar,
        industry_title varchar
    );

    CREATE UNIQUE INDEX industry_code_lookup_index ON industry_titles (industry_code);

    COPY industry_titles(industry_code, industry_title)
        FROM '$path/industry_titles.csv' DELIMITER ',' CSV HEADER;
"

psql -q qcew -c "$query"

query="
    CREATE TABLE agglvl_titles (
        agglvl_code varchar,
        agglvl_title varchar
    );

    CREATE UNIQUE INDEX agglvl_code_lookup_index ON agglvl_titles (agglvl_code);

    COPY agglvl_titles(agglvl_code, agglvl_title)
        FROM '$path/agglevel_titles.csv' DELIMITER ',' CSV HEADER;
"

psql -q qcew -c "$query"

query="
    CREATE TABLE size_titles (
        own_code varchar,
        own_title varchar
    );

    CREATE UNIQUE INDEX own_code_lookup_index ON size_titles (own_code);

    COPY size_titles(own_code, own_title)
        FROM '$path/size_titles.csv' DELIMITER ',' CSV HEADER;
"

psql -q qcew -c "$query"
