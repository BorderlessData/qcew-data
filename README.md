# QCEW Data Loader

Imports the entire Bureau of Labor Statistics Quarterly Census of Employement (1990 - current) and Wages into a Postgres database.

The database created by this process will be about **80GB**. Make sure you have enough space before you start!

# Usage

```
./download_data.sh
createdb qcew
./import_data.sh
./import_lookups.sh
```
