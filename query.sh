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
# ) TO '$PATH/results/national.csv' DELIMITER ',' CSV HEADER;"

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
# ) TO '$PATH/results/national_by_month.csv' DELIMITER ',' CSV HEADER;"

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
# ) TO '$PATH/results/tyler_healthcare.csv' DELIMITER ',' CSV HEADER;"

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
#     FROM
#         data as first,
#         data as last,
#         area_titles.
#         annual_cpi
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
#         area_titles.area_fips = first.area_fips AND
#
#         annual_cpi.year = first.year
# ) TO '$PATH/results/wages_by_area.csv' DELIMITER ',' CSV HEADER;"

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
# ) TO '$PATH/results/tyler_by_sector.csv' DELIMITER ',' CSV HEADER;"

# All private businesses
# QUERY="
# COPY (
#     SELECT
#         data.year,
#         qtr,
#         (month1_emplvl + month2_emplvl + month3_emplvl) / 3 as avg_emplvl,
#         avg_wkly_wage,
#         (avg_wkly_wage * 237 / cpi) as avg_wkly_wage_2015_dollars
#     FROM
#         data,
#         annual_cpi
#     WHERE data.area_fips = 'US000'
#         AND data.own_code = '5'
#         AND (data.size_code = '0' or data.size_code = '')
#         AND data.industry_code = '10'
#         AND annual_cpi.year = data.year
# ) TO '$PATH/results/national_by_quarter_private.csv' DELIMITER ',' CSV HEADER;"

# Area change change w/ CPI adjustment
# QUERY="
# COPY (
#     SELECT
#         area_fips,
#         agglvl_code,
#         area_title,
#         avg_wkly_wage_1990,
#         avg_wkly_wage_1990_adj,
#         avg_wkly_wage_2015,
#         (avg_wkly_wage_2015 - avg_wkly_wage_1990_adj) as change,
#         (avg_wkly_wage_2015 - avg_wkly_wage_1990_adj) / avg_wkly_wage_1990_adj as pct_change
#     FROM (
#         SELECT
#             first.area_fips,
#             first.agglvl_code,
#             area_titles.area_title,
#             first.avg_wkly_wage as avg_wkly_wage_1990,
#             (first.avg_wkly_wage * 237 / cpi) as avg_wkly_wage_1990_adj,
#             last.avg_wkly_wage::real as avg_wkly_wage_2015
#         FROM
#             data as first,
#             data as last,
#             area_titles,
#             annual_cpi
#         WHERE
#             first.year = '1990' AND
#             first.qtr = '1' AND
#             first.own_code = '0' AND
#             first.industry_code = '10' AND
#             (first.size_code = '0' OR first.size_code = '') AND
#
#             last.year = '2015' AND
#             last.qtr = '1' AND
#             last.own_code = '0' AND
#             last.industry_code = '10' AND
#             (last.size_code = '0' OR last.size_code = '') AND
#
#             first.area_fips = last.area_fips AND
#             first.agglvl_code = last.agglvl_code AND
#             area_titles.area_fips = first.area_fips AND
#
#             annual_cpi.year = first.year
#     ) sub
# ) TO '$PATH/results/wages_by_area_adjusted.csv' DELIMITER ',' CSV HEADER;"

# Area wages by year w/ CPI adjustment
# QUERY="
# COPY (
#     SELECT
#         area_fips,
#         area_title,
#         agglvl_code,
#         sub.year,
#         (avg_wkly_wage * 237 / cpi) as avg_wkly_wage_2015_dollars
#     FROM (
#         SELECT
#             data.area_fips,
#             area_title,
#             data.agglvl_code,
#             data.year,
#             AVG(avg_wkly_wage) as avg_wkly_wage
#         FROM
#             data,
#             area_titles
#         WHERE
#             own_code = '0' AND
#             industry_code = '10' AND
#             (size_code = '0' OR size_code = '') AND
#
#             area_titles.area_fips = data.area_fips
#         GROUP BY
#             data.area_fips,
#             area_title,
#             data.agglvl_code,
#             data.year
#         ) sub,
#         annual_cpi
#     WHERE
#         sub.year = annual_cpi.year
#     ORDER BY
#         sub.area_fips,
#         sub.year
# ) TO '$PATH/results/wages_by_year_adjusted.csv' DELIMITER ',' CSV HEADER;"

# Brooklyn (Kings county) industry mix
FIPS="36047"
AGGLVL="74"
OWN="5"

QUERY="
COPY (
    SELECT
        industry_code,
        industry_title,
        avg_wkly_wage_1990,
        avg_wkly_wage_1990_adj,
        avg_wkly_wage_2015,
        (avg_wkly_wage_2015 - avg_wkly_wage_1990_adj) as wage_change,
        (avg_wkly_wage_2015 - avg_wkly_wage_1990_adj) / avg_wkly_wage_1990_adj as wage_pct_change,
        avg_emplvl_1990,
        avg_emplvl_2015,
        (avg_emplvl_2015 - avg_emplvl_1990) as emplvl_change,
        (avg_emplvl_2015 - avg_emplvl_1990) / avg_emplvl_1990::real as emplvl_pct_change
    FROM (
        SELECT
            first.industry_code,
            industry_titles.industry_title,
            first.avg_wkly_wage as avg_wkly_wage_1990,
            (first.avg_wkly_wage * 237 / cpi) as avg_wkly_wage_1990_adj,
            last.avg_wkly_wage::real as avg_wkly_wage_2015,
            (first.month1_emplvl + first.month2_emplvl + first.month3_emplvl) / 3 as avg_emplvl_1990,
            (last.month1_emplvl + last.month2_emplvl + last.month3_emplvl) / 3 as avg_emplvl_2015
        FROM
            data as first,
            data as last,
            industry_titles,
            annual_cpi
        WHERE
            first.area_fips = '$FIPS' AND
            first.year = '1990' AND
            first.qtr = '1' AND
            first.agglvl_code = '$AGGLVL' AND
            first.own_code = '$OWN' AND

            last.area_fips = '$FIPS' AND
            last.year = '2015' AND
            last.qtr = '1' AND
            last.agglvl_code = '$AGGLVL' AND
            last.own_code = '$OWN' AND

            first.industry_code = last.industry_code AND

            industry_titles.industry_code = first.industry_code AND

            annual_cpi.year = first.year
    ) sub
) TO '$PATH/results/brooklyn_wages_by_sector_adjusted.csv' DELIMITER ',' CSV HEADER;"

$PSQL -q $DATABASE -c "$QUERY"
