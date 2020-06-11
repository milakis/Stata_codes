*=============================================*
*==========DATA FOR BORDEAUX======================*
*=============================================*


clear 

set more off

use "${hp}/stata_data/data_raw"

//SPLIT THE DATASET INTO FIRST SECOND, THIRD AND FOURTH TRANSACTIONS


*FIRST TRANSACTIONS

forvalues t = 3/7 {

drop sale_price_`t' sale_year_`t'

}

gen id_1 = _n

drop id

save "${hp}/stata_data/data_complete", replace


*SECOND TRANSACTIONS - 2 with 3

use "${hp}/stata_data/data_raw", replace

forvalues t = 4/7 {

drop sale_price_`t' sale_year_`t'

}

forvalues t = 1/1 {

drop sale_price_`t' sale_year_`t'

}

keep if sale_price_3 !=.

gen id_2 = _n

drop id

//replace names of the variables s.t. we always have sale_price_1 and sale_price_2

forvalues t = 2/3 {

local t_1  = `t' - 1 

rename sale_price_`t' sale_price_`t_1'

rename sale_year_`t' sale_year_`t_1'

}

append using "${hp}/stata_data/data_complete"

save "${hp}/stata_data/data_complete", replace


*THIRD TRANSACTIONS - 3 with 4

use "${hp}/stata_data/data_raw", replace

forvalues t = 5/7 {

drop sale_price_`t' sale_year_`t'

}

forvalues t = 1/2 {

drop sale_price_`t' sale_year_`t'

}

keep if sale_price_4 !=.

gen id_3 = _n

drop id


forvalues t = 3/4 {

local t_1  = `t' - 2 

rename sale_price_`t' sale_price_`t_1'

rename sale_year_`t' sale_year_`t_1'

}

append using "${hp}/stata_data/data_complete"

save "${hp}/stata_data/data_complete", replace


*FOURTH TRANSACTIONS - 4 with 5

use "${hp}/stata_data/data_raw", replace

forvalues t = 6/7 {

drop sale_price_`t' sale_year_`t'

}

forvalues t = 1/3 {

drop sale_price_`t' sale_year_`t'

}

keep if sale_price_5 !=.

gen id_4 = _n

drop id


forvalues t = 4/5 {

local t_1  = `t' - 3 

rename sale_price_`t' sale_price_`t_1'

rename sale_year_`t' sale_year_`t_1'

}

append using "${hp}/stata_data/data_complete"

save "${hp}/stata_data/data_complete", replace


*FIFTH TRANSACTIONS - 5 with 6

use "${hp}/stata_data/data_raw", replace

forvalues t = 7/7 {

drop sale_price_`t' sale_year_`t'

}

forvalues t = 1/4 {

drop sale_price_`t' sale_year_`t'

}

keep if sale_price_6 !=.

gen id_5 = _n

drop id


forvalues t = 5/6 {

local t_1  = `t' - 4 

rename sale_price_`t' sale_price_`t_1'

rename sale_year_`t' sale_year_`t_1'

}

append using "${hp}/stata_data/data_complete"

save "${hp}/stata_data/data_complete", replace


*SIXTH TRANSACTIONS - 6 with 7

use "${hp}/stata_data/data_raw", replace

forvalues t = 1/5 {

drop sale_price_`t' sale_year_`t'

}

keep if sale_price_7 !=.

gen id_6 = _n

drop id


forvalues t = 6/7 {

local t_1  = `t' - 5 

rename sale_price_`t' sale_price_`t_1'

rename sale_year_`t' sale_year_`t_1'

}

append using "${hp}/stata_data/data_complete"

* data management 

drop if sale_year_1 == .

drop if sale_year_2 == .

drop if sale_price_1 == .

drop if sale_price_2 == .

drop if sale_year_1 < 1864

drop if sale_year_2 < 1864

gen n = _n



save "${hp}/stata_data/data_complete", replace




