

*====================================================================*
*====MASTER FILE FOR BORDEAUX=============================================*
*====================================================================*


clear 
 
set more off

*________ data input 

timer on 1


capture cd "..\stata_code"



include paths


*______

run "${hp}/stata_code/load_repeat_sales"


*_____

run "${hp}/stata_code/appraisals"


*______


run "${hp}/stata_code/outliers" 


*______

run "${hp}/stata_code/pairs"


*______


run "${hp}/stata_code/repeat_sales"


*______


run "${hp}/stata_code/WLS_Schiller_repeat_sales"









