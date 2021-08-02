********************************************************************************	
** Description:This file cleans the price data for Senegal
** Author: Dieynab Diatta
** Date: May 4th 2021
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
global		temp 		"$dir\DIME\Outputs" 						// path the temporary files 
cd 			"$outputs"

********************************************************************************	


********************************************************************************	
*** CEREALS
********************************************************************************

import 		excel "$data_raw/Prix/BASE PRIX 1990 2020 SIM CSA.xlsx", sheet("CEREALES") firstrow clear
drop 		L M
destring 	RIZBRISEIMPORTEPARFUME, replace
* data cleaning regions/departments to account for changes in administrative divisions

replace 	MARCHE = "TOUBA" 			if MARCHE == 		"TOUBA "
replace 	MARCHE = "SAGATTA" 			if MARCHE == 		"SAGATTA "
replace 	MARCHE = "LOUGA" 			if MARCHE == 		"LOUGA "
replace 	MARCHE = "TOUBA TOUL" 		if MARCHE == 		"Touba Toul"
replace 	REGION = "SAINT LOUIS" 		if REGION == 		"ST.LOUIS"
replace 	DEPARTEMENT = "SAINT LOUIS" if DEPARTEMENT 	== 	"ST.LOUIS"
replace 	MARCHE = "SAINT LOUIS" 		if MARCHE 		== 	"ST.LOUIS"
replace 	DEPARTEMENT = "BIRKELANE" if DEPARTEMENT == "MBIRKILANE"
replace 	MARCHE = "BIRKELANE" if MARCHE == "MBIRKILANE"
replace 	REGION = "KAFFRINE" if MARCHE == "MABO"  // Since 2008 Kaffrine is no longer a department of Kaolack
replace 	REGION = "SEDHIOU" if MARCHE == "SEDHIOU"  // Since 2008 Sedhiou is no longer a department of Kolda
replace 	DEPARTEMENT = "KANEL" if MARCHE == "ORKODIERE"
replace 	DEPARTEMENT = "MATAM" if MARCHE == "THIODAYE"
replace 	REGION = "MATAM" if DEPARTEMENT == "MATAM"
replace 	REGION = "SEDHIOU" if DEPARTEMENT == "BOUNKILING"
replace 	REGION = "LOUGA" if DEPARTEMENT == "KEBEMER"
replace 	DEPARTEMENT = "BIGNONA" if MARCHE == "BIGNONA"
replace 	DEPARTEMENT = "KAFFRINE" if MARCHE == "MABO"
duplicates 	tag, gen(dups)
duplicates 	drop 
drop 		dups
sort 		REGION DEPARTEMENT MARCHE DATE

gen 		x = ";" 
gen 		market 	= REGION+x+DEPARTEMENT+x+MARCHE // create a unique market identifier
sort 		REGION DEPARTEMENT MARCHE DATE
drop 		x
gen 		year 	= year(DATE)
gen 		month 	= month(DATE)
gen 		day 	= day(DATE)
gen 		date 	= mofd(DATE) // create a monthly variable
gen 		date2 	= date
format		date2 %tm
collapse 	(mean) MIL - RIZLOCALDECORTIQUE, by(REGION DEPARTEMENT MARCHE market year month date date2)   // aggregrate prices to monthly prices
encode 		market, generate(markets)

order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year  
isid 		markets date
tsset 		markets date
tsfill		, full
list		, clean noobs
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace
gsort 		markets - date
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace

sort 		market date month year
duplicates 	tag market date, gen(dups)
tab 		dups
drop 		dups
sort 		market date month year
gen 		n = _n
order 		n
format 		date %tm
gen 		date3 	= dofm(date)
gen 		month2	= month(date3)
gen 		year2	= year(date3)
drop 		year month date2 date3
rename 		year2 year 
rename 		month2 month
drop 		n 
order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE year month 

save 		"$data_clean/Prices_monthly_cereals.dta", replace

********************************************************************************	
** VEGETABLES ******************************************************************
********************************************************************************	

import 		excel "$data_raw/Prix/BASE PRIX 1990 2020 SIM CSA.xlsx", sheet("LEGUMES") firstrow clear
replace 	MARCHE = "TOUBA" if MARCHE == "TOUBA "
replace 	MARCHE = "SAGATTA" if MARCHE == "SAGATTA "
replace 	MARCHE = "LOUGA" if MARCHE == "LOUGA "
replace 	MARCHE = "TOUBA TOUL" if MARCHE == "Touba Toul"
replace 	REGION = "SAINT LOUIS" 		if REGION == 		"ST.LOUIS"
replace 	DEPARTEMENT = "SAINT LOUIS" if DEPARTEMENT 	== 	"ST.LOUIS"
replace 	DEPARTEMENT = "SAINT LOUIS" if DEPARTEMENT 	== 	"ST. LOUIS"
replace 	MARCHE = "SAINT LOUIS" 		if MARCHE 		== 	"ST.LOUIS"
replace 	MARCHE = "SAINT LOUIS" 		if MARCHE 		== 	"ST. LOUIS"
replace 	DEPARTEMENT = "BIRKELANE" if DEPARTEMENT == "MBIRKILANE"
replace 	MARCHE = "BIRKELANE" if MARCHE == "MBIRKILANE"

