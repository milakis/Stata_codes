*=====================================================*
*===============REPEAT SALES WLS SHILLER=============================*
*=====================================================*

clear 

use "${hp}/stata_data/data_cleaned", replace

*standard regression as in the repeat sales

forvalues i = 1864(1)1899 {

gen dummy`i' = 0

replace dummy`i' = 1 if `i' == sale_year_2

replace dummy`i' = -1 if `i' == sale_year_1 

}

reg r_t dummy*, noconstant

* WLS

* regress squared residuals on constant and interval between sales

predict res, residuals

gen res_sq = res^2

reg res_sq holding_period 

* obtain square roots of fitted values

predict fitted_2

gen sq_fitted_2 = sqrt(fitted_2)

* divide all observations on square root of fitted values and run wls regression

gen r_t_wls = r_t/sq_fitted_2

forvalues i = 1864(1)1899 {
   gen dummy_wls`i' = dummy`i' / sq_fitted_2
   }

reg r_t_wls dummy_wls*, noconstant

* derive indices in the same manner

drop dummy_wls*

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

gen index_base = index/index[1]

save "${hp}/stata_data/data_deflated_wls", replace

cd "${hp}/graphs"
line index_base year, scheme(s1color) legend(size(`size') order(1) cols(1) region(lwidth(none)))

graph export nominal_index_wls_1864_1899.pdf, replace

gen growth = (index/index[_n-1] - 1)*100

sum growth




