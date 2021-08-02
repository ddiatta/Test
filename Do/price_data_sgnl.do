** Senegal price data ******************************************
** This file contains code that cleans price data for Senegal **
****************************************************************

********************************************************************************	

clear all
macro drop _all // reset globals
set more off
set mem 800m
********************************************************************************	


********************************************************************************	
*** SET FOLDER PATH 
********************************************************************************

	if c(username)=="ddiatta"{
		global dir "C:\Users\ddiatta\Dropbox (Personal)"  		
	}
	
	
cd "$dir"

global data_raw 	"$dir\SAHEL-SHOCKS\Documents\Raw data\Prix"		// raw data in shared DB folder
global data_clean 	"$dir\DIME\Data" 					    // cleaned data in personal DB
global outputs 		"$dir\DIME\Outputs" 					// path to all tables, graphs, etc

********************************************************************************
	

********************************************************************************	
** CEREALES ********************************************************************
********************************************************************************	

import excel "$data_raw/BASE PRIX 1990 2020 SIM CSA.xlsx", sheet("CEREALES") firstrow clear
drop L M
replace MARCHE = "TOUBA" if MARCHE == "TOUBA "
replace MARCHE = "SAGATTA" if MARCHE == "SAGATTA "
replace MARCHE = "LOUGA" if MARCHE == "LOUGA "
replace MARCHE = "TOUBA TOUL" if MARCHE == "Touba Toul"
replace DEPARTEMENT = "ST.LOUIS" if DEPARTEMENT == "ST. LOUIS"
destring RIZBRISEIMPORTEPARFUME, replace
duplicates tag, gen(dups)
duplicates drop 
drop dups
*************************
** data cleaning regions/departments to account for changes in administrative divisions
replace REGION = "KAFFRINE" if MARCHE == "MABO"  // Since 2008 Kaffrine is no longer a department of Kaolack
replace REGION = "SEDHIOU" if MARCHE == "SEDHIOU"  // Since 2008 Sedhiou is no longer a department of Kolda
replace DEPARTEMENT = "KANEL" if MARCHE == "ORKODIERE"
replace DEPARTEMENT = "MATAM" if MARCHE == "THIODAYE"
replace REGION = "MATAM" if DEPARTEMENT == "MATAM"
replace REGION = "SEDHIOU" if DEPARTEMENT == "BOUNKILING"
replace REGION = "LOUGA" if DEPARTEMENT == "KEBEMER"
replace DEPARTEMENT = "BIGNONA" if MARCHE == "BIGNONA"
replace DEPARTEMENT = "KAFFRINE" if MARCHE == "MABO"

*duplicates drop REGION DEPARTEMENT MARCHE, force
sort REGION DEPARTEMENT MARCHE DATE
*************************

gen x = ";" 
gen market 	= REGION+x+DEPARTEMENT+x+MARCHE // create a unique market identifier
sort REGION DEPARTEMENT MARCHE DATE
drop x
gen year 	= year(DATE)
gen month 	= month(DATE)
gen day 	= day(DATE)
gen date 	= mofd(DATE) // create a monthly variable

gen date2 	= date
format date2 %tm
collapse (mean) MIL - RIZLOCALDECORTIQUE, by(REGION DEPARTEMENT MARCHE market year month date date2)   // aggregrate prices to monthly prices
encode market, generate(markets)

order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year  
isid 		markets date
tsset 		markets date
tsfill, full
list, clean noobs
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace
gsort 		markets - date
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace

sort 		market date month year
duplicates 	tag market date, gen(dups)
tab 		dups
drop 		dups
sort 		market date month year
gen n		= _n
order 		n
format date %tm
gen date3 	= dofm(date)
gen month2	= month(date3)
gen year2	= year(date3)
drop 		year month date2 date3
rename 		year2 year 
rename 		month2 month
drop 		n 
order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year 

save 		"$data_clean/Prices_monthly_cereals.dta", replace
export 		excel using "$data_clean\Prices_monthly_cereals.xlsx", firstrow(variables) replace



******** Summary statistics ***************************************************************************************
/*global cereals MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE

global format1 rtf

bys market: mdesc $cereals 
estpost tabstat $cereals, by(MARCHE) columns(statistics)
esttab . using Table1.$format1, main(mean %12.0fc) not nostar unstack nomtitle nonumber nonote noobs label replace
*/
// create a variable containing that proportion

local cereals MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE

