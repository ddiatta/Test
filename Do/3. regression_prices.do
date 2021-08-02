********************************************************************************	
** Description:This file codes the regressions for the impact of climate shocks on price in Senegal 
** Project: Sahel shock response cash transfers - Early trigger analysis
** Author: Dieynab Diatta
** Date: May 17th 2021
********************************************************************************
	
********************************************************************************	
cd 			"$outputs/Tables/Regressions - Prices"
use 		"$data_clean/price_climate_foranalysis.dta", clear
********************************************************************************	


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



