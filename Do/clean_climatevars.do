********************************************************************************	
** Description:This file creates climate variables for Senegal
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

		if c(username)=="DDiatta"{
		global dir "C:\Users\DDiatta\Dropbox (Personal)"  		
}
	
		if c(username)=="ddiatta"{
		global dir "C:/Users/ddiatta/Dropbox (Personal)"  		
}

global 		data_raw 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Raw"	// raw data in shared DB folder
global 		data_clean 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Clean"	// cleaned data in personal DB
global 		outputs 	"$dir\SAHEL-SHOCKS\1. Analysis\Outputs" 	// path to all tables, graphs, etc
global		temp 		"$dir\DIME\Outputs" 						// path the temporary files 
cd 			"$outputs"

********************************************************************************	


**********************************
** Admin data to be merged
**********************************

import 		delimited "$data_raw\Climate data\Pluie_temperature_NDVI\exports_SEN-MLI-NER-BFA\merged_chirps_20y.csv", encoding(UTF-8) clear
keep 		if adm0_name== "Senegal"
keep 		adm3_pcode adm3_name adm2_pcode adm2_name adm1_pcode adm1_name adm0_pcode adm0_name
rename 		adm2_pcode pcode 
lab 		var pcode "Admin 2 code"
replace 	adm2_name = "Tivaouane" if adm2_name == "Tivaoune"
replace 	adm2_name = "Nioro" if adm2_name == "Nioro Du Rip"
replace		adm2_name = "Medina Yoro Foulah" if adm2_name == "Medina Yoroufoula"
*replace 	adm2_name = "St.Louis" if adm2_name == "Saint Louis"
sort 		pcode
save 		"$data_clean\Senegal_admincode.dta", replace


**********************************
** WRSI
**********************************
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
drop 		crop

local 		crops millet niebe maize groundnut
foreach 	crop of local crops {
lab 		var wrsi_`crop' "WRSI for `crop', annual"
}
sort 		region departement year
save 		"$data_clean\wrsi_allcrops_long.dta", replace


**********************************
** Rainfall data 
**********************************
import 		delimited "$data_raw\Climate data\Pluie_temperature_NDVI\Admin2\sahel_adm2_dekadal_rainfall_1981-2020.csv", encoding(UTF-8) clear
sort 		pcode 
merge 		pcode using "$data_clean\Senegal_admincode.dta"
order 		_merge
sort 		_merge
keep 		if _merge ==3 
drop 		_merge
renvars 	adm1_name  adm2_name pcode dekad/ region departement admin2_pcode dekads
keep 		region departement dekads rainfall_mm admin2_pcode
split 		dekad, parse(-) generate(newv)
renvars 	newv1 newv2 / year dekad  
destring	(year), replace
destring	(dekad), replace
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

order 		region departement dekad month year rainfall_mm admin2_pcode
sort 		region departement year month dekad  rainfall_mm admin2_pcode
rename		rainfall_m rain
bysort		region departement year month: egen rain_month=sum(rain)
drop		dekad rain dekads
duplicates 	drop 
gen 		rainy_season=1 if month>=6 & month<=9 // June to Sept
replace 	rainy_season=0 if rainy_season==.
bysort		region departement year month: egen rain_seasonx=sum(rain_month) if rainy_season==1
bysort		region departement year: egen rain_season=sum(rain_seasonx)
bysort		region departement year: egen rain_junex=sum(rain_month) if month==6
bysort		region departement year: egen rain_june=sum(rain_junex)
bysort		region departement year: egen rain_julyx=sum(rain_month) if month==7
bysort		region departement year: egen rain_july=sum(rain_julyx)
bysort		region departement year: egen rain_augx=sum(rain_month) if month==8
bysort		region departement year: egen rain_aug=sum(rain_augx)
bysort		region departement year: egen rain_sepx=sum(rain_month) if month==9
bysort		region departement year: egen rain_sep=sum(rain_sepx)
drop 		*x rainy_season
local 		months month season june july aug sep
foreach 	month of local months{
    lab 	var rain_`month' "Cummulative rainfall, `month', mm"
}
sort		region departement year month
save 		"$data_clean\Rain_long.dta", replace

*collapse 	rain_month rain_june rain_july rain_aug rain_sep rain_season , by(region departement year month)

reshape 	wide rain_month, i(region departement year rain_season rain_june rain_july rain_aug rain_sep) j(month)
*egen 		rain_season=rowtotal(rain_month6 rain_month7 rain_month8 rain_month9)
order 		region departement year rain*
sort 		region departement year rain*
save 		"$data_clean\Rain_wide.dta", replace

