*==================================================================*
*==============CHECKING FOR OUTLIERS===================================*
*==================================================================*

clear

use "${hp}/stata_data/data_complete", replace

* check whether the yearly growth is too big

gen holding_period = sale_year_2 - sale_year_1 

drop if holding_period < 2

gen log_sale_price_1 = log(sale_price_1)

gen log_sale_price_2 = log(sale_price_2)

gen return = log_sale_price_2 - log_sale_price_1

gen return_year = return/holding_period

winsor2 return_year, cuts(1 99) replace

gen r_t = return_year*holding_period

save "${hp}/stata_data/data_cleaned", replace
 
