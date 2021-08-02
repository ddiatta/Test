putpdf clear
use 	"$data_clean\reg_production_wide.dta", clear
putpdf begin

// Create a paragraph
/*
. putpdf paragraph, font("Courier",20) 
. putpdf text ("Report on 1978 automobiles")
*/
// Add a title
putpdf paragraph, halign(center)
putpdf text ("Regression Outputs"), bold
putpdf paragraph
putpdf text ("WRSI"), bold
/*
. putpdf begin
. putpdf table tbl2 = etable, width(100%)
. putpdf table tbl2(.,5), drop //drop p-value column
. putpdf table tbl2(.,4), drop //drop t column
. putpdf table tbl2(.,3), drop //drop SE column
*/

local 		crops millet niebe groundnut maize
foreach 	crop of local crops {
eststo 		raw1: xtreg lnharvest_`crop' lnwrsi_`crop', fe robust
eststo 		raw2: xtreg lnharvest_`crop' lnwrsi_`crop' i.year , fe robust
eststo 		raw3: xtreg lnharvest_`crop' lnwrsi_`crop' c.lnwrsi_`crop'##i.year, fe robust
estimates table raw1 raw2 raw3, b(%10.3f) star stats(N r2) 
putpdf table mytable = etable, width(50%)
}




local 		crops millet niebe groundnut maize
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnwrsi_`crop', fe robust
estimates store model1_`crop'
eststo 		raw: xtreg lnharvest_`crop' lnwrsi_`crop' i.year , fe robust
estimates store model2_`crop'
eststo 		raw: xtreg lnharvest_`crop' lnwrsi_`crop' c.lnwrsi_`crop'##i.year, fe robust
estimates store model3_`crop'
estimates table model1_`crop' model2_`crop' model3_`crop', b(%10.3f) star stats(N r2) 
putpdf table mytable_`crop' = etable, width(50%)
}







foreach 	crop of local crops {
xtreg lnharvest_`crop' lnwrsi_`crop', fe robust
estimates store model1_`crop'
xtreg lnharvest_`crop' lnwrsi_`crop' i.year , fe robust
estimates store model2_`crop'
xtreg lnharvest_`crop' lnwrsi_`crop' c.lnwrsi_`crop'##i.year, fe robust
estimates store model3_`crop'
estimates table model1_`crop' model2_`crop' model3_`crop', b(%10.3f) star stats(N r2) 
putpdf table mytable_`crop' = etable, width(50%)
}


putpdf save reg_production.pdf, replace




/*
putpdf sectionbreak
putpdf paragraph
putpdf text ("Rainfall"), bold
********************************************************************************	
*** REGRESSIONS - SHOCK: RAINFALL
********************************************************************************
putpdf paragraph
putpdf text ("Seasonal Rainfall (cumul) "), bold

local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnrain_season, fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnrain_season i.year , fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnrain_season c.lnwrsi_`crop'##i.year, fe robust
putpdf table mytable = etable
}

putpdf paragraph
putpdf text ("June Rainfall"), bold
* Rain June 
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnrain_june, fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnrain_june i.year , fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnrain_june c.lnwrsi_`crop'##i.year, fe robust
putpdf table mytable = etable
}

* Rain July 
putpdf paragraph
putpdf text ("July Rainfall"), bold
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnrain_july, fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnrain_july i.year , fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnrain_july c.lnwrsi_`crop'##i.year, fe robust
putpdf table mytable = etable
}

* Rain August
putpdf paragraph
putpdf text ("August Rainfall"), bold
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnrain_aug, fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnrain_aug i.year , fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnrain_aug c.lnwrsi_`crop'##i.year, fe robust
putpdf table mytable = etable
}

* Rain September
putpdf paragraph
putpdf text ("September Rainfall"), bold
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnrain_sep, fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnrain_sep i.year , fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnrain_sep c.lnwrsi_`crop'##i.year, fe robust
putpdf table mytable = etable
}


********************************************************************************	
*** REGRESSIONS - SHOCK: TEMPERATURE
********************************************************************************
putpdf sectionbreak
putpdf paragraph
putpdf text ("Extreme Heat Degree Days"), bold
********************************
* Extreme heat degree days / mostly 0
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnehdd_season, fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnehdd_season i.year , fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnehdd_season c.lnwrsi_`crop'##i.year, fe robust
putpdf table mytable = etable
}


********************************************************************************	
*** REGRESSIONS - SHOCK: NDVI
********************************************************************************
putpdf sectionbreak
putpdf paragraph
putpdf text ("NDVI"), bold
* Seasonal NDVI
local 		crops millet niebe groundnut maize
local 		date: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
foreach 	crop of local crops {
eststo 		raw: xtreg lnharvest_`crop' lnndvi_season, fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnndvi_season i.year , fe robust
putpdf table mytable = etable
eststo 		raw: xtreg lnharvest_`crop' lnndvi_season c.lnwrsi_`crop'##i.year, fe robust
putpdf table mytable = etable
}


putpdf save reg_production.pdf, replace


******************************************************************************






/*

putpdf sectionbreak
putpdf text ("Temperature"), bold

putpdf sectionbreak
putpdf text ("NDVI"), bold



putpdf text ("")
putpdf text ("italicize, "), italic
putpdf text ("striketout, "), strikeout
putpdf text ("underline"), underline
putpdf text (", sub/super script")
putpdf text ("2 "), script(sub)
putpdf text (", and   ")
putpdf text ("bgcolor"), bgcolor("blue")
qui sum mpg
local sum : display %4.2f `r(sum)'
putpdf text (".  Also, you can easily add Stata results to your paragraph (mpg total = `sum')")

// Embed a graph
histogram rep
graph export hist.png, replace
putpdf paragraph, halign(center)
putpdf image hist.png

// Embed Stata output
putpdf paragraph
putpdf text ("Embed the output from a regression command into your pdf file.")
regress mpg price
putpdf table mytable = etable

// Embed Stata dataset
putpdf paragraph
putpdf text ("Embed the data in Stata's memory into a table in your pdf file.")
statsby Total=r(N) Average=r(mean) Max=r(max) Min=r(min), by(foreign): summarize mpg
rename foreign Origin
putpdf table tbl1 = data("Origin Total Average Max Min"), varnames  ///
        border(start, nil) border(insideV, nil) border(end, nil)

putpdf save myreport.pdf, replace