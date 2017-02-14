#!/bin/bash

source config.sh

# All businesses
# QUERY="
# COPY (
#     SELECT agglvl_code, size_code, year, qtr, month1_emplvl, month2_emplvl, month3_emplvl
#     FROM data
#     WHERE area_fips = 'US000'
#         AND own_code = '0'
#         AND industry_code = '10'
# ) TO '$PATH/national.csv' DELIMITER ',' CSV HEADER;"

# All businesses, by month
# QUERY="
# COPY (
#     SELECT
#         year,
#         unnest(array[(qtr::int - 1) * 3 + 1, (qtr::int - 1) * 3 + 2, (qtr::int - 1) * 3 + 3]) as month,
#         unnest(array[month1_emplvl, month2_emplvl, month3_emplvl]) as emplvl
#     FROM data
#     WHERE data.area_fips = 'US000'
#         AND data.own_code = '0'
#         AND data.industry_code = '10'
# ) TO '$PATH/national_by_month.csv' DELIMITER ',' CSV HEADER;"

# Tyler Private Healthcare
# QUERY="
# COPY (
#     SELECT
#         year,
#         unnest(array[(qtr::int - 1) * 3 + 1, (qtr::int - 1) * 3 + 2, (qtr::int - 1) * 3 + 3]) as month,
#         unnest(array[lq_month1_emplvl, lq_month2_emplvl, lq_month3_emplvl]) as lq_emplvl
#     FROM data
#     WHERE data.area_fips = 'C4634'
#         AND data.own_code = '5'
#         AND data.industry_code = '621'
# ) TO '$PATH/tyler_healthcare.csv' DELIMITER ',' CSV HEADER;"

# # Change in avg_weekly_wage from 1st quarter 1990 to 1st quarter 2015
# QUERY="
# COPY (
#     SELECT
#         first.area_fips,
#         first.agglvl_code,
#         area_titles.area_title,
#         (first.month1_emplvl + first.month2_emplvl + first.month3_emplvl) / 3 as avg_emplvl_1990,
#         first.avg_wkly_wage as avg_wkly_wage_1990,
#         (last.month1_emplvl + last.month2_emplvl + last.month3_emplvl) / 3 as avg_emplvl_2015,
#         last.avg_wkly_wage as avg_wkly_wage_2015,
#         (last.avg_wkly_wage - first.avg_wkly_wage) / first.avg_wkly_wage::real as pct_change
#     FROM
#         data as first,
#         data as last,
#         area_titles
#     WHERE
#         first.year = '1990' AND
#         first.qtr = '1' AND
#         first.own_code = '0' AND
#         first.industry_code = '10' AND
#         (first.size_code = '0' OR first.size_code = '') AND
#
#         last.year = '2015' AND
#         last.qtr = '1' AND
#         last.own_code = '0' AND
#         last.industry_code = '10' AND
#         (last.size_code = '0' OR last.size_code = '') AND
#
#         first.area_fips = last.area_fips AND
#         first.agglvl_code = last.agglvl_code AND
#         area_titles.area_fips = first.area_fips
# ) TO '$PATH/wages_by_area.csv' DELIMITER ',' CSV HEADER;"

# Private Tyler businesses by sector and month
# QUERY="
# COPY (
#     SELECT
#         data.industry_code,
#         industry_titles.industry_title,
#         year,
#         unnest(array[(qtr::int - 1) * 3 + 1, (qtr::int - 1) * 3 + 2, (qtr::int - 1) * 3 + 3]) as month,
#         unnest(array[month1_emplvl, month2_emplvl, month3_emplvl]) as emplvl
#     FROM
#         data,
#         industry_titles
#     WHERE
#         data.area_fips = '48423'
#         AND data.own_code = '5'
#         AND data.size_code = '0'
#         AND data.agglvl_code = '75'
#         AND industry_titles.industry_code = data.industry_code
# ) TO '$PATH/tyler_by_sector.csv' DELIMITER ',' CSV HEADER;"

# All private businesses
QUERY="
COPY (
    SELECT
        year,
        qtr,
        (month1_emplvl + month2_emplvl + month3_emplvl) / 3 as avg_emplvl,
        avg_wkly_wage
    FROM data
    WHERE data.area_fips = 'US000'
        AND data.own_code = '5'
        AND (data.size_code = '0' or data.size_code = '')
        AND data.industry_code = '10'
) TO '$PATH/national_by_quarter_private.csv' DELIMITER ',' CSV HEADER;"

$PSQL -q $DATABASE -c "$QUERY"
