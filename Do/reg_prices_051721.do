********************************************************************************	
** Description:This file codes the regressions for the impact of climate shocks on price in Senegal 
** Author: Dieynab Diatta
** Date: May 16th 2021
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

use 		"$data_clean/price_climate_foranalysis.dta", clear

********************************************************************************	
*** REGRESSIONS - SHOCK: WRSI
********************************************************************************
cd 			"$outputs/Tables"

local 		crops millet maize niebe groundnut
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnrprice_`crop' lnwrsi_ag_`crop', fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, replace
eststo 		raw: xtreg lnrprice_`crop' lnwrsi_ag_`crop' i.year, fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnwrsi_ag_`crop' i.month, fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnwrsi_ag_`crop' i.year i.month, fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnwrsi_ag_`crop' c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnwrsi_ag_`crop' i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, append
}

****************************************************************************************************************************

********************************************************************************	
*** REGRESSIONS - SHOCK: RAINFALL
********************************************************************************
* Cumul season

local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnrprice_`crop' lnrain_season, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, replace
eststo 		raw: xtreg lnrprice_`crop' lnrain_season i.year, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_season i.month, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_season i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_season c.lnrain_season##i.month, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_season i.year c.lnrain_season##i.month, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, append
}

* Rain June 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnrprice_`crop' lnrain_june, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, replace
eststo 		raw: xtreg lnrprice_`crop' lnrain_june i.year, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_june i.month, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_june i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_june c.lnrain_june##i.month, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_june i.year c.lnrain_june##i.month, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, append
}


* Rain July 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnrprice_`crop' lnrain_july, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, replace
eststo 		raw: xtreg lnrprice_`crop' lnrain_july i.year, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_july i.month, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_july i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_july c.lnrain_july##i.month, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_july i.year c.lnrain_july##i.month, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, append
}

* Rain August
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnrprice_`crop' lnrain_aug, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, replace
eststo 		raw: xtreg lnrprice_`crop' lnrain_aug i.year, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_aug i.month, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_aug i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_aug c.lnrain_aug##i.month, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_aug i.year c.lnrain_aug##i.month, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, append
}

* Rain September
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnrprice_`crop' lnrain_sep, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, replace
eststo 		raw: xtreg lnrprice_`crop' lnrain_sep i.year, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_sep i.month, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_sep i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_sep c.lnrain_sep##i.month, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_sep i.year c.lnrain_sep##i.month, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, append
}

* Monthly rainfall 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnrprice_`crop' lnrain_month, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, replace
eststo 		raw: xtreg lnrprice_`crop' lnrain_month i.year, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_month i.month, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_month i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_month c.lnrain_month##i.month, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnrain_month i.year c.lnrain_month##i.month, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, append
}



********************************************************************************	
*** REGRESSIONS - SHOCK: TEMPERATURE
********************************************************************************

* Extreme heat degree days / mostly 0
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnrprice_`crop' lnehdd, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, replace
eststo 		raw: xtreg lnrprice_`crop' lnehdd i.year, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnehdd i.month, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnehdd i.year i.month, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnehdd c.lnehdd##i.month, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnehdd i.year c.lnehdd##i.month, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, append
}


* Growing degree days 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnrprice_`crop' lngdd, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, replace
eststo 		raw: xtreg lnrprice_`crop' lngdd i.year, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lngdd i.month, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lngdd i.year i.month, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lngdd c.lngdd##i.month, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lngdd i.year c.lngdd##i.month, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, append
}


********************************************************************************	
*** REGRESSIONS - SHOCK: NDVI
********************************************************************************

* Seasonal NDVI
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnrprice_`crop' lnndvi_season, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, replace
eststo 		raw: xtreg lnrprice_`crop' lnndvi_season i.year, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnndvi_season i.month, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnndvi_season i.year i.month, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnndvi_season c.lnndvi_season##i.month, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnndvi_season i.year c.lnndvi_season##i.month, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, append
}

* Monthly NDVI
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnrprice_`crop' lnndvi_month, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, replace
eststo 		raw: xtreg lnrprice_`crop' lnndvi_month i.year, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnndvi_month i.month, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnndvi_month i.year i.month, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnndvi_month c.lnndvi_month##i.month, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, append
eststo 		raw: xtreg lnrprice_`crop' lnndvi_month i.year c.lnndvi_month##i.month, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, append
}

