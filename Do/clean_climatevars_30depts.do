********************************************************************************	
** Description:This file creates climate variables for Senegal's 30 historical departments
** Author: Dieynab Diatta
** Date: June 1st 2021
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

** Admin data 

import 		excel using "$data_clean\pcode_1988.xlsx", firstrow clear
rename 		ADMIN_NAME departement
replace 	departement = "Mbacke" if departement == "M'backe"
replace 	departement = "Mbour" if departement == "M'bour"
sort 		pcode
save 		"$data_clean\pcode_1988.dta", replace
**********************************
** WRSI
**********************************
import 		excel using "$data_raw\Climate data\WRSI\WRSI_senegal30depts\geo2_sn1988_mil.xlsx", firstrow clear
reshape 	long WRSI , i(Admin_Name) j(year)
drop		if substr(string(year), 5, 6) == "27" //dropping duplicates ending in 27 for the year 2003
gen 		double years = floor(year/100)
drop 		year 
rename 		years year
rename 		Admin_Name departement
replace 	departement = "Mbacke" if departement == "M'backe"
replace 	departement = "Mbour" if departement == "M'bour"
rename 		WRSI wrsi_millet 
order 		departement year wrsi_millet
sort 		departement year wrsi_millet
save		"$data_clean\wrsi_millet_30dpts.dta", replace 


import 		excel using "$data_raw\Climate data\WRSI\WRSI_senegal30depts\geo2_sn1988_mais.xlsx", firstrow clear
reshape 	long WRSI , i(Admin_Name) j(year)
gen 		double years = floor(year/100)
drop 		year 
rename 		years year
rename 		Admin_Name departement
replace 	departement = "Mbacke" if departement == "M'backe"
replace 	departement = "Mbour" if departement == "M'bour"
rename 		WRSI wrsi_maize
order 		departement year wrsi_maize
sort 		departement year wrsi_maize
save		"$data_clean\wrsi_maize_30dpts.dta", replace 


import 		excel using "$data_raw\Climate data\WRSI\WRSI_senegal30depts\geo2_sn1988_niebe.xlsx", firstrow clear
reshape 	long WRSI , i(Admin_Name) j(year)
gen 		double years = floor(year/100)
drop 		year 
rename 		years year
rename 		Admin_Name departement
replace 	departement = "Mbacke" if departement == "M'backe"
replace 	departement = "Mbour" if departement == "M'bour"
rename 		WRSI wrsi_niebe
order 		departement year wrsi_niebe
sort 		departement year wrsi_niebe
save		"$data_clean\wrsi_niebe_30dpts.dta", replace 


import 		excel using "$data_raw\Climate data\WRSI\WRSI_senegal30depts\geo2_sn1988_arachide.xlsx", firstrow clear
reshape 	long WRSI , i(Admin_Name) j(year)
gen 		double years = floor(year/100)
drop 		year 
rename 		years year
rename 		Admin_Name departement
replace 	departement = "Mbacke" if departement == "M'backe"
replace 	departement = "Mbour" if departement == "M'bour"
rename 		WRSI wrsi_groundnut
order 		departement year wrsi_groundnut
sort 		departement year wrsi_groundnut
save		"$data_clean\wrsi_groundnut_30dpts.dta", replace 

* Merge data 

use			"$data_clean\wrsi_millet_30dpts.dta", clear 
merge 		departement year using  "$data_clean\wrsi_maize_30dpts.dta"
tab 		_merge
drop 		_merge
sort 		departement year 
merge 		departement year using  "$data_clean\wrsi_niebe_30dpts.dta"
tab 		_merge
drop 		_merge
sort 		departement year 
merge 		departement year using  "$data_clean\wrsi_groundnut_30dpts.dta"
tab 		_merge
drop 		_merge
sort 		departement  
merge 		departement using "$data_clean\admin_senegal.dta"
tab 		_merge
drop 		if _merge ==2 
drop 		_merge
drop 		arrondissement
duplicates 	drop 


order 		departement year 
sort 		departement year 
save 		"$data_clean\wrsi_allcrops_30dpts.dta", replace


