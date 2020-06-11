*============================================================*
*=============PAIRS PER YEAR====================================*
*============================================================*

clear

use "${hp}/stata_data/data_complete", replace

forvalues f = 1864(1)1899 {

egen pairs_`f' = count(sale_year_1) if sale_year_1 == `f'

egen b = mean(pairs_`f')

replace pairs_`f' = b

drop b

replace pairs_`f' = 0  if pairs_`f' == .

egen pairs_2 = count(sale_year_2) if sale_year_2 == `f'

egen b = mean(pairs_2)

replace pairs_2 = b

drop b

replace pairs_2 = 0 if pairs_2 == .

replace pairs_`f' = pairs_`f' + pairs_2 

drop pairs_2

replace pairs_`f' = . if pairs_`f' == 0

}

// adding the first and second transactions that took place on the same year

drop id*

gen id = _n

keep pairs* id

keep  if id == 1

reshape long pairs_@, i(id) j(year) string

destring year, replace 

rename pairs_ pairs

cd 	"${hp}/graphs"	

twoway bar pairs year, scheme(s1color) legend(size(`size') order(1) cols(1) region(lwidth(none))) ytitle("Pairs")  title("Number of Transaction Pairs")
        graph export pairs.pdf, replace	














