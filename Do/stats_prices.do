********************************************************************************	
** Description:This file codes descriptive statistics for price variables for Senegal
** Author: Dieynab Diatta
** Date: May 7th 2021
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
use 		"$data_clean/price_climate_foranalysis.dta", clear

* Histogram of values
hist		ndvi_season
hist 		ndvi_month
hist		lnndvi_season
hist 		lnndvi_month
hist		ehdd
hist 		gdd
hist 		lnehdd
hist 		lngdd
hist 		rain_season
hist		lnrain_season

******** Summary statistics ***************************************************************************************
cd 			"$outputs/Tables"

** Table 1: Market characteristics 

* Cereals
xtable market, c(N price_millet mean prprice_millet mean price_millet min price_millet max price_millet) filename(Market_statistics) sheet(Millet, replace) replace
xtable market, c(N price_sorghum mean prprice_sorghum mean price_sorghum min price_sorghum max price_sorghum) filename(Market_statistics) sheet(Sorghum, replace) 
xtable market, c(N price_maize mean prprice_maize mean price_maize min price_maize max price_maize) filename(Market_statistics) sheet(Maize local, replace) 
xtable market, c(N price_maize_i mean prprice_maize_i mean price_maize_i min price_maize_i max price_maize_i) filename(Market_statistics) sheet(Maize imported, replace) 
xtable market, c(N price_rice_io mean prprice_rice_io mean price_rice_io min price_rice_io max price_rice_io) filename(Market_statistics) sheet(Rice imp o, replace) 
xtable market, c(N price_rice_ip mean prprice_rice_ip mean price_rice_ip min price_rice_ip max price_rice_ip) filename(Market_statistics) sheet(Rice imp perf, replace) 
xtable market, c(N price_rice mean prprice_rice mean price_rice min price_rice max price_rice) filename(Market_statistics) sheet(Rice local, replace) 

* Vegetables
xtable market, c(N price_onion mean prprice_onion mean price_onion min price_onion max price_onion) filename(Market_statistics) sheet(Onion local, replace) 
xtable market, c(N price_onion_i mean prprice_onion_i mean price_onion_i min price_onion_i max price_onion_i) filename(Market_statistics) sheet(Onion imported, replace) 
xtable market, c(N price_potato mean prprice_potato mean price_potato min price_potato max price_potato)  filename(Market_statistics) sheet(Potatoe local, replace) 
xtable market, c(N price_potato_i mean prprice_potato_i mean price_potato_i min price_potato_i max price_potato_i)  filename(Market_statistics) sheet(Potatoe imported, replace) 
xtable market, c(N price_cassava mean prprice_cassava mean price_cassava min price_cassava max price_cassava)  filename(Market_statistics) sheet(Cassava, replace) 

* Legumes
xtable market, c(N price_niebe mean prprice_niebe mean price_niebe min price_niebe max price_niebe) filename(Market_statistics) sheet(Niebe, replace) 
xtable market, c(N price_groundnut mean prprice_groundnut mean price_groundnut min price_groundnut max price_groundnut) filename(Market_statistics) sheet(Peanut shelled, replace) 
xtable market, c(N price_groundnut_d mean prprice_groundnut_d mean price_groundnut_d min price_groundnut_d max price_groundnut_d) filename(Market_statistics) sheet(Peanut unshelled, replace) 


** Graph 1: Temporal dynamic by crop 

* Millet
generate shock = 400
format date %tm
local peak shock date if inrange(date, 459, 467) | inrange(date, 504, 520) | inrange(date, 540, 551) | inrange(date, 579, 587) | inrange(date, 686, 697) | inrange(date, 727, 731) , bcolor(gs14) base(10)
twoway bar `peak' || (tsline price_millet if marche == "Tilene") (tsline price_millet if marche == "Saint Louis") (tsline price_millet if marche == "Tambacounda") (tsline price_millet if marche == "Kaolack"), xtick(360(12)734, tlength(*0.5)) xlabel(360(24)734, format(%tmCY))  tlabel(, labsize(tiny)) xtitle("") tlabel(, labsize(vsmall)) legend(label(1 "shock") label(2 "Tilene") label(3 "Saint-Louis") label(4 "Tambacounda") label(5 "Kaolack") size(vsmall) rows(1)) title (Millet Prices)
graph save "$outputs/Graphs/millet_seasonality.gph", replace


* Maize
generate shock = 400
format date %tm
local peak shock date if inrange(date, 428, 440) | inrange(date, 579, 587) | inrange(date, 624, 635) | inrange(date, 686, 697) , bcolor(gs14) base(10)
twoway bar `peak' || (tsline price_maize if marche == "Tilene") (tsline price_maize if marche == "Kolda") (tsline price_maize if marche == "Tambacounda") (tsline price_maize if marche == "Kaolack"), xtick(360(12)734, tlength(*0.5)) xlabel(360(24)734, format(%tmCY))  tlabel(, labsize(tiny)) xtitle("") tlabel(, labsize(vsmall)) legend(label(1 "shock") label(2 "Tilene") label(3 "Kolda") label(4 "Tambacounda") label(5 "Kaolack") size(vsmall) rows(1)) title (Maize Prices)
graph save "$outputs/Graphs/maize_seasonality.gph", replace

