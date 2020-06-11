*======================================*
*===============LONDON PRICES AND RENTS 1963 - 1969 FROM KENSINGTON POST====================*
*======================================*


clear 
 
set more off
 
import excel using "${hp}/Excel/London_1946_1969.xlsx", cellrange(A2:AI6940) firstrow

*keep KP ads
drop if Year < 1963

destring Pricefreeh, replace


*CLEANING 

*drop empty lines
drop if Transciber == "" & Newspaper == ""

*drop AJ AK AL

*drop the observations without number of rooms (any rooms)
drop if Rooms == . & Bedrooms == .

*drop the observations without any prices and rents
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
 replace Frequencywym = "w" if !missing(Rents) & missing( Rentpo ) & Frequencywym == ""
 
  *dealing with Rentpo
 gen renty = Rentpo/ Pricefreeh 
 replace renty = Rentpo / Pricelease if Leaseyears > 50 & Leaseyears < 1000
 gen rentm = Rentpo*12/ Pricefreeh 
 replace rentm = Rentpo*12 / Pricelease if Leaseyears > 50 & Leaseyears < 1000
 gen rentw = Rentpo*52/ Pricefreeh 
 replace rentw = Rentpo*52 / Pricelease if Leaseyears > 50 & Leaseyears < 1000
 br if renty > 0.01 & renty < 0.1
  br if rentm > 0.01 & rentm < 0.1
 br if rentw > 0.01 & rentw < 0.1
 replace Frequencywym = "w" if Rentpo < 26 & missing( Frequencywym)
 replace Frequencywym = "m" if Rentpo < 90 & Rentpo > 25 & missing( Frequencywym)
 replace Frequencywym = "y" if Rentpo > 89 & Rentpo < 1000 & missing( Frequencywym)
 drop renty rentm rentw
 
  br if Pricefreeh < 500
  replace Pricefreeh = . if Pricefreeh < 500
  
  br if Pricefreeh > 20000 & Pricefreeh < 100000
   
  br if Pricelease < 40
  gen n=0
  replace n=1 if Rentpo == 2250
  replace n=1 if Leaseyears == 500 & Pricelease == 18 
  replace Rentpo = Leaseyears if n==1
  replace Leaseyears = Pricelease if n==1
  replace Pricelease = Rentpo if n==1
  replace Rentpo = . if n==1
  drop n
  gen n=0
  replace n=1 if Pricelease == 17
  replace Leaseyears = Pricelease if n==1
  replace Pricelease = Pricefreeh if n==1
  replace Pricefreeh = . if n==1
  drop n
  
  br if Pricelease > 20000 & Pricelease < 100000
  
  br if Leaseyears > 1000 & Leaseyears < 5000
 * correct mixed up pricelease leaseyears
 gen n=0
 replace n=1 if Leaseyears == 3150 & Pricelease == 99
 replace Pricefreeh = Pricelease if n == 1
 replace Leaseyears = Pricelease if n == 1
 replace Pricelease = Pricefreeh  if n == 1
 replace Pricefreeh = . if n == 1
 drop n
 
  br if Rentpo > 700 & Rentpo < 1000 & Frequencywym == "y"
  
  br if Rentpo < 22 & Frequencywym == "y"
  
  br if Rentpo > 22 & Rentpo < 1000 & Frequencywym == "m"
  
  br if Rentpo > 22 & Rentpo < 1000 & Frequencywym == "m"
  
  br if Rents > 40 & Rents < 1000 & Frequencywym == "y"
  gen n=0
  replace n=1 if Rents == 450
  replace Rentpo = Rents if n==1
  replace Rents = . if n==1
  drop n
  
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
 replace Area = "Shepherd's Bush" if Area == " Shephers Bush"
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
 replace Area = "Bayswater" if Area == "Baywater"
 replace Area = "Chiswick" if Area == "Chiswik"
 replace Area = "Kensington" if Area == "Kenshington"
 replace Area = "Knightsbridge" if strpos(Area, "Knight")
 replace Area = "Ladbroke Grove" if strpos(Area, "Lad")
 replace Area = "Marylebone" if Area == "Marleybone"
 replace Area = "Marylebone" if Area == "Marylebone "
 replace Area = "Neasden" if Area == "Neasdan"
 replace Area = "Neasden" if Area == "Neasden "
 replace Area = "Norwood" if Area == "Northwood"
 replace Area = "Queens Gate Mews " if Area == "Quens Gate Mews"
 replace Area = "SouthHall" if Area == "SoutHall"
 replace Area = "Stamford Hill" if Area == "Standford Hill"
 replace Area = "Sydenham" if Area == "Sydenhan"
 replace Area = "West Hampstead" if Area == "West Hamstead"
 replace Area = "West Kensington" if Area == "West Kenington"
 replace Area = "Westminster" if Area == "Westrminster"
 
 local ar `" "Mitcham" "Streatham" "Acton" "Balham" "Barnes" "Battersea" "Beulah" "Brixton" "Carshalton" "Cheam" "Clampham" "Clapham" "Claygate" "Croydon" "Dulwich" "Earlsfield" "Ham" "Sheen" "Hounslow" "Kent" "Merton" "Morden" "Malden" "Norbury" "Kensington" "Norwood" "Notholt" "Richmond" "Ruislip" "Ealing" "Ruislip" "Wimbledon" "Surbiton" "Sydenham" "Tooting" "Trinity" "Wandsworth" "Worcester Park" "Camden" "Holland Park" "Notting Hill" "Willesden" "'
 foreach a of local ar {
 replace Area = "`a'" if strpos(Area, "`a'")
 }
 replace Area = "Clampham" if Area == "Clapham"
  
  save "${hp}/Stata_data/KP_London_1963-1969", replace
  
  append using "${hp}/Stata_data/NN_London_1946-1962"
  save "${hp}/Stata_data/London_1946-1969", replace

  
 
 
 
 
 
 
 
 
