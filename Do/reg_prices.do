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
rename 		wrsi_ wrsi_millet
sort 		departement year
save 		"$data_clean\wrsi_millet_long.dta", replace

use 		"$data_raw\Climate data\WRSI\WRSI_clean_dta\Senegal\wrsi_maize.dta", clear
rename 		admin1Name region
rename 		admin2Name departement
replace 	departement = "Nioro" if departement == "Nioro du Rip"
reshape 	long wrsi_, i(departement) j(year)
rename 		wrsi_ wrsi_maize
sort 		departement year
save 		"$data_clean\wrsi_maize_long.dta", replace


use 		"$data_raw\Climate data\WRSI\WRSI_clean_dta\Senegal\wrsi_groundnut.dta", clear
rename 		admin1Name region
rename 		admin2Name departement
replace 	departement = "Nioro" if departement == "Nioro du Rip"
reshape 	long wrsi_, i(departement) j(year)
rename 		wrsi_ wrsi_groundnut
sort 		departement year
save 		"$data_clean\wrsi_groundnut_long.dta", replace


use 		"$data_raw\Climate data\WRSI\WRSI_clean_dta\Senegal\wrsi_beans.dta", clear
rename 		admin1Name region
rename 		admin2Name departement
replace 	departement = "Nioro" if departement == "Nioro du Rip"
reshape 	long wrsi_, i(departement) j(year)
rename 		wrsi_ wrsi_niebe
sort 		departement year
save 		"$data_clean\wrsi_beans_long.dta", replace

merge 		departement year using "$data_clean\wrsi_millet_long.dta"
drop 		_merge
sort 		departement year
merge 		departement year using "$data_clean\wrsi_maize_long.dta"
drop 		_merge
sort 		departement year
merge 		departement year using "$data_clean\wrsi_groundnut_long.dta"
drop 		_merge
sort 		departement year
save 		"$data_clean\wrsi_allcrops_long.dta", replace


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
merge 		departement year using "$data_clean\wrsi_allcrops_long.dta"
tab 		_merge
order 		_merge region departement marche date month year 
sort 		_merge region departement marche date year month
drop  		if _merge ==1
drop 		if _merge ==2 
drop 		_merge



********************************************************************************	
*** VARIABLE CONSTRUCTION 
********************************************************************************
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

local 		crop millet niebe groundnut maize
foreach 	var of local crop { 
gen 		wrsi_ag_`var' =.
replace		wrsi_ag_`var' = wrsi_`var' if (month == 9 | month == 10 | month ==11 | month == 12)
}

order 		region departement marche date month month_ag year year_ag price* wrsi* market markets
sort 		market date 

foreach 	var of local crop { 
bys			market year_ag: carryforward wrsi_ag_`var' if wrsi_ag_`var'==., replace
}
sort 		market date 
save 		"$data_clean\prices_wrsi.dta", replace


* Variable cleaning 
renvars price_peanut_d / price_groundnut
foreach var of varlist price*{
gen 		ln`var' 	= ln(`var')
gen 		sin`var'  	= asinh(`var')
}

foreach var of varlist wrsi*{
gen 		ln`var' 	= ln(`var')
gen 		sin`var' 	= asinh(`var')
}



********************************************************************************	
*** REGRESSIONS 
********************************************************************************
cd 			"$outputs/Tables"

local 		crops millet niebe groundnut maize
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop', fe robust
outreg2 	using reg`crop'_price.xls, replace

eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop' i.year i.month, fe robust
outreg2 	using reg`crop'_price.xls, append
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop' i.year i.month_ag, fe robust
outreg2 	using reg`crop'_price.xls, append
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop' i.year_ag i.month, fe robust
outreg2 	using reg`crop'_price.xls, append
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop' i.year_ag i.month_ag, fe robust
outreg2 	using reg`crop'_price.xls, append
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop' i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_price.xls, append
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop' i.year c.lnwrsi_ag_`crop'##i.month_ag, fe robust
outreg2 	using reg`crop'_price.xls, append
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop' i.year_ag c.lnwrsi_ag_`crop'##i.month_ag, fe robust
outreg2 	using reg`crop'_price.xls, append

}

/*
foreach 	crop of local crops {
use reg`crop'_price.xls
export excel using "reg_prices" , sheet("`crop'")
}
 */
 
 
********************************************************************************	
*** GRAPHS 
********************************************************************************
use			"$data_clean\prices_wrsi.dta", clear


twoway 		tsline price_millet 
twoway 		(line price_millet month if marche == "Kaolack" & year == 2000) (line price_millet month if marche == "Kaolack" & year == 2009) (line price_millet month if marche == "Kaolack" & year == 2014) (line price_millet month if marche == "Kaolack" & year == 2019),  xlabel(#12) 

preserve 
keep if year ==2010
tsset markets month
twoway 		(tsline price_millet if marche == "Kaolack") (tsline price_millet if marche == "Tilene") (tsline price_millet if marche == "Tambacounda")  (tsline price_millet if marche == "St.Louis") 

*(tsline price_millet month if marche == "Kaolack" & year == 2009) (tsline price_millet month if marche == "Kaolack" & year == 2014) (tsline price_millet month if marche == "Kaolack" & year == 2019),  xlabel(#12) 
restore

twoway 		line MIL month if marche == "Kaolack" & year == 2008

twoway (tsline price_millet) if marche == "Kaolack", ytitle(Millet prices) ttitle(Month / year) tline(2008m7) tlabel(#30) tmtick(##12)
twoway (tsline price_millet) if marche == "Kaolack"  & year > 2003 & year < 2005, ytitle(Millet prices) ttitle(Month / year) tline(2008m7) tlabel(#30, labsize(vsmall) format(%tm) alternate) tmtick(##12, labsize(vsmall)) title(Price seasonality - Millet) name(seasonality_millet, replace)

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


, yla(, ang(h)) legend(pos(11) ring(0) order(6 5 4 3 2 1) col(1))
)


 
twoway 		(tsline price_millet if marche == "Kaolack") (tsline price_millet if marche == "Tilene") (tsline price_millet if marche == "Tambacounda")  (tsline price_millet if marche == "St.Louis") 







