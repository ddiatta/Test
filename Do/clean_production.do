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

global 		data_raw 	"$dir\SAHEL-SHOCKS\Documents\Raw data"		// raw data in shared DB folder
global 		data_clean 	"$dir\DIME\Data" 					    // cleaned data in personal DB
global 		outputs 	"$dir\DIME\Outputs" 					// path to all tables, graphs, etc
********************************************************************************	

*** Decoupage administratif 
import 		delimited "$outputs\admin_senegal.txt", clear 
rename 		adm3_fr arrondissement 
rename 		adm2_fr departement 
rename 		adm1_fr region 
replace 	departement = "Tivaouane" if departement == "Tivaoune"
replace 	departement = "Nioro" if departement == "Nioro Du Rip"
replace 	departement = "Medina Yoro Foulah" if departement ==  "Medina Yoroufoula"
keep 		region arrondissement departement
duplicates 	drop
order 		region departement arrondissement
sort 		departement 
save 		"$data_clean\admin_senegal.dta", replace
*** 

********************************************************************************	
*** IMPORT 
********************************************************************************
import 		excel "$data_clean\Production_data.xlsx", sheet("Mil") firstrow clear
rename 		DEPARTEMENT departement
replace 	departement = ustrregexra(ustrnormalize(departement, "nfd" ) , "\p{Mark}", "" ) // gets rid of accents 
replace 	departement = "Goudiry" if departement == "Goudiri"   // reconcile spelling differences
replace 	departement = "Tambacounda" if departement == "Tamba" 
replace 	departement = "Koumpentoum" if departement == "Koumpetoum" 
sort 		departement
merge 		departement using "$data_clean\admin_senegal.dta"
keep 		if _merge ==3 
drop 		_merge arrondissement 
gen 		a=";"
gen 		dept = region+a+departement
drop 		a
encode		(dept), gen(depts) 
tsset 		depts year 
tsfill, 	full
sort 		depts year
order 		depts dept region departement year
bysort      depts: carryforward dept region departement, replace
gsort		depts - year 
bysort 		depts: carryforward dept region departement, replace
gen 		crop = "millet"
order 		region departement year area yield harvest crop
sort 		region departement year
sort 		departement year
save 		"$data_clean\production_millet.dta", replace


import 		excel "$data_clean\Production_data.xlsx", sheet("Arachide") firstrow clear
rename		DEPARTEMENT departement
replace 	departement = ustrregexra(ustrnormalize(departement, "nfd" ) , "\p{Mark}", "" ) // gets rid of accents 
replace 	departement = "Goudiry" if departement == "Goudiri"   // reconcile spelling differences
replace	    departement = "Tambacounda" if departement == "Tamba" 
replace 	departement = "Koumpentoum" if departement == "Koumpetoum" 
sort 		departement
merge 		departement using "$data_clean\admin_senegal.dta"
keep 		if _merge ==3 
drop 		_merge arrondissement 
gen 		a=";"
gen 		dept = region+a+departement
drop 		a
encode		(dept), gen(depts) 
tsset 		depts year 
tsfill, 	full
sort 		depts year
order 		depts dept region departement year
bysort      depts: carryforward dept region departement, replace
gsort		depts - year 
bysort 		depts: carryforward dept region departement, replace
gen 		crop = "peanut"
order	 	region departement year area yield harvest crop
sort 		region departement year
save 		"$data_clean\production_peanut.dta", replace

import 		excel "$data_clean\Production_data.xlsx", sheet("Coton") firstrow clear
rename 		DEPARTEMENT departement
replace 	departement = ustrregexra(ustrnormalize(departement, "nfd" ) , "\p{Mark}", "" ) // gets rid of accents 
replace 	departement = "Goudiry" if departement == "Goudiri"   // reconcile spelling differences
replace 	departement = "Tambacounda" if departement == "Tamba" 
replace 	departement = "Koumpentoum" if departement == "Koumpetoum" 
sort 		departement
merge 		departement using "$data_clean\admin_senegal.dta"
keep 		if _merge ==3 
drop		 _merge arrondissement 
gen 		a=";"
gen 		dept = region+a+departement
drop 		a
encode		(dept), gen(depts) 
tsset 		depts year 
tsfill, 	full
sort 		depts year
order 		depts dept region departement year
bysort      depts: carryforward dept region departement, replace
gsort		depts - year 
bysort 		depts: carryforward dept region departement, replace
gen 		crop = "coton"
order 		region departement year area yield harvest crop
sort 		region departement year
save 		"$data_clean\production_coton.dta", replace