**********************************
** Rainfall data 
**********************************
import 		delimited "$data_raw\Climate data\Pluie_temperature_NDVI\Senegal_30depts\dekadal_rainfall.csv", encoding(UTF-8) clear
sort 		pcode 
merge 		pcode using "$data_clean\pcode_1988.dta"
tab 		_merge 
drop 		_merge
drop 		FID CNTRY_NAME CNTRY_CODE IPUM1988 DEPA1988 PARENT
split 		dekad, parse(-) generate(newv)
renvars 	newv1 newv2 / year dekads  
destring	(year), replace
destring	(dekads), replace
drop 		dekad 
rename 		dekads dekad
gen 		month = .
replace		month = 1 if (dekad == 1 | dekad == 2 | dekad == 3)
replace		month = 2 if (dekad == 4 | dekad == 5 | dekad == 6)
replace		month = 3 if (dekad == 7 | dekad == 8 | dekad == 9)
replace		month = 4 if (dekad == 10 | dekad == 11 | dekad == 12)
replace		month = 5 if (dekad == 13 | dekad == 14 | dekad == 15)
replace		month = 6 if (dekad == 16 | dekad == 17 | dekad == 18)
replace		month = 7 if (dekad == 19 | dekad == 20 | dekad == 21)
replace		month = 8 if (dekad == 22 | dekad == 23 | dekad == 24)
replace		month = 9 if (dekad == 25 | dekad == 26 | dekad == 27)
replace		month = 10 if (dekad == 28 | dekad == 29 | dekad == 30)
replace		month = 11 if (dekad == 31 | dekad == 32 | dekad == 33)
replace		month = 12 if (dekad == 34 | dekad == 35 | dekad == 36)

order 		departement dekad month year rainfall_mm pcode
sort 		departement year month dekad  rainfall_mm pcode
rename		rainfall_m rain
bysort		departement year month: egen rain_month=sum(rain)
drop		dekad rain uid
duplicates 	drop 
gen 		rainy_season=1 if month>=6 & month<=9 // June to Sept
replace 	rainy_season=0 if rainy_season==.
bysort		departement year month: egen rain_seasonx=sum(rain_month) if rainy_season==1
bysort		departement year: egen rain_season=sum(rain_seasonx)
bysort		departement year: egen rain_junex=sum(rain_month) if month==6
bysort		departement year: egen rain_june=sum(rain_junex)
bysort		departement year: egen rain_julyx=sum(rain_month) if month==7
bysort		departement year: egen rain_july=sum(rain_julyx)
bysort		departement year: egen rain_augx=sum(rain_month) if month==8
bysort		departement year: egen rain_aug=sum(rain_augx)
bysort		departement year: egen rain_sepx=sum(rain_month) if month==9
bysort		departement year: egen rain_sep=sum(rain_sepx)
drop 		*x rainy_season
sort		departement year month
save 		"$data_clean\Rain_long_30depts.dta", replace

*collapse 	rain_month rain_june rain_july rain_aug rain_sep rain_season , by(departement year month)

reshape 	wide rain_month, i(departement year rain_season rain_june rain_july rain_aug rain_sep) j(month)
*egen 		rain_season=rowtotal(rain_month6 rain_month7 rain_month8 rain_month9)
order 		departement year rain*
sort 		departement year rain*
save 		"$data_clean\Rain_wide_30depts.dta", replace

********************************************************************************
** Temperature data 
********************************************************************************
import 		delimited "$data_raw\Climate data\Pluie_temperature_NDVI\Senegal_30depts\daily_temp.csv", encoding(UTF-8) clear
sort 		pcode 
merge 		pcode using "$data_clean\pcode_1988.dta"
drop 		_merge
keep 	 	departement date temp_mean temp_min temp_max temp_stddev pcode
split 		date, parse(-) generate(newv)
renvars 	newv1 newv2 newv3 / year month day 
destring	(year), replace
destring	(month), replace
destring	(day), replace

order 		departement date day month year temp_mean temp_min temp_max temp_stddev pcode
sort 		departement date day month year temp_mean temp_min temp_max temp_stddev pcode

** Generate GDD, HDD and average temperature: Sine Wave Method
********************************************************************************
rename 		temp_mean avtemprt
rename 		temp_max maxtemprt
rename 		temp_min mintemprt

gen 		Tu=35
gen 		Tl=25
gen 		thetau=asin((2*Tu-(maxtemprt+mintemprt))/(maxtemprt-mintemprt))
gen 		thetal=asin((2*Tl-(maxtemprt+mintemprt))/(maxtemprt-mintemprt))

