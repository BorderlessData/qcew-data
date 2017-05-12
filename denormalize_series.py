#!/usr/bin/env python

import agate

print('Loading')
table = agate.Table.from_csv('results/employment_by_year_adjusted.csv')

print('Denormalizing')
table = table.denormalize(['area_fips', 'area_title', 'agglvl_code'], 'year', 'avg_qrtly_emplvl')

print('Saving')
table.to_csv('results/area_employment_series.csv')