* Niebe
generate shock2 = 1000
format date %tm
local peak shock2 date if inrange(date, 450, 467) | inrange(date, 512, 528) | inrange(date, 703, 730) , bcolor(gs14) base(10)
twoway bar `peak' || (tsline price_niebe if marche == "Tilene") (tsline price_niebe if marche == "Thies") (tsline price_niebe if marche == "Kolda") (tsline price_niebe if marche == "Louga"), xtick(360(12)734, tlength(*0.5)) xlabel(360(24)734, format(%tmCY))  tlabel(, labsize(tiny)) xtitle("") tlabel(, labsize(vsmall)) legend(label(1 "shock") label(2 "Tilene") label(3 "Thies") label(4 "Kolda") label(5 "Louga") size(vsmall) rows(1)) title (Niebe Prices)
graph save "$outputs/Graphs/niebe_seasonality.gph", replace

* groundnut
generate shock3 = 650
format date %tm
local peak shock3 date if inrange(date, 450, 467) | inrange(date, 512, 540) | inrange(date, 576, 587) | inrange(date, 675, 685) , bcolor(gs14) base(10)
twoway bar `peak' || (tsline price_groundnut if marche == "Saint Louis") (tsline price_groundnut if marche == "Thies") (tsline price_groundnut if marche == "Diourbel") (tsline price_groundnut if marche == "Kaolack"), xtick(360(12)734, tlength(*0.5)) xlabel(360(24)734, format(%tmCY))  tlabel(, labsize(tiny)) xtitle("") tlabel(, labsize(vsmall)) legend(label(1 "shock") label(2 "Saint Louis") label(3 "Thies") label(4 "Diourbel") label(5 "Kaolack") size(vsmall) rows(1)) title (Groundnut Prices)
graph save "$outputs/Graphs/groundnut_seasonality.gph", replace

 
 
/*tmtick(##11, labsize(tiny) valuelabel)

generate shock = 400
format date %tm
local peak shock date if inrange(date, 459, 467) | inrange(date, 504, 520) | inrange(date, 540, 551) | inrange(date, 686, 697) | inrange(date, 727, 731) , bcolor(gs14) base(10)
twoway bar `peak' || (tsline price_millet if marche == "Tilene") (tsline price_millet if marche == "Saint Louis") (tsline price_millet if marche == "Tambacounda") (tsline price_millet if marche == "Kaolack"), scheme(s1color) tlabel(#32, labsize(tiny)) tmtick(##11, labsize(tiny) valuelabel)

line price_millet date if marche == "Tilene", xtick(360(24)734, tlength(*0.5)) xlabel(360(24)734, format(%tmCY))  tlabel(, labsize(tiny)) xtitle("")

local peak shock date if inrange(date, 459, 467) | inrange(date, 504, 520) | inrange(date, 540, 551) | inrange(date, 686, 697) | inrange(date, 727, 731) , bcolor(gs14) base(10)
twoway bar `peak' || (tsline price_millet if marche == "Tilene") (tsline price_millet if marche == "Saint Louis") (tsline price_millet if marche == "Tambacounda") (tsline price_millet if marche == "Kaolack"), xtick(, tlength(*1.5)) xlabel(1990m1 "1990"  1991m1 "1991" 1992m1 "1992", noticks format(%tqCY)) xtitle("")



*/

, tlength(*1.5)) 


