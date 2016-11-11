-- after having done the spatial processing in ArcGIS to identify areas that should go into switchgrass, 
-- import the txt file exported from ArcGIS (I use psql because it is faster: 
-- \copy  swg_scenarios from C:/Users/ebrandes/Documents/swg_scenarios.txt DELIMITER ' '

-- there are a lot of 'NULL' values for fips, that means that there is no attribute data associated with the polygon 
-- most likely because that polygon was not continuously in corn/soybean from 2012-2015.
-- the null values are filled with a character 'NULL'. First I want to replace those by real NULL VALUES.



DELETE FROM swg_scenarios
WHERE "FIPS" = 'NULL';

/*
UPDATE swg_scenarios
SET 
"IN_SWG_MIN_16_10000_20" = NULL WHERE "IN_SWG_MIN_16_10000_20" = 'NULL',
"IN_SWG_2ND_16_10000_20" = NULL WHERE "IN_SWG_2ND_16_10000_20" = 'NULL',
"IN_SWG_MIN_6_10000_20" = NULL WHERE "IN_SWG_MIN_6_10000_20" = 'NULL',
"IN_SWG_2ND_6_10000_20" = NULL WHERE "IN_SWG_2ND_6_10000_20" = 'NULL';


DROP TABLE IF EXISTS "12_swg_areas_min_16_county";
CREATE TABLE "12_swg_areas_min_16_county"
AS SELECT
"FIPS",
SUM("SHAPE_AREA"::NUMERIC)*0.0001 AS in_swg
FROM swg_scenarios 
WHERE "IN_SWG_MIN_16_10000_20" = 'TRUE' AND "FIPS" != 'NULL'
GROUP BY "FIPS";

SELECT count(*) FROM "12_swg_areas_min_16_county"
*/