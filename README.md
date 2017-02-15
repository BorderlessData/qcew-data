# QCEW Data Loader

Imports the entire Bureau of Labor Statistics Quarterly Census of Employement and Wages (from 1990 to latest) into a Postgres database.

The database created by this process will use about **80GB** of disk space. Make sure you have enough space available before you start!

## Usage

```
./download_data.sh
./create_db.sh
./import_data.sh
./import_lookups.sh
```

## Notes

* QCEW lookup tables (in the `lookup` folder) are from the BLS's QCEW [layout documentation](https://data.bls.gov/cew/doc/layouts/csv_quarterly_layout.htm).

* The annual CPI is from the [Minneapolis Fed](https://www.minneapolisfed.org/community/teaching-aids/cpi-calculator-information/consumer-price-index-and-inflation-rates-1913).
