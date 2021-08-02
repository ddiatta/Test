********************************************************************************	
** Description:This file contains code that creates summary tables/graphs of price data in Senegal
** Author: Dieynab Diatta
** Date: April 12th 2020
********************************************************************************	

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

use "$data_clean/Prices_monthly_all.dta", clear
/*sum MIL
graph twoway bar MIL year
graph twoway bar MIL month
tsline MIL
*tsline (MIL if MARCHE == "TILENE"), xlabel(#15) scale(0.5)

twoway (tsline MIL if MARCHE == "TILENE") (tsline MIL if MARCHE == "TOUBA") (tsline MIL if MARCHE == "THIES") (tsline MIL if MARCHE == "KEDOUGOU") (tsline MIL if MARCHE == "ST.LOUIS") (tsline MIL if MARCHE == "GOUILLE MBEUTH") (tsline MIL if MARCHE == "KOLDA"), xlabel(#15) scale(0.5) 


encode MARCHE, generate(MARCHES)
sumtable MIL MARCHES, vartype(contmean) first(1) last(1) vartext(Millet) exportname($outputs/Market_stats)
*/
* creating a missing variable 
local crop MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE MANIOC NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE
foreach var of local crop{
gen miss_`var' = 1 if `var' ==.
bys MARCHE: egen totmiss_`var' = count(miss_`var')
gen prmiss_`var' = (totmiss_`var'/375)*100
lab var prmiss_`var' "Percentage of missing data"
}

local crop MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE MANIOC NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE
foreach var of local crop{
gen ymiss`var' = 1 if `var' ==.
bys year: egen ytotmiss`var' = count(ymiss`var')
gen yprmiss`var' = (ytotmiss`var'/576)*100
lab var yprmiss`var' "Percentage of missing data by year"
}

local crop MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE MANIOC NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE
foreach var of local crop{
gen mmiss`var' = 1 if `var' ==.
bys month: egen mtotmiss`var' = count(mmiss`var')
gen mprmiss`var' = (mtotmiss`var'/1536)*100
lab var mprmiss`var' "Percentage of missing data by month"
}


* Pattern of missing data 
sum pr*
bys MARCHE: sum pr*, sep(0)
bys REGION: sum pr*, sep(0)

xtable REGION, c(mean prmiss_MIL mean prmiss_MAÏSLOCAL mean prmiss_NIEBE mean prmiss_ARACHIDEDECORTIQUEE) filename(Missing_market_data) sheet(Region) replace
xtable DEPARTEMENT, c(mean prmiss_MIL mean prmiss_MAÏSLOCAL mean prmiss_NIEBE mean prmiss_ARACHIDEDECORTIQUEE) filename(Missing_market_data) sheet(Department, replace)
xtable year, c(mean yprmissMIL mean yprmissMAÏSLOCAL mean yprmissNIEBE mean yprmissARACHIDEDECORTIQUEE) filename(Missing_market_data) sheet(Year, replace) 
xtable month, c(mean mprmissMIL mean mprmissMAÏSLOCAL mean mprmissNIEBE mean mprmissARACHIDEDECORTIQUEE) filename(Missing_market_data) sheet(Month, replace)





twoway (tsline MIL) if prmiss_MIL < 2.7, ytitle(Millet prices) by(, title(Millet Prices - monthly (1990-2021))) by(MARCHE) 
graph save "millet_prices" "$outputs/millet_prices.gph", replace

twoway (tsline MIL if MARCHE == "TILENE") (tsline MIL if MARCHE == "ST.LOUIS") (tsline MIL if MARCHE == "TAMBACOUNDA") (tsline MIL if MARCHE == "GOUILLE MBEUTH") (tsline MIL if MARCHE == "KOLDA") (tsline MIL if MARCHE == "KAOLACK"), ytitle(Millet prices) title(Millet Prices - monthly (1990-2021)) legend (1 "TILENE" )
graph save "millet_prices" "$outputs/millet_prices.gph", replace

generate shock = 400
local peak shock date if inrange(date, 459, 467) | inrange(date, 504, 520) | inrange(date, 540, 551) | inrange(date, 686, 697) | inrange(date, 727, 731) , bcolor(gs14) base(10)
twoway bar `peak' || (tsline MIL if MARCHE == "TILENE") (tsline MIL if MARCHE == "ST.LOUIS") (tsline MIL if MARCHE == "TAMBACOUNDA") (tsline MIL if MARCHE == "KAOLACK"), scheme(s3color)
graph save "millet_prices_shock" "$outputs/millet_prices_shock.gph", replace


* Merge market data and missing data
*keep REGION DEPARTEMENT MARCHE market markets pr*
duplicates drop
replace REGION = lower(REGION)
replace REGION = proper(REGION)
replace DEPARTEMENT = lower(DEPARTEMENT)
replace DEPARTEMENT = proper(DEPARTEMENT)
replace MARCHE = lower(MARCHE)
replace MARCHE = proper(MARCHE)



* 
collapse 

sort REGION DEPARTEMENT MARCHE
tempfile markets_miss 
save `markets_miss' 

import excel "$data_clean\market_gps.xlsx", sheet("Sheet1") firstrow clear
rename admin2name DEPARTEMENT
rename market MARCHE
sort REGION DEPARTEMENT MARCHE
save "$data_clean\\markets_gps.dta", replace

use `markets_miss' 
merge 1:1 MARCHE using "$data_clean\markets_gps.dta"
drop _merge
order REGION DEPARTEMENT MARCHE Y X prmiss*
sort REGION DEPARTEMENT MARCHE
save "$data_clean\markets_gps_miss.dta", replace
export excel "$data_clean\markets_gps_miss.xlsx", firstrow(variables) replace