sort market date
foreach var of local cereals{
    by market : egen pr`var' = mean(missing(`var'))
}
list market date `vars' pr*, sepby(market)

// make a table showing that proportion
foreach var of local vars {
    gen m`var' = missing(`var')
}
xtable market, c(N MIL mean prMIL mean MIL min MIL max MIL) filename(Price_monthly) sheet(Millet) replace
xtable market, c(N SORGHO mean prSORGHO mean SORGHO min SORGHO max SORGHO) filename(Price_monthly) sheet(Sorghum) 
xtable market, c(N MAÏSLOCAL mean prMAÏSLOCAL mean MAÏSLOCAL min MAÏSLOCAL max MAÏSLOCAL) filename(Price_monthly) sheet(Maize local) 
xtable market, c(N MAÏSIMPORTE mean prMAÏSIMPORTE mean MAÏSIMPORTE min MAÏSIMPORTE max MAÏSIMPORTE) filename(Price_monthly) sheet(Maize imported) 
xtable market, c(N RIZIMPORTEBRISEORDINAIRE mean prRIZIMPORTEBRISEORDINAIRE mean RIZIMPORTEBRISEORDINAIRE min RIZIMPORTEBRISEORDINAIRE max RIZIMPORTEBRISEORDINAIRE) filename(Price_monthly) sheet(Rice imp o) 
xtable market, c(N RIZBRISEIMPORTEPARFUME mean prRIZBRISEIMPORTEPARFUME mean RIZBRISEIMPORTEPARFUME min RIZBRISEIMPORTEPARFUME max RIZBRISEIMPORTEPARFUME) filename(Price_monthly) sheet(Rice imp perf) 
xtable market, c(N RIZLOCALDECORTIQUE mean prRIZLOCALDECORTIQUE mean RIZLOCALDECORTIQUE min RIZLOCALDECORTIQUE max RIZLOCALDECORTIQUE) filename(Price_monthly) sheet(Rice local) 

********************************************************************************	
** VEGETABLES ******************************************************************
********************************************************************************	

import excel "$data_raw/BASE PRIX 1990 2020 SIM CSA.xlsx", sheet("LEGUMES") firstrow clear
replace MARCHE = "TOUBA" if MARCHE == "TOUBA "
replace MARCHE = "SAGATTA" if MARCHE == "SAGATTA "
replace MARCHE = "LOUGA" if MARCHE == "LOUGA "
replace MARCHE = "TOUBA TOUL" if MARCHE == "Touba Toul"
replace DEPARTEMENT = "ST.LOUIS" if DEPARTEMENT == "ST. LOUIS"
duplicates tag, gen(dups)
duplicates drop 
drop dups

*************************
** data cleaning regions/departments to account for changes in administrative divisions

replace DEPARTEMENT = "KAFFRINE" if MARCHE == "MABO"
replace DEPARTEMENT = "MATAM" if MARCHE == "THIODAYE"
replace MARCHE = "THIODAYE" if MARCHE == "THIAROYE"  & DEPARTEMENT == "MATAM"
replace DEPARTEMENT = "BOUNKILING" if MARCHE == "SARE ALKALY"
replace DEPARTEMENT = "KAFFRINE" if MARCHE == "DIAMAGADIO"
replace DEPARTEMENT = "BAMBEY" if MARCHE == "BAMBEY"
replace DEPARTEMENT = "KAOLACK" if MARCHE == "KAOLACK"
*duplicates drop REGION DEPARTEMENT MARCHE, force
*sort REGION DEPARTEMENT MARCHE
*sort MARCHE
sort REGION DEPARTEMENT MARCHE DATE
*************************

gen x = ";" 
gen market 	= REGION+x+DEPARTEMENT+x+MARCHE // create a unique market identifier
sort REGION DEPARTEMENT MARCHE DATE
drop x
gen year 	= year(DATE)
gen month 	= month(DATE)
gen day 	= day(DATE)
gen date 	= mofd(DATE) // create a monthly variable

gen date2 	= date
format date2 %tm
collapse (mean) OIGNONLOCAL - MANIOC, by(REGION DEPARTEMENT MARCHE market year month date date2)   // aggregrate prices to monthly prices
encode market, generate(markets)

order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year  
isid 		markets date
tsset 		markets date
tsfill, full
list, clean noobs
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace
gsort 		markets - date
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace

sort 		market date month year
duplicates 	tag market date, gen(dups)
tab 		dups
drop 		dups
sort 		market date month year
gen n		= _n
order 		n
format date %tm
gen date3 	= dofm(date)
gen month2	= month(date3)
gen year2	= year(date3)
drop 		year month date2 date3
rename 		year2 year 
rename 		month2 month
drop 		n 
order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year 

save 		"$data_clean/Prices_monthly_vegetables.dta", replace
export 		excel using "$data_clean\Prices_monthly_vegetables.xlsx", firstrow(variables) replace

