********************************************************************************	
** Description:This file codes the regressions for the impact of climate shocks on price in Senegal 
** Author: Dieynab Diatta
** Date: May 17th 2021
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
cd 			"$dir"

global 		data_raw 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Raw"	// raw data in shared DB folder
global 		data_clean 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Clean"	// cleaned data in personal DB
global 		outputs 	"$dir\SAHEL-SHOCKS\1. Analysis\Outputs" 	// path to all tables, graphs, etc
********************************************************************************	

use 		"$data_clean/price_climate_foranalysis.dta", clear

cd 			"$outputs/Tables/Regressions - Prices"

********************************************************************************	
*** REGRESSIONS - Millet 
********************************************************************************
// full sample

local 		shocks lnwrsi_ag_millet lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep ehdd ehdd_season lnehdd lnehdd_season lngdd lnndvi_season spei lnspei drymonths lndrymonths vdrymonths lnvdrymonths spei_season lnspei_season drymonths_season lndrymonths_season vdrymonths_season lnvdrymonths_season swi lnswi swi_season lnswi_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_millet `shock', fe robust
outreg2 	using pricemillet_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_millet `shock' i.year, fe robust
outreg2 	using pricemillet_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.month, fe robust
outreg2 	using pricemillet_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.year i.month, fe robust
outreg2 	using pricemillet_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' c.`shock'##i.month, fe robust
outreg2 	using pricemillet_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using pricemillet_`shock'_`date'.xls, append
}

preserve
drop 		if prprice_millet >0.5  // dropping markets missing more than 50% of data 

local 		shocks lnwrsi_ag_millet lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep ehdd ehdd_season lnehdd lnehdd_season lngdd lnndvi_season spei lnspei drymonths lndrymonths vdrymonths lnvdrymonths spei_season lnspei_season drymonths_season lndrymonths_season vdrymonths_season lnvdrymonths_season swi lnswi swi_season lnswi_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_millet `shock', fe robust
outreg2 	using pricemillet50_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_millet `shock' i.year, fe robust
outreg2 	using pricemillet50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.month, fe robust
outreg2 	using pricemillet50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.year i.month, fe robust
outreg2 	using pricemillet50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' c.`shock'##i.month, fe robust
outreg2 	using pricemillet50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using pricemillet50_`shock'_`date'.xls, append
}
restore
preserve
drop 		if prprice_millet >0.2  // dropping markets missing more than 20% of data 

local 		shocks lnwrsi_ag_millet lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep ehdd ehdd_season lnehdd lnehdd_season lngdd lnndvi_season spei lnspei drymonths lndrymonths vdrymonths lnvdrymonths spei_season lnspei_season drymonths_season lndrymonths_season vdrymonths_season lnvdrymonths_season swi lnswi swi_season lnswi_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_millet `shock', fe robust
outreg2 	using pricemillet20_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_millet `shock' i.year, fe robust
outreg2 	using pricemillet20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.month, fe robust
outreg2 	using pricemillet20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.year i.month, fe robust
outreg2 	using pricemillet20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' c.`shock'##i.month, fe robust
outreg2 	using pricemillet20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using pricemillet20_`shock'_`date'.xls, append
}
restore



