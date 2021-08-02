** Senegal price data ****************************************************************************************
** This file contains code that merges the GIS department coordinates to the markets for Senegal**
**************************************************************************************************************

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
global gis_data 	"$dir\SAHEL-SHOCKS\Documents\Raw data\Shapefile_Sahel"	


***************
use "$data_clean\Prices_monthly_all.dta", clear
keep REGION DEPARTEMENT MARCHE
duplicates drop
replace REGION = lower(REGION)
replace REGION = proper(REGION)
replace DEPARTEMENT = lower(DEPARTEMENT)
replace DEPARTEMENT = proper(DEPARTEMENT)
replace MARCHE = lower(MARCHE)
replace MARCHE = proper(MARCHE)
rename MARCHE Name // to match departments in the GIS file
lab var Name "Market names"

sort REGION DEPARTEMENT Name

save "$data_clean\list_markets.dta", replace
***************

use "$gis_data\WestAfrica_admin3_merged.dta", clear
keep if Country == "Senegal"
gen DEPARTEMENT = Name
merge 1:1 DEPARTEMENT using "$data_clean\list_markets.dta"
tab _merge
order _merge Name REGION DEPARTEMENT
sort _merge 

*************************
import delimited "$gis_data\Admin.txt", clear 
save "$data_clean\admin2.dta", replace


use "$data_clean\list_markets.dta", clear
*rename admin2Name admin2name
*rename Name market
replace admin2name = "Saint Louis" if admin2name == "St.Louis"
sort admin2name

save "$data_clean\list_markets.dta", replace

use "$data_clean\admin2.dta", clear
sort admin2name
merge admin2name using "$data_clean\list_markets.dta"
order _merge
sort _merge

gen markets = 1 if !missing(market)
save "$data_clean\list_markets_withgps.dta", replace