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
********************************************************************************\
cd 			"$outputs/Tables/Test/Allag"

local 		shocks lnwrsi_millet_ag lnrain_season_ag lnrain_june_ag lnrain_july_ag lnrain_aug_ag lnrain_sep_ag lnndvi_season_ag lnndvi_june_ag lnndvi_july_ag lnndvi_aug_ag lnndvi_sep_ag spei_season_ag spei_june_ag spei_july_ag spei_aug_ag spei_sep_ag lndrymonths_season_ag lnvdrymonths_season_ag lnswi_season_ag lnswi_june_ag lnswi_july_ag lnswi_aug_ag lnswi_sep_ag
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_millet `shock', fe robust
outreg2 	using pricemillet_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.year_ag, fe robust
outreg2 	using pricemillet_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.month_ag, fe robust
outreg2 	using pricemillet_`date'.xls, append
eststo 		raw: xtreg lnprice_millet `shock' i.year_ag i.month_ag, fe robust
outreg2 	using pricemillet_`date'.xls, append
}


********************************************************************************	
*** REGRESSIONS - GROUNDNUT 
********************************************************************************
local 		shocks lnwrsi_groundnut_ag lnrain_season_ag lnrain_june_ag lnrain_july_ag lnrain_aug_ag lnrain_sep_ag lnndvi_season_ag lnndvi_june_ag lnndvi_july_ag lnndvi_aug_ag lnndvi_sep_ag spei_season_ag spei_june_ag spei_july_ag spei_aug_ag spei_sep_ag lndrymonths_season_ag lnvdrymonths_season_ag lnswi_season_ag lnswi_june_ag lnswi_july_ag lnswi_aug_ag lnswi_sep_ag
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	shock of local shocks {
eststo 		raw: xtreg lnprice_groundnut `shock', fe robust
outreg2 	using pricegroundnut_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.year_ag, fe robust
outreg2 	using pricegroundnut_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.month_ag, fe robust
outreg2 	using pricegroundnut_`date'.xls, append
eststo 		raw: xtreg lnprice_groundnut `shock' i.year_ag i.month_ag, fe robust
outreg2 	using pricegroundnut_`date'.xls, append
}