/********************************************************************************	
*** REGRESSIONS - MAIZE 
********************************************************************************
// full sample
local 		shocks lnwrsi_ag_maize lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnehdd lngdd lnndvi_season spei drymonths vdrymonths spei_season drymonths_season vdrymonths_season lnspei lnspei_season lndrymonths lndrymonths_season lnvdrymonths lnvdrymonths_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_maize `shock', fe robust
outreg2 	using pricemaize_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_maize `shock' i.year, fe robust
outreg2 	using pricemaize_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' i.month, fe robust
outreg2 	using pricemaize_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' i.year i.month, fe robust
outreg2 	using pricemaize_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' c.`shock'##i.month, fe robust
outreg2 	using pricemaize_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using pricemaize_`shock'_`date'.xls, append
}

preserve
drop 		if prprice_maize >0.5  // dropping markets missing more than 50% of data 

local 		shocks lnwrsi_ag_maize lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnehdd lngdd lnndvi_season spei drymonths vdrymonths spei_season drymonths_season vdrymonths_season lnspei lnspei_season lndrymonths lndrymonths_season lnvdrymonths lnvdrymonths_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_maize `shock', fe robust
outreg2 	using pricemaize50_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_maize `shock' i.year, fe robust
outreg2 	using pricemaize50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' i.month, fe robust
outreg2 	using pricemaize50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' i.year i.month, fe robust
outreg2 	using pricemaize50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' c.`shock'##i.month, fe robust
outreg2 	using pricemaize50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using pricemaize50_`shock'_`date'.xls, append
}
restore
preserve
drop 		if prprice_maize >0.2  // dropping markets missing more than 20% of data 

local 		shocks lnwrsi_ag_maize lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnehdd lngdd lnndvi_season spei drymonths vdrymonths spei_season drymonths_season vdrymonths_season lnspei lnspei_season lndrymonths lndrymonths_season lnvdrymonths lnvdrymonths_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_maize `shock', fe robust
outreg2 	using pricemaize20_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_maize `shock' i.year, fe robust
outreg2 	using pricemaize20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' i.month, fe robust
outreg2 	using pricemaize20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' i.year i.month, fe robust
outreg2 	using pricemaize20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' c.`shock'##i.month, fe robust
outreg2 	using pricemaize20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_maize `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using pricemaize20_`shock'_`date'.xls, append
}
restore
*/
/********************************************************************************	
*** REGRESSIONS - NIEBE 
********************************************************************************
//ful sample 

local 		shocks lnwrsi_ag_niebe lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnehdd lngdd lnndvi_season spei drymonths vdrymonths spei_season drymonths_season vdrymonths_season lnspei lnspei_season lndrymonths lndrymonths_season lnvdrymonths lnvdrymonths_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_niebe `shock', fe robust
outreg2 	using priceniebe_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_niebe `shock' i.year, fe robust
outreg2 	using priceniebe_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' i.month, fe robust
outreg2 	using priceniebe_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' i.year i.month, fe robust
outreg2 	using priceniebe_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' c.`shock'##i.month, fe robust
outreg2 	using priceniebe_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using priceniebe_`shock'_`date'.xls, append
}
preserve
drop 		if prprice_niebe >0.5  // dropping markets missing more than 50% of data 

local 		shocks lnwrsi_ag_niebe lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnehdd lngdd lnndvi_season spei drymonths vdrymonths spei_season drymonths_season vdrymonths_season lnspei lnspei_season lndrymonths lndrymonths_season lnvdrymonths lnvdrymonths_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_niebe `shock', fe robust
outreg2 	using priceniebe50_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_niebe `shock' i.year, fe robust
outreg2 	using priceniebe50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' i.month, fe robust
outreg2 	using priceniebe50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' i.year i.month, fe robust
outreg2 	using priceniebe50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' c.`shock'##i.month, fe robust
outreg2 	using priceniebe50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using priceniebe50_`shock'_`date'.xls, append
}
restore
preserve
drop 		if prprice_niebe >0.2  // dropping markets missing more than 20% of data 

local 		shocks lnwrsi_ag_niebe lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnehdd lngdd lnndvi_season spei drymonths vdrymonths spei_season drymonths_season vdrymonths_season lnspei lnspei_season lndrymonths lndrymonths_season lnvdrymonths lnvdrymonths_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_niebe `shock', fe robust
outreg2 	using priceniebe20_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_niebe `shock' i.year, fe robust
outreg2 	using priceniebe20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' i.month, fe robust
outreg2 	using priceniebe20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' i.year i.month, fe robust
outreg2 	using priceniebe20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' c.`shock'##i.month, fe robust
outreg2 	using priceniebe20_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_niebe `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using priceniebe20_`shock'_`date'.xls, append
}
restore
*/
********************************************************************************	
*** REGRESSIONS - GROUNDNUT 
********************************************************************************
//full sample 

local 		shocks lnwrsi_ag_groundnut lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep ehdd ehdd_season lnehdd lnehdd_season lngdd lnndvi_season spei lnspei drymonths lndrymonths vdrymonths lnvdrymonths spei_season lnspei_season drymonths_season lndrymonths_season vdrymonths_season lnvdrymonths_season swi lnswi swi_season lnswi_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_groundnut `shock', fe robust
outreg2 	using pricegroundnut_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_groundnut `shock' i.year, fe robust
outreg2 	using pricegroundnut_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.month, fe robust
outreg2 	using pricegroundnut_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.year i.month, fe robust
outreg2 	using pricegroundnut_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' c.`shock'##i.month, fe robust
outreg2 	using pricegroundnut_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using pricegroundnut_`shock'_`date'.xls, append
}

preserve
drop 		if prprice_groundnut >0.96  // dropping markets with only 1 data point

local 		shocks lnwrsi_ag_groundnut lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep ehdd ehdd_season lnehdd lnehdd_season lngdd lnndvi_season spei lnspei drymonths lndrymonths vdrymonths lnvdrymonths spei_season lnspei_season drymonths_season lndrymonths_season vdrymonths_season lnvdrymonths_season swi lnswi swi_season lnswi_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_groundnut `shock', fe robust
outreg2 	using pricegroundnut95_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_groundnut `shock' i.year, fe robust
outreg2 	using pricegroundnut95_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.month, fe robust
outreg2 	using pricegroundnut95_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.year i.month, fe robust
outreg2 	using pricegroundnut95_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' c.`shock'##i.month, fe robust
outreg2 	using pricegroundnut95_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using pricegroundnut95_`shock'_`date'.xls, append
}
restore
preserve
drop 		if prprice_groundnut >0.5  // dropping markets missing more than 50% of data 

local 		shocks lnwrsi_ag_groundnut lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep ehdd ehdd_season lnehdd lnehdd_season lngdd lnndvi_season spei lnspei drymonths lndrymonths vdrymonths lnvdrymonths spei_season lnspei_season drymonths_season lndrymonths_season vdrymonths_season lnvdrymonths_season swi lnswi swi_season lnswi_season
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_groundnut `shock', fe robust
outreg2 	using pricegroundnut50_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnprice_groundnut `shock' i.year, fe robust
outreg2 	using pricegroundnut50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.month, fe robust
outreg2 	using pricegroundnut50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.year i.month, fe robust
outreg2 	using pricegroundnut50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' c.`shock'##i.month, fe robust
outreg2 	using pricegroundnut50_`shock'_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.year c.`shock'##i.month, fe robust
outreg2 	using pricegroundnut50_`shock'_`date'.xls, append
}
restore



