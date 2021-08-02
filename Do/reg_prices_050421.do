********************************************************************************	
** Description:This file codes the regressions for the impact of climate shocks on price in Senegal 
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
drop 		if _merge ==2
rename 		_merge _merge1 
sort 		region departement year month
merge 		region departement year month using "$data_clean\Rain_long.dta"
tab 		_merge
order 		_merge 
sort 		_merge
drop 		if year <1990 // price data is from 1990
rename  	_merge _merge2
sort 		region departement year month
merge 		region departement year month using "$data_clean\Temp_ehdd_long.dta"
tab 		_merge
order 		_merge 
sort 		_merge
drop 		if year <1990 // price data is from 1990
rename 		_merge _merge3
sort 		region departement year month
merge 		region departement year month using "$data_clean\ndvi_long.dta"
tab 		_merge
order 		_merge 
sort 		_merge
drop 		if year <1990 // price data is from 1990
rename 		_merge _merge4
drop 		if year ==2021 // no climate data in 2021
drop 		if departement == "Guediawaye" // no price data
drop 		if departement == "Rufisque" // no price data
drop 		if departement == "Guinguineo" // no price data
drop 		_merge*

foreach 	var of varlist wrsi* rain* ndvi* ehdd gdd {
gen 		ln`var' 	= ln(`var')
}
/*
hist		ndvi_season
hist 		ndvi_month
hist		lnndvi_season
hist 		lnndvi_month
hist		ehdd
hist 		gdd
hist 		lnehdd
hist 		lngdd
hist 		rain_season
hist		lnrain_season
*/
sort 		region departement marche year month
save 		"$data_clean/price_regression_long.dta", replace


/********************************************************************************	
*** REGRESSIONS - SHOCK: WRSI
********************************************************************************
cd 			"$outputs/Tables"

local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop', fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop' i.year i.month, fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop' i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, append
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
eststo 		raw: xtreg lnprice_`crop' lnrain_season, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_season i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_season i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, append
}

* Rain June 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnrain_june, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_june i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_june i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, append
}


* Rain July 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnrain_july, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_july i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_july i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, append
}

* Rain August
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnrain_aug, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_aug i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_aug i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, append
}

* Rain September
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnrain_sep, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_sep i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_sep i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, append
}

* Monthly rainfall 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnrain_month, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_month i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_month i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, append
}



********************************************************************************	
*** REGRESSIONS - SHOCK: TEMPERATURE
********************************************************************************

* Extreme heat degree days / mostly 0
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnehdd, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnehdd i.year i.month, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnehdd i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, append
}


* Growing degree days 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lngdd, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lngdd i.year i.month, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lngdd i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, append
}


********************************************************************************	
*** REGRESSIONS - SHOCK: NDVI
********************************************************************************

* Seasonal NDVI
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnndvi_season, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnndvi_season i.year i.month, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnndvi_season i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, append
}

* Monthly NDVI
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnndvi_month, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnndvi_month i.year i.month, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnndvi_month i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, append
}


sort 		region departement year month
save 		"$data_clean/price_regression_long.dta", replace


/*
foreach 	crop of local crops {
use reg`crop'_price.xls
export excel using "reg_prices" , sheet("`crop'")
}
 */
 
 