******** Summary statistics ***************************************************************************************
/*global cereals MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE

global format1 rtf

bys market: mdesc $cereals 
estpost tabstat $cereals, by(MARCHE) columns(statistics)
esttab . using Table1.$format1, main(mean %12.0fc) not nostar unstack nomtitle nonumber nonote noobs label replace
*/
// create a variable containing that proportion

local vegetables OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE MANIOC
sort market date
foreach var of local vegetables{
    by market : egen pr`var' = mean(missing(`var'))
}
list market date `vars' pr*, sepby(market)

// make a table showing that proportion
foreach var of local vars {
    gen m`var' = missing(`var')
}

xtable market, c(N OIGNONLOCAL mean prOIGNONLOCAL mean OIGNONLOCAL min OIGNONLOCAL max OIGNONLOCAL) filename(Price_monthly) sheet(Onion local) 
xtable market, c(N OIGNONIMPORTE mean prOIGNONIMPORTE mean OIGNONIMPORTE min OIGNONIMPORTE max OIGNONIMPORTE) filename(Price_monthly) sheet(Onion imported) 
xtable market, c(N POMMEDETERRELOCALE mean prPOMMEDETERRELOCALE mean POMMEDETERRELOCALE min POMMEDETERRELOCALE max POMMEDETERRELOCALE)  filename(Price_monthly) sheet(Potatoe local) 
xtable market, c(N POMMEDETERREIMPORTEE mean prPOMMEDETERREIMPORTEE mean POMMEDETERREIMPORTEE min POMMEDETERREIMPORTEE max POMMEDETERREIMPORTEE)  filename(Price_monthly) sheet(Potatoe imported) 
xtable market, c(N MANIOC mean prMANIOC mean MANIOC min MANIOC max MANIOC)  filename(Price_monthly) sheet(Cassava) 


********************************************************************************	
** LEGUMINEUSES ******************************************************************
********************************************************************************	

import excel "$data_raw/BASE PRIX 1990 2020 SIM CSA.xlsx", sheet("LEGUMINEUSES") firstrow clear
drop H
replace MARCHE = "TOUBA" if MARCHE == "TOUBA "
replace MARCHE = "SAGATTA" if MARCHE == "SAGATTA "
replace MARCHE = "LOUGA" if MARCHE == "LOUGA "
replace MARCHE = "TOUBA TOUL" if MARCHE == "Touba Toul"
replace DEPARTEMENT = "ST.LOUIS" if DEPARTEMENT == "ST. LOUIS"
replace MARCHE = "BAMBEY" if DEPARTEMENT == "BAMBEY" & MARCHE == "DIOURBEL"
replace DEPARTEMENT = "DIOURBEL" if MARCHE == "NDINDY"
replace DEPARTEMENT = "BIGNONA" if MARCHE == "BIGNONA"
replace REGION = "KAFFRINE" if DEPARTEMENT == "KAFFRINE"
replace DEPARTEMENT = "KANEL" if MARCHE == "ORKODIERE"
replace REGION = "MATAM" if DEPARTEMENT == "MATAM"
replace REGION = "SEDHIOU" if DEPARTEMENT == "BOUNKILING"
replace REGION = "ZIGUINCHOR" if DEPARTEMENT == "BIGNONA"
duplicates tag, gen(dups)
duplicates drop 
drop dups

*************************
** data cleaning regions/departments to account for changes in administrative divisions

*duplicates drop REGION DEPARTEMENT MARCHE, force
*************************

gen x = ";" 
gen market 	= REGION+x+DEPARTEMENT+x+MARCHE // create a unique market identifier
sort REGION DEPARTEMENT MARCHE DATE
drop x
gen year 	= year(DATE)
gen month 	= month(DATE)
gen day 	= day(DATE)
gen date 	= mofd(DATE) // create a monthly variable

gen date2 	= date
format date2 %tm
collapse (mean) NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE, by(REGION DEPARTEMENT MARCHE market year month date date2)   // aggregrate prices to monthly prices
encode market, generate(markets)

order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year  
isid 		markets date
tsset 		markets date
tsfill, full
list, clean noobs
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace
gsort 		markets - date
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace

sort 		market date month year
duplicates 	tag market date, gen(dups)
tab 		dups
drop 		dups
sort 		market date month year
gen n		= _n
order 		n
format date %tm
gen date3 	= dofm(date)
gen month2	= month(date3)
gen year2	= year(date3)
drop 		year month date2 date3
rename 		year2 year 
rename 		month2 month
drop 		n 
order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year 

save 		"$data_clean/Prices_monthly_legumes.dta", replace
export 		excel using "$data_clean\Prices_monthly_legumes.xlsx", firstrow(variables) replace