line sales t, 								xtick(119.5(4)159.5, tlength(*1.5)) xlabel(121.5(4)157.5, noticks format(%tqCY)) xtitle("")


line price_millet date if marche == "Tilene", xtick(360(12)734)


1990m1 "1990"  1991m1 "1991" 1992m1 "1992"
tmtick(##5, labsize(tiny) valuelabel)

scheme(s3color) tlabel(#32, labsize(tiny)) xlabel(121.5(4)157.5, format(%tqCY))  
graph save "millet_prices_shock" "$outputs/millet_prices_shock.gph", replace


1990m1 "1990"  1991m1 "1991" 1992m1 "1992" 1993m1 "1993" 1994m1 "1994" 1995m1 "1995" 1996m1 "1996" 1997m1 "1997" 1998m1 "1998" 1999m1 "1999" 2000m1 "2000" 2001m1 "2001" 2002m1 "2002" 2003m1 "2003" 2004m1 "2004" 2005m1 "2005" 2006m1 "2006" 2007m1 "2007" 2008m1 "2008" 2009m1 "2009" 2010m1 "2010" 2011m1 "2011" 2012m1 "2012" 2013m1 "2013" 2014m1 "2014" 2015m1 "2015" 2016m1 "2016" 2017m1 "2017" 2018m1 "2018" 2019m1 "2019" 2020m1 "2020" 2021m1 "2021"





twoway (tsline MIL) if prmiss_MIL < 2.7, ytitle(Millet prices) by(, title(Millet Prices - monthly (1990-2021))) by(MARCHE) 
graph save "millet_prices" "$outputs/millet_prices.gph", replace

twoway (tsline MIL if MARCHE == "TILENE") (tsline MIL if MARCHE == "ST.LOUIS") (tsline MIL if MARCHE == "TAMBACOUNDA") (tsline MIL if MARCHE == "GOUILLE MBEUTH") (tsline MIL if MARCHE == "KOLDA") (tsline MIL if MARCHE == "KAOLACK"), ytitle(Millet prices) title(Millet Prices - monthly (1990-2021)) legend (1 "TILENE" )
graph save "millet_prices" "$outputs/millet_prices.gph", replace


** Graph 2: Maps 

use 		"$data_clean/price_climate_foranalysis.dta", clear
collapse 	price*, by(region departement marche year)
save 		"$data_clean/price_market_yearly.dta", replace
collapse 	price*, by(region departement marche)
save 		"$data_clean/price_market_30ymean.dta", replace

use 		"$data_clean/markets_gps.dta", clear
renvars 	REGION DEPARTEMENT MARCHE / region departement marche
replace 	departement = "Birkelane" if departement == "Mbirkilane"
replace 	marche = "Birkelane" if marche == "Mbirkilane"
replace 	region = "Saint Louis" if region == "St.Louis"
replace 	marche = "Saint Louis" if marche == "St.Louis"
save 		"$data_clean/markets_gps.dta", replace

merge 		1:1 region departement marche  using "$data_clean/price_market_30ymean.dta"
drop 		_merge 
save 		"$data_clean/price_market_30ymean_gps.dta", replace
export 		excel using "C:\Users\ddiatta\Dropbox (Personal)\SAHEL-SHOCKS\1. Analysis\Data\Clean\Market_prices_30ymean.xlsx", firstrow(variables) replace



** Graph 3: Price seasonality - Month
cd 			"$outputs/Graphs"

* Mean 1990-2020 / 2000-2020 / 2010-2020
use 		"$data_clean/price_climate_foranalysis.dta", clear
foreach 	var of varlist rprice* price* { 
** Mean 1990-2020
bys 		region departement marche month: egen `var'9020x = mean(`var') 
bysort		region departement marche month: egen `var'9020 =mean(`var'9020x)
lab 		var `var'9020 "Mean monthly prices, 1990-2020"
** Mean 2000-2020
bys 		region departement marche month: egen `var'0020x = mean(`var') if year >= 2000 & year <=2020
bys 		region departement marche month: egen `var'0020 = mean(`var'0020x)
lab 		var `var'0020 "Mean monthly prices, 2000-2020"
** Mean 2010-2020
bys 		region departement marche month: egen `var'1020x = mean(`var') if year >= 2010 & year <=2020
bys 		region departement marche month: egen `var'1020 = mean(`var'1020x)
lab 		var `var'1020 "Mean monthly prices, 2010-2020"
}

drop 		*x
preserve 
keep 		region departement marche month market markets *9020 *0020 *1020
duplicates	drop
tsset 		markets month
* Graphs - MILLET 

twoway (bar rprice_millet9020 month, sort) if marche == "Tilene", ytitle("Millet prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(205 240)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Tilene) subtitle(Monthly average (1990-2020), linegap(5))
graph save "$outputs/Graphs/Tilene_millet9020.gph", replace

twoway (bar rprice_millet9020 month, sort) if marche == "Kaolack", ytitle("Millet prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Kaolack) subtitle(Monthly average (1990-2020), linegap(5))
graph save "$outputs/Graphs/Kaolack_millet9020.gph", replace

twoway (bar rprice_millet0020 month, sort) if marche == "Tilene", ytitle("Millet prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(210 250)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Tilene) subtitle(Monthly average (2000-2020), linegap(5))
graph save "$outputs/Graphs/Tilene_millet0020.gph", replace

twoway (bar rprice_millet0020 month, sort) if marche == "Kaolack", ytitle("Millet prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(165 200)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Kaolack) subtitle(Monthly average (2000-2020), linegap(5))
graph save "$outputs/Graphs/Kaolack_millet0020.gph", replace

twoway (bar rprice_millet1020 month, sort) if marche == "Tilene", ytitle("Millet prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(230 250)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Tilene) subtitle(Monthly average (2010-2020), linegap(5))
graph save "$outputs/Graphs/Tilene_millet1020.gph", replace

twoway (bar rprice_millet1020 month, sort) if marche == "Kaolack", ytitle("Millet prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(170 210)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Kaolack) subtitle(Monthly average (2010-2020), linegap(5))
graph save "$outputs/Graphs/Kaolack_millet1020.gph", replace

graph combine "$outputs/Graphs/Tilene_millet9020.gph" "$outputs/Graphs/Kaolack_millet9020.gph" "$outputs/Graphs/Tilene_millet0020.gph" "$outputs/Graphs/Kaolack_millet0020.gph" "$outputs/Graphs/Tilene_millet1020.gph" "$outputs/Graphs/Kaolack_millet1020.gph", cols(2) rows(3) iscale(0.4) title(Millet Prices)
graph save "$outputs/Graphs/Millet_avgprices.gph", replace
 

* Graphs - Maize 

twoway (bar rprice_maize9020 month, sort) if marche == "Saint Louis", ytitle("Maize prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(210 240)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Saint Louis) subtitle(Monthly average (1990-2020), linegap(5))
graph save "$outputs/Graphs/SaintLouis_maize9020.gph", replace

twoway (bar rprice_maize9020 month, sort) if marche == "Tambacounda", ytitle("Maize prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(165 210)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Tambacounda) subtitle(Monthly average (1990-2020), linegap(5))
graph save "$outputs/Graphs/Tambacounda_maize9020.gph", replace

twoway (bar rprice_maize0020 month, sort) if marche == "Saint Louis", ytitle("Maize prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(210 240)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Saint Louis) subtitle(Monthly average (2000-2020), linegap(5))
graph save "$outputs/Graphs/SaintLouis_maize0020.gph", replace

twoway (bar rprice_maize0020 month, sort) if marche == "Tambacounda", ytitle("Maize prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(165 200)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Tambacounda) subtitle(Monthly average (2000-2020), linegap(5))
graph save "$outputs/Graphs/Tambacounda_maize0020.gph", replace

twoway (bar rprice_maize1020 month, sort) if marche == "Saint Louis", ytitle("Maize prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(230 250)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Saint Louis) subtitle(Monthly average (2010-2020), linegap(5))
graph save "$outputs/Graphs/SaintLouis_maize1020.gph", replace

twoway (bar rprice_maize1020 month, sort) if marche == "Tambacounda", ytitle("Maize prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(170 210)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Tambacounda) subtitle(Monthly average (2010-2020), linegap(5))
graph save "$outputs/Graphs/Tambacounda_maize1020.gph", replace



graph combine "$outputs/Graphs/SaintLouis_maize9020.gph" "$outputs/Graphs/Tambacounda_maize9020.gph" "$outputs/Graphs/SaintLouis_maize0020.gph" "$outputs/Graphs/Tambacounda_maize0020.gph" "$outputs/Graphs/SaintLouis_maize1020.gph" "$outputs/Graphs/Tambacounda_maize1020.gph" , cols(2) rows(3) iscale(0.4) title(Maize Prices)
graph save "$outputs/Graphs/Maize_avgprices.gph", replace
 
* Graphs - Niebe 


twoway (bar rprice_niebe9020 month, sort) if marche == "Kolda", ytitle("Niebe prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(470 580)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Kolda) subtitle(Monthly average (1990-2020), linegap(5))
graph save "$outputs/Graphs/Kolda_niebe9020.gph", replace

twoway (bar rprice_niebe9020 month, sort) if marche == "Louga", ytitle("Niebe prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(300 400)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Louga) subtitle(Monthly average (1990-2020), linegap(5))
graph save "$outputs/Graphs/Louga_niebe9020.gph", replace

twoway (bar rprice_niebe0020 month, sort) if marche == "Kolda", ytitle("Niebe prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(525 650)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Kolda) subtitle(Monthly average (2000-2020), linegap(5))
graph save "$outputs/Graphs/Kolda_niebe0020.gph", replace

twoway (bar rprice_niebe0020 month, sort) if marche == "Louga", ytitle("Niebe prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(325 450)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Louga) subtitle(Monthly average (2000-2020), linegap(5))
graph save "$outputs/Graphs/Louga_niebe0020.gph", replace

twoway (bar rprice_niebe1020 month, sort) if marche == "Kolda", ytitle("Niebe prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(570 580)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Kolda) subtitle(Monthly average (2010-2020), linegap(5))
graph save "$outputs/Graphs/Kolda_niebe1020.gph", replace

twoway (bar rprice_niebe1020 month, sort) if marche == "Louga", ytitle("Niebe prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(325 450)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Louga) subtitle(Monthly average (2010-2020), linegap(5))
graph save "$outputs/Graphs/Louga_niebe1020.gph", replace


graph combine "$outputs/Graphs/Kolda_niebe9020.gph" "$outputs/Graphs/Louga_niebe9020.gph" "$outputs/Graphs/Kolda_niebe0020.gph" "$outputs/Graphs/Louga_niebe0020.gph" "$outputs/Graphs/Kolda_niebe1020.gph" "$outputs/Graphs/Louga_niebe1020.gph"  , cols(2) rows(3) iscale(0.4) title(Niebe Prices)
graph save "$outputs/Graphs/Niebe_avgprices.gph", replace


* Graphs - Groundnut 

twoway (bar rprice_groundnut9020 month, sort) if marche == "Thiaroye", ytitle("Groundnut prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(230 320)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Thiaroye) subtitle(Monthly average (1990-2020), linegap(5))
graph save "$outputs/Graphs/Thiaroye_groundnut9020.gph", replace

twoway (bar rprice_groundnut9020 month, sort) if marche == "Diourbel", ytitle("Groundnut prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(200 210)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Diourbel) subtitle(Monthly average (1990-2020), linegap(5))
graph save "$outputs/Graphs/Diourbel_groundnut9020.gph", replace

twoway (bar rprice_groundnut0020 month, sort) if marche == "Thiaroye", ytitle("Groundnut prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(210 240)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Thiaroye) subtitle(Monthly average (2000-2020), linegap(5))
graph save "$outputs/Graphs/Thiaroye_groundnut0020.gph", replace

twoway (bar rprice_groundnut0020 month, sort) if marche == "Diourbel", ytitle("Groundnut prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(200 350)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Diourbel) subtitle(Monthly average (2000-2020), linegap(5))
graph save "$outputs/Graphs/Diourbel_groundnut0020.gph", replace

twoway (bar rprice_groundnut1020 month, sort) if marche == "Thiaroye", ytitle("Groundnut prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(250 400)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Thiaroye) subtitle(Monthly average (2010-2020), linegap(5))
graph save "$outputs/Graphs/Thiaroye_groundnut1020.gph", replace

twoway (bar rprice_groundnut1020 month, sort) if marche == "Diourbel", ytitle("Groundnut prices, real CFA/KG") ytitle() yscale(titlegap(5) outergap(0)) yscale(range(200 400)) ylabel(, format(%9.0g)) xtitle(Months) xtitle() xscale(titlegap(5) outergap(0)) xlabel(1 "Jan" 2 "Feb" 3 "Mar"  4 "Apr"  5 "May"  6 "Jun"  7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", format(%tmMon)) title(Diourbel) subtitle(Monthly average (2010-2020), linegap(5))
graph save "$outputs/Graphs/Diourbel_groundnut1020.gph", replace

graph combine  "$outputs/Graphs/Thiaroye_groundnut9020.gph" "$outputs/Graphs/Diourbel_groundnut9020.gph" "$outputs/Graphs/Thiaroye_groundnut0020.gph" "$outputs/Graphs/Diourbel_groundnut0020.gph" "$outputs/Graphs/Thiaroye_groundnut1020.gph" "$outputs/Graphs/Diourbel_groundnut1020.gph"  , cols(2) rows(3) iscale(0.4) title(Groundnut Prices)
graph save "$outputs/Graphs/Groundnut_avgprices.gph", replace
 
** Graph 3: Price seasonality - Month/year
restore
use 		"$data_clean/price_climate_foranalysis.dta", clear

twoway 		(tsline rprice_millet if marche== "Tilene") (tsline rprice_millet if marche == "Kaolack"), scheme(plotplain)

twoway 		(tsline price_millet if marche== "Tilene") (tsline price_millet if marche == "Kaolack"), scheme(cleanplot)

set scheme 
twoway 		(tsline price_millet if marche== "Tilene") (tsline price_millet if marche == "Kaolack"), scheme(white_hue)
lean2
. set scheme economist 

. set scheme s1rcolor 

. set scheme plottig 

set scheme plotplain 

. set scheme uncluttered 

. set scheme lean2



/********************************************************************************	
*** GRAPHS 
********************************************************************************
use			"$data_clean\prices_wrsi.dta", clear
twoway 		(line price_millet month if marche == "Kaolack" & year == 2000) (line price_millet month if marche == "Kaolack" & year == 2009) (line price_millet month if marche == "Kaolack" & year == 2014) (line price_millet month if marche == "Kaolack" & year == 2019),  xlabel(#12) 

preserve 
keep if year ==2010
tsset markets month
twoway 		(tsline price_millet if marche == "Kaolack") (tsline price_millet if marche == "Tilene") (tsline price_millet if marche == "Tambacounda")  (tsline price_millet if marche == "St.Louis") 

*(tsline price_millet month if marche == "Kaolack" & year == 2009) (tsline price_millet month if marche == "Kaolack" & year == 2014) (tsline price_millet month if marche == "Kaolack" & year == 2019),  xlabel(#12) 
restore

twoway 		line MIL month if marche == "Kaolack" & year == 2008

twoway (tsline price_millet) if marche == "Kaolack", ytitle(Millet prices) ttitle(Month / year) tline(2008m7) tlabel(#30) tmtick(##12)
twoway (tsline price_millet) if marche == "Kaolack", ytitle(Millet prices) ttitle(Month / year) tline(2008m7) tlabel(#30, labsize(vsmall) format(%tm) alternate) tmtick(##12, labsize(vsmall)) title(Price seasonality - Millet) name(seasonality_millet, replace)

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


 
twoway 		(tsline price_millet if marche == "Kaolack") (tsline price_millet if marche == "Tilene") (tsline price_millet if marche == "Tambacounda")  (tsline price_millet if marche == "St.Louis") 












































































































use 		"$data_clean\prices_wrsi.dta", replace

* Variable cleaning 
renvars 	price_peanut_d / price_groundnut
foreach 	var of varlist price*{
gen 		ln`var' 	= ln(`var')
gen 		sin`var'  	= asinh(`var')
}

