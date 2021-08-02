** Senegal price data ******************************************
** This file contains code that cleans price data for Senegal **
****************************************************************

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
	
	
cd "$dir"

global data_raw 	"$dir\SAHEL-SHOCKS\Documents\Raw data\Prix"		// raw data in shared DB folder
global data_clean 	"$dir\DIME\Data" 					    // cleaned data in personal DB
global outputs 		"$dir\DIME\Outputs" 					// path to all tables, graphs, etc

********************************************************************************

use 		"$data_clean/Prices_monthly.dta", clear

codebook MARCHE 

sum prMIL
bys MARCHE: egen pr2MIL = mean(missing(MIL))
xtable market, c(mean MIL mean prSORGHO mean prMAÏSLOCAL mean prMAÏSIMPORTE)

bys year: egen prmiss_year = mean(missing)
xtable market, c(N MIL mean prMIL mean MIL min MIL max MIL) filename(Price_monthly_all_2012) sheet(Millet) replace

missings report, percent// reports the number of missing values
missings table
			
MIL	6155	34.19
SORGHO	9323	51.79
MAÏSLOCAL	8413	46.74
MAÏSIMPORTE	13282	73.79
RIZIMPORTEBRISEORDINAIRE	7258	40.32
RIZBRISEIMPORTEPARFUME	15204	84.47
RIZLOCALDECORTIQUE	14320	79.56
OIGNONLOCAL	16088	89.38
OIGNONIMPORTE	15591	86.62
POMMEDETERRELOCALE	16646	92.48
POMMEDETERREIMPORTEE	15589	86.61
MANIOC	15745	87.47
NIEBE	8445	46.92
ARACHIDECOQUE	11316	62.87
ARACHIDEDECORTIQUEE	7567	42.04


bys year: missings report, percent
bys market: missings report, percent


use 		"$data_clean/Prices_monthly.dta", clear

drop if year <2012 // March 2012 - March 2021
drop if (month== 1 | month ==2) & year ==2012
drop pr*


*** Summary statistics ******************************************************************

local vegetables OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE MANIOC
local cereals MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE
local legumes NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE

sort market date
foreach var of local cereals{
    by market : egen pr`var' = mean(missing(`var'))
}

foreach var of local vegetables{
    by market : egen pr`var' = mean(missing(`var'))
}

foreach var of local legumes{
    by market : egen pr`var' = mean(missing(`var'))
}
list market date `vars' pr*, sepby(market)

// make a table showing that proportion
foreach var of local vars {
    gen m`var' = missing(`var')
}

xtable market, c(N MIL mean MIL min MIL max MIL mean prMIL) filename(Price_monthly_all_march2012) sheet(Millet) replace
xtable market, c(N SORGHO mean SORGHO min SORGHO max SORGHO mean prSORGHO) filename(Price_monthly_all_march2012) sheet(Sorghum) 
xtable market, c(N MAÏSLOCAL mean MAÏSLOCAL min MAÏSLOCAL max MAÏSLOCAL mean prMAÏSLOCAL) filename(Price_monthly_all_march2012) sheet(Maize local) 
xtable market, c(N MAÏSIMPORTE mean MAÏSIMPORTE min MAÏSIMPORTE max MAÏSIMPORTE mean prMAÏSIMPORTE) filename(Price_monthly_all_march2012) sheet(Maize imported) 
xtable market, c(N RIZIMPORTEBRISEORDINAIRE mean RIZIMPORTEBRISEORDINAIRE min RIZIMPORTEBRISEORDINAIRE max RIZIMPORTEBRISEORDINAIRE mean prRIZIMPORTEBRISEORDINAIRE) filename(Price_monthly_all_march2012) sheet(Rice imp o) 
xtable market, c(N RIZBRISEIMPORTEPARFUME mean RIZBRISEIMPORTEPARFUME min RIZBRISEIMPORTEPARFUME max RIZBRISEIMPORTEPARFUME mean prRIZBRISEIMPORTEPARFUME) filename(Price_monthly_all_march2012) sheet(Rice imp perf) 
xtable market, c(N RIZLOCALDECORTIQUE mean RIZLOCALDECORTIQUE min RIZLOCALDECORTIQUE max RIZLOCALDECORTIQUE mean prRIZLOCALDECORTIQUE) filename(Price_monthly_all_march2012) sheet(Rice local) 

xtable market, c(N OIGNONLOCAL mean OIGNONLOCAL min OIGNONLOCAL max OIGNONLOCAL mean prOIGNONLOCAL) filename(Price_monthly_all_march2012) sheet(Onion local) 
xtable market, c(N OIGNONIMPORTE mean OIGNONIMPORTE min OIGNONIMPORTE max OIGNONIMPORTE mean prOIGNONIMPORTE) filename(Price_monthly_all_march2012) sheet(Onion imported) 
xtable market, c(N POMMEDETERRELOCALE mean POMMEDETERRELOCALE min POMMEDETERRELOCALE max POMMEDETERRELOCALE mean prPOMMEDETERRELOCALE)  filename(Price_monthly_all_march2012) sheet(Potatoe local) 
xtable market, c(N POMMEDETERREIMPORTEE mean POMMEDETERREIMPORTEE min POMMEDETERREIMPORTEE max POMMEDETERREIMPORTEE mean prPOMMEDETERREIMPORTEE)  filename(Price_monthly_all_march2012) sheet(Potatoe imported) 
xtable market, c(N MANIOC mean MANIOC min MANIOC max MANIOC mean prMANIOC)  filename(Price_monthly_all_march2012) sheet(Cassava) 

