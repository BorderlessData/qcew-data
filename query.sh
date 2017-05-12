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
# ) TO '$OUTPUT/results/national.csv' DELIMITER ',' CSV HEADER;"

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
# ) TO '$OUTPUT/results/national_by_month.csv' DELIMITER ',' CSV HEADER;"

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
# ) TO '$OUTPUT/results/tyler_healthcare.csv' DELIMITER ',' CSV HEADER;"

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
# ) TO '$OUTPUT/results/wages_by_area.csv' DELIMITER ',' CSV HEADER;"

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
# ) TO '$OUTPUT/results/tyler_by_sector.csv' DELIMITER ',' CSV HEADER;"

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
# ) TO '$OUTPUT/results/national_by_quarter_private.csv' DELIMITER ',' CSV HEADER;"

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
#         (avg_wkly_wage_2015 - avg_wkly_wage_1990_adj) / avg_wkly_wage_1990_adj as pct_change,
#         power(abs(avg_wkly_wage_2015 / avg_wkly_wage_1990_adj), 1.0 / 25.0) - 1 as abs_avg_annual_pct_change
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
# ) TO '$OUTPUT/results/wages_by_area_adjusted.csv' DELIMITER ',' CSV HEADER;"

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
# ) TO '$OUTPUT/results/wages_by_year_adjusted.csv' DELIMITER ',' CSV HEADER;"

# Manhattan (New York county) industry mix
# FIPS="36061"
# AGGLVL="75"
# OWN="5"
#
# QUERY="
# COPY (
#     SELECT
#         industry_code,
#         industry_title,
#         avg_wkly_wage_1990,
#         avg_wkly_wage_1990_adj,
#         avg_wkly_wage_2015,
#         (avg_wkly_wage_2015 - avg_wkly_wage_1990_adj) AS wage_change,
#         (avg_wkly_wage_2015 - avg_wkly_wage_1990_adj) / NULLIF(avg_wkly_wage_1990_adj, 0) AS wage_pct_change,
#         avg_emplvl_1990,
#         avg_emplvl_2015,
#         (avg_emplvl_2015 - avg_emplvl_1990) AS emplvl_change,
#         (avg_emplvl_2015 - avg_emplvl_1990) / NULLIF(avg_emplvl_1990, 0) AS emplvl_pct_change
#     FROM (
#         SELECT
#             first.industry_code,
#             industry_titles.industry_title,
#             first.avg_wkly_wage as avg_wkly_wage_1990,
#             (first.avg_wkly_wage * 237 / cpi) AS avg_wkly_wage_1990_adj,
#             last.avg_wkly_wage::real AS avg_wkly_wage_2015,
#             (first.month1_emplvl + first.month2_emplvl + first.month3_emplvl) / 3 AS avg_emplvl_1990,
#             (last.month1_emplvl + last.month2_emplvl + last.month3_emplvl) / 3::real AS avg_emplvl_2015
#         FROM
#             data as first,
#             data as last,
#             industry_titles,
#             annual_cpi
#         WHERE
#             first.area_fips = '$FIPS' AND
#             first.year = '1990' AND
#             first.qtr = '1' AND
#             first.agglvl_code = '$AGGLVL' AND
#             first.own_code = '$OWN' AND
#
#             last.area_fips = '$FIPS' AND
#             last.year = '2015' AND
#             last.qtr = '1' AND
#             last.agglvl_code = '$AGGLVL' AND
#             last.own_code = '$OWN' AND
#
#             first.industry_code = last.industry_code AND
#
#             industry_titles.industry_code = first.industry_code AND
#
#             annual_cpi.year = first.year
#     ) sub
# ) TO '$OUTPUT/results/manhattan_wages_by_sector_adjusted.csv' DELIMITER ',' CSV HEADER;"

# Wages and employment for all industries in a single place
# New York County: 36061
# Bronx County: 36005
# Kings County: 36047
# Queens County: 36081
# Richmond County: 36085
# FIPS="36061"
# REGION="new_york_county"
#
# QUERY="
# COPY (
#     SELECT
#         industry_code,
#         industry_title,
#         agglvl_code,
#         sub.year,
#         avg_qrtly_emplvl,
#         (avg_wkly_wage * 237 / cpi) as avg_wkly_wage_2015_dollars,
#         (avg_total_qrtrly_wages * 237 / cpi) as avg_total_qrtrly_wages_2015_dollars
#     FROM (
#         SELECT
#             data.industry_code,
#             industry_title,
#             data.agglvl_code,
#             data.year,
#             AVG((month1_emplvl + month2_emplvl + month3_emplvl) / 3) as avg_qrtly_emplvl,
#             AVG(avg_wkly_wage) as avg_wkly_wage,
#             AVG(total_qtrly_wages) as avg_total_qrtrly_wages
#         FROM
#             data,
#             industry_titles
#         WHERE
#             area_fips = '$FIPS' AND
#             own_code = '5' AND
#             (size_code = '0' OR size_code = '') AND
#
#             industry_titles.industry_code = data.industry_code
#         GROUP BY
#             data.industry_code,
#             industry_title,
#             data.agglvl_code,
#             data.year
#         ) sub,
#         annual_cpi
#     WHERE
#         sub.year = annual_cpi.year
#     ORDER BY
#         sub.industry_code,
#         sub.year
# ) TO '$OUTPUT/results/${REGION}_wages_by_industry.csv' DELIMITER ',' CSV HEADER;"

