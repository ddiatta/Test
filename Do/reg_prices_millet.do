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
/* 		
merge 		1:1 departement year using "$data_clean\production_millet.dta"
order 		_merge 
sort 		_merge departement year
drop 		if year == 2020
drop 		if departement == "Guediawaye" 		// No production data for Guediawaye 
drop 		if departement == "Malem Hodar" 	// No WRSI data for Malem Hodar 
drop 		if year <1981 						// WRSI data available from 1981
drop 		if year == 2020						// No production data for 2020
drop 		_merge

*/
*reshape 	long prix_, i( year month) j(market)

* Format price data 
use 		"$data_clean\Prices_monthly_all.dta", clear
renvars 	MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE MANIOC / price_millet price_sorghum price_maize price_maize_i price_rice_io price_rice_ip price_rice price_onion price_onion_i price_potato price_potato_i price_niebe price_peanut_c price_peanut_d price_cassava

* Format variables 
duplicates 	drop
replace 	REGION = lower(REGION)
replace 	REGION = proper(REGION)
replace 	DEPARTEMENT = lower(DEPARTEMENT)
replace 	DEPARTEMENT = proper(DEPARTEMENT)
replace 	MARCHE = lower(MARCHE)
replace 	MARCHE = proper(MARCHE)
renvars 	REGION DEPARTEMENT MARCHE / region departement marche
replace 	departement = "Birkelane" if departement == "Mbirkilane"
*replace 	departement = "Nioro du Rip" if departement == "Nioro"
replace 	departement = "Saint Louis" if departement == "St.Louis"
*collapse 	price_millet - price_peanut_d, by(region departement year month)
sort 		departement year
merge 		departement year using "$data_clean\wrsi_millet_long.dta"
tab 		_merge
order 		_merge region departement marche date month year 
sort 		_merge region departement marche date year month
drop  		if _merge ==1
drop 		if _merge ==2 
drop 		_merge
drop 		price_sorghum - price_peanut_d
preserve
sort 		departement year
merge 		departement year using "$data_clean\production_millet.dta"
tab 		_merge
order 		_merge region departement marche date month year 
sort 		_merge region departement marche date year month
keep 		if _merge ==3
		
* Create ag dates corresponding to the ag calendar 
foreach 	i of num 1990/2020 {
gen			s_`i' =`i' if year==`i' & (  month ==9 | month ==10 | month ==11 | month ==12) // main harvest - Sept to Dec
replace 	s_`i'=`i' if year==`i'+1 & ( month ==1 | month ==2 | month ==3 | month ==4 | month ==5 | month ==6 | month ==7 | month ==8)
}
egen 		year_ag=rsum( s_*)
drop		s_*
replace 	year_ag=1989 if year_ag==0
drop 		if year_ag==1989
gen 		b=1
order 		year_ag, after(year)
sort 		market date
bysort 		market year_ag: gen month_ag=sum(b)

gen 		wrsi_ag =.
replace		wrsi_ag = wrsi if month == 9 | month == 10 | month ==11 | month == 12
order 		region departement marche date month month_ag year year_ag price_millet wrsi wrsi_ag market markets
sort 		market date 

bys			market year_ag: carryforward wrsi_ag if wrsi_ag==., replace
keep 		region departement marche date month month_ag year year_ag price_millet wrsi wrsi_ag market markets
order 		region departement marche date month month_ag year year_ag price_millet wrsi wrsi_ag market markets
sort 		market date 
save 		"$data_clean\millet_prices_wrsi.dta", replace

preserve 


res



use 		"$data_clean\millet_prices_wrsi.dta", replace


* Variable cleaning 
hist 		price_millet
gen 		lnprice_millet 		= ln(price_millet)
hist 		lnprice_millet
gen 		sinprice_millet  	= asinh(price_millet)
hist 		sinprice_millet
*gen 		sqprice_millet 		= price_millet*price_millet
*hist 		sqprice_millet

hist 		wrsi
gen 		lnwrsi 		= ln(wrsi)
gen 		lnwrsi_ag 	= ln(wrsi_ag)
gen 		sinwrsi  	= asinh(wrsi)
gen 		sinwrsi_ag  	= asinh(wrsi_ag)
gen 		sqwrsi		= wrsi*wrsi
hist 		lnwrsi
hist 		sinwrsi
hist 		sqwrsi

eststo raw: xtreg price_millet wrsi, fe robust
outreg2 using regprice1.xls, replace 
eststo raw: xtreg lnprice_millet lnwrsi, fe robust
outreg2 using regprice1.xls, append
eststo raw: xtreg lnprice_millet sqwrsi, fe robust
outreg2 using regprice1.xls, append


eststo raw: xtreg lnprice_millet lnwrsi_ag i.year_ag c.lnwrsi_ag##i.month_ag, fe robust
outreg2 using regprice1.xls, append




