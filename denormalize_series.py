#!/usr/bin/env python

import agate

print('Loading')
table = agate.Table.from_csv('results/wages_by_year_adjusted.csv')

print('Denormalizing')
table = table.denormalize(['area_fips', 'area_title', 'agglvl_code'], 'year', 'avg_wkly_wage_2015_dollars')

print('Saving')
table.to_csv('results/area_wage_series.csv')