* data cleaning regions/departments to account for changes in administrative divisions
replace 	DEPARTEMENT = "KAFFRINE" if MARCHE == "MABO"
replace 	DEPARTEMENT = "MATAM" if MARCHE == "THIODAYE"
replace 	MARCHE = "THIODAYE" if MARCHE == "THIAROYE"  & DEPARTEMENT == "MATAM"
replace 	DEPARTEMENT = "BOUNKILING" if MARCHE == "SARE ALKALY"
replace	 	DEPARTEMENT = "KAFFRINE" if MARCHE == "DIAMAGADIO"
replace 	DEPARTEMENT = "BAMBEY" if MARCHE == "BAMBEY"
replace 	DEPARTEMENT = "KAOLACK" if MARCHE == "KAOLACK"
*duplicates drop REGION DEPARTEMENT MARCHE, force
*sort 		REGION DEPARTEMENT MARCHE
*sort 		MARCHE

duplicates 	tag, gen(dups)
duplicates 	drop 
drop 		dups
sort 		REGION DEPARTEMENT MARCHE DATE

gen 		x = ";" 
gen 		market 	= REGION+x+DEPARTEMENT+x+MARCHE // create a unique market identifier
sort 		REGION DEPARTEMENT MARCHE DATE
drop 		x
gen 		year 	= year(DATE)
gen 		month 	= month(DATE)
gen 		day 	= day(DATE)
gen 		date 	= mofd(DATE) // create a monthly variable

gen 		date2 	= date
format 		date2 %tm
collapse 	(mean) OIGNONLOCAL - MANIOC, by(REGION DEPARTEMENT MARCHE market year month date date2)   // aggregrate prices to monthly prices
encode 		market, generate(markets)

order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year  
isid 		markets date
tsset 		markets date
tsfill		, full
list		, clean noobs
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace
gsort 		markets - date
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace

sort 		market date month year
duplicates 	tag market date, gen(dups)
tab 		dups
drop 		dups
sort 		market date month year
gen 		n = _n
order 		n
format 		date %tm
gen 		date3 	= dofm(date)
gen 		month2	= month(date3)
gen 		year2	= year(date3)
drop 		year month date2 date3
rename 		year2 year 
rename 		month2 month
drop 		n 
order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE year month 

save 		"$data_clean/Prices_monthly_vegetables.dta", replace


********************************************************************************	
** LEGUMINEUSES ******************************************************************
********************************************************************************	

import 		excel "$data_raw/Prix/BASE PRIX 1990 2020 SIM CSA.xlsx", sheet("LEGUMINEUSES") firstrow clear
drop 		H
replace 	MARCHE = "TOUBA" if MARCHE == "TOUBA "
replace 	MARCHE = "SAGATTA" if MARCHE == "SAGATTA "
replace 	MARCHE = "LOUGA" if MARCHE == "LOUGA "
replace 	MARCHE = "TOUBA TOUL" if MARCHE == "Touba Toul"
replace 	REGION = "SAINT LOUIS" 		if REGION == 		"ST.LOUIS"
replace 	DEPARTEMENT = "SAINT LOUIS" if DEPARTEMENT 	== 	"ST.LOUIS"
replace 	DEPARTEMENT = "SAINT LOUIS" if DEPARTEMENT 	== 	"ST. LOUIS"
replace 	MARCHE = "SAINT LOUIS" 		if MARCHE 		== 	"ST.LOUIS"
replace 	MARCHE = "SAINT LOUIS" 		if MARCHE 		== 	"ST. LOUIS"
replace 	DEPARTEMENT = "BIRKELANE" if DEPARTEMENT == "MBIRKILANE"
replace 	MARCHE = "BIRKELANE" if MARCHE == "MBIRKILANE"

replace 	MARCHE = "BAMBEY" if DEPARTEMENT == "BAMBEY" & MARCHE == "DIOURBEL"
replace 	DEPARTEMENT = "DIOURBEL" if MARCHE == "NDINDY"
replace 	DEPARTEMENT = "BIGNONA" if MARCHE == "BIGNONA"
replace 	REGION = "KAFFRINE" if DEPARTEMENT == "KAFFRINE"
replace 	DEPARTEMENT = "KANEL" if MARCHE == "ORKODIERE"
replace 	REGION = "MATAM" if DEPARTEMENT == "MATAM"
replace 	REGION = "SEDHIOU" if DEPARTEMENT == "BOUNKILING"
replace 	REGION = "ZIGUINCHOR" if DEPARTEMENT == "BIGNONA"
duplicates 	tag, gen(dups)
duplicates 	drop 
drop 		dups