xtable market, c(N NIEBE mean NIEBE min NIEBE max NIEBE mean prNIEBE) filename(Price_monthly_all_march2012) sheet(Niebe, replace) 
xtable market, c(N ARACHIDECOQUE mean ARACHIDECOQUE min ARACHIDECOQUE max ARACHIDECOQUE mean prARACHIDECOQUE) filename(Price_monthly_all_march2012) sheet(Peanut shelled, replace) 
xtable market, c(N ARACHIDEDECORTIQUEE mean ARACHIDEDECORTIQUEE min ARACHIDEDECORTIQUEE max ARACHIDEDECORTIQUEE mean prARACHIDEDECORTIQUEE) filename(Price_monthly_all_march2012) sheet(Peanut unshelled) 

codebook MARCHE

save 		"$data_clean/Prices_monthly_march2012.dta", replace



use 		"$data_clean/Prices_monthly.dta", clear

drop if year <2012
drop pr*


*** Summary statistics ******************************************************************

local vegetables OIGNONLOCAL OIGNONIMPORTE POMMEDETERRELOCALE POMMEDETERREIMPORTEE MANIOC
local cereals MIL SORGHO MAÏSLOCAL MAÏSIMPORTE RIZIMPORTEBRISEORDINAIRE RIZBRISEIMPORTEPARFUME RIZLOCALDECORTIQUE
local legumes NIEBE ARACHIDECOQUE ARACHIDEDECORTIQUEE

sort market date
foreach var of local cereals{
    by market : egen pr`var' = mean(missing(`var'))
}

foreach var of local vegetables{
    by market : egen pr`var' = mean(missing(`var'))
}

foreach var of local legumes{
    by market : egen pr`var' = mean(missing(`var'))
}
list market date `vars' pr*, sepby(market)

// make a table showing that proportion
foreach var of local vars {
    gen m`var' = missing(`var')
}

xtable market, c(N MIL mean MIL min MIL max MIL mean prMIL) filename(Price_monthly_all_2012) sheet(Millet) replace
xtable market, c(N SORGHO mean SORGHO min SORGHO max SORGHO mean prSORGHO) filename(Price_monthly_all_2012) sheet(Sorghum) 
xtable market, c(N MAÏSLOCAL mean MAÏSLOCAL min MAÏSLOCAL max MAÏSLOCAL mean prMAÏSLOCAL) filename(Price_monthly_all_2012) sheet(Maize local) 
xtable market, c(N MAÏSIMPORTE mean MAÏSIMPORTE min MAÏSIMPORTE max MAÏSIMPORTE mean prMAÏSIMPORTE) filename(Price_monthly_all_2012) sheet(Maize imported) 
xtable market, c(N RIZIMPORTEBRISEORDINAIRE mean RIZIMPORTEBRISEORDINAIRE min RIZIMPORTEBRISEORDINAIRE max RIZIMPORTEBRISEORDINAIRE mean prRIZIMPORTEBRISEORDINAIRE) filename(Price_monthly_all_2012) sheet(Rice imp o) 
xtable market, c(N RIZBRISEIMPORTEPARFUME mean RIZBRISEIMPORTEPARFUME min RIZBRISEIMPORTEPARFUME max RIZBRISEIMPORTEPARFUME mean prRIZBRISEIMPORTEPARFUME) filename(Price_monthly_all_2012) sheet(Rice imp perf) 
xtable market, c(N RIZLOCALDECORTIQUE mean RIZLOCALDECORTIQUE min RIZLOCALDECORTIQUE max RIZLOCALDECORTIQUE mean prRIZLOCALDECORTIQUE) filename(Price_monthly_all_2012) sheet(Rice local) 

xtable market, c(N OIGNONLOCAL mean OIGNONLOCAL min OIGNONLOCAL max OIGNONLOCAL mean prOIGNONLOCAL) filename(Price_monthly_all_2012) sheet(Onion local) 
xtable market, c(N OIGNONIMPORTE mean OIGNONIMPORTE min OIGNONIMPORTE max OIGNONIMPORTE mean prOIGNONIMPORTE) filename(Price_monthly_all_2012) sheet(Onion imported) 
xtable market, c(N POMMEDETERRELOCALE mean POMMEDETERRELOCALE min POMMEDETERRELOCALE max POMMEDETERRELOCALE mean prPOMMEDETERRELOCALE)  filename(Price_monthly_all_2012) sheet(Potatoe local) 
xtable market, c(N POMMEDETERREIMPORTEE mean POMMEDETERREIMPORTEE min POMMEDETERREIMPORTEE max POMMEDETERREIMPORTEE mean prPOMMEDETERREIMPORTEE)  filename(Price_monthly_all_2012) sheet(Potatoe imported) 
xtable market, c(N MANIOC mean MANIOC min MANIOC max MANIOC mean prMANIOC)  filename(Price_monthly_all_2012) sheet(Cassava) 

xtable market, c(N NIEBE mean NIEBE min NIEBE max NIEBE mean prNIEBE) filename(Price_monthly_all_2012) sheet(Niebe, replace) 
xtable market, c(N ARACHIDECOQUE mean ARACHIDECOQUE min ARACHIDECOQUE max ARACHIDECOQUE mean prARACHIDECOQUE) filename(Price_monthly_all_2012) sheet(Peanut shelled, replace) 
xtable market, c(N ARACHIDEDECORTIQUEE mean ARACHIDEDECORTIQUEE min ARACHIDEDECORTIQUEE max ARACHIDEDECORTIQUEE mean prARACHIDEDECORTIQUEE) filename(Price_monthly_all_2012) sheet(Peanut unshelled) 

codebook MARCHE

save 		"$data_clean/Prices_monthly_2012.dta", replace

