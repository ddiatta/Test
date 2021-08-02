********************************************************************************	
** Description:This file builds the dataset for analysis for the production data - Senegal
** Author: Dieynab Diatta
** Date: May 25th 2020
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
use 		"$data_clean\production_allcrops_clean.dta", clear
drop 		crop
sort 		departement year
 

* Merge climate data for 30 departments 
merge		departement year using "$data_clean\wrsi_allcrops_30dpts.dta"
tab 		_merge
order 		_merge
sort 		_merge
drop 		if _merge ==2
drop 		_merge 
sort 		departement year 
merge 		departement year using "$data_clean\Rain_wide_30depts.dta"
tab 		_merge
order 		_merge
sort 		_merge
drop 		if _merge ==2
drop 		_merge 
sort 		departement year 
merge 		departement year using "$data_clean\Temp_ehdd_wide_30depts.dta"
tab 		_merge
order 		_merge
sort 		_merge
drop 		if _merge ==2
drop 		_merge 
sort 		departement year 
merge 		departement year using "$data_clean\ndvi_wide_30depts.dta"
tab 		_merge
order 		_merge
sort 		_merge
drop 		if _merge ==2
drop 		_merge 
sort 		departement year 
merge 		departement year using "$data_clean\spei_year_30depts.dta"
tab 		_merge
order 		_merge
sort 		_merge
drop 		_merge 
sort 		departement year 
merge 		departement year using "$data_clean\swi_30depts.dta"
tab 		_merge
order 		_merge
sort 		_merge
drop 		_merge 
* gen log variables 
foreach 	var of varlist harvest* yield* area* wrsi* rain* ndvi* ehdd* gdd* spei* drymonths* vdrymonths* swi*{ 
gen 		ln`var' = ln(`var')
gen 		sin`var' = asinh(`var')
}

sort 	 	region departement year 
save 		"$data_clean\production_climate_30dpts.dta", replace


/* Merge climate data
restore
merge 		 region departement year using "$data_clean\wrsi_allcrops_long.dta"
tab 		_merge
order 		_merge 
sort 		_merge
drop 		if _merge ==2
drop 		_merge
sort 		region departement year
merge 		region departement year using "$data_clean\Rain_long.dta"
tab 		_merge
order 		_merge 
sort 		_merge
drop 		if _merge ==2
drop 		_merge
sort 		region departement year 
merge 		region departement year using "$data_clean\Temp_ehdd_long.dta"
tab 		_merge
order 		_merge 
sort 		_merge
drop 		if _merge ==2
drop 		_merge
sort 		region departement year 
merge 		region departement year using "$data_clean\ndvi_long.dta"
tab 		_merge
order 		_merge 
sort 		_merge
drop 		if _merge ==2
drop 		_merge

* gen log variables 
foreach 	var of varlist harvest* yield* area* rain* gdd* ehdd* ndvi* wrsi*{ 
gen 		ln`var' = ln(`var')
}


sort 		region departement year 
save 		"$data_clean/production_climate_analysis.dta", replace

********************************************************************************


