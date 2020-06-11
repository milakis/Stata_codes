*======================================*
*===============LONDON PRICES AND RENTS 1946 - 1962 FROM NORWOOD NEWS ====================*
*======================================*


clear 
 
set more off
 
import excel using "${hp}/Excel/London_1946_1969.xlsx", cellrange(A2:AI6940) firstrow
*import excel using "${hp}/excel/Elmer_1.xlsx", cellrange(A2) firstrow

*keep NN ads
drop if Year > 1962

destring Pricefreeh, replace


*CLEANING 

*drop empty lines
drop if Transciber == "" & Newspaper == ""

*drop the observations without number of rooms (any rooms) - 39 observations
drop if Rooms == . & Bedrooms == .

*drop the observations without any prices and rents - 8 observations
 drop if missing(Pricefreeh) & missing( Pricelease ) & missing( Rentpo)& missing( Rents)& missing( Rentpe)& missing( Rentg)

 *browse and correct if columns pricelease and pricefreh mixed up
 br if missing(Pricelease) & !missing(Leaseyears)
 gen n = 0
 replace n=1 if !missing( Leaseyears) & missing( Pricelease)
 replace Pricelease = Pricefreeh if n == 1
 replace Pricefreeh = . if n == 1
 drop n
  
 *destring some variables
 gen leaseyears = real(Leaseyears)
 drop Leaseyears
 rename leaseyears Leaseyears
 gen rentpe = real(Rentpe)
 drop Rentpe
 rename rentpe Rentpe
 order Transciber TranscriptionDate Newspaper Year Month Date Page Area Pricefreeh Pricelease Leaseyears Rentpo Rents Rentpe
 
 
 *MISSING FREQUENCIES
 
 * this line is necessary to correct manual mistakes 
 replace Frequencywym = "" if Frequencywym == "yc" | Frequencywym == "wc" | Frequencywym == "ys"
 
 *simple
 br if Frequencywym == "" & (!missing( Rentpo) | !missing( Rents) | !missing( Rentpe) | !missing( Rentg))
 replace Frequencywym = "w" if !missing(Rents) & !missing( Rentpe) & missing(Rentpo) & Frequencywym == ""
 replace Frequencywym = "w" if !missing(Rents) & missing( Rentpo ) & Frequencywym == ""
 replace Frequencywym = "w" if !missing( Rentg) & Frequencywym == ""
 
 *dealing with Rentpo
 br if Frequencywym == "" & !missing( Rentpo)
 gen renty = Rentpo/ Pricefreeh if Frequencywym == ""
 replace renty = Rentpo / Pricelease if Frequencywym == "" & Leaseyears > 50 & Leaseyears < 1000
 gen rentm = Rentpo*12/ Pricefreeh if Frequencywym == ""
 replace rentm = Rentpo*12 / Pricelease if Frequencywym == "" & Leaseyears > 50 & Leaseyears < 1000
 gen rentw = Rentpo*52/ Pricefreeh if Frequencywym == ""
 replace rentw = Rentpo*52 / Pricelease if Frequencywym == "" & Leaseyears > 50 & Leaseyears < 1000
 br if renty > 0.01 & renty < 0.1
 br if rentm > 0.01 & rentm < 0.1
 br if rentw > 0.01 & rentw < 0.1
 replace Frequencywym = "w" if Rentpo < 6 & missing( Frequencywym)
 replace Frequencywym = "m" if Rentpo < 23 & Rentpo > 5 & missing( Frequencywym)
 replace Frequencywym = "y" if Rentpo > 22 & Rentpo < 1000 & missing( Frequencywym)
 drop renty rentm rentw
 
 *CHECKS and individual corrections - manual corrections
 
 br if Pricefreeh < 500
 replace Pricefreeh = 3500 if Area == "Tooting" & Pricefreeh == 350
 replace Rentpo = 400 if Area == "Streatham" & Pricefreeh == 400 & Page == 18
 replace Pricefreeh = . if Area == "Streatham" & Rentpo == 400 & Page == 18
 replace Pricefreeh = . if Area == "Clapham" & Pricefreeh == 150 & Page == 7
 drop if Pricefreeh == 250
 
 br if Pricefreeh > 8000 & Pricefreeh < 100000
 
 br if Pricelease < 250
 replace Pricelease = 750 if Pricelease == 75 & Area == "Brixton" & Page == 20
 replace Pricelease = . if Pricelease == 180 & Area == "Streatham" & Page == 18
 replace Rentpo = Pricelease if Area == "Streatham" & Pricelease == 250 & Page == 7
 replace Pricelease = . if Area == "Streatham" & Pricelease == 250 & Page == 7
 replace Pricelease = 2600 if Area == "West Norwood" & Leaseyears == 43
 replace Rentpo = . if Area == "West Norwood" & Leaseyears == 43
 *if lease price is too small (<40) it's given annually. change it to overall price
 replace Pricelease = Pricelease* Leaseyears if Pricelease < 40
 
 br if Pricelease > 8000 & Pricelease < 100000
 
 br if !missing(Pricelease) & missing(Leaseyears)
 * correct mixed up pricefreeh, pricelease and leaseyears
 gen n=0
 replace n=1 if Pricefreeh == 3400 & Pricelease == 93
 replace n=1 if Pricefreeh == 3000 & Pricelease == 1500
 replace Leaseyears = Pricelease  if n == 1
 replace Pricelease = Pricefreeh if n == 1
 replace Pricefreeh = . if n == 1
 drop n
 
 br if Leaseyears > 1000 & Leaseyears < 5000
 * correct mixed up pricelease, rentpo and leaseyears
 gen n=0
 replace n=1 if Leaseyears == 2800 & Rentpo == 78
 replace n=1 if Leaseyears == 2650 & Rentpo == 74
 replace Pricelease = Leaseyears if n == 1
 replace Leaseyears = Rentpo  if n == 1
 replace Rentpo = . if n == 1
 drop n
 
 br if Rentpo > 700 & Rentpo < 1000 & Frequencywym == "y"
 drop if Rentpo == 897
 drop if Rentpo == 900
 replace Rentpo = . if Area == "Upper Norwood" & Rentpo == 850
 
 br if Rentpo < 22 & Frequencywym == "y"
 
 br if Rentpo > 22 & Rentpo < 1000 & Frequencywym == "m"
 replace Rentpo = 16 if Area == "Sydenham" & Rentpo == 145
 replace Rentpo = 2 if Area == "Tooting" & Rentpo == 77 & Page == 13

 br if Rentpo < 6 & Frequencywym == "m"
 replace Frequencywym = "w" if Area == "Tooting" & Rentpo == 2 & Page == 13

 br if Rentpo > 5 & Rentpo < 3000 & Frequencywym == "w"
 gen n = 1 if Pricelease == 1950 & Leaseyears == 55
 replace Pricefreeh = Pricelease if n == 1
 replace Pricelease = Rentpo* Leaseyears if n==1
 replace Rentpo = . if n == 1
 drop n
 *Rentpo weekly - too high (pattern if rentpo > 10 and <100)
 gen n = 1 if Rentpo > 10 & Rentpo < 100 & Frequencywym == "w"
 replace Rents = Rentpo if n == 1
 replace Rentpo = . if n == 1
 drop n
 *Rentpo weekly - too high (pattern if rentpo > 100)
 replace Frequencywym = "y" if Rentpo > 100 & Rentpo < 1000 & Frequencywym == "w"
 
 br if Rentpo == . & Rents != . & Frequencywym == "y"
 *Rent shillings yearly - too small
 gen n = 1  if Rentpo == . & Rents != . & Frequencywym == "y"
 replace Rentpo = Rents if n == 1
 replace Rents = Rentpe if n == 1
 replace Rentpe = . if n == 1
 drop n
 
 br if Rents < 3 & Rentpo == .
 *Rent shillings weekly - too small
 gen n = 1 if missing(Rentpo) & Rents < 3
 replace Rentpo = Rents if n == 1
 replace Rents = . if n == 1
 drop n

 br if Rentg > 20 & Rentg < 1000 & Frequencywym == "w"
 replace Rentg = 2.5 if Area == "Brixton" & Rentg == 21
 replace Rentg = 3.5 if Area == "Streatham" & Rentg == 34
 replace Rentg = 4.5 if Area == "Streatham" & Rentg == 41
 replace Rents = Rentg if Area == "Tooting" & Rentg == 45 & Page == 18
 replace Rentg = . if Area == "Tooting" & Rents == 45 & Page == 18
 replace Rentg = . if Rentg > 20 & Rentg < 1000 
 replace Rentg = . if !missing(Rentg) & !missing(Rentpo)
 replace Rentg = . if !missing(Rentg) & !missing(Rents)
 
 gen n = 1 if Rentpe == 10 & Rentg == 6
 replace Rentpo = Rentpe if n == 1
 replace Rents = Rentg if n ==1
 replace Rentpe = . if n == 1
 replace Rentg = . if n == 1
 drop n
  
 br if Bedrooms > 20 & Bedrooms < 50
 replace Bedrooms = 3 if Bedrooms == 34
 
 *correct areas
 replace Area = "Anerley" if Area == "Anarley"
 replace Area = "Anerley" if Area == "Anerly"
 replace Area = "Battersea" if Area == "Battesea"
 replace Area = "Battersea" if Area == "Bettersea"
 replace Area = "Beulah" if Area == "Beaulah Hill"
 replace Area = "Brixton" if Area == "Brixtin Hill"
 replace Area = "Claygate" if Area == "Clay gate"
 replace Area = "Colliers Wood" if Area == "Coliers Wood"
 replace Area = "Crofton Park" if Area == "Crofton park"
 replace Area = "Herne Hill" if Area == "Henre Hill"
 replace Area = "Earlsfield" if Area == "Earsfield"
 replace Area = "Langham" if Area == "Liegham"
 replace Area = "Merton" if Area == "Metron"
 replace Area = "Merton" if Area == "Metron Park"
 replace Area = "Mitcham" if Area == "Micham"
 replace Area = "Morden" if Area == "Modern"
 replace Area = "Nightingale Lane" if Area == "Nightingale lane"
 replace Area = "Parsons Green" if Area == "Parson Green"
 replace Area = "Pollards Hill" if Area == "Polard"
 replace Area = "Pollards Hill" if Area == "Pollands Hill"
 replace Area = "Pollards Hill" if Area == "Pollards  Hill"
 replace Area = "South London" if Area == "SW London"
 replace Area = "Shepherd's Bush" if Area == "Sheperds Bush"
 replace Area = "Shepherd's Bush" if Area == "Shepherds Bush"
 replace Area = "Southfields" if Area == "SouthFields"
 replace Area = "Streatham" if Area == "Steatham"
 replace Area = "Stockwell" if Area == "StockWell"
 replace Area = "Streatham" if Area == "Streartham"
 replace Area = "Streatham" if Area == "Streatahm"
 replace Area = "Streatham" if Area == "Stretham"
 replace Area = "Streatham" if Area == "Stretham Hill"
 replace Area = "Streatham" if Area == "Strteatham Hill"
 replace Area = "Streatham" if Area == "streatham"
 replace Area = "Sydenham" if Area == "Sydeham"
 replace Area = "Thornton Heath" if Area == "Thoeton Heath"
 replace Area = "Thornton Heath" if Area == "Thornthon Heath"
 replace Area = "Thornton Heath" if Area == "Thornton"
 replace Area = "Thornton Heath" if Area == "Thornton heath"
 replace Area = "Thornton Heath" if Area == "Thorthon Heath"
 replace Area = "Thornton Heath" if Area == "Thorton Heath"
 replace Area = "Tulse Hill" if Area == "Thulse Hill"
 replace Area = "Tulse Hill" if Area == "Tules Hill"
 replace Area = "Tulse Hill" if Area == "Tulse"
 replace Area = "Norwood" if Area == "Upper Norwod"
 replace Area = "Tulse Hill" if Area == "Upper Tulse"
 replace Area = "Tulse Hill" if Area == "Upper Tulse Hill"
 replace Area = "Tooting" if Area == "Upper tooting"
 replace Area = "Wandsworth" if Area == "Wandswoth Common"
 replace Area = "Wandsworth" if Area == "Wandworth"
 replace Area = "Norwood" if Area == "West Noorwood"
 replace Area = "Worcester Park" if Area == "Worcerter Park"
 replace Area = "Clampham" if Area == "clapham"
 
 
 local ar `" "Mitcham" "Streatham" "Acton" "Balham" "Barnes" "Battersea" "Beulah" "Brixton" "Carshalton" "Cheam" "Clampham" "Clapham" "Claygate" "Croydon" "Dulwich" "Earlsfield" "Ham" "Sheen" "Hounslow" "Kent" "Merton" "Morden" "Malden" "Norbury" "Kensington" "Norwood" "Notholt" "Richmond" "Ruislip" "Ealing" "Ruislip" "Wimbledon" "Surbiton" "Sydenham" "Tooting" "Trinity" "Wandsworth" "Worcester Park" "'
 foreach a of local ar {
 replace Area = "`a'" if strpos(Area, "`a'")
 }
 replace Area = "Clampham" if Area == "Clapham"
 
  save "${hp}/Stata_data/NN_London_1946-1962", replace
  
  
  
  
  
  