/********************************************************************************	
*** GRAPHS 
********************************************************************************
use			"$data_clean\prices_wrsi.dta", clear
twoway 		(line price_millet month if marche == "Kaolack" & year == 2000) (line price_millet month if marche == "Kaolack" & year == 2009) (line price_millet month if marche == "Kaolack" & year == 2014) (line price_millet month if marche == "Kaolack" & year == 2019),  xlabel(#12) 

preserve 
keep if year ==2010
tsset markets month
twoway 		(tsline price_millet if marche == "Kaolack") (tsline price_millet if marche == "Tilene") (tsline price_millet if marche == "Tambacounda")  (tsline price_millet if marche == "St.Louis") 

*(tsline price_millet month if marche == "Kaolack" & year == 2009) (tsline price_millet month if marche == "Kaolack" & year == 2014) (tsline price_millet month if marche == "Kaolack" & year == 2019),  xlabel(#12) 
restore

twoway 		line MIL month if marche == "Kaolack" & year == 2008

twoway (tsline price_millet) if marche == "Kaolack", ytitle(Millet prices) ttitle(Month / year) tline(2008m7) tlabel(#30) tmtick(##12)
twoway (tsline price_millet) if marche == "Kaolack", ytitle(Millet prices) ttitle(Month / year) tline(2008m7) tlabel(#30, labsize(vsmall) format(%tm) alternate) tmtick(##12, labsize(vsmall)) title(Price seasonality - Millet) name(seasonality_millet, replace)

preserve 

tsset markets month
tsset markets month

ssc
cycleplot price_millet month year if marche == "Kaolack"
sliceplot line price_millet year if marche == "Kaolack"
 , at(numlist) unequal length(#) slices(#) combine(combine options) twoway options 

separate price_millet, by(year) veryshortlabel
twoway (line price_millet month if marche == "Kaolack" & year == 1991) (line price_millet month if marche == "Kaolack" & year == 1992) (line price_millet month if marche == "Kaolack" & year == 1993) (line price_millet month if marche == "Kaolack" & year == 1994) (line price_millet month if marche == "Kaolack" & year == 1995) (line price_millet month if marche == "Kaolack" & year == 1996) (line price_millet month if marche == "Kaolack" & year == 1997) (line price_millet month if marche == "Kaolack" & year == 1998)  (line price_millet month if marche == "Kaolack" & year == 1999)  (line price_millet month if marche == "Kaolack" & year == 2000)  (line price_millet month if marche == "Kaolack" & year == 2001)  (line price_millet month if marche == "Kaolack" & year == 2002)  (line price_millet month if marche == "Kaolack" & year == 2003)  (line price_millet month if marche == "Kaolack" & year == 2004)  (line price_millet month if marche == "Kaolack" & year == 2005)  (line price_millet month if marche == "Kaolack" & year == 2006)  (line price_millet month if marche == "Kaolack" & year == 2007)  (line price_millet month if marche == "Kaolack" & year == 2008)  (line price_millet month if marche == "Kaolack" & year == 2009)  (line price_millet month if marche == "Kaolack" & year == 2010) (line price_millet month if marche == "Kaolack" & year == 2011) (line price_millet month if marche == "Kaolack" & year == 2012) (line price_millet month if marche == "Kaolack" & year == 2013) (line price_millet month if marche == "Kaolack" & year == 2014) (line price_millet month if marche == "Kaolack" & year == 2015) (line price_millet month if marche == "Kaolack" & year == 2016) (line price_millet month if marche == "Kaolack" & year == 2017) (line price_millet month if marche == "Kaolack" & year == 2018) (line price_millet month if marche == "Kaolack" & year == 2019)  (line price_millet month if marche == "Kaolack" & year == 2020), ytitle(Millet prices (CFA/Kg)) xtitle(Month) xlabel(#12 1"Jan" 2"Feb" 3"Mar" 4"Apr" 5"May" 6"Jun" 7"Jul" 8"Aug" 9"Sep" 10"Oct" 11"Nov" 12"Dec", labels labsize(small)) ylab(, ang(h)) legend(pos(11) ring(0) order(6 5 4 3 2 1) col(1))



twoway (line price_millet month if marche == "Kaolack" & year == 1995) (line price_millet month if marche == "Kaolack" & year == 2000) (line price_millet month if marche == "Kaolack" & year == 2005) (line price_millet month if marche == "Kaolack" & year == 2010) (line price_millet month if marche == "Kaolack" & year == 2015) (line price_millet month if marche == "Kaolack" & year == 2020), ytitle(Millet prices (CFA/Kg)) xtitle(Month) xlabel(#12 1"Jan" 2"Feb" 3"Mar" 4"Apr" 5"May" 6"Jun" 7"Jul" 8"Aug" 9"Sep" 10"Oct" 11"Nov" 12"Dec", labels labsize(small)) ylab(, ang(h)) legend(pos(11) ring(0) col(1))

twoway (connected price_millet month if marche == "Kaolack" & year == 1995) (connected price_millet month if marche == "Kaolack" & year == 2000) (connected price_millet month if marche == "Kaolack" & year == 2005) (connected price_millet month if marche == "Kaolack" & year == 2010) (connected price_millet month if marche == "Kaolack" & year == 2015) (connected price_millet month if marche == "Kaolack" & year == 2020), ytitle(Millet prices (CFA/Kg)) xtitle(Month) xlabel(#12 1"Jan" 2"Feb" 3"Mar" 4"Apr" 5"May" 6"Jun" 7"Jul" 8"Aug" 9"Sep" 10"Oct" 11"Nov" 12"Dec", labels labsize(small)) ylab(, ang(h)) legend(label(1 "1995") label(2 "2000") label(3 "2005") label(4 "2010") label(5 "2015") label(6 "2020") pos(11) ring(0) col(1)) scheme(538) title(Kaolack)

label(3 "2005") label(4 "2010") label(5 "2015") label(6 "2020")

twoway (line price_millet month, sort) if marche == "Kaolack" & year ==2008, 


gen months = "Jan" if month ==1
replace months = "Feb" if month ==2 
replace months = "Mar" if month ==3
replace months = "Apr" if month ==4 
replace months = "May" if month ==5 
replace months = "Jun" if month ==6 
replace months = "Jul" if month ==7 
replace months = "Aug" if month ==8 
replace months = "Sep" if month ==9 
replace months = "Oct" if month ==10 
replace months = "Nov" if month ==11
replace months = "Dec" if month ==12


 
twoway 		(tsline price_millet if marche == "Kaolack") (tsline price_millet if marche == "Tilene") (tsline price_millet if marche == "Tambacounda")  (tsline price_millet if marche == "St.Louis") 







