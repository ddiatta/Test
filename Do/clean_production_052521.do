********************************************************************************	
** Description:This file cleans the production data for Senegal
** Author: Dieynab Diatta
** Date: April 19th 2020
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


use 		"$data_clean\production_data_clean_old_departement\millet_production_long.dta", clear
export		excel "$data_clean\production_data_clean_old_departement\millet_production_long1.csv" , firstrow(variables) replace
// change � character manually for accented e
import 		excel "$data_clean\production_data_clean_old_departement\millet_production_long2.xlsx", firstrow clear
replace 	departement = "Tambacounda" if departement == "Tamba"
renvars 	production rendement superficie / harvest_millet yield_millet area_millet  
drop 		crop
sort 		departement year
merge 		departement using "$data_clean\admin_senegal.dta"
order		_merge
sort 		_merge
drop 		arrondissement
replace 	region = "Kaolack" if region == "Kaffrine"
replace 	region = "Kolda" if region == "Sedhiou"
replace 	region = "Tambacounda" if region == "Kedougou"
duplicates 	drop
drop 		if _merge ==2
drop 		_merge
encode		(departement), gen(depts)
tsset 		depts year
order		region departement year 
sort 		region departement year 
save 		"$data_clean\production_millet_clean.dta", replace

use 		"$data_clean\production_data_clean_old_departement\maize_production_long.dta", clear
*cleanchars	, in("�") out ("e") vval
export		excel "$data_clean\production_data_clean_old_departement\maize_production_long1.csv" , firstrow(variables) replace
// change � character manually for accented e
import 		excel "$data_clean\production_data_clean_old_departement\maize_production_long2.xlsx", firstrow clear
replace 	departement = "Tambacounda" if departement == "Tamba"
renvars 	production rendement superficie / harvest_maize yield_maize area_maize  
sort 		departement year
merge 		departement using "$data_clean\admin_senegal.dta"
order		_merge
sort 		_merge
replace 	region = "Kaolack" if region == "Kaffrine"
replace 	region = "Kolda" if region == "Sedhiou"
replace 	region = "Tambacounda" if region == "Kedougou"
drop 		arrondissement
duplicates 	drop
drop 		if _merge ==2
drop 		_merge
encode		(departement), gen(depts)
tsset 		depts year
order		region departement year 
sort 		region departement year 
save 		"$data_clean\production_maize_clean.dta", replace


use 		"$data_clean\production_data_clean_old_departement\niebe_production_long.dta", clear
// change � character manually for accented e
*cleanchars	, in("�") out ("e") vval // function does not work so do it manually
export		excel "$data_clean\production_data_clean_old_departement\niebe_production_long1.csv" , firstrow(variables) replace
import 		excel "$data_clean\production_data_clean_old_departement\niebe_production_long2.xlsx", firstrow clear
replace 	departement = "Tambacounda" if departement == "Tamba"
renvars 	production rendement superficie / harvest_niebe yield_niebe area_niebe  
sort 		departement year
merge 		departement using "$data_clean\admin_senegal.dta"
order		_merge
sort 		_merge
replace 	region = "Kaolack" if region == "Kaffrine"
replace 	region = "Kolda" if region == "Sedhiou"
replace 	region = "Tambacounda" if region == "Kedougou"
drop 		arrondissement
duplicates 	drop
drop 		if _merge ==2
drop 		_merge
encode		(departement), gen(depts)
tsset 		depts year
order		region departement year 
sort 		region departement year 
save 		"$data_clean\production_niebe_clean.dta", replace


use 		"$data_clean\production_data_clean_old_departement\groundnut_production_long.dta", clear
// change � character manually for accented e
*cleanchars	, in("�") out ("e") vval // function does not work so do it manually
export		excel "$data_clean\production_data_clean_old_departement\groundnut_production_long1.csv" , firstrow(variables) replace
import 		excel "$data_clean\production_data_clean_old_departement\groundnut_production_long2.xlsx", firstrow clear
replace 	departement = "Tambacounda" if departement == "Tamba"
renvars 	production rendement superficie / harvest_groundnut yield_groundnut area_groundnut 
sort 		departement year
merge 		departement using "$data_clean\admin_senegal.dta"
order		_merge
sort 		_merge
replace 	region = "Kaolack" if region == "Kaffrine"
replace 	region = "Kolda" if region == "Sedhiou"
replace 	region = "Tambacounda" if region == "Kedougou"
drop 		arrondissement
duplicates 	drop
drop 		if _merge ==2
drop 		_merge
encode		(departement), gen(depts)
tsset 		depts year
order		region departement year 
sort 		region departement year 
save 		"$data_clean\production_groundnut_clean.dta", replace


** Merge
use 		"$data_clean\production_millet_clean.dta", replace
merge 		region departement year using "$data_clean\production_maize_clean.dta"
drop 		_merge
sort 		region departement year 
merge 		region departement year using "$data_clean\production_niebe_clean.dta"
drop 		_merge 
sort 		region departement year 
merge 		region departement year using "$data_clean\production_groundnut_clean.dta"
drop 		_merge
sort 		region departement year 
drop 		G H I J
save 		"$data_clean\production_allcrops_clean.dta", replace


********************************************************************************	
