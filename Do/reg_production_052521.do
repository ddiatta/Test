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

		if c(username)=="ddiatta"{
		global dir "C:\Users\ddiatta\Dropbox (Personal)"  		
}
	
global 		data_raw 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Raw"	// raw data in shared DB folder
global 		data_clean 	"$dir\SAHEL-SHOCKS\1. Analysis\Data\Clean"	// cleaned data in personal DB
global 		outputs 	"$dir\SAHEL-SHOCKS\1. Analysis\Outputs" 	// path to all tables, graphs, etc
cd 			"$outputs/Tables"

********************************************************************************	
/*
use 		"$data_clean\production_wrsi_30dpts.dta", replace

local 		crops millet maize niebe groundnut
foreach 	crop of local crops{ 
eststo		raw: xtreg lnharvest_`crop' lnwrsi_`crop', fe robust 
outreg2 	using reg`crop'_wrsi_30dpts.xls, replace 
eststo		raw: xtreg lnharvest_`crop' lnwrsi_`crop' i.year, fe robust 
outreg2 	using reg`crop'_wrsi_30dpts.xls, append 
eststo		raw: xtreg lnharvest_`crop' lnwrsi_`crop' c.lnwrsi_`crop'##i.year, fe robust 
outreg2 	using reg`crop'_wrsi_30dpts.xls, append 
}

local 		crops millet maize niebe groundnut
foreach 	crop of local crops{ 
eststo		raw: xtreg lnharvest_`crop' lnwrsi_`crop'_rv, fe robust 
outreg2 	using reg`crop'_wrsirv_30dpts.xls, replace 
eststo		raw: xtreg lnharvest_`crop' lnwrsi_`crop'_rv i.year, fe robust 
outreg2 	using reg`crop'_wrsirv_30dpts.xls, append 
eststo		raw: xtreg lnharvest_`crop' lnwrsi_`crop'_rv c.lnwrsi_`crop'_rv##i.year, fe robust 
outreg2 	using reg`crop'_wrsirv_30dpts.xls, append 
}

*/
use 		"$data_clean\production_climate_30dpts.dta", replace
********************************************************************************	
*** REGRESSIONS - MILLET 
********************************************************************************
local 		shocks lnwrsi_millet lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnehdd_season lnndvi_season spei spei_season drymonths lndrymonths drymonths_season lndrymonths_season vdrymonths lnvdrymonths vdrymonths_season lnvdrymonths_season 
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnharvest_millet `shock', fe robust
outreg2 	using prodmillet_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnharvest_millet `shock' i.year, fe robust
outreg2 	using prodmillet_`shock'_`date'.xls, append
}


********************************************************************************	
*** REGRESSIONS - MAIZE 
********************************************************************************
// full sample
local 		shocks lnwrsi_maize lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnehdd_season lnndvi_season spei spei_season drymonths lndrymonths drymonths_season lndrymonths_season vdrymonths lnvdrymonths vdrymonths_season lnvdrymonths_season 
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnharvest_maize `shock', fe robust
outreg2 	using prodmaize_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnharvest_maize `shock' i.year, fe robust
outreg2 	using prodmaize_`shock'_`date'.xls, append
}

********************************************************************************	
*** REGRESSIONS - NIEBE 
********************************************************************************
//ful sample 

local 		shocks lnwrsi_niebe lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnehdd_season lnndvi_season spei spei_season drymonths lndrymonths drymonths_season lndrymonths_season vdrymonths lnvdrymonths vdrymonths_season lnvdrymonths_season 
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnharvest_niebe `shock', fe robust
outreg2 	using prodniebe_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnharvest_niebe `shock' i.year, fe robust
outreg2 	using prodniebe_`shock'_`date'.xls, append
}

********************************************************************************	
*** REGRESSIONS - GROUNDNUT 
********************************************************************************
//full sample 

local 		shocks lnwrsi_groundnut lnrain_season lnrain_june lnrain_july lnrain_aug lnrain_sep lnehdd_season lnndvi_season spei spei_season drymonths lndrymonths drymonths_season lndrymonths_season vdrymonths lnvdrymonths vdrymonths_season lnvdrymonths_season 
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnharvest_groundnut `shock', fe robust
outreg2 	using prodgroundnut_`shock'_`date'.xls, replace
eststo 		raw: xtreg lnharvest_groundnut `shock' i.year, fe robust
outreg2 	using prodgroundnut_`shock'_`date'.xls, append
}

