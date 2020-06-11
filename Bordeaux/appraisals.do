*=============================================*
*==========APPRAISALS======================*
*=============================================*


clear 

set more off

use "${hp}/stata_data/data_raw"

*droping observations without appraisals

drop if revenu_brut_1864 == . & revenu_brut_1865 == . & revenu_brut_1870 == . & revenu_brut_1873 == . & revenu_brut_1876 == .

save "${hp}/stata_data/data_raw", replace

*transforming dataset

keep id sale_year_1 sale_price_1 revenu_brut_18* 

rename sale_year_1 sale_year

rename sale_price_1 sale_price

save "${hp}/stata_data/data_complete_appr", replace

foreach i of num 2/7 {

use "${hp}/stata_data/data_raw", replace

keep revenu_brut_18* id sale_year_`i' sale_price_`i'

keep if sale_price_`i' != .

rename sale_year_`i' sale_year

rename sale_price_`i' sale_price

append using "${hp}/stata_data/data_complete_appr"

save "${hp}/stata_data/data_complete_appr", replace

}

drop if sale_year < 1865

gen n = _n

replace sale_year = 1888 if n == 86

replace sale_year = 1886 if n == 101

replace sale_year = 1878 if n == 197

replace sale_year = 1869 if n == 1046

drop n

rename revenu_brut_1865 appr_1865

label variable appr_1865 "Appraisal"

label variable sale_year "Year of sale"

label variable sale_price "Sale price"

save "${hp}/stata_data/data_complete_appr", replace

* common graph and regresion

twoway (scatter appr_1865 sale_price)(lowess appr_1865 sale_price)

reg sale_price appr_1865

* create graphs by years 

forvalues i = 1865(1)1899 {

clear

use "${hp}/stata_data/data_complete_appr"

keep if sale_year == `i'

twoway (scatter appr_1865 sale_price)(lowess appr_1865 sale_price), xtitle(`i') 

cd "${hp}/graphs/appraisals"

graph save `i'.gph, replace

}

graph combine 1865.gph 1866.gph 1867.gph 1868.gph  1869.gph  1870.gph 1871.gph  1872.gph 1873.gph 1874.gph 1875.gph 1876.gph 1877.gph 1878.gph 1879.gph 1880.gph 1881.gph  1882.gph 1883.gph 1884.gph 1885.gph 1886.gph 1887.gph 1888.gph 1889.gph 1890.gph 1891.gph  1892.gph 1893.gph 1894.gph 1895.gph 1896.gph 1897.gph 1898.gph 1899.gph

cd "${hp}/graphs/appraisals"

graph export appraisals.pdf, replace 