# Employment time series
# QUERY="
# COPY (
#     SELECT
#         data.area_fips,
#         area_title,
#         data.agglvl_code,
#         data.year,
#         AVG((month1_emplvl + month2_emplvl + month3_emplvl) / 3) as avg_qrtly_emplvl
#     FROM
#         data,
#         area_titles
#     WHERE
#         own_code = '0' AND
#         industry_code = '10' AND
#         (size_code = '0' OR size_code = '') AND
#
#         area_titles.area_fips = data.area_fips
#     GROUP BY
#         data.area_fips,
#         area_title,
#         data.agglvl_code,
#         data.year
#     ORDER BY
#         data.area_fips,
#         data.year
# ) TO '$OUTPUT/results/employment_by_year_adjusted.csv' DELIMITER ',' CSV HEADER;"

# All counties industry mix
# FIPS="36061"
# AGGLVL="75"
# OWN="5"

# QUERY="
# COPY (
#     SELECT
#         area_fips,
#         area_title,
#         industry_code,
#         industry_title,
#         avg_wkly_wage_1990,
#         avg_wkly_wage_1990_adj,
#         avg_wkly_wage_2015,
#         (avg_wkly_wage_2015 - avg_wkly_wage_1990_adj) AS wage_change,
#         (avg_wkly_wage_2015 - avg_wkly_wage_1990_adj) / NULLIF(avg_wkly_wage_1990_adj, 0) AS wage_pct_change,
#         avg_emplvl_1990,
#         avg_emplvl_2015,
#         (avg_emplvl_2015 - avg_emplvl_1990) AS emplvl_change,
#         (avg_emplvl_2015 - avg_emplvl_1990) / NULLIF(avg_emplvl_1990, 0) AS emplvl_pct_change
#     FROM (
#         SELECT
#             first.area_fips,
#             area_titles.area_title,
#             first.industry_code,
#             industry_titles.industry_title,
#             first.avg_wkly_wage as avg_wkly_wage_1990,
#             (first.avg_wkly_wage * 237 / cpi) AS avg_wkly_wage_1990_adj,
#             last.avg_wkly_wage::real AS avg_wkly_wage_2015,
#             (first.month1_emplvl + first.month2_emplvl + first.month3_emplvl) / 3 AS avg_emplvl_1990,
#             (last.month1_emplvl + last.month2_emplvl + last.month3_emplvl) / 3::real AS avg_emplvl_2015
#         FROM
#             data as first,
#             data as last,
#             area_titles,
#             industry_titles,
#             annual_cpi
#         WHERE
#             first.year = '1990' AND
#             first.qtr = '1' AND
#             first.agglvl_code = '$AGGLVL' AND
#             first.own_code = '$OWN' AND
#
#             last.year = '2015' AND
#             last.qtr = '1' AND
#             last.agglvl_code = '$AGGLVL' AND
#             last.own_code = '$OWN' AND
#
#             first.area_fips = last.area_fips AND
#             first.industry_code = last.industry_code AND
#
#             area_titles.area_fips = first.area_fips AND
#
#             industry_titles.industry_code = first.industry_code AND
#
#             annual_cpi.year = first.year
#     ) sub
# ) TO '$OUTPUT/results/area_wages_by_sector_adjusted.csv' DELIMITER ',' CSV HEADER;"

# Employment level for all counties, all industries, average of 2015 (for Yano)
# QUERY="
# COPY (
#     SELECT
#         area_fips,
#         sub.industry_code,
#         industry_title,
#         avg_emplvl
#     FROM
#         (SELECT
#             area_fips,
#             data.industry_code,
#             (sum(month1_emplvl) + sum(month2_emplvl) + sum(month3_emplvl)) / 12 as avg_emplvl
#         FROM
#             data
#         WHERE
#             year = '2015' AND
#             own_code = '5' AND
#             agglvl_code = '76' AND
#             (size_code = '0' OR size_code = '')
#         GROUP BY
#             area_fips,
#             data.industry_code,
#             year
#         ) sub, industry_titles
#     WHERE
#         industry_titles.industry_code = sub.industry_code
#
# ) TO '$OUTPUT/results/emplvl_all_fips_all_4d_naics_2015.csv' DELIMITER ',' CSV HEADER;"