******** Summary statistics ***************************************************************************************
/*global cereals MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE

global format1 rtf

bys market: mdesc $cereals 
estpost tabstat $cereals, by(MARCHE) columns(statistics)
esttab . using Table1.$format1, main(mean %12.0fc) not nostar unstack nomtitle nonumber nonote noobs label replace
*/
// create a variable containing that proportion

local legumes NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE
sort market date
foreach var of local legumes{
    by market : egen pr`var' = mean(missing(`var'))
}
list market date `vars' pr*, sepby(market)

// make a table showing that proportion
foreach var of local vars {
    gen m`var' = missing(`var')
}

xtable market, c(N NIEBE mean prNIEBE mean NIEBE min NIEBE max NIEBE) filename(Price_monthly) sheet(Niebe, replace) 
xtable market, c(N ARACHIDECOQUE mean prARACHIDECOQUE mean ARACHIDECOQUE min ARACHIDECOQUE max ARACHIDECOQUE) filename(Price_monthly) sheet(Peanut shelled, replace) 
xtable market, c(N ARACHIDEDECORTIQUEE mean prARACHIDEDECORTIQUEE mean ARACHIDEDECORTIQUEE min ARACHIDEDECORTIQUEE max ARACHIDEDECORTIQUEE) filename(Price_monthly) sheet(Peanut unshelled) 



***** Merge all files *****

use "$data_clean/Prices_monthly_cereals.dta", clear
merge REGION DEPARTEMENT MARCHE market markets date month year using "$data_clean/Prices_monthly_vegetables.dta"
tab _merge
drop _merge
sort REGION DEPARTEMENT MARCHE market markets date month year
merge REGION DEPARTEMENT MARCHE market markets date month year using "$data_clean/Prices_monthly_legumes.dta"
tab _merge
drop _merge

codebook market
*duplicates drop REGION DEPARTEMENT MARCHE, force
*sort MARCHE
drop market markets
gen x = ";" 
gen market 	= REGION+x+DEPARTEMENT+x+MARCHE // create a unique market identifier
sort REGION DEPARTEMENT MARCHE date
drop x
/*gen year 	= year(DATE)
gen month 	= month(DATE)
gen day 	= day(DATE)
gen date 	= mofd(DATE) // create a monthly variable
*/
gen date2 	= date
format date2 %tm
collapse (mean) MIL - ARACHIDEDECORTIQUEE, by(REGION DEPARTEMENT MARCHE market year month date)   // aggregrate prices to monthly prices
encode market, generate(markets)

order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year  
isid 		markets date
tsset 		markets date
tsfill, full
list, clean noobs
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace
gsort 		markets - date
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace

sort 		market date month year
duplicates 	tag market date, gen(dups)
tab 		dups
drop 		dups
sort 		market date month year
gen n		= _n
order 		n
format date %tm
gen date3 	= dofm(date)
gen month2	= month(date3)
gen year2	= year(date3)
drop 		year month date3
rename 		year2 year 
rename 		month2 month
drop 		n 
order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year 

export 		excel using "$data_clean\Prices_monthly_all.xlsx", firstrow(variables) replace
save "$data_clean\Prices_monthly_all.dta", replace






*** Summary statistics ******************************************************************

local vegetables OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE MANIOC
local cereals MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE
local legumes NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE

sort market date
foreach var of local cereals{
    by market : egen pr`var' = mean(missing(`var'))
}

foreach var of local vegetables{
    by market : egen pr`var' = mean(missing(`var'))
}

foreach var of local legumes{
    by market : egen pr`var' = mean(missing(`var'))
}
list market date `vars' pr*, sepby(market)

// make a table showing that proportion
foreach var of local vars {
    gen m`var' = missing(`var')
}

xtable market, c(N MIL mean prMIL mean MIL min MIL max MIL) filename(Price_monthly_all) sheet(Millet) replace
xtable market, c(N SORGHO mean prSORGHO mean SORGHO min SORGHO max SORGHO) filename(Price_monthly_all) sheet(Sorghum) 
xtable market, c(N MAÏSLOCAL mean prMAÏSLOCAL mean MAÏSLOCAL min MAÏSLOCAL max MAÏSLOCAL) filename(Price_monthly_all) sheet(Maize local) 
xtable market, c(N MAÏSIMPORTE mean prMAÏSIMPORTE mean MAÏSIMPORTE min MAÏSIMPORTE max MAÏSIMPORTE) filename(Price_monthly_all) sheet(Maize imported) 
xtable market, c(N RIZIMPORTEBRISEORDINAIRE mean prRIZIMPORTEBRISEORDINAIRE mean RIZIMPORTEBRISEORDINAIRE min RIZIMPORTEBRISEORDINAIRE max RIZIMPORTEBRISEORDINAIRE) filename(Price_monthly_all) sheet(Rice imp o) 
xtable market, c(N RIZBRISEIMPORTEPARFUME mean prRIZBRISEIMPORTEPARFUME mean RIZBRISEIMPORTEPARFUME min RIZBRISEIMPORTEPARFUME max RIZBRISEIMPORTEPARFUME) filename(Price_monthly_all) sheet(Rice imp perf) 
xtable market, c(N RIZLOCALDECORTIQUE mean prRIZLOCALDECORTIQUE mean RIZLOCALDECORTIQUE min RIZLOCALDECORTIQUE max RIZLOCALDECORTIQUE) filename(Price_monthly_all) sheet(Rice local) 