********************************************************************************
** Temperature data 
********************************************************************************
import delimited "$data_raw\Climate data\Pluie_temperature_NDVI\Admin2\sahel_era5_daily_temp.csv", encoding(UTF-8) clear
sort 		pcode 
merge 		pcode using "$data_clean\Senegal_admincode.dta"
order 		_merge
sort 		_merge
keep 		if _merge ==3 
drop 		_merge
renvars 	adm1_name  adm2_name adm3_name pcode / region departement arrondissement admin2_pcode
keep 		region departement date temp_mean temp_min temp_max temp_stddev admin2_pcode
split 		date, parse(-) generate(newv)
renvars 	newv1 newv2 newv3 / year month day 
destring	(year), replace
destring	(month), replace
destring	(day), replace

order 		region departement date day month year temp_mean temp_min temp_max temp_stddev admin2_pcode
sort 		region departement date day month year temp_mean temp_min temp_max temp_stddev admin2_pcode

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

collapse 	(sum) gdd (sum) hdd, by(region departement year month)
rename 		hdd ehdd
gen 		rainy_season=1 if month>=6 & month<=9 // June to Sept
replace 	rainy_season=0 if rainy_season==.
bysort		region departement year month: egen ehdd_seasonx=sum(ehdd) if rainy_season==1
bysort		region departement year: egen ehdd_season=sum(ehdd_seasonx)
bysort		region departement year: egen ehdd_junex=sum(ehdd) if month==6
bysort		region departement year: egen ehdd_june=sum(ehdd_junex)
bysort		region departement year: egen ehdd_julyx=sum(ehdd) if month==7
bysort		region departement year: egen ehdd_july=sum(ehdd_julyx)
bysort		region departement year: egen ehdd_augx=sum(ehdd) if month==8
bysort		region departement year: egen ehdd_aug=sum(ehdd_augx)
bysort		region departement year: egen ehdd_sepx=sum(ehdd) if month==9
bysort		region departement year: egen ehdd_sep=sum(ehdd_sepx)
drop 		*x rainy_season
duplicates	drop
lab 		var gdd "Growing degree days, cummulative, monthly"
lab 		var ehdd "Extreme heat degree days, cummulative, monthly"
lab 		var ehdd_season "Extreme heat degree days, cummulative, rainy season"
lab 		var ehdd_june "Extreme heat degree days, cummulative, June"
lab 		var ehdd_july "Extreme heat degree days, cummulative, July"
lab 		var ehdd_aug "Extreme heat degree days, cummulative, August"
lab 		var ehdd_sep "Extreme heat degree days, cummulative, September"

sort 		region departement year month
save		"$data_clean\Temp_ehdd_long.dta", replace
reshape 	wide gdd ehdd, i(region departement year ehdd_season) j(month)
*egen 		ehdd_season2=rowtotal(ehdd6 ehdd7 ehdd8 ehdd9)
lab 		var ehdd_season "Extreme heat degree days, cummulative, rainy season"

sort 		region departement year
save 		"$data_clean\Temp_ehdd_wide.dta", replace


********************************************************************************
** NDVI 
********************************************************************************
import delimited "$data_raw\Climate data\Pluie_temperature_NDVI\Admin2\sahel_adm2_monthly_ndvi_1981-2020.csv", encoding(UTF-8) clear
sort 		pcode 
merge 		pcode using "$data_clean\Senegal_admincode.dta"
order 		_merge
sort 		_merge
keep 		if _merge ==3 
drop 		_merge
renvars 	adm1_name  adm2_name / region departement 
keep 		region departement date ndvi_mean ndvi_min ndvi_max ndvi_stddev 
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
order 		region departement month year
sort 		region departement year month

bysort		region departement year month: egen ndvi_seasonx=mean(ndvi_mean) if rainy_season==1
bysort		region departement year: egen ndvi_season=mean(ndvi_seasonx)
bysort		region departement year: egen ndvi_junex=mean(ndvi_mean) if month==6
bysort		region departement year: egen ndvi_june=mean(ndvi_junex)
bysort		region departement year: egen ndvi_julyx=mean(ndvi_mean) if month==7
bysort		region departement year: egen ndvi_july=mean(ndvi_julyx)
bysort		region departement year: egen ndvi_augx=mean(ndvi_mean) if month==8
bysort		region departement year: egen ndvi_aug=mean(ndvi_augx)
bysort		region departement year: egen ndvi_sepx=mean(ndvi_mean) if month==9
bysort		region departement year: egen ndvi_sep=mean(ndvi_sepx)
drop 		ndvi_seasonx rainy_season
rename 		ndvi_mean ndvi_month
lab 		var ndvi_month "NDVI, monthly average"
lab 		var ndvi_min "NDVI, monthly min"
lab 		var ndvi_max "NDVI, monthly max"
lab 		var ndvi_stddev "NDVI, standard deviation"
lab 		var ndvi_season "NDVI, rainy season average"
lab 		var ndvi_june "NDVI, June"
lab 		var ndvi_july "NDVI, July"
lab 		var ndvi_aug "NDVI, August"
lab 		var ndvi_sep "NDVI, September"

