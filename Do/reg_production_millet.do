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
	
cd 			"$dir"

global 		data_raw 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Raw"	// raw data in shared DB folder
global 		data_clean 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Clean"	// cleaned data in personal DB
global 		outputs 	"$dir\SAHEL-SHOCKS\1. Analysis\Outputs" 	// path to all tables, graphs, etc
********************************************************************************	


********************************************************************************	
*** MERGE DATASETS 
********************************************************************************
use 		"$data_raw\Climate data\WRSI\WRSI_clean_dta\Senegal\wrsi_millet.dta", clear
rename 		admin1Name region
rename 		admin2Name departement
replace 	departement = "Nioro" if departement == "Nioro du Rip"
reshape 	long wrsi_, i(departement) j(year)
rename 		wrsi_ wrsi
sort 		departement year
save 		"$data_clean\wrsi_millet_long.dta", replace

* Merge
use 		 "$data_clean\production_millet.dta", clear
sort 		departement year
merge 		departement year using "$data_clean\wrsi_millet_long.dta"
tab 		_merge
order 		_merge region departement year 
sort 		_merge region departement year 
keep 		if _merge ==3
drop 		_merge
order 		region departement year harvest wrsi
sort 		region departement year harvest wrsi
tsset
save 		"$data_clean\prod_millet_wrsi.dta", replace
		

********************************************************************************	
*** Variable cleaning/ construction 
********************************************************************************
renvars area harvest yield / area_millet harvest_millet yield_millet 	
gen 		lnharvest_millet 		= ln(harvest_millet)
hist 		lnharvest_millet
hist 		wrsi
gen 		lnwrsi 		= ln(wrsi)
hist 		lnwrsi

********************************************************************************	
*** Regressions
********************************************************************************
eststo raw: xtreg harvest_millet wrsi, fe robust
outreg2 using regmillet_prod.xls, replace 
eststo raw: xtreg harvest_millet wrsi i.year, fe robust
outreg2 using regmillet_prod.xls, append
eststo raw: xtreg lnharvest_millet lnwrsi, fe robust
outreg2 using regmillet_prod.xls, append
eststo raw: xtreg lnharvest_millet lnwrsi i.year, fe robust
outreg2 using regmillet_prod.xls, append
eststo raw: xtreg lnharvest_millet c.lnwrsi##i.year, fe robust
outreg2 using regmillet_prod.xls, append

********************************************************************************