import 		excel "$data_clean\Production_data.xlsx", sheet("Mais") firstrow clear
rename 		DEPARTEMENT departement
replace 	departement = ustrregexra(ustrnormalize(departement, "nfd" ) , "\p{Mark}", "" ) // gets rid of accents 
replace 	departement = "Goudiry" if departement == "Goudiri"   // reconcile spelling differences
replace 	departement = "Tambacounda" if departement == "Tamba" 
replace 	departement = "Koumpentoum" if departement == "Koumpetoum" 
sort 		departement
merge 		departement using "$data_clean\admin_senegal.dta"
keep 		if _merge ==3 
drop 		_merge arrondissement 
gen 		a=";"
gen 		dept = region+a+departement
drop 		a
encode(dept), gen(depts) 
tsset 		depts year 
tsfill, full
sort 		depts year
order 		depts dept region departement year
bysort      depts: carryforward dept region departement, replace
gsort		depts - year 
bysort 		depts: carryforward dept region departement, replace
gen 		crop = "maize"
order 		region departement year area yield harvest crop
sort 		region departement year
save 		"$data_clean\production_maize.dta", replace

use "$data_raw\Production\production_clean\niebe_production_long.dta", clear
renvars superficie rendement production / area yield harvest 
replace 	departement = ustrregexra(ustrnormalize(departement, "nfd" ) , "\p{Mark}", "" ) // gets rid of accents 
cleanchars 	departement, in("�") out("e") vval
replace 	departement = "Goudiry" if departement == "Goudiri"   // reconcile spelling differences
replace 	departement = "Tambacounda" if departement == "Tamba" 
replace 	departement = "Koumpentoum" if departement == "Koumpetoum" 
replace 	departement = "Saint Louis" if departement == "saint-Louis"
replace 	departement = "Mbacke" if departement == "Mbacke "
sort 		departement
merge 		departement using "$data_clean\admin_senegal.dta"
keep 		if _merge ==3 
drop 		_merge arrondissement 
gen 		a=";"
gen 		dept = region+a+departement
drop 		a
encode(dept), gen(depts) 
tsset 		depts year 
tsfill, full
order 		region departement year area yield harvest crop
sort 		region departement year
save 		"$data_clean\production_niebe.dta", replace


import excel "$data_clean\Production_data.xlsx", sheet("Manioc") firstrow clear
rename 		DEPARTEMENT departement
replace 	departement = ustrregexra(ustrnormalize(departement, "nfd" ) , "\p{Mark}", "" ) // gets rid of accents 
replace 	departement = "Goudiry" if departement == "Goudiri"   // reconcile spelling differences
replace 	departement = "Tambacounda" if departement == "Tamba" 
replace 	departement = "Koumpentoum" if departement == "Koumpetoum" 
sort 		departement
merge 		departement using "$data_clean\admin_senegal.dta"
keep 		if _merge ==3 
drop 		_merge arrondissement 
gen 		a=";"
gen 		dept = region+a+departement
drop 		a
encode		(dept), gen(depts) 
duplicates 	drop
tsset 		depts year 
tsfill,		full
sort 		depts year
order 		depts dept region departement year
bysort      depts: carryforward dept region departement, replace
gsort		depts - year 
bysort 		depts: carryforward dept region departement, replace
gen 		crop = "cassava"
duplicates	drop
order 		region departement year area yield harvest crop
sort 		region departement year
save 		"$data_clean\production_cassava.dta", replace

append 		using "$data_clean\production_millet.dta"
append 		using "$data_clean\production_peanut.dta"
append 		using "$data_clean\production_maize.dta"
append 		using "$data_clean\production_coton.dta"
save		"$data_clean\production_all_long.dta", replace


/*
tostring 	year, generate(years)
gen 		dept_year = departement + years 
encode		(dept_year), gen(dept_years)	
encode 		(crop), gen(crops)	
reshape 	wide year area yield harvest, i(depts) j(crops) */ 

********************************************************************************	
*** Descriptive statistics 
********************************************************************************
use 		"$data_clean\production_millet.dta", clear
mdesc				

local 		prod_vars area yield harvest
foreach 	var of local prod_vars{
gen 		miss_`var' = 1 if `var' ==.
bys 		departement: egen totmiss_`var' = count(miss_`var')
gen 		prmiss_`var' = (totmiss_`var'/60)*100
lab 		var prmiss_`var' "Percentage of missing `var' data"
}

local 		prod_vars area yield harvest
foreach 	var of local prod_vars{
gen 		missyear_`var' = 1 if `var' ==.
bys 		year: egen totmissyear_`var' = count(missyear_`var')
gen 		prmissyear_`var' = (totmissyear_`var'/44)*100
lab 		var prmissyear_`var' "Percentage of missing `var' data, by year"
}

sum 		pr*
bys 		departement: sum pr*, sep(0)
bys 		region: sum pr*, sep(0)

xtable 		dept, c(mean prmiss_area mean prmiss_yield mean prmiss_harvest) filename(Missing_prod_data) sheet(millet_dpt, replace) replace
xtable 		region, c(mean prmiss_area mean prmiss_yield mean prmiss_harvest) filename(Missing_prod_data) sheet(millet_reg, replace) 
xtable 		year, c(mean prmissyear_area mean prmissyear_yield mean prmissyear_harvest) filename(Missing_prod_data) sheet(millet_year, replace) 
xtable 		dept, c(N harvest min harvest mean harvest max harvest) filename(Missing_prod_data) sheet(millet_harvest, replace) 
xtable 		dept, c(mean area mean yield mean harvest) filename(Missing_prod_data) sheet(millet_sumstat, replace) 

