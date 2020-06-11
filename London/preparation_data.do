*======================================*
*===============LONDON PRICES AND RENTS 1946 - 1969 DATA PREPARATION====================*
*======================================*

clear 
 
set more off

*use "${hp}/Stata_data/Elmer_1_corrected_dist"
*use "${hp}/Stata_data/NN_London_1946-1962"
*use "${hp}/Stata_data/KP_London_1963-1969"
use "${hp}/Stata_data/London_1946-1969"

 
 *UNIFIED RENT. one pound is 20 shillings, one guinea is 21 shilling, one shilling is 12 pence
 
  br
  gen Rent = .
  
  foreach var of varlist Rentpo Rents Rentpe Rentg {
  replace `var' = 0 if missing(`var')
  }
  
  replace Rent = Rentpo + Rents/20 + Rentpe/12/20 + Rentg*21/20 if Frequencywym == "y"
  replace Rent = (Rentpo + Rents/20 + Rentpe/12/20 + Rentg*21/20)*12 if Frequencywym == "m"
  replace Rent = (Rentpo + Rents/20 + Rentpe/12/20 + Rentg*21/20)*52 if Frequencywym == "w"
  
  *UNIFIED PRICE
  gen Price = Pricefreeh
  replace Price = Pricelease if Leaseyears > 50 & Leaseyears < 1000 & Pricefreeh == .
  replace Price = Pricelease if missing(Leaseyears) & Pricelease > 2650 & Pricelease < 10000
  
  *all rooms as one variable
  gen Furnished_dummy = 1 if Furnished == "yes"
  foreach var of varlist  Rooms Bedrooms Bathrooms Kitchen Lounge Reception Scullery Ceiling Garage Garden Furnished_dummy{
  replace `var' = 0 if missing(`var')
  }
  gen Allrooms = Rooms+ Bedrooms+ Bathrooms+ Kitchen+ Lounge+ Reception+ Scullery+ Ceiling
  recast int Allrooms, force
  recast int Bedrooms Bathrooms Kitchen, force
  *create price per room variable to check the outliers
  gen price_per_room = Pricefreeh/ Allrooms
  replace price_per_room = Pricelease/Allrooms if missing(Pricefreeh) & Leaseyears > 50 & Leaseyears < 5000
  gen rent_per_room = Rent/ Allrooms
  
  *correct manually price_per_room outliers
  br if price_per_room > 2000 & price_per_room < 10000
  drop if Year == 1960 & Price==3250 & Page == 19
  drop if Year == 1960 & Page == 14 & Pricelease == 2550 & Leaseyears ==71
  drop if Year == 1960 & Pricelease == 3450 & Leaseyears == 99 & Page == 19 & Area == "Streatham"
  replace Bedrooms = 2 if Year == 1960 & Pricelease == 2350 & Leaseyears == 99
  replace Bathrooms = 1 if Year == 1960 & Pricelease == 2350 & Leaseyears == 99
  replace Reception = 2 if Year == 1960 & Pricelease == 2350 & Leaseyears == 99
  replace Garden = 1 if Year == 1960 & Pricelease == 2350 & Leaseyears == 99
  replace Kitchen = 1 if Year == 1960 & Pricelease == 2350 & Leaseyears == 99
  replace Allrooms = Rooms+ Bedrooms+ Bathrooms+ Kitchen+ Lounge+ Reception+ Scullery+ Ceiling if Year == 1960 & Pricelease == 2350 & Leaseyears == 99
  replace price_per_room = Price/Allrooms if Year == 1960 & Pricelease == 2350 & Leaseyears == 99
  
  *correct manually rent_per_room outliers
  br if rent_per_room > 500 & rent_per_room < 5000
  replace Rentg = . if rent_per_room > 500 & rent_per_room < 5000
  replace Rent = (Rentpo + Rents/21 + Rentpe/12/21 + Rentg*21/20)*52 if Frequencywym == "w" & rent_per_room > 500 & rent_per_room < 5000
  replace rent_per_room = Rent/Allrooms if rent_per_room > 500 & rent_per_room < 5000
  
  *YIELD
  gen yield = Rent/ Price
  tabulate Year, summarize(yield)
  
  egen area_int = group( Area )
  
  sort Year
  
  *recode type of the house. 1 = house, 2 = maisonnette, 3 - villa, 4 - cottage, 5 - bungalow, 6 - flat, 7 - room
  replace Typerhfmvc = "h" if Typerhfmvc == "r" & !missing( Pricefreeh)
  gen Type = 7
  replace Type = 6 if Typerhfmvc == "m" | Typerhfmvc == "maisonnettes"
  replace Type = 5 if Typerhfmvc == "v" | Typerhfmvc == "villa"
  replace Type = 4 if Typerhfmvc == "c"
  replace Type = 3 if Typerhfmvc == "bungalow" | Typerhfmvc == "Bungalow"
  replace Type = 2 if Typerhfmvc == "f"
  replace Type = 1 if Typerhfmvc == "r"
  
  *group by house = 3, flat = 2, room = 1
  gen Type3 = 1
  replace Type3 = 2 if Type == 2
  replace Type3 = 3 if Type == 3 | Type == 4 | Type == 5 | Type == 6 | Type == 7
  
  * aggregate Areas by boroughs
  * merge by Area column with the intial document
  merge m:m Area using "${hp}/Stata_data/area_boroughs"
  drop _merge
  * merge with the document with missing boroughs
  merge m:m Area using "${hp}/Stata_data/area_boroughs_missing",  replace update force
  replace Borough = Borough1 if missing(Borough)
  drop Borough1
  drop _merge
  * choose one Borough if an Area has few at the same time
  gen Borough1 = Borough if strpos(Borough, ",")
  replace Borough1 = substr(Borough1, 1, strpos(Borough1, ",") - 1)
  replace Borough = Borough1 if strpos(Borough, ",")
  drop Borough1
  replace Borough = "Camden" if Borough == "Camden and Islington"
  replace Borough = "Haringey" if Borough == "Haringey and Barnet"
  replace Borough = "Islington" if Borough == "Islington & City"
  replace Borough = "not London" if Borough == "Dartford"
  replace Borough = "Ealing" if strpos(Borough, "Ealing")
  drop if missing(Transciber)
  
  * label Price and Rent
  label variable Rent "Annual in pounds"
  label variable Price "in pounds"
  
  * fill in empty Area
  replace Area = "Streatham" if Pricefreeh == 2600 & Year == 1960 & Page == 15 & Bedroom == 3
  replace Borough = "Lambeth" if Pricefreeh == 2600 & Year == 1960 & Page == 15 & Bedroom == 3
  replace Area = "Rookery" if Pricefreeh == 3300 & Year == 1960 & Page == 15 & Bedroom == 3
  replace Borough = "Croydon" if Pricefreeh == 3300 & Year == 1960 & Page == 15 & Bedroom == 3
  replace Rentpo = 425 if Rentpo == 150 & Year == 1963 & Page == 11 & Rooms == 3
  replace Area = "Bayswater" if Rentpo == 425 & Year == 1963 & Page == 11 & Rooms == 3
  replace Borough = "Westminster" if Rentpo == 425 & Year == 1963 & Page == 11 & Rooms == 3
  
  * generate int value
  egen Borough_int = group(Borough)
 
  save "${hp}/Stata_data/London_1946-1969_prepared", replace

 *use "${hp}/Stata_data/London_1946-1969_prepared", clear
  
   *drop if missing(price_per_room)
   *summarize price_per_room, detail
   *keep if inrange(price_per_room, r(p1), r(p99))
   
  *drop if missing(rent_per_room)
   *summarize rent_per_room, detail
   *keep if inrange(rent_per_room, r(p1), r(p99))
 
  
  
