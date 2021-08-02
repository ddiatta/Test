********************************************************************************	
** Description:This file merges price and climate data. And prepares the data for the regression anlysis for the impact of climate shocks on price in Senegal 
** Author: Dieynab Diatta
** Date: May 10th 2021
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

		if c(username)=="DDiatta"{
		global dir "C:\Users\DDiatta\Dropbox (Personal)"  		
}
			if c(username)=="ddiatta"{
		global dir "C:/Users/ddiatta/Dropbox (Personal)"  		
}
	
cd 			"$dir"

global 		data_raw 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Raw"	// raw data in shared DB folder
global 		data_clean 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Clean"	// cleaned data in personal DB
global 		outputs 	"$dir\SAHEL-SHOCKS\1. Analysis\Outputs" 	// path to all tables, graphs, etc
********************************************************************************	
********************************************************************************	
*** MERGE DATASETS
********************************************************************************

use 		"$data_clean\Prices_monthly.dta", replace
merge 		 region departement year using "$data_clean\wrsi_allcrops_long.dta"
tab 		_merge
order 		_merge 
sort 		_merge
*drop 		if _merge ==2
rename 		_merge _merge1 
sort 		region departement year month
merge 		region departement year month using "$data_clean\Rain_long.dta"
tab 		_merge
order 		_merge 
sort 		_merge
*drop 		if year <1990 // price data is from 1990
rename  	_merge _merge2
sort 		region departement year month
merge 		region departement year month using "$data_clean\Temp_ehdd_long.dta"
tab 		_merge
order 		_merge 
sort 		_merge
*drop 		if year <1990 // price data is from 1990
rename 		_merge _merge3
sort 		region departement year month
merge 		region departement year month using "$data_clean\ndvi_long.dta"
tab 		_merge
order 		_merge 
sort 		_merge
*drop 		if year <1990 // price data is from 1990
rename 		_merge _merge4
*drop 		if year ==2021 // no climate data in 2021
drop 		_merge*
sort 		region departement year month
merge		region departement year month using "$data_clean\spei_month_45depts.dta"
tab 		_merge
order 		_merge 
sort 		_merge
drop 		_merge 
sort 		region departement year month
merge		region departement year month using "$data_clean\swi_45depts.dta"
tab 		_merge
order 		_merge 
sort 		_merge
drop 		_merge 
sort 		region departement marche year month
save 		"$data_clean/price_climate.dta", replace

********************************************************************************
ssc 		install unique 
unique 		departement 		 // 44 departments
drop 		if market == ""      // droppping departements that have no markets listed (12 departemnts)
unique 		region				 // 14 regions 
unique 		departement 		 // 32 departments
unique 		marche 			     // 48 markets

* Real prices 
preserve
import 		excel "C:\Users\ddiatta\Dropbox (Personal)\SAHEL-SHOCKS\1. Analysis\Data\Raw\Prix\senegal_cpi.xlsx", sheet("Sheet3") firstrow clear
sort 		year 
save 		"$data_raw/senegal_cpi.dta", replace
restore
sort 		year
merge 		year using  "$data_raw/senegal_cpi.dta"
drop 		if _merge ==2
gen 		cpi2019 = 109.25127
gen 		pindex = cpi2019 / cpi  		//index in terms of 2019 XOF
lab 		var pindex "Price index in terms of 2019 XOF"
lab 		var cpi "Consumer price index"
lab 		var cpi2019 "Consumer price index, 2019"
foreach 	var of varlist price*{ 
gen 		r`var' = `var' * pindex
}


* Climate variables for ag months 

local 		climate wrsi_niebe wrsi_millet wrsi_maize wrsi_groundnut rain_month rain_season rain_june rain_july rain_aug rain_sep gdd ehdd ehdd_season ehdd_june ehdd_july ehdd_aug ehdd_sep ndvi_season ndvi_month ndvi_min ndvi_max ndvi_stddev ndvi_june ndvi_july ndvi_aug ndvi_sep spei drymonths vdrymonths spei_season spei_june spei_july spei_aug spei_sep drymonths_season vdrymonths_season swi swi_season swi_june swi_july swi_aug swi_sep
foreach 	var of local climate { 
gen 		`var'_ag =.
replace		`var'_ag = `var' if (month == 9 | month == 10 | month ==11 | month == 12)
lab 		var `var'_ag "`var', ag year"
}

order 		region departement marche date month month_ag year year_ag price* wrsi* rain* *ehdd ndvi* spei* dry* vdry* swi* market markets
sort 		market date 
ssc 		install carryforward
foreach 	var of local climate { 
bys			market year_ag: carryforward `var'_ag if `var'_ag==., replace
}
sort 		market date 


* Natural log of vars for analysis
foreach 	var of varlist rprice* price* wrsi* rain* ndvi* ehdd* gdd* spei* dry* vdry* swi*{
gen 		ln`var' 	= ln(`var')
}



* Generate percentage of missing price values
local 		price price_millet price_sorghum price_maize price_maize_i price_rice_io price_rice_ip price_rice price_onion price_onion_i price_potato price_potato_i price_cassava price_niebe price_groundnut price_groundnut_d

sort 		market date
foreach 	var of local price{
    by market : egen pr`var' = mean(missing(`var'))
	lab var pr`var' "Percentage of missing data for `var'"
}

*list market date `vars' pr*, sepby(market)

// make a table showing that proportion
foreach var of local vars {
    gen m`var' = missing(`var')
}

local 		crops millet sorghum maize maize_i rice_io rice_ip rice onion onion_i potato potato_i cassava niebe groundnut groundnut_d 
foreach 	crop of local crops {
lab			var price_`crop' 		"Nominal prices, `crop' CFA/KG"
lab			var lnprice_`crop' 		"Log nominal prices, `crop' CFA/KG"
lab			var rprice_`crop' 		"Real prices, `crop' CFA/KG"
lab			var lnrprice_`crop' 	"Log real prices, `crop' CFA/KG"
} 	
drop 		_merge	 
tsset		// strongly balanced, monthly data January 1990 to March 2021
sort 		region departement marche year month
save 		"$data_clean/price_climate_foranalysis.dta", replace


/* Price data for maps 

use 		"$data_clean/price_climate_foranalysis.dta", clear
collapse 	price*, by(region departement marche year)
save 		"$data_clean/price_market_yearly.dta", replace
collapse 	price*, by(region departement marche)
save 		"$data_clean/price_market_30ymean.dta", replace

use 		"$data_clean/markets_gps.dta", clear
renvars 	REGION DEPARTEMENT MARCHE / region departement marche
replace 	departement = "Birkelane" if departement == "Mbirkilane"
replace 	marche = "Birkelane" if marche == "Mbirkilane"
replace 	region = "Saint Louis" if region == "St.Louis"
replace 	marche = "Saint Louis" if marche == "St.Louis"
save 		"$data_clean/markets_gps.dta", replace

merge 		1:1 region departement marche  using "$data_clean/price_market_30ymean.dta"
drop 		_merge 
save 		"$data_clean/price_market_30ymean_gps.dta", replace
export 		excel using "C:\Users\ddiatta\Dropbox (Personal)\SAHEL-SHOCKS\1. Analysis\Data\Clean\Market_prices_30ymean.xlsx", firstrow(variables) replace

