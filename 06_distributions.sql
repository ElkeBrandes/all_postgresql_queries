
-- distribution of NO3 leaching in the state, on a CLU-mukey level

-- the table "05_dndc_clumu_iowa_cgsb_swg_2011_2014" includes clumuacres and NO3 leaching for corn/bean and swg. 
--add two columns with the rounded values 
-- also, convert units to metric system 
/*
ALTER TABLE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
ADD COLUMN ave_no3_leach_cs_round NUMERIC,
ADD COLUMN ave_no3_leach_swg_round NUMERIC,
ADD COLUMN clumuha NUMERIC;

UPDATE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
SET ave_no3_leach_cs_round = ROUND(ave_no3_leach_cs * 0.4536 * 2.471,0);
UPDATE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
SET ave_no3_leach_swg_round = ROUND(ave_no3_leach_swg * 0.4536 * 2.471,0);
UPDATE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
SET clumuha = clumuacres / 2.471;
*/
-- to reduce the number of records, first round NO3 to zero decimals, then aggregate over the same amounts
/*


DROP TABLE IF EXISTS "06_cgsb_ave_no3_leach_rounded_aggr";
CREATE TABLE "06_cgsb_ave_no3_leach_rounded_aggr"
AS SELECT
ave_no3_leach_cs_round,
sum(clumuha) AS area_ha
FROM "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
GROUP BY ave_no3_leach_cs_round;

DROP TABLE IF EXISTS "06_swg_ave_no3_leach_rounded_aggr";
CREATE TABLE "06_swg_ave_no3_leach_rounded_aggr"
AS SELECT
ave_no3_leach_swg_round,
sum(clumuha) AS area_ha
FROM "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
GROUP BY ave_no3_leach_swg_round;
*/

-- profit optimized scenario:

-- distribution of no3 leaching on CGSB fields of unprofitable areas:
-- create a new column and filter for those areas
/*
ALTER TABLE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
ADD COLUMN ave_no3_leach_cs_round_unprofit NUMERIC;
UPDATE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
SET ave_no3_leach_cs_round_unprofit = ave_no3_leach_cs_round WHERE mean_profit_ha < 0;

-- aggregate to the same leaching values for the data subset

DROP TABLE IF EXISTS "06_cgsb_ave_no3_leach_rounded_aggr_unprofit";
CREATE TABLE "06_cgsb_ave_no3_leach_rounded_aggr_unprofit"
AS SELECT
ave_no3_leach_cs_round_unprofit,
sum(clumuha) AS area_ha
FROM "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
GROUP BY ave_no3_leach_cs_round_unprofit;

-- distribution of no3 leaching on swg fields of unprofitable areas:
-- create a new column and filter for those areas

ALTER TABLE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
ADD COLUMN ave_no3_leach_swg_round_unprofit NUMERIC;
UPDATE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
SET ave_no3_leach_swg_round_unprofit = ave_no3_leach_swg_round WHERE mean_profit_ha < 0;

-- aggregate to the same leaching values for the data subset

DROP TABLE IF EXISTS "06_swg_ave_no3_leach_rounded_aggr_unprofit";
CREATE TABLE "06_swg_ave_no3_leach_rounded_aggr_unprofit"
AS SELECT
ave_no3_leach_swg_round_unprofit,
sum(clumuha) AS area_ha
FROM "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
GROUP BY ave_no3_leach_swg_round_unprofit;
*/
-- water quality optimized scenario:

-- distribution of no3 leaching on CGSB fields of unprofitable areas:
-- create a new column and filter for those areas

ALTER TABLE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
ADD COLUMN ave_no3_leach_cs_round_highleach NUMERIC;
UPDATE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
SET ave_no3_leach_cs_round_highleach = ave_no3_leach_cs_round WHERE ave_no3_leach_cs > 62;

-- aggregate to the same leaching values for the data subset

DROP TABLE IF EXISTS "06_cgsb_ave_no3_leach_rounded_aggr_highleach";
CREATE TABLE "06_cgsb_ave_no3_leach_rounded_aggr_highleach"
AS SELECT
ave_no3_leach_cs_round_highleach,
sum(clumuha) AS area_ha
FROM "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
GROUP BY ave_no3_leach_cs_round_highleach;

-- distribution of no3 leaching on swg fields of unprofitable areas:
-- create a new column and filter for those areas
/*
ALTER TABLE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
ADD COLUMN ave_no3_leach_swg_round_highleach NUMERIC;
UPDATE "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
SET ave_no3_leach_swg_round_hichleach = ave_no3_leach_swg_round WHERE mean_profit_ha < 0;

-- aggregate to the same leaching values for the data subset

DROP TABLE IF EXISTS "06_swg_ave_no3_leach_rounded_aggr_unprofit";
CREATE TABLE "06_swg_ave_no3_leach_rounded_aggr_unprofit"
AS SELECT
ave_no3_leach_swg_round_unprofit,
sum(clumuha) AS area_ha
FROM "05_dndc_clumu_iowa_cgsb_swg_2011_2014"
GROUP BY ave_no3_leach_swg_round_unprofit;
*/