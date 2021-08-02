********************************************************************************	
** Description:This file codes the regressions for the impact of shocks on  production in Senegal 
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
use 		"$data_clean\production_climate_30dpts.dta", replace

cd 			"$outputs/Tables/Test/Allag"

********************************************************************************	
*** REGRESSIONS - MILLET 
********************************************************************************
local 		shocks lnwrsi_millet lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnndvi_season lnndvi_june lnndvi_july lnndvi_aug lnndvi_sep spei_season spei_june spei_july spei_aug spei_sep lndrymonths_season lnvdrymonths_season lnswi_season lnswi_june lnswi_july lnswi_aug lnswi_sep
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnharvest_millet `shock', fe robust
outreg2 	using prodmillet_`date'.xls, append
eststo 		raw: xtreg lnharvest_millet `shock' i.year, fe robust
outreg2 	using prodmillet_`date'.xls, append
}


********************************************************************************	
*** REGRESSIONS - GROUNDNUT 
********************************************************************************
local 		shocks lnwrsi_groundnut lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnndvi_season lnndvi_june lnndvi_july lnndvi_aug lnndvi_sep spei_season spei_june spei_july spei_aug spei_sep lndrymonths_season lnvdrymonths_season lnswi_season lnswi_june lnswi_july lnswi_aug lnswi_sep
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnharvest_groundnut `shock', fe robust
outreg2 	using prodgroundnut_`date'.xls, append
eststo 		raw: xtreg lnharvest_groundnut `shock' i.year, fe robust
outreg2 	using prodgroundnut_`date'.xls, append
}