# National totals by industry (for Yano)
# QUERY="
# COPY (
#     SELECT
#         sub.area_fips,
#         sub.industry_code,
#         industry_title,
#         avg_emplvl
#     FROM
#         (SELECT
#             area_fips,
#             data.industry_code,
#             (sum(month1_emplvl) + sum(month2_emplvl) + sum(month3_emplvl)) / 12 as avg_emplvl
#         FROM
#             data
#         WHERE
#             year = '2015' AND
#             own_code = '5' AND
#             agglvl_code = '16' AND
#             (size_code = '0' OR size_code = '')
#         GROUP BY
#             area_fips,
#             data.industry_code,
#             year
#         ) sub, industry_titles
#     WHERE
#         industry_titles.industry_code = sub.industry_code
#
# ) TO '$OUTPUT/results/emplvl_national_all_4d_naics_2015.csv' DELIMITER ',' CSV HEADER;"

# County totals (for Yano)
# QUERY="
# COPY (
#     SELECT
#         sub.area_fips,
#         area_title,
#         avg_emplvl
#     FROM
#         (SELECT
#             area_fips,
#             data.industry_code,
#             (sum(month1_emplvl) + sum(month2_emplvl) + sum(month3_emplvl)) / 12 as avg_emplvl
#         FROM
#             data
#         WHERE
#             year = '2015' AND
#             own_code = '5' AND
#             agglvl_code = '71' AND
#             (size_code = '0' OR size_code = '')
#         GROUP BY
#             area_fips,
#             data.industry_code,
#             year
#         ) sub, area_titles
#     WHERE
#         area_titles.area_fips = sub.area_fips
#
# ) TO '$OUTPUT/results/emplvl_all_fips_total_2015.csv' DELIMITER ',' CSV HEADER;"



# All Tyler MSA employment by sector and month
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
#         data.area_fips = 'C4634' AND
#         own_code = '5' AND
#         (size_code = '0' OR size_code = '') AND
#         data.agglvl_code = '44' AND
#
#         industry_titles.industry_code = data.industry_code
# ) TO '$OUTPUT/results/tyler_by_sector.csv' DELIMITER ',' CSV HEADER;"

# QUERY="
# COPY (
#     SELECT
#         sub.area_fips,
#         sub.industry_code,
#         industry_title,
#         avg_emplvl
#     FROM
#         (SELECT
#             area_fips,
#             data.industry_code,
#             (sum(month1_emplvl) + sum(month2_emplvl) + sum(month3_emplvl)) / 12 as avg_emplvl
#         FROM
#             data
#         WHERE
#             year = '2015' AND
#             own_code = '5' AND
#             agglvl_code = '16' AND
#             (size_code = '0' OR size_code = '')
#         GROUP BY
#             area_fips,
#             data.industry_code,
#             year
#         ) sub, industry_titles
#     WHERE
#         industry_titles.industry_code = sub.industry_code
#
# ) TO '$OUTPUT/results/emplvl_national_all_4d_naics_2015.csv' DELIMITER ',' CSV HEADER;"

# Total monthly employment
# QUERY="
# COPY (
#     SELECT
#         year,
#         data.area_fips,
#         area_title,
#         data.industry_code,
#         industry_title,
#         year,
#         own_code,
#         agglvl_code,
#         unnest(array[(qtr::int - 1) * 3 + 1, (qtr::int - 1) * 3 + 2, (qtr::int - 1) * 3 + 3]) as month,
#         unnest(array[month1_emplvl, month2_emplvl, month3_emplvl]) as emplvl
#     FROM
#         data,
#         area_titles,
#         industry_titles
#     WHERE
#         (agglvl_code IN ('11', '14', '15', '16', '17', '18')) AND
#         (own_code = '0' OR own_code = '5') AND
#         (size_code = '0' OR size_code = '') AND
#         area_titles.area_fips = data.area_fips AND
#         industry_titles.industry_code = data.industry_code
# ) TO '$OUTPUT/results/emplvl_national_all_naics_monthly.csv' DELIMITER ',' CSV HEADER;"

# Employment level for all counties, all industries, all years, 4d NAICS (for Dan)
QUERY="
COPY (
    SELECT
        sub.area_fips,
        area_title,
        sub.industry_code,
        industry_title,
        year,
        avg_emplvl
    FROM
        (SELECT
            area_fips,
            data.industry_code,
            year,
            (sum(month1_emplvl) + sum(month2_emplvl) + sum(month3_emplvl)) / 12 as avg_emplvl
        FROM
            data
        WHERE
            own_code = '5' AND
            agglvl_code = '76' AND
            (size_code = '0' OR size_code = '')
        GROUP BY
            area_fips,
            data.industry_code,
            year
        ) sub, area_titles, industry_titles
    WHERE
        area_titles.area_fips = sub.area_fips AND
        industry_titles.industry_code = sub.industry_code

) TO '$OUTPUT/results/emplvl_all_fips_all_4d_naics_all_years.csv' DELIMITER ',' CSV HEADER;"

$PSQL -q $DATABASE -c "$QUERY"