* Generate case dummies
gen     	case=1   if Tu<mintemprt
replace 	case=2   if maxtemprt<=Tl
replace 	case=3   if Tl<mintemprt  & maxtemprt<=Tu
replace 	case=4   if Tl<mintemprt  & mintemprt<=Tu & Tu<maxtemprt
replace 	case=5   if mintemprt<=Tl & Tl<maxtemprt  & maxtemprt<=Tu
replace 	case=6   if mintemprt<=Tl & Tu<maxtemprt


**Generate gdd, hdd, avt
gen     	gdd=Tu-Tl                                                                                                             if case==1
replace 	gdd=0                                                                                                                 if case==2
replace 	gdd=avtemprt-Tl                                                                                                       if case==3
replace 	gdd=((avtemprt-Tl)*(0.5*_pi+thetau)+(Tu-Tl)*(0.5*_pi-thetau)-0.5*(maxtemprt-mintemprt)*cos(thetau))/_pi               if case==4
replace 	gdd=((avtemprt-Tl)*(0.5*_pi-thetal)+0.5*(maxtemprt-mintemprt)*cos(thetal))/_pi                                        if case==5
replace 	gdd=((avtemprt-Tl)*(thetau-thetal)+(Tu-Tl)*(0.5*_pi-thetau)+0.5*(maxtemprt-mintemprt)*(cos(thetal)-cos(thetau)))/_pi  if case==6

gen     	hdd=avtemprt-Tu                                                                                                       if case==1
replace 	hdd=0                                                                                                                 if case==2
replace 	hdd=0                                                                                                                 if case==3
replace 	hdd=((avtemprt-Tu)*(0.5*_pi-thetau)+0.5*(maxtemprt-mintemprt)*cos(thetau))/_pi                                        if case==4
replace 	hdd=0                                                                                                                 if case==5
replace 	hdd=((avtemprt-Tu)*(0.5*_pi-thetau)+0.5*(maxtemprt-mintemprt)*cos(thetau))/_pi                                        if case==6

drop 		Tu-case avtemprt

*gen 		rainy_season=1 if month>=6 & month<=9 // June to Sept
*replace 	rainy_season=0 if rainy_season==.
*keep 		if rainy_season==1

*bysort 		departement year month: egen gdd_month=sum(gdd)
*bysort 		departement year month: egen ehdd_month=sum(hdd)

collapse 	(sum) gdd (sum) hdd, by(departement year month)
rename 		hdd ehdd
gen 		rainy_season=1 if month>=6 & month<=9 // June to Sept
replace 	rainy_season=0 if rainy_season==.
bysort		departement year month: egen ehdd_seasonx=sum(ehdd) if rainy_season==1
bysort		departement year: egen ehdd_season=sum(ehdd_seasonx)
bysort		departement year: egen ehdd_junex=sum(ehdd) if month==6
bysort		departement year: egen ehdd_june=sum(ehdd_junex)
bysort		departement year: egen ehdd_julyx=sum(ehdd) if month==7
bysort		departement year: egen ehdd_july=sum(ehdd_julyx)
bysort		departement year: egen ehdd_augx=sum(ehdd) if month==8
bysort		departement year: egen ehdd_aug=sum(ehdd_augx)
bysort		departement year: egen ehdd_sepx=sum(ehdd) if month==9
bysort		departement year: egen ehdd_sep=sum(ehdd_sepx)
drop 		*x rainy_season
duplicates	drop
lab 		var gdd "Growing degree days, cummulative, monthly"
lab 		var ehdd "Extreme heat degree days, cummulative, monthly"
lab 		var ehdd_season "Extreme heat degree days, cummulative, rainy season"
lab 		var ehdd_june "Extreme heat degree days, cummulative, June"
lab 		var ehdd_july "Extreme heat degree days, cummulative, July"
lab 		var ehdd_aug "Extreme heat degree days, cummulative, August"
lab 		var ehdd_sep "Extreme heat degree days, cummulative, September"



duplicates	drop
sort 		departement year month
save		"$data_clean\Temp_ehdd_long_30depts.dta", replace
reshape 	wide gdd ehdd, i(departement year ehdd_season) j(month)
*egen 		ehdd_season2=rowtotal(ehdd6 ehdd7 ehdd8 ehdd9)

sort 		 departement year
save 		"$data_clean\Temp_ehdd_wide_30depts.dta", replace