order 		region departement month year ndvi_season ndvi_month ndvi_min ndvi_max ndvi_stddev
sort 		region departement year month ndvi_season ndvi_month ndvi_min ndvi_max ndvi_stddev 
save 		"$data_clean\ndvi_long.dta", replace

rename		ndvi_month ndvi
keep 		region departement month year ndvi
reshape 	wide ndvi, i(region departement year) j(month)
egen 		ndvi_season = rowmean(ndvi6 ndvi7 ndvi8 ndvi9)
lab 		var ndvi_season "NDVI, rainy season average"

sort 		region departement year 
save 		"$data_clean\ndvi_wide.dta", replace
********************************************************************************



********************************************************************************
** SPEI
********************************************************************************
use 		"$data_raw/Climate data/SPEI/spei_month_45depts_long.dta", replace

rename 		admin2Name departement
replace 	departement = "Nioro" if departement == "Nioro du Rip"
sort 		departement 
merge 		departement using "$data_clean\admin_senegal.dta"
tab 		_merge 
order 		_merge 
sort 		_merge
keep 	 	region departement spei*
duplicates 	drop
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
order 		region departement month year spei
sort 		region departement year month
save 		"$data_clean\spei_month_45depts.dta", replace

gen 		rainy_season=1 if month>=6 & month<=9 // June to Sept
replace 	rainy_season=0 if rainy_season==.

bysort		region departement year month: egen spei_seasonx=sum(spei) if rainy_season==1
bysort		region departement year: egen spei_season=mean(spei_seasonx)
bysort		region departement year: egen spei_junex=sum(spei) if month==6
bysort		region departement year: egen spei_june=mean(spei_junex)
bysort		region departement year: egen spei_julyx=sum(spei) if month==7
bysort		region departement year: egen spei_july=mean(spei_julyx)
bysort		region departement year: egen spei_augx=sum(spei) if month==8
bysort		region departement year: egen spei_aug=mean(spei_augx)
bysort		region departement year: egen spei_sepx=sum(spei) if month==9
bysort		region departement year: egen spei_sep=mean(spei_sepx)

bysort		departement year month: egen drymonths_seasonx=sum(drymonths) if rainy_season==1
bysort		departement year: egen drymonths_season=sum(drymonths_seasonx)
bysort		departement year month: egen vdrymonths_seasonx=sum(vdrymonths) if rainy_season==1
bysort		departement year: egen vdrymonths_season=sum(vdrymonths_seasonx)
drop 		*x rainy_season
lab			var spei "SPEI, monthly"
lab 		var spei_season "SPEI, seasonal average"
lab 		var spei_june "SPEI, June"
lab 		var spei_june "SPEI, July"
lab 		var spei_june "SPEI, August"
lab 		var spei_june "SPEI, September"

lab 		var drymonths_season "Number of months with SPEI<-0.5 during the rainy season"
lab 		var vdrymonths_season "Number of months with SPEI<-1 during the rainy season"
lab 		var drymonths "Month has SPEI<-0.5"
lab 		var vdrymonths "Month has SPEI<-1"
sort		region departement year month
save 		"$data_clean\spei_month_45depts.dta", replace

********************************************************************************
** SWI
********************************************************************************

import 		delimited "$data_raw/Climate data/SWI/SWI_45_depts/swi_month_45depts_long.csv", clear
rename 		admin2name departement
replace 	departement = "Nioro" if departement == "Nioro du Rip"
sort 		departement 
merge 		departement using "$data_clean\admin_senegal.dta"
tab 		_merge 
order 		_merge 
sort 		_merge
keep 	 	region departement year month swi*
order 		region departement month year swi*
duplicates 	drop
gen 		rainy_season=1 if month>=6 & month<=9 // June to Sept
replace 	rainy_season=0 if rainy_season==.
bysort		region departement year month: egen swi_seasonx=sum(swi) if rainy_season==1
bysort		region departement year: egen swi_season=mean(swi_seasonx)
bysort		region departement year: egen swi_junex=sum(swi) if month==6
bysort		region departement year: egen swi_june=mean(swi_junex)
bysort		region departement year: egen swi_julyx=sum(swi) if month==7
bysort		region departement year: egen swi_july=mean(swi_julyx)
bysort		region departement year: egen swi_augx=sum(swi) if month==8
bysort		region departement year: egen swi_aug=mean(swi_augx)
bysort		region departement year: egen swi_sepx=sum(swi) if month==9
bysort		region departement year: egen swi_sep=mean(swi_sepx)

lab			var swi "SWI, monthly"
lab 		var swi_season "SWI, seasonal average"
lab 		var swi_june "SWI, June"
lab 		var swi_july "SWI, July"
lab 		var swi_aug "SWI, August"
lab 		var swi_sep "SWI, September"
 
drop 		*x rainy_season

lab 		var swi "Mean monthly SWI"
lab 		var swi_season "Mean SWI during rainy season"
order 		region departement month year swi*
sort 		region departement year month swi*
save 		"$data_clean/swi_45depts.dta", replace 

