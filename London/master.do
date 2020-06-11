
*____________________________________________________________________________*
*________CONSTRUCT HOUSEPRICE AND RENT INDICES FOR THE SPECIFIED CITY________*
*____________________________________________________________________________*


*____________________________________________________________________________*
*______BEFORE RUNNING THE CODE ALTER THE PATHS FILE TO THE DESIRED END_______*
*____________________________________________________________________________*



clear 
 
set more off

*________ data input 


capture cd "../Stata_code"

include paths

* Define baseyear for whole programm
global baseyear 1990 1970

* Define cityname for whole programm
global cityname  London


*_______ LOAD THE DATA FROM EXCEL AND CONSTRUCT SERIES_________*

*run "${hp}/Stata_code/data"

*_______ CALCULATE HOUSING RETURNS _________*

*run "${hp}/Stata_code/hous_returns" 
 
 
*_______ CONSTRUCT FINAL DATASET TO EXPORT _________*

*run "${hp}/Stata_code/final_dataset_to export" 


 
* Delete globals
macro drop baseyear
macro drop cityname