********************************************************************************
** NDVI 
********************************************************************************
********************************************************************************
import 		delimited "$data_raw\Climate data\Pluie_temperature_NDVI\Senegal_30depts\monthly_ndvi.csv", encoding(UTF-8) clear
sort 		pcode 
merge 		pcode using "$data_clean\pcode_1988.dta"
drop 		_merge
keep 		departement date ndvi_mean ndvi_min ndvi_max ndvi_stddev pcode uid
split 		date, parse(-) generate(newv)
renvars 	newv1 newv2  / year month 
destring	(year), replace
destring	(month), replace
duplicates	drop

foreach 	var of varlist ndvi* {
replace 	`var' = . if `var' == -100
}
gen 		rainy_season=1 if month>=6 & month<=9 // June to Sept
replace 	rainy_season=0 if rainy_season==.
bysort		departement year month: egen ndvi_seasonx=mean(ndvi_mean) if rainy_season==1
bysort		departement year: egen ndvi_season=mean(ndvi_seasonx)
bysort		departement year: egen ndvi_junex=mean(ndvi_mean) if month==6
bysort		departement year: egen ndvi_june=mean(ndvi_junex)
bysort		departement year: egen ndvi_julyx=mean(ndvi_mean) if month==7
bysort		departement year: egen ndvi_july=mean(ndvi_julyx)
bysort		departement year: egen ndvi_augx=mean(ndvi_mean) if month==8
bysort		departement year: egen ndvi_aug=mean(ndvi_augx)
bysort		departement year: egen ndvi_sepx=mean(ndvi_mean) if month==9
bysort		departement year: egen ndvi_sep=mean(ndvi_sepx)
drop 		*x rainy_season
rename 		ndvi_mean ndvi_month
lab 		var ndvi_month "NDVI, monthly average"
lab 		var ndvi_season "NDVI, rainy season average"
lab 		var ndvi_june "NDVI, June"
lab 		var ndvi_july "NDVI, July"
lab 		var ndvi_aug "NDVI, August"
lab 		var ndvi_sep "NDVI, September"
order 		departement month year ndvi_season   
sort 		departement year month ndvi_season
save 		"$data_clean\ndvi_long_30depts.dta", replace

rename		ndvi_month ndvi
keep 		departement month year ndvi
reshape 	wide ndvi, i(departement year) j(month)
egen 		ndvi_season = rowmean(ndvi6 ndvi7 ndvi8 ndvi9)
rename 		ndvi6 ndvi_june
rename 		ndvi7 ndvi_july
rename 		ndvi8 ndvi_aug
rename 		ndvi9 ndvi_sep
lab 		var ndvi_season "NDVI, rainy season average"
lab 		var ndvi_june "NDVI, June"
lab 		var ndvi_july "NDVI, July"
lab 		var ndvi_aug "NDVI, August"
lab 		var ndvi_sep "NDVI, September"

sort 	 	departement year 
save 		"$data_clean\ndvi_wide_30depts.dta", replace
********************************************************************************

********************************************************************************
** SPEI
********************************************************************************
import 		delimited "$data_raw\Climate data\SPEI\SPEI_Senegal_30depts.csv", encoding(UTF-8) clear
rename 		admin_name departement
replace 	departement = "Mbacke" if departement == "M'backe"
replace 	departement = "Mbour" if departement == "M'bour"
rename 		ipum1988 pcode
sort 		departement 
merge 		departement using "$data_clean\admin_senegal.dta"
tab 		_merge 
order 		_merge 
sort 		_merge
drop 		if _merge ==2
keep 	 	departement spei*
duplicates drop
reshape 	long spei_ , i(departement) j(years, string)
split 		years, parse(_) generate(year) 
renvars 	year1 year2 spei_ / year month spei 
destring	(year), replace
destring	(month), replace
gen 		drymonths =(spei<-0.5)
lab 		var drymonths "SPEI < -0.5"
gen 		vdrymonths =(spei<-1)
lab 		var vdrymonths "SPEI < -1"
drop  		years
order 		departement month year spei
sort 		departement year month
save 		"$data_clean\spei_month_30depts.dta", replace

