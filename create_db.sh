#!/bin/bash

source config.sh

CREATE_QUERY="
    CREATE TABLE $TABLE (
        area_fips varchar(5),
        own_code varchar(1),
        industry_code varchar(6),
        agglvl_code varchar(2),
        size_code varchar(1),
        year varchar(4),
        qtr varchar(1),
        disclosure_code varchar(1),
        qtrly_estabs integer,
        month1_emplvl integer,
        month2_emplvl integer,
        month3_emplvl integer,
        total_qtrly_wages bigint,
        taxable_qtrly_wages bigint,
        qtrly_contributions bigint,
        avg_wkly_wage integer,
        lq_disclosure_code varchar(1),
        lq_qtrly_estabs real,
        lq_month1_emplvl real,
        lq_month2_emplvl real,
        lq_month3_emplvl real,
        lq_total_qtrly_wages real,
        lq_taxable_qtrly_wages real,
        lq_qtrly_contributions real,
        lq_avg_wkly_wage real,
        oty_disclosure_code varchar(1),
        oty_qtrly_estabs_chg integer,
        oty_qtrly_estabs_pct_chg real,
        oty_month1_emplvl_chg integer,
        oty_month1_emplvl_pct_chg real,
        oty_month2_emplvl_chg integer,
        oty_month2_emplvl_pct_chg real,
        oty_month3_emplvl_chg integer,
        oty_month3_emplvl_pct_chg real,
        oty_total_qtrly_wages_chg bigint,
        oty_total_qtrly_wages_pct_chg real,
        oty_taxable_qtrly_wages_chg bigint,
        oty_taxable_qtrly_wages_pct_chg real,
        oty_qtrly_contributions_chg bigint,
        oty_qtrly_contributions_pct_chg real,
        oty_avg_wkly_wage_chg integer,
        oty_avg_wkly_wage_pct_chg real
    );

    CREATE INDEX ${TABLE}_area_fips_index ON $TABLE (area_fips);
    CREATE INDEX ${TABLE}_industry_code_index ON $TABLE (industry_code);
    CREATE INDEX ${TABLE}_agglvl_code_index ON $TABLE (agglvl_code);
"

$PSQL -q "$DATABASE" -c "$CREATE_QUERY";
