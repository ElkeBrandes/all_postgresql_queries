-- extract cash rents calculated with CSR and CSR2 from the table clumu_cgsb_profit_2012_2015
-- these tables are then read in with R and plotted. 
/*
DROP TABLE IF EXISTS "01_csr_cash_rents_aggr_2012_2015";
CREATE TABLE "01_csr_cash_rents_aggr_2012_2015" 
AS WITH 
rents_rounded AS (
SELECT
year,
cluid_mukey,
acres * 0.471 AS ha,
round(clu_cash_rent_csr /0.471) AS rent_csr_round
FROM "clumu_cgsb_profit_2012_2015"
)
SELECT
year,
sum(ha) AS ha,
rent_csr_round
FROM rents_rounded
GROUP BY year, rent_csr_round;


DROP TABLE IF EXISTS "01_csr2_cash_rents_aggr_2012_2015";
CREATE TABLE "01_csr2_cash_rents_aggr_2012_2015" 
AS WITH 
rents_rounded AS (
SELECT
year,
cluid_mukey,
acres * 0.471 AS ha,
round(clu_cash_rent_csr2 /0.471) AS rent_csr2_round
FROM "clumu_cgsb_profit_2012_2015"
)
SELECT
year,
sum(ha) AS ha,
rent_csr2_round
FROM rents_rounded
GROUP BY year, rent_csr2_round;
*/
-- check average cash rent per county


-- this query is not working ...
/*
DROP TABLE IF EXISTS "01_county_cash_rents";
CREATE TABLE "01_county_cash_rents"
AS WITH 
csr_table_1 AS (
SELECT
fips,
year,
sum(clu_cash_rent_csr * acres)/sum(acres) AS rent_csr
FROM clumu_cgsb_profit_2012_2015
WHERE year = '2012'
GROUP BY fips, year
),
csr_table_2 AS (
SELECT
fips,
year,
sum(clu_cash_rent_csr * acres)/sum(acres) AS rent_csr
FROM clumu_cgsb_profit_2012_2015 as t1
WHERE year = '2013'
GROUP BY fips, year
),
csr_table_3 AS (
SELECT
fips,
year,
sum(clu_cash_rent_csr * acres)/sum(acres) AS rent_csr
FROM clumu_cgsb_profit_2012_2015
WHERE year = '2014'
GROUP BY fips, year
),
csr_table_4 AS (
SELECT
fips,
year,
sum(clu_cash_rent_csr * acres)/sum(acres) AS rent_csr
FROM clumu_cgsb_profit_2012_2015
WHERE year = '2015'
GROUP BY fips, year
),
csr_table_5 AS (
SELECT
fips,
year,
sum(clu_cash_rent_csr2 * acres)/sum(acres) AS rent_csr2
FROM clumu_cgsb_profit_2012_2015
WHERE year = '2012'
GROUP BY fips, year
),
csr_table_6 AS (
SELECT
fips,
year,
sum(clu_cash_rent_csr2 * acres)/sum(acres) AS rent_csr2
FROM clumu_cgsb_profit_2012_2015
WHERE year = '2013'
GROUP BY fips, year
),
csr_table_7 AS (
SELECT
fips,
year,
sum(clu_cash_rent_csr2 * acres)/sum(acres) AS rent_csr2
FROM clumu_cgsb_profit_2012_2015
WHERE year = '2014'
GROUP BY fips, year
),
csr_table_8 AS (
SELECT 
fips,
year,
sum(clu_cash_rent_csr2 * acres)/sum(acres) AS rent_csr2
FROM clumu_cgsb_profit_2012_2015
WHERE year = '2015'
GROUP BY fips, year
),
csr_table AS (
SELECT * FROM csr_table_1
UNION
SELECT * FROM csr_table_2
UNION 
SELECT * FROM csr_table_3
UNION
SELECT * FROM csr_table_4
),
csr2_table AS (
SELECT * FROM csr_table_5
UNION
SELECT * FROM csr_table_6
UNION 
SELECT * FROM csr_table_7
UNION
SELECT * FROM csr_table_8
)
SELECT 
t1.*,
t2.rent_csr2
FROM csr_table AS t1
LEFT JOIN csr2_table AS t2 ON t1.fips = t2.fips and t1.year = t2.year;

*/

-- join with the survey cash rent values and calculate the % difference

DROP TABLE IF EXISTS "01_county_cash_rents_comp";
CREATE TABLE "01_county_cash_rents_comp"
AS SELECT
t1.*,
t2.nass_rent AS survey_rent
FROM "01_county_cash_rents" AS t1
LEFT JOIN cnty_rent_per_csr_pt_2010_2015 AS t2 ON t1.fips = t2.fips AND t1.year = t2.year;

ALTER TABLE "01_county_cash_rents_comp"
ADD COLUMN diff_csr NUMERIC;
ALTER TABLE "01_county_cash_rents_comp"
ADD COLUMN diff_csr2 NUMERIC;

UPDATE "01_county_cash_rents_comp"
SET
diff_csr = (rent_csr - survey_rent)*100 / survey_rent,
diff_csr2 = (rent_csr2 - survey_rent)*100 / survey_rent;