xtable market, c(N OIGNONLOCAL mean prOIGNONLOCAL mean OIGNONLOCAL min OIGNONLOCAL max OIGNONLOCAL) filename(Price_monthly_all) sheet(Onion local) 
xtable market, c(N OIGNONIMPORTE mean prOIGNONIMPORTE mean OIGNONIMPORTE min OIGNONIMPORTE max OIGNONIMPORTE) filename(Price_monthly_all) sheet(Onion imported) 
xtable market, c(N POMMEDETERRELOCALE mean prPOMMEDETERRELOCALE mean POMMEDETERRELOCALE min POMMEDETERRELOCALE max POMMEDETERRELOCALE)  filename(Price_monthly_all) sheet(Potatoe local) 
xtable market, c(N POMMEDETERREIMPORTEE mean prPOMMEDETERREIMPORTEE mean POMMEDETERREIMPORTEE min POMMEDETERREIMPORTEE max POMMEDETERREIMPORTEE)  filename(Price_monthly_all) sheet(Potatoe imported) 
xtable market, c(N MANIOC mean prMANIOC mean MANIOC min MANIOC max MANIOC)  filename(Price_monthly_all) sheet(Cassava) 

xtable market, c(N NIEBE mean prNIEBE mean NIEBE min NIEBE max NIEBE) filename(Price_monthly_all) sheet(Niebe, replace) 
xtable market, c(N ARACHIDECOQUE mean prARACHIDECOQUE mean ARACHIDECOQUE min ARACHIDECOQUE max ARACHIDECOQUE) filename(Price_monthly_all) sheet(Peanut shelled, replace) 
xtable market, c(N ARACHIDEDECORTIQUEE mean prARACHIDEDECORTIQUEE mean ARACHIDEDECORTIQUEE min ARACHIDEDECORTIQUEE max ARACHIDEDECORTIQUEE) filename(Price_monthly_all) sheet(Peanut unshelled) 



save 		"$data_clean/Prices_monthly.dta", replace

local crops MIL SORGHO MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE MANIOC NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE

foreach var of local crops {
sum pr`var' if `var' !=. & pr`var' <0.5
}

drop if year <2012






