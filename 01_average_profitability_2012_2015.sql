
-- add cluid_mukey as a unique identifyer to the original table

ALTER TABLE clumu_cgsb_profit_2012_2015
ADD COLUMN cluid_mukey TEXT;

UPDATE clumu_cgsb_profit_2012_2015
SET cluid_mukey = cluid || mukey;

-- calculate mean profits for each polygon in a new table
-- calculate standard deviation as a measure of variability 
-- convert to metric system

DROP TABLE IF EXISTS "01_clumu_cgsb_profit_2012_2015_mean";
CREATE TABLE "01_clumu_cgsb_profit_2012_2015_mean"
AS SELECT
fips,
cluid,
cluid_mukey,
acres / 2.471 as clumuha,
AVG(profit_csr2) * 2.471 AS mean_profit_ha,
STDDEV_POP(profit_csr2 * 2.471) AS std_profit
FROM clumu_cgsb_profit_2012_2015
GROUP BY cluid_mukey, cluid, acres, fips;


-- for distribution, round profits and std deviation to the dollar and aggregate
/*
ALTER TABLE "01_clumu_cgsb_profit_2012_2015_mean"
ADD COLUMN profit_mean_ha_rounded FLOAT;
ALTER TABLE "01_clumu_cgsb_profit_2012_2015_mean"
ADD COLUMN profit_std_ha_rounded FLOAT;

UPDATE "01_clumu_cgsb_profit_2012_2015_mean"
SET 
profit_mean_ha_rounded = ROUND(mean_profit_ha,0),
profit_std_ha_rounded = ROUND(std_profit,0);

-- aggregate to the rounded mean profit values by summing up the areas

DROP TABLE IF EXISTS "01_profit_mean_2012_2015_aggregated";
CREATE TABLE "01_profit_mean_2012_2015_aggregated"
AS SELECT 
profit_mean_ha_rounded,
sum(clumuha) as sum_ha
FROM "01_clumu_cgsb_profit_2012_2015_mean"
GROUP BY profit_mean_ha_rounded;

-- calculate total area:
SELECT SUM(sum) FROM "01_profit_mean_2012_2015_aggregated" WHERE profit_mean_ha_rounded < 0;
*/

-- create distributions for each year 
-- 2012:
-- convert into metric system
/*
DROP TABLE IF EXISTS "01_profit_rounded_2012";
CREATE TABLE "01_profit_rounded_2012"
AS SELECT
ccrop,
clumuacres/2.471 as clumuha,
ROUND(profit*2.471,0) as profit_2012_ha_rounded
FROM clumu_cgsb_profit_2012_2015
WHERE year = 2012;

-- aggregate to profitability
DROP TABLE IF EXISTS "01_profit_rounded_aggregated_2012";
CREATE TABLE "01_profit_rounded_aggregated_2012"
AS SELECT
profit_2012_ha_rounded,
SUM(clumuha) AS area
FROM "01_profit_rounded_2012"
GROUP BY profit_2012_ha_rounded;

-- 2013:
-- convert into metric system

DROP TABLE IF EXISTS "01_profit_rounded_2013";
CREATE TABLE "01_profit_rounded_2013"
AS SELECT
ccrop,
clumuacres/2.471 as clumuha,
ROUND(profit*2.471,0) as profit_2013_ha_rounded
FROM clumu_cgsb_profit_2012_2015
WHERE year = 2013;

-- aggregate to profitability
DROP TABLE IF EXISTS "01_profit_rounded_aggregated_2013";
CREATE TABLE "01_profit_rounded_aggregated_2013"
AS SELECT
profit_2013_ha_rounded,
SUM(clumuha) AS area
FROM "01_profit_rounded_2013"
GROUP BY profit_2013_ha_rounded;

-- 2014:
-- convert into metric system

DROP TABLE IF EXISTS "01_profit_rounded_2014";
CREATE TABLE "01_profit_rounded_2014"
AS SELECT
ccrop,
clumuacres/2.471 as clumuha,
ROUND(profit*2.471,0) as profit_2014_ha_rounded
FROM clumu_cgsb_profit_2012_2015
WHERE year = 2014;

-- aggregate to profitability
DROP TABLE IF EXISTS "01_profit_rounded_aggregated_2014";
CREATE TABLE "01_profit_rounded_aggregated_2014"
AS SELECT
profit_2014_ha_rounded,
SUM(clumuha) AS area
FROM "01_profit_rounded_2014"
GROUP BY profit_2014_ha_rounded;

-- 2015:
-- convert into metric system

DROP TABLE IF EXISTS "01_profit_rounded_2015";
CREATE TABLE "01_profit_rounded_2015"
AS SELECT
ccrop,
clumuacres/2.471 as clumuha,
ROUND(profit*2.471,0) as profit_2015_ha_rounded
FROM clumu_cgsb_profit_2012_2015
WHERE year = 2015;

-- aggregate to profitability
DROP TABLE IF EXISTS "01_profit_rounded_aggregated_2015";
CREATE TABLE "01_profit_rounded_aggregated_2015"
AS SELECT
profit_2015_ha_rounded,
SUM(clumuha) AS area
FROM "01_profit_rounded_2015"
GROUP BY profit_2015_ha_rounded;


-- calculate the area in corn and soybean for each county 

DROP TABLE IF EXISTS "01_total_area_county";
CREATE TABLE "01_total_area_county"
AS SELECT
fips,
sum(clumuha) AS total_area
FROM "01_clumu_cgsb_profit_2012_2015_mean"
GROUP BY fips;

-- aggregate area below break even per county

DROP TABLE IF EXISTS "01_profit_below_breakeven_county_12_15";
CREATE TABLE "01_profit_below_breakeven_county_12_15"
AS SELECT
fips,
sum(clumuha) AS area
FROM "01_clumu_cgsb_profit_2012_2015_mean"
WHERE mean_profit_ha < 0
GROUP BY fips;

-----------------------------------------------
-----------------------------------------------
-----------------------------------------------

-- add a column with the GEOID

ALTER TABLE "01_profit_below_breakeven_county"
ADD COLUMN geoid TEXT;

UPDATE "01_profit_below_breakeven_county"
SET geoid = '19' || substring(fips from 3 for 3);

--join the tables 01_profit_below_breakeven_county and 01_total_area_county

DROP TABLE IF EXISTS "01_profit_below_breakeven_total_area_county";
CREATE TABLE "01_profit_below_breakeven_total_area_county"
AS SELECT 
t1.*,
t2.total_area
FROM "01_profit_below_breakeven_county" AS t1
JOIN "01_total_area_county" AS t2 ON t1.fips = t2.fips;


-- calculate area weighted average profitability per county 

DROP TABLE IF EXISTS "01_profit_mean_county";
CREATE TABLE "01_profit_mean_county"
AS SELECT
fips,
sum(mean_profit_ha * clumuha)/sum(clumuha) AS mean_county_profit
FROM "01_clumu_cgsb_profit_2011_2014_mean"
GROUP BY fips;


ALTER TABLE "01_profit_mean_county"
ADD COLUMN geoid TEXT;

UPDATE "01_profit_mean_county"
SET geoid = '19' || substring(fips from 3 for 3);

*/