foreach 	var of varlist wrsi*{
gen 		ln`var' 	= ln(`var')
gen 		sin`var' 	= asinh(`var')
}



********************************************************************************	
*** REGRESSIONS - SHOCK: WRSI
********************************************************************************
cd 			"$outputs/Tables"

local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop', fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop' i.year i.month, fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnwrsi_ag_`crop' i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixwrsi_`date'.xls, append
}
tab 		departement if e(sample)
****************************************************************************************************************************

********************************************************************************	
*** REGRESSIONS - SHOCK: RAINFALL
********************************************************************************
sort 		region departement year month
merge 		region departement year month using "$data_clean\Rain_long.dta"
drop 		_merge
hist 		rain_season
foreach 	var of varlist rain*{
gen 		ln`var' 	= ln(`var')
}
hist 		lnrain_season

* Cumul season

local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnrain_season, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_season i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_season i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainseas_`date'.xls, append
}

* Rain June 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnrain_june, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_june i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_june i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainjune_`date'.xls, append
}


* Rain July 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnrain_july, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_july i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_july i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainjuly_`date'.xls, append
}

* Rain August
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnrain_aug, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_aug i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_aug i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainaug_`date'.xls, append
}

* Rain September
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnrain_sep, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_sep i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_sep i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainsep_`date'.xls, append
}

* Monthly rainfall 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnrain_month, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnrain_month i.year i.month, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnrain_month i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixrainmonth_`date'.xls, append
}