/*






import excel "C:\Users\ddiatta\Dropbox (Personal)\SAHEL-SHOCKS\Documents\Raw data\Prix\BASE PRIX 1990 2020 SIM CSA.xlsx", sheet("LEGUMES") firstrow clear
replace MARCHE = "TOUBA" if MARCHE == "TOUBA "
replace MARCHE = "SAGATTA" if MARCHE == "SAGATTA "
replace MARCHE = "LOUGA" if MARCHE == "LOUGA "
replace MARCHE = "TOUBA TOUL" if MARCHE == "Touba Toul"
replace DEPARTEMENT = "ST.LOUIS" if DEPARTEMENT == "ST. LOUIS"
duplicates tag, gen(dups)
order dups
sort dups REGION DEPARTEMENT MARCHE DATE
duplicates drop 
drop dups
duplicates tag REGION DEPARTEMENT MARCHE DATE, gen(dups)
tab dups
order dups 
sort dups REGION DEPARTEMENT MARCHE DATE
drop dups
gen x = ";"
gen market = REGION+x+DEPARTEMENT+x+MARCHE
sort REGION DEPARTEMENT MARCHE DATE
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_legumes.xls", replace
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_legumes.dta", replace


import excel "C:\Users\ddiatta\Dropbox (Personal)\SAHEL-SHOCKS\Documents\Raw data\Prix\BASE PRIX 1990 2020 SIM CSA.xlsx", sheet("LEGUMINEUSES") firstrow clear
drop H
replace MARCHE = "TOUBA" if MARCHE == "TOUBA "
replace MARCHE = "SAGATTA" if MARCHE == "SAGATTA "
replace MARCHE = "LOUGA" if MARCHE == "LOUGA "
replace MARCHE = "TOUBA TOUL" if MARCHE == "Touba Toul"
replace DEPARTEMENT = "ST.LOUIS" if DEPARTEMENT == "ST. LOUIS"
duplicates tag, gen(dups)
order dups
sort dups REGION DEPARTEMENT MARCHE DATE
duplicates drop 
drop dups
duplicates tag REGION DEPARTEMENT MARCHE DATE, gen(dups)
tab dups
order dups 
sort dups REGION DEPARTEMENT MARCHE DATE
drop dups
gen x = ";"
gen market = REGION+x+DEPARTEMENT+x+MARCHE
sort REGION DEPARTEMENT MARCHE DATE
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_legumineuses.xlsx", replace
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_legumineuses.dta", replace

use "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_cereals.xlsx", clear
sort REGION DEPARTEMENT MARCHE DATE
merge REGION DEPARTEMENT MARCHE DATE using "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_legumes.xlsx"
order _merge
sort _merge
drop _merge
sort REGION DEPARTEMENT MARCHE DAT
merge REGION DEPARTEMENT MARCHE DATE using "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_legumineuses.xlsx"
order _merge
sort _merge
drop _merge

save "C:\Users\ddiatta\Dropbox (Personal)\Prices_market.xlsx", replace
duplicates tag REGION DEPARTEMENT MARCHE DATE, gen(dups)
tab dups 
order dups 

sort dups REGION DEPARTEMENT MARCHE DATE
unique REGION DEPARTEMENT MARCHE DATE // data are not uniquely identified by market and date 
order dups 
sort dups REGION DEPARTEMENT MARCHE DATE

tab1 REGION DEPARTEMENT MARCHE DATE if dups ==1 // check if error distribution is even across space and time, and crops
drop if dups ==1
drop dups

unique REGION DEPARTEMENT MARCHE DATE // data are not uniquely identified by market and date 

save "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_nodups.xlsx", replace

use "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_nodups.xlsx", clear

sum MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE MANIOC NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE

table MARCHE, c(mean MIL min MIL max MIL N MIL)
table MARCHE, c(mean SORGHO min SORGHO max SORGHO N SORGHO) 
table MARCHE, c(mean MAÏSLOCAL min MAÏSLOCAL max MAÏSLOCAL N MAÏSLOCAL) 
table MARCHE, c(mean MAÏSIMPORTE min MAÏSIMPORTE max MAÏSIMPORTE N MAÏSIMPORTE)
table MARCHE, c(mean RIZIMPORTEBRISEORDINAIRE min RIZIMPORTEBRISEORDINAIRE max RIZIMPORTEBRISEORDINAIRE N RIZIMPORTEBRISEORDINAIRE) 
table MARCHE, c(mean RIZBRISEIMPORTEPARFUME min RIZBRISEIMPORTEPARFUME max RIZBRISEIMPORTEPARFUME N RIZBRISEIMPORTEPARFUME) 
table MARCHE, c(mean RIZLOCALDECORTIQUE min RIZLOCALDECORTIQUE max RIZLOCALDECORTIQUE N RIZLOCALDECORTIQUE) 
table MARCHE, c(mean OIGNONLOCAL min OIGNONLOCAL max OIGNONLOCAL N OIGNONLOCAL) 
table MARCHE, c(mean OIGNONIMPORTE min OIGNONIMPORTE max OIGNONIMPORTE N OIGNONIMPORTE) 
table MARCHE, c(mean POMMEDETERRELOCALE min POMMEDETERRELOCALE max POMMEDETERRELOCALE N POMMEDETERRELOCALE) 
table MARCHE, c(mean POMMEDETERREIMPORTEE min POMMEDETERREIMPORTEE max POMMEDETERREIMPORTEE N POMMEDETERREIMPORTEE) 
table MARCHE, c(mean MANIOC min MANIOC max MANIOC N MANIOC) 
table MARCHE, c(mean NIEBE min NIEBE max NIEBE N NIEBE) 
table MARCHE, c(mean ARACHIDECOQUE min ARACHIDECOQUE max ARACHIDECOQUE N ARACHIDECOQUE) 
table MARCHE, c(mean ARACHIDEDECORTIQUEE min ARACHIDEDECORTIQUEE max ARACHIDEDECORTIQUEE N ARACHIDEDECORTIQUEE) 

gen x = ";"
gen market = REGION+x+DEPARTEMENT+x+MARCHE

table market, c(mean MIL min MIL max MIL N MIL)
table market, c(mean SORGHO min SORGHO max SORGHO N SORGHO) 
table market, c(mean MAÏSLOCAL min MAÏSLOCAL max MAÏSLOCAL N MAÏSLOCAL) 
table market, c(mean MAÏSIMPORTE min MAÏSIMPORTE max MAÏSIMPORTE N MAÏSIMPORTE)
table market, c(mean RIZIMPORTEBRISEORDINAIRE min RIZIMPORTEBRISEORDINAIRE max RIZIMPORTEBRISEORDINAIRE N RIZIMPORTEBRISEORDINAIRE) 
table market, c(mean RIZBRISEIMPORTEPARFUME min RIZBRISEIMPORTEPARFUME max RIZBRISEIMPORTEPARFUME N RIZBRISEIMPORTEPARFUME) 
table market, c(mean RIZLOCALDECORTIQUE min RIZLOCALDECORTIQUE max RIZLOCALDECORTIQUE N RIZLOCALDECORTIQUE) 
table market, c(mean OIGNONLOCAL min OIGNONLOCAL max OIGNONLOCAL N OIGNONLOCAL) 
table market, c(mean OIGNONIMPORTE min OIGNONIMPORTE max OIGNONIMPORTE N OIGNONIMPORTE) 
table market, c(mean POMMEDETERRELOCALE min POMMEDETERRELOCALE max POMMEDETERRELOCALE N POMMEDETERRELOCALE) 
table market, c(mean POMMEDETERREIMPORTEE min POMMEDETERREIMPORTEE max POMMEDETERREIMPORTEE N POMMEDETERREIMPORTEE) 
table market, c(mean MANIOC min MANIOC max MANIOC N MANIOC) 
table market, c(mean NIEBE min NIEBE max NIEBE N NIEBE) 
table market, c(mean ARACHIDECOQUE min ARACHIDECOQUE max ARACHIDECOQUE N ARACHIDECOQUE) 
table market, c(mean ARACHIDEDECORTIQUEE min ARACHIDEDECORTIQUEE max ARACHIDEDECORTIQUEE N ARACHIDEDECORTIQUEE) 



bys MARCHE: sum MIL
table MARCHE, c(mean MIL min MIL max MIL N MIL)

tab2docx

replace MARCHE = "LOUGA" if MARCHE == "LOUGA "
asdoc tabstat MIL SORGHO , statistics(p50) by(MARCHE) 
bys MARCHE : asdoc sum MIL SORGHO, stat(N min mean max) dec(2) replace

bys MARCHE : asdoc sum MIL SORGHO, stat(N min mean max) dec(2) replace

SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE MANIOC NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE 

using table1.htm, c(freq col row) ///
f(0c 1) style(htm) font(bold)



tabout REGION DEPARTEMENT MARCHE MIL using table1.txt, c(freq col row) ///
f(0c 1) style(htm) font(bold)
min, max, average, nb of observation, period of observations) 


import excel "C:\Users\ddiatta\Dropbox (Personal)\SAHEL-SHOCKS\Documents\Raw data\Prix\BASE PRIX 1990 2020 SIM CSA.xlsx", sheet("PRODUCTIONS") firstrow clear
drop B-H
save "C:\Users\ddiatta\Dropbox (Personal)\Production_annual.xlsx", replace

import excel "C:\Users\ddiatta\Dropbox (Personal)\SAHEL-SHOCKS\Documents\Raw data\Prix\BASE PRIX 1990 2020 SIM CSA.xlsx", sheet("IMPORTATIONS") firstrow clear
drop B-E
save "C:\Users\ddiatta\Dropbox (Personal)\Importation_annual.xlsx", replace


import excel "C:\Users\ddiatta\Dropbox (Personal)\SAHEL-SHOCKS\Documents\Raw data\Prix\PRIX MOYENS DEPARTEMENTAUX 1990 2020.xlsx", sheet("CEREALES") firstrow clear 
drop K - AE
destring RIZBRISEIMPORTEPARFUME, replace
duplicates drop
duplicates tag REGION DEPARTEMENT DATEDECOLLECTE, gen(dups)
order dups
sort dups REGION DEPARTEMENT DATEDECOLLECTE 
drop dups
sort REGION DEPARTEMENT DATEDECOLLECTE 
rename DATEDECOLLECTE DATE
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_dpt_cereals.xlsx", replace
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_dpt_cereals.dta", replace


import excel "C:\Users\ddiatta\Dropbox (Personal)\SAHEL-SHOCKS\Documents\Raw data\Prix\PRIX MOYENS DEPARTEMENTAUX 1990 2020.xlsx", sheet("LEGUMES") firstrow clear 
drop I - AE
duplicates drop
duplicates tag REGION DEPARTEMENT DATEDECOLLECTE, gen(dups)
order dups
sort dups REGION DEPARTEMENT DATEDECOLLECTE 
drop dups
sort REGION DEPARTEMENT DATEDECOLLECTE 
rename DATEDECOLLECTE DATE
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_dpt_legumes.xlsx", replace
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_dpt_legumes.dta", replace


import excel "C:\Users\ddiatta\Dropbox (Personal)\SAHEL-SHOCKS\Documents\Raw data\Prix\PRIX MOYENS DEPARTEMENTAUX 1990 2020.xlsx", sheet("LEGUMINEUSES") firstrow clear 
drop G - U
duplicates drop
duplicates tag REGION DEPARTEMENT DATE, gen(dups)
order dups
sort dups REGION DEPARTEMENT DATE 
drop dups
sort REGION DEPARTEMENT DATE 
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_dpt_legumineuses.xlsx", replace
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_dpt_legumineuses.dta", replace


use "C:\Users\ddiatta\Dropbox (Personal)\Prices_dpt_cereals.dta", clear
merge REGION DEPARTEMENT DATE using "C:\Users\ddiatta\Dropbox (Personal)\Prices_dpt_legumes.dta"
order _merge 
sort _merge
drop _merge
sort REGION DEPARTEMENT DATE
merge REGION DEPARTEMENT DATE using "C:\Users\ddiatta\Dropbox (Personal)\Prices_dpt_legumineuses.dta"
order _merge 
sort _merge
drop _merge
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_dpt.xlsx", replace
save "C:\Users\ddiatta\Dropbox (Personal)\Prices_dpt.dta", replace



use "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_nodups.xlsx", clear
codebook market
use "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_cereals.xlsx", clear
codebook market // 53 markets 
gen year = year(DATE)
gen month = month(DATE)
gen day = day(DATE)

gen date = mofd(DATE)
encode market, generate(markets)
order REGION DEPARTEMENT MARCHE DATE year month day
sort REGION DEPARTEMENT MARCHE DATE year month day
collapse (mean) MIL - RIZLOCALDECORTIQUE, by(REGION DEPARTEMENT MARCHE market year month date) 
 
*bys year: tab month if MARCHE == "TILENE", m
*bys year: tab month if MARCHE == "THIAROYE", m

isid market date
encode(market), gen(markets)  
tsset markets date
tsfill
list, clean noobs
bysort markets: carryforward REGION DEPARTEMENT MARCHE year, replace

bys markets: egen nbr = count(month)
gen x3 = nbr/12

use "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_legumes.xlsx", clear
codebook market
gen year = year(DATE)
gen month = month(DATE)
gen day = day(DATE)

gen date = mofd(DATE)
encode market, generate(markets)
order REGION DEPARTEMENT MARCHE DATE year month day
sort REGION DEPARTEMENT MARCHE DATE year month day
collapse (mean) OIGNONLOCAL - MANIOC, by(REGION DEPARTEMENT MARCHE market year month date) 
 
isid market date
encode(market), gen(markets)  
tsset markets date
tsfill
list, clean noobs
bysort markets: carryforward REGION DEPARTEMENT MARCHE year, replace

bys markets: egen nbr = count(month)
gen x3 = nbr/12

use "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_legumineuses.xlsx", clear
codebook market
gen year = year(DATE)
gen month = month(DATE)
gen day = day(DATE)

gen date = mofd(DATE)
encode market, generate(markets)
order REGION DEPARTEMENT MARCHE DATE year month day
sort REGION DEPARTEMENT MARCHE DATE year month day
collapse (mean) NIEBE - ARACHIDEDECORTIQUEE, by(REGION DEPARTEMENT MARCHE market year month date) 
 
isid market date
encode(market), gen(markets)  
tsset markets date
tsfill
list, clean noobs
bysort markets: carryforward REGION DEPARTEMENT MARCHE year, replace

bys markets: egen nbr = count(month)
gen x3 = nbr/12

use "C:\Users\ddiatta\Dropbox (Personal)\Prices_market_nodups.xlsx", clear

order REGION DEPARTEMENT MARCHE DATE year month day date markets MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE MANIOC NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE
codebook market
gen year = year(DATE)
gen month = month(DATE)
gen day = day(DATE)

gen date = mofd(DATE)
encode market, generate(markets)
order REGION DEPARTEMENT MARCHE DATE year month day
sort REGION DEPARTEMENT MARCHE DATE year month day
collapse (mean) MIL - ARACHIDEDECORTIQUEE, by(REGION DEPARTEMENT MARCHE market year month date) 
 
isid market date
encode(market), gen(markets)  
tsset markets date
tsfill
list, clean noobs
bysort markets: carryforward REGION DEPARTEMENT MARCHE year, replace

bys markets: egen nbr = count(month)
gen x3 = nbr/12