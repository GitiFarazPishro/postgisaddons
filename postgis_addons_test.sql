﻿-------------------------------------------------------------------------------
-- PostGIS PL/pgSQL Add-ons - Test file
-- Version 1.x for PostGIS 2.1.x and PostgreSQL 9.x
-- http://github.com/pedrogit/postgisaddons
--
-- This test file return a table of two columns: 
--
-- - the 1st column is the number of the test (e.g. 2.3) 
-- - the 2nd column is the name of the function being tested
-- - the 3rd column is the description of the test
-- - the 4th column is the result of the test: 
--
--   - true  if the test passed
--   - false if the test did not pass
--
-- Simply execute the text in as a SQL file to chech if every test pass.
--
-----------------------------------------------------------
-- Comment out the following line and the last one of the file to display 
-- only failing tests
--SELECT * FROM (

---------------------------------------------------------
-- Test ST_DeleteBand
---------------------------------------------------------

SELECT '1.1'::text test_number,
       'ST_DeleteBand'::text function_tested,
       'True deletion of one band'::text test_description,
        ST_NumBands(ST_DeleteBand(ST_AddBand(ST_MakeEmptyRaster(10, 10, 0, 0, 1),
                                             ARRAY[ROW(NULL, '8BUI', 255, 0), 
                                                   ROW(NULL, '16BUI', 1, 2)]::addbandarg[]), 2)) = 1 passed
UNION ALL
---------------------------------------------------------
SELECT '1.2'::text test_number,
       'ST_DeleteBand'::text function_tested,
       'Index too high (3)'::text test_description,
        ST_NumBands(ST_DeleteBand(rast, 3)) = 2 passed
FROM (SELECT ST_AddBand(ST_MakeEmptyRaster(10, 10, 0, 0, 1),
                        ARRAY[ROW(NULL, '8BUI', 255, 0), 
                              ROW(NULL, '16BUI', 1, 2)]::addbandarg[]) rast
     ) foo
UNION ALL
---------------------------------------------------------
SELECT '1.3'::text test_number,
       'ST_DeleteBand'::text function_tested,
       'Index zero'::text test_description,
        ST_NumBands(ST_DeleteBand(rast, 0)) = 2 passed
FROM (SELECT ST_AddBand(ST_MakeEmptyRaster(10, 10, 0, 0, 1),
                        ARRAY[ROW(NULL, '8BUI', 255, 0), 
                              ROW(NULL, '16BUI', 1, 2)]::addbandarg[]) rast
     ) foo
UNION ALL
---------------------------------------------------------
SELECT '1.4'::text test_number,
       'ST_DeleteBand'::text function_tested,
       'Index minus one'::text test_description,
        ST_NumBands(ST_DeleteBand(rast, -1)) = 2 passed
FROM (SELECT ST_AddBand(ST_MakeEmptyRaster(10, 10, 0, 0, 1),
                        ARRAY[ROW(NULL, '8BUI', 255, 0), 
                              ROW(NULL, '16BUI', 1, 2)]::addbandarg[]) rast
     ) foo

---------------------------------------------------------
-- Test ST_CreateIndexRaster
---------------------------------------------------------

UNION ALL
SELECT '2.1'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Basic index raster'::text test_description,
       (ST_DumpValues(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BUI'))).valarray = 
       '{{0,4,8,12},{1,5,9,13},{2,6,10,14},{3,7,11,15}}' passed
UNION ALL
SELECT '2.2'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Pixel type 8BUI'::text test_description,
       ST_BandPixelType(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BUI')) = 
       '8BUI' passed
UNION ALL
SELECT '2.3'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Pixel type 32BF'::text test_description,
       ST_BandPixelType(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '32BF')) = 
       '32BF' passed
UNION ALL
SELECT '2.4'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Start value = 99'::text test_description,
       (ST_DumpValues(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BUI', 99))).valarray = 
       '{{99,103,107,111},{100,104,108,112},{101,105,109,113},{102,106,110,114}}' passed
UNION ALL
SELECT '2.5'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Negative start value = -99'::text test_description,
       (ST_DumpValues(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BSI', -99))).valarray = 
       '{{-99,-95,-91,-87},{-98,-94,-90,-86},{-97,-93,-89,-85},{-96,-92,-88,-84}}' passed
UNION ALL
SELECT '2.6'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Decrementing X'::text test_description,
       (ST_DumpValues(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BUI', 0, false))).valarray = 
       '{{12,8,4,0},{13,9,5,1},{14,10,6,2},{15,11,7,3}}' passed
UNION ALL
SELECT '2.7'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Decrementing X and Y'::text test_description,
       (ST_DumpValues(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BUI', 0, false, false))).valarray = 
       '{{15,11,7,3},{14,10,6,2},{13,9,5,1},{12,8,4,0}}' passed
UNION ALL
SELECT '2.8'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Rows increment first'::text test_description,
       (ST_DumpValues(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BUI', 0, true, true, false))).valarray = 
       '{{0,1,2,3},{4,5,6,7},{8,9,10,11},{12,13,14,15}}' passed
UNION ALL
SELECT '2.9'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Rows increment first and row-prime scan order'::text test_description,
       (ST_DumpValues(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BUI', 0, true, true, false, false))).valarray = 
       '{{0,1,2,3},{7,6,5,4},{8,9,10,11},{15,14,13,12}}' passed
UNION ALL
SELECT '2.10'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Rows incremant by 2 and cols by 10'::text test_description,
       (ST_DumpValues(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BUI', 0, true, true, true, true, 10, 2))).valarray = 
       '{{0,10,20,30},{2,12,22,32},{4,14,24,34},{6,16,26,36}}' passed
UNION ALL
SELECT '2.11'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Start at 3, decrement with y, row-prime scan order, increment by 100 and 2'::text test_description,
       (ST_DumpValues(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BUI', 3, true, false, true, false, 100, 2))).valarray = 
       '{{9,103,209,255},{7,105,207,255},{5,107,205,255},{3,109,203,255}}' passed
UNION ALL
SELECT '2.12'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Start at -10, decrement with x, columns increment first, increment by 2 and 20'::text test_description,
       (ST_DumpValues(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BSI', -10, false, true, false, true, 2, 20))).valarray = 
       '{{-4,-6,-8,-10},{16,14,12,10},{36,34,32,30},{56,54,52,50}}' passed
UNION ALL
SELECT '2.13'::text test_number,
       'ST_CreateIndexRaster'::text function_tested,
       'Start at -10, decrement with x and y, columns increment first, row-prime scan order, increment by 2 and 20'::text test_description,
       (ST_DumpValues(
          ST_CreateIndexRaster(
             ST_MakeEmptyRaster(4, 4, 0, 0, 1, 1, 0, 0), '8BSI', -10, false, false, false, false, 2, 20))).valarray = 
       '{{50,52,54,56},{36,34,32,30},{10,12,14,16},{-4,-6,-8,-10}}' passed
       
---------------------------------------------------------
-- To add a text, copy the next test template above...
---------------------------------------------------------
-- Test ST_FunctionName

-- UNION ALL
-- SELECT 'x.y'::text test_number,
--        'ST_FunctionName'::text function_tested,
--        'Write a descriotion here'::text test_description,
--        Actual call to the function to test = 'what the test should equal' passed
---------------------------------------------------------
-- This last line has to be commented out, with the line at the beginning,
-- to display only failing tests...
--) foo WHERE NOT passed;