********************************************************************************	
*** REGRESSIONS - SHOCK: TEMPERATURE
********************************************************************************
sort 		region departement year month
merge 		region departement year month using "$data_clean\Temp_ehdd_long.dta"
tab 		_merge
drop 		_merge
hist		ehdd
hist 		gdd
foreach 	var of varlist ehdd gdd{
gen 		ln`var' 	= ln(`var')
}
hist 		lnehdd
hist 		lngdd


* Extreme heat degree days / mostly 0
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnehdd, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnehdd i.year i.month, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnehdd i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixehdd_`date'.xls, append
}


* Growing degree days 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lngdd, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lngdd i.year i.month, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lngdd i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixgdd_`date'.xls, append
}


********************************************************************************	
*** REGRESSIONS - SHOCK: NDVI
********************************************************************************
sort 		region departement year month
merge 		region departement year month using "$data_clean\ndvi_long.dta"
tab 		_merge
drop 		_merge
hist		ndvi_season
hist 		ndvi_month
foreach 	var of varlist ndvi*{
gen 		ln`var' 	= ln(`var')
}
hist		lnndvi_season
hist 		lnndvi_month

* Seasonal NDVI
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnndvi_season, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnndvi_season i.year i.month, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnndvi_season i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixndvi_seas_`date'.xls, append
}

* Monthly NDVI
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnprice_`crop' lnndvi_month, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, replace
eststo 		raw: xtreg lnprice_`crop' lnndvi_month i.year i.month, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, append
eststo 		raw: xtreg lnprice_`crop' lnndvi_month i.year c.lnwrsi_ag_`crop'##i.month, fe robust
outreg2 	using reg`crop'_prixndvi_month_`date'.xls, append
}


