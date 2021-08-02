********************************************************************************	
** Description:This file codes the regressions for the impact of shocks on  production in Senegal 
** Author: Dieynab Diatta
** Date: May 5th 2020
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
	
global 		data_raw 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Raw"	// raw data in shared DB folder
global 		data_clean 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Clean"	// cleaned data in personal DB
global 		outputs 	"$dir\SAHEL-SHOCKS\1. Analysis\Outputs" 	// path to all tables, graphs, etc
cd 			"$outputs"

********************************************************************************	

********************************************************************************	
*** MERGE DATASETS
********************************************************************************
use 		"$data_clean\production_allcrops.dta", clear
sort 		region departement year 
merge 		region departement year using "$data_clean\wrsi_allcrops.dta"
tab 		_merge
order 		_merge
sort 		_merge
drop 		_merge
sort 		region departement year 
merge 		region departement year using "$data_clean\Rain_wide.dta"
tab 		_merge
order 		_merge
sort 		_merge
drop 		_merge
sort 		region departement year 
merge 		region departement year using "$data_clean\Temp_ehdd_wide.dta"
tab 		_merge
order 		_merge
sort 		_merge
drop 		_merge
sort 		region departement year 
merge 		region departement year using "$data_clean\ndvi_wide.dta"
tab 		_merge
order 		_merge
sort 		_merge
drop 		_merge

foreach 	var of varlist harvest* area* yield* wrsi* rain* ehdd* gdd* ndvi* {
gen 		ln`var' 	= ln(`var')
}
sort 		region departement year
save 		"$data_clean\reg_production_wide.dta", replace



********************************************************************************	
*** REGRESSIONS - SHOCK: WRSI
********************************************************************************
cd 			"$outputs/Tables"

local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnwrsi_`crop', fe robust
outreg2 	using reg`crop'_prodwrsi_`date'.xls, replace
eststo 		raw: xtreg lnharvest_`crop' lnwrsi_`crop' i.year , fe robust
outreg2 	using reg`crop'_prodwrsi_`date'.xls, append
eststo 		raw: xtreg lnharvest_`crop' lnwrsi_`crop' c.lnwrsi_`crop'##i.year, fe robust
outreg2 	using reg`crop'_prodwrsi_`date'.xls, append
}
tab 		departement if e(sample)
****************************************************************************************************************************

********************************************************************************	
*** REGRESSIONS - SHOCK: RAINFALL
********************************************************************************

* Cumul season

local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnrain_season, fe robust
outreg2 	using reg`crop'_prodrainseas_`date'.xls, replace
eststo 		raw: xtreg lnharvest_`crop' lnrain_season i.year , fe robust
outreg2 	using reg`crop'_prodrainseas_`date'.xls, append
eststo 		raw: xtreg lnharvest_`crop' lnrain_season c.lnrain_season##i.year, fe robust
outreg2 	using reg`crop'_prodrainseas_`date'.xls, append
}

* Rain June 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnrain_june, fe robust
outreg2 	using reg`crop'_prodrainjune_`date'.xls, replace
eststo 		raw: xtreg lnharvest_`crop' lnrain_june i.year , fe robust
outreg2 	using reg`crop'_prodrainjune_`date'.xls, append
eststo 		raw: xtreg lnharvest_`crop' lnrain_june c.lnrain_june##i.year, fe robust
outreg2 	using reg`crop'_prodrainjune_`date'.xls, append
}


* Rain July 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnrain_july, fe robust
outreg2 	using reg`crop'_prodrainjuly_`date'.xls, replace
eststo 		raw: xtreg lnharvest_`crop' lnrain_july i.year , fe robust
outreg2 	using reg`crop'_prodrainjuly_`date'.xls, append
eststo 		raw: xtreg lnharvest_`crop' lnrain_july c.lnrain_july##i.year, fe robust
outreg2 	using reg`crop'_prodrainjuly_`date'.xls, append
}

* Rain August
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnrain_aug, fe robust
outreg2 	using reg`crop'_prodrainaug_`date'.xls, replace
eststo 		raw: xtreg lnharvest_`crop' lnrain_aug i.year , fe robust
outreg2 	using reg`crop'_prodrainaug_`date'.xls, append
eststo 		raw: xtreg lnharvest_`crop' lnrain_aug c.lnrain_aug##i.year, fe robust
outreg2 	using reg`crop'_prodrainaug_`date'.xls, append
}

* Rain September
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnrain_sep, fe robust
outreg2 	using reg`crop'_prodrainsep_`date'.xls, replace
eststo 		raw: xtreg lnharvest_`crop' lnrain_sep i.year , fe robust
outreg2 	using reg`crop'_prodrainsep_`date'.xls, append
eststo 		raw: xtreg lnharvest_`crop' lnrain_sep c.lnrain_sep##i.year, fe robust
outreg2 	using reg`crop'_prodrainsep_`date'.xls, append
}



********************************************************************************	
*** REGRESSIONS - SHOCK: TEMPERATURE
********************************************************************************

* Extreme heat degree days / mostly 0
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnehdd_season, fe robust
outreg2 	using reg`crop'_prodehdd_`date'.xls, replace
eststo 		raw: xtreg lnharvest_`crop' lnehdd_season i.year , fe robust
outreg2 	using reg`crop'_prodehdd_`date'.xls, append
eststo 		raw: xtreg lnharvest_`crop' lnehdd_season c.lnehdd_season##i.year, fe robust
outreg2 	using reg`crop'_prodehdd_`date'.xls, append
}


/*Growing degree days 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lngdd, fe robust
outreg2 	using reg`crop'_prodgdd_`date'.xls, replace
eststo 		raw: xtreg lnharvest_`crop' lngdd i.year , fe robust
outreg2 	using reg`crop'_prodgdd_`date'.xls, append
eststo 		raw: xtreg lnharvest_`crop' lngdd c.lngdd##i.year, fe robust
outreg2 	using reg`crop'_prodgdd_`date'.xls, append
}
*/

********************************************************************************	
*** REGRESSIONS - SHOCK: NDVI
********************************************************************************

* Seasonal NDVI
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnndvi_season, fe robust
outreg2 	using reg`crop'_prodndvi_seas_`date'.xls, replace
eststo 		raw: xtreg lnharvest_`crop' lnndvi_season i.year , fe robust
outreg2 	using reg`crop'_prodndvi_seas_`date'.xls, append
eststo 		raw: xtreg lnharvest_`crop' lnndvi_season c.lnndvi_season##i.year, fe robust
outreg2 	using reg`crop'_prodndvi_seas_`date'.xls, append
}