* data cleaning regions/departments to account for changes in administrative divisions

gen 		x = ";" 
gen 		market 	= REGION+x+DEPARTEMENT+x+MARCHE // create a unique market identifier
sort 		REGION DEPARTEMENT MARCHE DATE
drop 		x
gen 		year 	= year(DATE)
gen 		month 	= month(DATE)
gen 		day 	= day(DATE)
gen 		date 	= mofd(DATE) // create a monthly variable

gen 		date2 	= date
format 		date2 %tm
collapse 	(mean) NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE, by(REGION DEPARTEMENT MARCHE market year month date date2)   // aggregrate prices to monthly prices
encode 		market, generate(markets)

order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year  
isid 		markets date
tsset 		markets date
tsfill		, full
list		, clean noobs
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace
gsort 		markets - date
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace

sort 		market date month year
duplicates 	tag market date, gen(dups)
tab 		dups
drop 		dups
sort 		market date month year
gen 		n = _n
order 		n
format 		date %tm
gen 		date3 	= dofm(date)
gen 		month2	= month(date3)
gen 		year2	= year(date3)
drop 		year month date2 date3
rename 		year2 year 
rename 		month2 month
drop 		n 
order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE year month 

save 		"$data_clean/Prices_monthly_legumes.dta", replace


********************************************************************************
** MERGE PRICE DATA 
********************************************************************************
use 		"$data_clean/Prices_monthly_cereals.dta", clear
merge 		REGION DEPARTEMENT MARCHE year month using "$data_clean/Prices_monthly_vegetables.dta"
tab 		_merge 
order 		_merge 
sort		_merge 
drop 		_merge
sort 		REGION DEPARTEMENT MARCHE year month
merge 		REGION DEPARTEMENT MARCHE year month using "$data_clean/Prices_monthly_legumes.dta"
tab 		_merge 
order 		_merge 
sort		_merge 
drop 		_merge
sort 		REGION DEPARTEMENT MARCHE year month
drop 		market markets
gen 		x = ";" 
gen 		market 	= REGION+x+DEPARTEMENT+x+MARCHE // create a unique market identifier
sort 		REGION DEPARTEMENT MARCHE date
drop 		x
gen 		date2 	= date
format 		date2 %tm
collapse 	(mean) MIL - ARACHIDEDECORTIQUEE, by(REGION DEPARTEMENT MARCHE market year month date)   // aggregrate prices to monthly prices
encode market, generate(markets)

order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year  
isid 		markets date
tsset 		markets date
tsfill		, full
list		, clean noobs
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace
gsort 		markets - date
bysort 		markets: carryforward REGION DEPARTEMENT MARCHE market, replace
sort 		market date month year
duplicates 	tag market date, gen(dups)
tab 		dups
drop 		dups
sort 		market date month year
gen 		n = _n
order 		n
format 		date %tm
gen 		date3 	= dofm(date)
gen 		month2	= month(date3)
gen 		year2	= year(date3)
drop 		year month date3
rename 		year2 year 
rename 		month2 month
drop 		n 
order 		REGION DEPARTEMENT MARCHE market markets date month year 
sort 		REGION DEPARTEMENT MARCHE market markets date month year 




********************************************************************************
** CREATE VARIABLES FOR ANALYSIS 
********************************************************************************
* rename renvars
renvars 	MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE MANIOC / price_millet price_sorghum price_maize price_maize_i price_rice_io price_rice_ip price_rice price_onion price_onion_i price_potato price_potato_i price_niebe price_groundnut_c price_groundnut_d price_cassava
renvars price_groundnut_c / price_groundnut
renvars 	REGION DEPARTEMENT MARCHE / region departement marche
* Format variables 
replace 	region = lower(region)
replace 	region = proper(region)
replace 	departement = lower(departement)
replace 	departement = proper(departement)
replace 	marche = lower(marche)
replace 	marche = proper(marche)

* Construct variables 
foreach 	i of num 1990/2020 {		// Create ag dates corresponding to the ag calendar 
gen			s_`i' =`i' if year==`i' & (  month ==9 | month ==10 | month ==11 | month ==12) // main harvest - Sept to Dec
replace 	s_`i'=`i' if year==`i'+1 & ( month ==1 | month ==2 | month ==3 | month ==4 | month ==5 | month ==6 | month ==7 | month ==8)
}
egen 		year_ag=rsum( s_*)
drop		s_*
replace 	year_ag=1989 if year_ag==0
*drop 		if year_ag==1989
gen 		b=1
order 		year_ag, after(year)
sort 		market date
bysort 		market year_ag: gen month_ag=sum(b)

order 		region departement marche date month month_ag year year_ag price* market markets
sort 		market date 

********************************************************************************
sort 		region departement year
save 		"$data_clean\Prices_monthly.dta", replace