sort 		region departement year month
save 		"$data_clean/price_regression_long.dta", replace


/*
foreach 	crop of local crops {
use reg`crop'_price.xls
export excel using "reg_prices" , sheet("`crop'")
}
 */
 
 
/********************************************************************************	
*** GRAPHS 
********************************************************************************
use			"$data_clean\prices_wrsi.dta", clear
twoway 		(line price_millet month if marche == "Kaolack" & year == 2000) (line price_millet month if marche == "Kaolack" & year == 2009) (line price_millet month if marche == "Kaolack" & year == 2014) (line price_millet month if marche == "Kaolack" & year == 2019),  xlabel(#12) 

preserve 
keep if year ==2010
tsset markets month
twoway 		(tsline price_millet if marche == "Kaolack") (tsline price_millet if marche == "Tilene") (tsline price_millet if marche == "Tambacounda")  (tsline price_millet if marche == "St.Louis") 

*(tsline price_millet month if marche == "Kaolack" & year == 2009) (tsline price_millet month if marche == "Kaolack" & year == 2014) (tsline price_millet month if marche == "Kaolack" & year == 2019),  xlabel(#12) 
restore

twoway 		line MIL month if marche == "Kaolack" & year == 2008

twoway (tsline price_millet) if marche == "Kaolack", ytitle(Millet prices) ttitle(Month / year) tline(2008m7) tlabel(#30) tmtick(##12)
twoway (tsline price_millet) if marche == "Kaolack", ytitle(Millet prices) ttitle(Month / year) tline(2008m7) tlabel(#30, labsize(vsmall) format(%tm) alternate) tmtick(##12, labsize(vsmall)) title(Price seasonality - Millet) name(seasonality_millet, replace)

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


 
twoway 		(tsline price_millet if marche == "Kaolack") (tsline price_millet if marche == "Tilene") (tsline price_millet if marche == "Tambacounda")  (tsline price_millet if marche == "St.Louis") 