use "$data_clean\spei_month_30depts.dta", clear
gen 		rainy_season=1 if month>=6 & month<=9 // June to Sept
replace 	rainy_season=0 if rainy_season==.
bysort		departement year month: egen spei_seasonx=sum(spei) if rainy_season==1
bysort		departement year: egen spei_season=mean(spei_seasonx)
bysort		departement year: egen spei_junex=sum(spei) if month==6
bysort		departement year: egen spei_june=mean(spei_junex)
bysort		departement year: egen spei_julyx=sum(spei) if month==7
bysort		departement year: egen spei_july=mean(spei_julyx)
bysort		departement year: egen spei_augx=sum(spei) if month==8
bysort		departement year: egen spei_aug=mean(spei_augx)
bysort		departement year: egen spei_sepx=sum(spei) if month==9
bysort		departement year: egen spei_sep=mean(spei_sepx)

bysort		departement year month: egen drymonths_seasonx=sum(drymonths) if rainy_season==1
bysort		departement year: egen drymonths_season=sum(drymonths_seasonx)
bysort		departement year month: egen vdrymonths_seasonx=sum(vdrymonths) if rainy_season==1
bysort		departement year: egen vdrymonths_season=sum(vdrymonths_seasonx)
drop 		*x rainy_season
lab			var spei "SPEI, monthly"
lab 		var spei_season "SPEI, seasonal average"
lab 		var spei_june "SPEI, June"
lab 		var spei_july "SPEI, July"
lab 		var spei_aug "SPEI, August"
lab 		var spei_sep "SPEI, September"

lab 		var drymonths_season "Number of months with SPEI<-0.5 during the rainy season"
lab 		var vdrymonths_season "Number of months with SPEI<-1 during the rainy season"
lab 		var drymonths "Month has SPEI<-0.5"
lab 		var vdrymonths "Month has SPEI<-1"
collapse	(mean) spei* drymonths_season vdrymonths_season (sum) drymonths vdrymonths, by(departement year)
lab 		var drymonths_season "Number of months with SPEI<-0.5 during the rainy season"
lab 		var vdrymonths_season "Number of months with SPEI<-1 during the rainy season"
lab 		var drymonths "Number of months with SPEI<-0.5 during the year"
lab 		var vdrymonths "Number of months with SPEI<-1 during the year"
sort		departement year 
save 		"$data_clean\spei_year_30depts.dta", replace

********************************************************************************
** SWI
********************************************************************************

use "$data_raw/Climate data/SWI/SWI_30_depts/SWI_Senegal_Monthly_Long", clear
gen 		rainy_season=1 if month>=6 & month<=9 // June to Sept
replace 	rainy_season=0 if rainy_season==.
bysort		ADMIN_NAME year month: egen swi_seasonx=sum(swi) if rainy_season==1 // seasonal SWI
bysort		ADMIN_NAME year: egen swi_season=mean(swi_seasonx)
bysort		ADMIN_NAME year: egen swi_junex=sum(swi) if month==6
bysort		ADMIN_NAME year: egen swi_june=mean(swi_junex)
bysort		ADMIN_NAME year: egen swi_julyx=sum(swi) if month==7
bysort		ADMIN_NAME year: egen swi_july=mean(swi_julyx)
bysort		ADMIN_NAME year: egen swi_augx=sum(swi) if month==8
bysort		ADMIN_NAME year: egen swi_aug=mean(swi_augx)
bysort		ADMIN_NAME year: egen swi_sepx=sum(swi) if month==9
bysort		ADMIN_NAME year: egen swi_sep=mean(swi_sepx)

lab			var swi "SWI, monthly"
lab 		var swi_season "SWI, seasonal average"
lab 		var swi_june "SWI, June"
lab 		var swi_july "SWI, July"
lab 		var swi_aug "SWI, August"
lab 		var swi_sep "SWI, September"
drop 		*x rainy_season

collapse swi*, by(year ADMIN_NAME IPUM1988)
rename ADMIN_NAME departement 
replace departement = "Mbour" if departement == "M'bour"
replace departement = "Mbacke" if departement == "M'backe"
rename 		IPUM1988 pcode
sort 		departement 
merge 		departement using "$data_clean\admin_senegal.dta"
tab 		_merge 
order 		_merge 
sort 		_merge
drop 		if _merge ==2
drop 		_merge arrondissement pcode
duplicates 	drop
lab 		var swi "Mean annual SWI"
lab 		var swi_season "Mean SWI during rainy season"
order 		departement year swi*
sort 		departement year swi*
save 		"$data_clean/swi_30depts.dta", replace 