eststo raw: xtreg lnprice_millet lnwrsi i.year c.lnwrsi##i.month, fe robust
outreg2 using regprice1.xls, append

eststo raw: xtreg lnprice_millet lnwrsi_ag, fe robust
outreg2 using regprice1.xls, append
eststo raw: xtreg price_millet wrsi i.year i.month, fe robust
outreg2 using regprice1.xls, append 
eststo raw: xtreg price_millet wrsi i.year_ag i.month_ag, fe robust
outreg2 using regprice1.xls, append 

* Regression for markets with changes in WRSI over time 
bys marche: egen sd_wrsi =  sd(wrsi)

eststo raw: xtreg lnprice_millet lnwrsi i.year c.lnwrsi##i.month, fe robust
outreg2 using regprice1.xls, append
eststo raw: xtreg lnprice_millet lnwrsi_ag i.year_ag c.lnwrsi_ag##i.month_ag if sd_wrsi >0 , fe robust
outreg2 using regprice1.xls, append


tab marche if sd_wrsi ==0
twoway line  (wrsi year) if marche == "Kaolack",  xlabel(#12) 
(price_millet year)
eststo margin: margins month, dydx(wrsi) post
estimates store rf, title(rfanmly)

 xtreg lprice_millet c.lwrsi##i.mois_ag i.year  , fe robust

* sin 
eststo raw: xtreg sinprice_millet sinwrsi i.year c.sinwrsi##i.month, fe robust
outreg2 using regprice1.xls, append
eststo raw: xtreg sinprice_millet sinwrsi_ag i.year_ag c.sinwrsi_ag##i.month_ag if sd_wrsi >0 , fe robust
outreg2 using regprice1.xls, append

* Final regressions
cd 			"$outputs/Tables"

eststo raw: xtreg lnprice_millet lnwrsi_ag, fe robust
outreg2 using regmillet_price.xls, replace
eststo raw: xtreg lnprice_millet lnwrsi_ag i.year i.month, fe robust
outreg2 using regmillet_price.xls, append
eststo raw: xtreg lnprice_millet lnwrsi_ag i.year i.month_ag, fe robust
outreg2 using regmillet_price.xls, append
eststo raw: xtreg lnprice_millet lnwrsi_ag i.year_ag i.month, fe robust
outreg2 using regmillet_price.xls, append
eststo raw: xtreg lnprice_millet lnwrsi_ag i.year_ag i.month_ag, fe robust
outreg2 using regmillet_price.xls, append
eststo raw: xtreg lnprice_millet lnwrsi_ag i.year c.lnwrsi_ag##i.month, fe robust
outreg2 using regmillet_price.xls, append
eststo raw: xtreg lnprice_millet lnwrsi_ag i.year c.lnwrsi_ag##i.month_ag, fe robust
outreg2 using regmillet_price.xls, append
eststo raw: xtreg lnprice_millet lnwrsi_ag i.year_ag c.lnwrsi_ag##i.month_ag, fe robust
outreg2 using regmillet_price.xls, append






*eststo raw: xtreg lnprice_millet lnwrsi_ag i.year_ag c.lnwrsi_ag##i.month, fe robust  // not sign
*outreg2 using regmillet_price.xls, append
*eststo raw: xtreg lnprice_millet lnwrsi_ag i.year c.lnwrsi_ag##i.month_ag, fe robust
*outreg2 using regmillet_price.xls, append


/*
eststo raw: xtreg lnprice_millet lnwrsi i.year c.lnwrsi##i.month, fe robust
outreg2 using regmillet_price.xls, replace
eststo raw: xtreg lnprice_millet lnwrsi i.year_ag c.lnwrsi##i.month, fe robust
outreg2 using regmillet_price.xls, append
eststo raw: xtreg lnprice_millet lnwrsi i.year c.lnwrsi##i.month_ag, fe robust
outreg2 using regmillet_price.xls, append
eststo raw: xtreg lnprice_millet lnwrsi i.year_ag c.lnwrsi##i.month_ag, fe robust
outreg2 using regmillet_price.xls, append
 preserve 
 
 drop if wrsi ==100 
 
 restore 
 */
 
* Price seasonality grpahs
twoway line MIL month if marche == "Kaolack" & year == 2008,  xlabel(#12) 
twoway line MIL month if marche == "Kaolack" & year == 2008







********************************************************************************	
*** MISSING DATA 
********************************************************************************
reg harvest wrsi i.year
tab departement if !missing(wrsi) & !missing(harvest)  // 1000 observations



xtreg mil wrsi i.year i.month, fe  robust


use 		"$data_clean/Prices_monthly_cereals.dta", replace

Prices(mtd) = WRSI(t-1) + Yfe + Mfe + RE

* What is the impact of WRSI shocks on price and production? 
