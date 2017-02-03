#!/bin/bash

path=$(pwd)

# All businesses
# query="
# COPY (
#     SELECT agglvl_code, size_code, year, qtr, month1_emplvl, month2_emplvl, month3_emplvl
#     FROM data
#     WHERE area_fips = 'US000'
#         AND own_code = '0'
#         AND industry_code = '10'
# ) TO '$path/output.csv' DELIMITER ',' CSV HEADER;"

# All businesses, by month
# query="
# COPY (
#     SELECT
#         year,
#         unnest(array[(qtr::int - 1) * 3 + 1, (qtr::int - 1) * 3 + 2, (qtr::int - 1) * 3 + 3]) as month,
#         unnest(array[month1_emplvl, month2_emplvl, month3_emplvl]) as emplvl
#     FROM data
#     WHERE data.area_fips = 'US000'
#         AND data.own_code = '0'
#         AND data.industry_code = '10'
# ) TO '$path/output.csv' DELIMITER ',' CSV HEADER;"

# Tyler Private Healthcare
# query="
# COPY (
#     SELECT
#         year,
#         unnest(array[(qtr::int - 1) * 3 + 1, (qtr::int - 1) * 3 + 2, (qtr::int - 1) * 3 + 3]) as month,
#         unnest(array[lq_month1_emplvl, lq_month2_emplvl, lq_month3_emplvl]) as lq_emplvl
#     FROM data
#     WHERE data.area_fips = 'C4634'
#         AND data.own_code = '5'
#         AND data.industry_code = '621'
# ) TO '$path/output.csv' DELIMITER ',' CSV HEADER;"

# Change in avg_weekly_wage from 1st quarter 1990 to 1st quarter 2015
query="
COPY (
    SELECT
        first.area_fips,
        area_titles.area_title,
        (first.month1_emplvl + first.month2_emplvl + first.month3_emplvl) / 3 as avg_emplvl_1990,
        first.avg_wkly_wage as avg_wkly_wage_1990,
        (last.month1_emplvl + last.month2_emplvl + last.month3_emplvl) / 3 as avg_emplvl_2015,
        last.avg_wkly_wage as avg_wkly_wage_2015,
        (last.avg_wkly_wage - first.avg_wkly_wage) / first.avg_wkly_wage as wage_pct_change
    FROM
        data as first,
        data as last,
        area_titles
    WHERE
        first.year = '1990' AND
        first.qtr = '1' AND
        first.own_code = '0' AND
        first.industry_code = '10' AND
        first.agglvl_code = '70' AND
        (first.size_code = '0' OR first.size_code = '') AND

        last.year = '2015' AND
        last.qtr = '1' AND
        last.own_code = '0' AND
        last.industry_code = '10' AND
        last.agglvl_code = '70' AND
        (last.size_code = '0' OR last.size_code = '') AND

        first.area_fips = last.area_fips AND
        area_titles.area_fips = first.area_fips
) TO '$path/output.csv' DELIMITER ',' CSV HEADER;"

psql -q qcew -c "$query"
