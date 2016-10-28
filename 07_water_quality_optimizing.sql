-- select highest leaching areas, trying different thresholds and sum up the area 

SELECT sum(clumuha) from "05_dndc_clumu_iowa_cgsb_swg_2011_2014";
-- 9496411
SELECT sum(clumuha) from "05_dndc_clumu_iowa_cgsb_swg_2011_2014" WHERE ave_no3_leach_cs > 100;
-- 28803
SELECT sum(clumuha) from "05_dndc_clumu_iowa_cgsb_swg_2011_2014" WHERE ave_no3_leach_cs > 75;
-- 251263
SELECT sum(clumuha) from "05_dndc_clumu_iowa_cgsb_swg_2011_2014" WHERE ave_no3_leach_cs > 50;
-- 2529374
SELECT sum(clumuha) from "05_dndc_clumu_iowa_cgsb_swg_2011_2014" WHERE ave_no3_leach_cs > 60;
-- 1162947
SELECT sum(clumuha) from "05_dndc_clumu_iowa_cgsb_swg_2011_2014" WHERE ave_no3_leach_cs > 65;
-- 738012
SELECT sum(clumuha) from "05_dndc_clumu_iowa_cgsb_swg_2011_2014" WHERE ave_no3_leach_cs > 62;
-- 956925

-- threshold of 62 kg/ha selected, as the resulting area comes close to 10%.
