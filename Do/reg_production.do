********************************************************************************	
** Description:This file codes the regressions for the impact of shocks on price and production is Senegal 
** Author: Dieynab Diatta
** Date: April 20th 2020
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
* Merge wrsi data
use 		"$data_raw\Climate data\WRSI\WRSI_clean_dta\Senegal\wrsi_millet.dta", clear
rename 		admin1Name region
rename 		admin2Name departement
replace 	departement = "Nioro" if departement == "Nioro du Rip"
reshape 	long wrsi_, i(departement) j(year)
rename 		wrsi_ wrsi_millet 
sort 		departement year
save 		"$data_clean\wrsi_millet_long.dta", replace

use 		"$data_raw\Climate data\WRSI\WRSI_clean_dta\Senegal\wrsi_beans.dta", clear
rename 		admin1Name region
rename 		admin2Name departement
replace 	departement = "Nioro" if departement == "Nioro du Rip"
reshape 	long wrsi_, i(departement) j(year)
rename 		wrsi_ wrsi_niebe 
sort 		departement year
save 		"$data_clean\wrsi_niebe_long.dta", replace

use 		"$data_raw\Climate data\WRSI\WRSI_clean_dta\Senegal\wrsi_groundnut.dta", clear
rename 		admin1Name region
rename 		admin2Name departement
replace 	departement = "Nioro" if departement == "Nioro du Rip"
reshape 	long wrsi_, i(departement) j(year)
rename 		wrsi_ wrsi_groundnut 
sort 		departement year
save 		"$data_clean\wrsi_groundnut_long.dta", replace

use 		"$data_raw\Climate data\WRSI\WRSI_clean_dta\Senegal\wrsi_maize.dta", clear
rename 		admin1Name region
rename 		admin2Name departement
replace 	departement = "Nioro" if departement == "Nioro du Rip"
reshape 	long wrsi_, i(departement) j(year)
rename 		wrsi_ wrsi_maize
sort 		departement year
save 		"$data_clean\wrsi_maize_long.dta", replace

merge 		departement year using "$data_clean\wrsi_groundnut_long.dta"
tab 		_merge
drop 		_merge
sort 		departement year
merge 		departement year using "$data_clean\wrsi_niebe_long.dta"
tab 		_merge
drop 		_merge
sort 		departement year
merge 		departement year using "$data_clean\wrsi_millet_long.dta"
tab 		_merge
drop 		_merge
drop 		crop
order		region departement year wrsi_millet wrsi_maize wrsi_niebe wrsi_groundnut
sort 		region departement year
save 		"$data_clean\wrsi_allcrops.dta", replace


* Merge production data 
use			"$data_clean\production_peanut.dta", clear 
renvars 	area yield harvest / area_groundnut yield_groundnut harvest_groundnut
drop		crop
sort 		departement year
save 		"$data_clean\production_groundnut2.dta", replace 

use			"$data_clean\production_millet.dta", clear 
renvars 	area yield harvest / area_millet yield_millet harvest_millet
drop		crop
sort 		departement year
save 		"$data_clean\production_millet2.dta", replace 

use			"$data_clean\production_niebe.dta", clear 
renvars 	area yield harvest / area_niebe yield_niebe harvest_niebe
drop		crop
sort 		departement year
save 		"$data_clean\production_niebe2.dta", replace 

use			"$data_clean\production_maize.dta", clear 
renvars 	area yield harvest / area_maize yield_maize harvest_maize
drop		crop
sort 		departement year
save 		"$data_clean\production_maize2.dta", replace 

merge 		departement year using "$data_clean\production_niebe2.dta"
tab 		_merge
order 		_merge region departement year 
sort 		_merge region departement year 
drop 		_merge 
sort 		departement year
merge 		departement year using "$data_clean\production_millet2.dta"
tab 		_merge
order 		_merge region departement year 
sort 		_merge region departement year 
drop 		_merge
sort 		departement year
merge 		departement year using "$data_clean\production_groundnut2.dta"
tab 		_merge
order 		_merge region departement year 
sort 		_merge region departement year 
drop 		_merge
order 		region departement year harvest* 
drop 		if dept == "Kolda;Medina Yoroufoula"
sort 		region departement year
save 		"$data_clean\production_allcrops.dta", replace

* Merge production and wrsi data  

merge departement year using "$data_clean\wrsi_allcrops.dta"
tab 		_merge
order 		_merge
sort 		_merge region departement year
browse
keep 		if _merge ==3
tsset 		depts year
sort 		region departement year harvest* wrsi* yield* area* 
save 		"$data_clean\production_wrsi_allcrops.dta", replace

********************************************************************************	
*** Variable construction 
********************************************************************************
foreach var of varlist harvest* area* yield* wrsi* {
gen 		ln`var' 	= ln(`var')
gen 		sin`var'  	= asinh(`var')
}

********************************************************************************	
*** Regressions
********************************************************************************
cd 			"$outputs/Tables"

local 		crops millet niebe groundnut maize
foreach 	crop of local crops {
eststo raw: xtreg harvest_`crop' wrsi_`crop', fe robust
outreg2 using reg`crop'_prod.xls, replace 
eststo raw: xtreg harvest_`crop' wrsi_`crop' i.year, fe robust
outreg2 using reg`crop'_prod.xls, append
eststo raw: xtreg lnharvest_`crop' lnwrsi_`crop', fe robust
outreg2 using reg`crop'_prod.xls, append
eststo raw: xtreg lnharvest_`crop' lnwrsi_`crop' i.year, fe robust
outreg2 using reg`crop'_prod.xls, append
eststo raw: xtreg lnharvest_`crop' c.lnwrsi_`crop'##i.year, fe robust
outreg2 using reg`crop'_prod.xls, append
}

********************************************************************************