use 		"$data_clean\production_peanut.dta", clear
mdesc				
local 		prod_vars area yield harvest
foreach 	var of local prod_vars{
gen 		miss_`var' = 1 if `var' ==.
bys 		departement: egen totmiss_`var' = count(miss_`var')
gen 		prmiss_`var' = (totmiss_`var'/60)*100
lab 		var prmiss_`var' "Percentage of missing `var' data"
}

local 		prod_vars area yield harvest
foreach 	var of local prod_vars{
gen 		missyear_`var' = 1 if `var' ==.
bys 		year: egen totmissyear_`var' = count(missyear_`var')
gen 		prmissyear_`var' = (totmissyear_`var'/44)*100
lab 		var prmissyear_`var' "Percentage of missing `var' data, by year"
}

sum 		pr*
bys 		departement: sum pr*, sep(0)
bys 		region: sum pr*, sep(0)

xtable 		dept, c(mean prmiss_area mean prmiss_yield mean prmiss_harvest) filename(Missing_prod_data) sheet(peanut_dpt, replace) 
xtable 		region, c(mean prmiss_area mean prmiss_yield mean prmiss_harvest) filename(Missing_prod_data) sheet(peanut_reg, replace) 
xtable 		year, c(mean prmissyear_area mean prmissyear_yield mean prmissyear_harvest) filename(Missing_prod_data) sheet(peanut_year, replace) 
xtable 		dept, c(N harvest min harvest mean harvest max harvest) filename(Missing_prod_data) sheet(peanut_harvest, replace) 
xtable 		dept, c(mean area mean yield mean harvest) filename(Missing_prod_data) sheet(peanut_sumstat, replace) 

use 		"$data_clean\production_maize.dta", clear
mdesc				
local 		prod_vars area yield harvest
foreach 	var of local prod_vars{
gen 		miss_`var' = 1 if `var' ==.
bys 		departement: egen totmiss_`var' = count(miss_`var')
gen 		prmiss_`var' = (totmiss_`var'/60)*100
lab 		var prmiss_`var' "Percentage of missing `var' data"
}

local 		prod_vars area yield harvest
foreach 	var of local prod_vars{
gen 		missyear_`var' = 1 if `var' ==.
bys 		year: egen totmissyear_`var' = count(missyear_`var')
gen 		prmissyear_`var' = (totmissyear_`var'/44)*100
lab 		var prmissyear_`var' "Percentage of missing `var' data, by year"
}

sum 		pr*
bys 		departement: sum pr*, sep(0)
bys 		region: sum pr*, sep(0)
bys 		year: sum pr*, sep(0)

xtable 		dept, c(mean prmiss_area mean prmiss_yield mean prmiss_harvest) filename(Missing_prod_data) sheet(maize_dpt, replace) 
xtable 		region, c(mean prmiss_area mean prmiss_yield mean prmiss_harvest) filename(Missing_prod_data) sheet(maize_reg, replace) 
xtable 		year, c(mean prmissyear_area mean prmissyear_yield mean prmissyear_harvest) filename(Missing_prod_data) sheet(maize_year, replace) 
xtable 		dept, c(N harvest min harvest mean harvest max harvest) filename(Missing_prod_data) sheet(maize_harvest, replace) 
xtable 		dept, c(mean area mean yield mean harvest) filename(Missing_prod_data) sheet(maize_sumstat, replace) 


use 		"$data_clean\production_niebe.dta", clear
mdesc				
local 		prod_vars area yield harvest
foreach 	var of local prod_vars{
gen 		miss_`var' = 1 if `var' ==.
bys 		departement: egen totmiss_`var' = count(miss_`var')
gen 		prmiss_`var' = (totmiss_`var'/60)*100
lab 		var prmiss_`var' "Percentage of missing `var' data"
}

local 		prod_vars area yield harvest
foreach 	var of local prod_vars{
gen 		missyear_`var' = 1 if `var' ==.
bys 		year: egen totmissyear_`var' = count(missyear_`var')
gen 		prmissyear_`var' = (totmissyear_`var'/44)*100
lab 		var prmissyear_`var' "Percentage of missing `var' data, by year"
}

sum 		pr*
bys 		departement: sum pr*, sep(0)
bys 		region: sum pr*, sep(0)
bys 		year: sum pr*, sep(0)

xtable 		dept, c(mean prmiss_area mean prmiss_yield mean prmiss_harvest) filename(Missing_prod_data) sheet(niebe_dpt, replace) 
xtable 		region, c(mean prmiss_area mean prmiss_yield mean prmiss_harvest) filename(Missing_prod_data) sheet(niebe_reg, replace) 
xtable 		year, c(mean prmissyear_area mean prmissyear_yield mean prmissyear_harvest) filename(Missing_prod_data) sheet(niebe_year, replace) 
xtable 		dept, c(N harvest min harvest mean harvest max harvest) filename(Missing_prod_data) sheet(niebe_harvest, replace) 
xtable 		dept, c(mean area mean yield mean harvest) filename(Missing_prod_data) sheet(niebe_sumstat, replace) 

