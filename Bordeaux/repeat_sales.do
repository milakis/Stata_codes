*=====================================================*
*===============REPEAT SALES=============================*
*=====================================================*

clear 

use "${hp}/stata_data/data_cleaned", replace

*Create dummies for the years between 1864 and 1899 

forvalues i = 1864(1)1899 {

gen dummy`i' = 0

replace dummy`i' = 1 if `i' == sale_year_2

replace dummy`i' = -1 if `i' == sale_year_1 

}

reg r_t dummy*, noconstant

drop dummy*

mata : st_matrix("coef", exp(st_matrix("e(b)")))

mat li coef

forvalues j = 1(1)36 {

local g = `j' + 1863

gen index`g' = coef[1,`j']

}

keep index* 

gen id = _n

drop if _n > 1

quietly reshape long index@, i(id) j(year) string

destring year, replace

save "${hp}/stata_data/data_deflated", replace

cd "${hp}/graphs"
line index year, scheme(s1color) legend(size(`size') order(1) cols(1) region(lwidth(none)))
	
graph export nominal_index_1864_1899.pdf, replace







