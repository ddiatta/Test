********************************************************************************	
*** REGRESSIONS - GROUNDNUT 
********************************************************************************
//full sample 

local 		shocks lnwrsi_ag_groundnut 
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

local 		shocks lnwrsi_ag_groundnut 
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

local 		shocks lnwrsi_ag_groundnut 
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



