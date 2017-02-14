# #!/bin/bash

source config.sh

# Area titles
query="
    CREATE TABLE area_titles (
        area_fips varchar,
        area_title varchar
    );

    CREATE UNIQUE INDEX area_fips_lookup_index ON area_titles (area_fips);

    COPY area_titles(area_fips, area_title)
        FROM '$PATH/area_titles.csv' DELIMITER ',' CSV HEADER;
"

$PSQL -q $DATABASE -c "$query"

# Ownership codes
query="
    CREATE TABLE ownership_titles (
        own_code varchar,
        own_title varchar
    );

    CREATE UNIQUE INDEX own_code_lookup_index ON ownership_titles (own_code);

    COPY ownership_titles(own_code, own_title)
        FROM '$PATH/ownership_titles.csv' DELIMITER ',' CSV HEADER;
"

$PSQL -q $DATABASE -c "$query"

# Industry titles
query="
    CREATE TABLE industry_titles (
        industry_code varchar,
        industry_title varchar
    );

    CREATE UNIQUE INDEX industry_code_lookup_index ON industry_titles (industry_code);

    COPY industry_titles(industry_code, industry_title)
        FROM '$PATH/industry_titles.csv' DELIMITER ',' CSV HEADER;
"

$PSQL -q $DATABASE -c "$query"

# Aggregation level codes
query="
    CREATE TABLE agglvl_titles (
        agglvl_code varchar,
        agglvl_title varchar
    );

    CREATE UNIQUE INDEX agglvl_code_lookup_index ON agglvl_titles (agglvl_code);

    COPY agglvl_titles(agglvl_code, agglvl_title)
        FROM '$PATH/agglevel_titles.csv' DELIMITER ',' CSV HEADER;
"

$PSQL -q $DATABASE -c "$query"

# Size codes
query="
    CREATE TABLE size_titles (
        own_code varchar,
        own_title varchar
    );

    CREATE UNIQUE INDEX own_code_lookup_index ON size_titles (own_code);

    COPY size_titles(own_code, own_title)
        FROM '$PATH/size_titles.csv' DELIMITER ',' CSV HEADER;
"

$PSQL -q $DATABASE -c "$query"

# CPI
query="
    CREATE TABLE annual_cpi (
        year varchar,
        cpi real
    );

    CREATE UNIQUE INDEX annual_cpi_lookup_index ON annual_cpi (year);

    COPY annual_cpi(year, cpi)
        FROM '$PATH/annual_cpi.csv' DELIMITER ',' CSV HEADER;
"

$PSQL -q $DATABASE -c "$query"
