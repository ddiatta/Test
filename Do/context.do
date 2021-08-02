********************************************************************************	
** Description:Contex analysis for the trigger study 
** Author: Dieynab Diatta
** Date: May 31st 2021
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
use _all using "$data_raw/Context/ehcvm_individu_SEN2018.dta", clear 
sort numind
		
keep numind lien age branch

tempfile temproster_SEN
save temproster_SEN, replace
				
use _all using "$data_raw/Context/s04_me_SEN2018.dta", clear
clonevar numind=s01q00a
		
sort numind
		
capture gen hhid=grappe*1000+menage
capture gen hhid=grappe*1000+id_menage
		
gen grappe2=grappe
		
merge numind using temproster_SEN
drop _merge
			
		// Worked in different types of jobs in the last seven days
								
			// Farming
				
				gen farmingl7d=(s04q06==1)
			
			// Non-farm enterprise
								
				gen nfel7d=(s04q07==1)
								
			// Wage-employment
				
				gen wagel7d=(s04q08==1)
			
			// Apprentice
				
				gen apprenticel7d=(s04q09==1)
						
			// Secondary activity
				
				egen numjobsl7d=rowtotal(farmingl7d nfel7d wagel7d apprenticel7d)
				gen secondaryl7d=(numjobsl7d>1 & numjobsl7d!=.)
				drop numjobsl7d
								
			// Focus these variables on 15+ year olds
				
				gen workingage=(age>=15)
				
				foreach var of varlist *l7d {
					replace `var'=. if workingage!=1
					}
					*
						
		// Household aggregates
			*Anyone in the household, number in the household, household head
			
			foreach var of varlist *l7d {
				
				bysort hhid: egen hhany_`var'=max(`var')
				
				bysort hhid: egen hhnum_`var'=total(`var')
				
				gen hhh_`var'_int=`var' if lien==1
				bysort hhid: egen hhh_`var'=max(hhh_`var'_int)
				drop hhh_`var'_int
				
				}
				*
			
			
			gen hhh_mainacx=0
			replace hhh_mainacx=3 if hhh_wagel7d==1
			replace hhh_mainacx=2 if hhh_mainacx==0 & hhh_nfel7d==1
			replace hhh_mainacx=1 if hhh_mainacx==0 & hhh_farmingl7d==1
			
			label define hhh_mainacx 0 "0 Not working" 1 "1 Farming and nothing else" 2 "2 Non-farm enterprise but no wage work" 3 "3 Any wage work"
			label values hhh_mainacx hhh_mainacx
			
			rename hhh_mainacx hhh_mainacx_l7d
						
		// Number of primary sectors in which households worked in the last 12 months
				
				gen branch2=branch if workingage==1 // focus only on those aged 15 or more
				
			// Number of working-age people reporting a primary sector
				
				gen intz=1 if branch2!=.
				bysort hhid: egen num_branch=total(intz)
				drop intz
				
			// Number of distinct primary sectors
							
				bysort hhid branch2: egen seq=seq()
				replace seq=. if branch2==.
				gen seq_int=(seq==1)
				bysort hhid: egen num_branch_distinct=total(seq_int)
				drop seq seq_int
				
			// Number of distinct primary sectors excluding agriculture
				
				gen branch3=branch2 if branch2!=1
				bysort hhid branch3: egen seq=seq()
				replace seq=. if branch3==.
				gen seq_int=(seq==1)
				bysort hhid: egen num_branch_dnoag=total(seq_int)
				drop seq seq_int
							
					
	// Set missings for secondary occupations
		
		drop hhnum_secondaryl7d
			
	// Check employment variables
		
		*bysort wagel7d: sum age, d
		
	// Keep variables and restrict to household level
		
		keep hhid *l7d* num_branch*
		
		bysort hhid: egen seq=seq()
		drop if seq!=1
		drop seq
				
	// Save tempfile
		
		sort  hhid
		
		save "$data_raw/Context/employment_SEN.dta", replace
		save `employment_`countrycode''
		
		}
		*
************************************** 
* Crops 
use "C:\Users\ddiatta\Downloads\Menage\s16a_me_SEN2018.dta", clear 

			capture gen hhid=grappe*1000+menage
			capture gen hhid=grappe*1000+id_menage
		// Does household have any fields/plots?
			
			gen anyfields=0 if s16aq02==.
			replace anyfields=1 if anyfields==.
			
		// Consistent area for the plot
				
				tab s16aq07
				
			// Generate raw variable
								
				gen plotarea_ha=s16aq09a if s16aq09b==1
				replace plotarea_ha=s16aq09a/10000 if s16aq09b==2
				
				gen any_plotarea_ha=(plotarea_ha!=.)
			
			// Winsorize at the top
				
				winsor plotarea_ha, gen(plotarea_ha_winsor) p(0.01) highonly
				
							
		// Calculate crop diversification
						
			// Number of crops household cultivates
				
				bysort hhid s16aq08: egen seq=seq() // could farm same crop on different plots
				replace seq=0 if seq!=1
				bysort hhid: egen num_croptypes=total(seq)
				drop seq
				
				replace num_croptypes=. if anyfields==0
				
			// Mix of cash crops and food crops
				
				fre s16aq08
				
				gen foodcrop_int=(s16aq08==1 | s16aq08==2 | s16aq08==4 | s16aq08==10)
				gen cashcrop_int=(foodcrop_int!=1 & s16aq08!=.)
				
				bysort hhid: egen foodcrop=max(foodcrop_int)
				bysort hhid: egen cashcrop=max(cashcrop_int)
				
				replace foodcrop=. if num_croptypes==.
				replace cashcrop=. if num_croptypes==.
								
				drop cashcrop_int foodcrop_int
				
				gen cashfoodcrop=.
				replace cashfoodcrop=1 if foodcrop==1 & cashcrop==0
				replace cashfoodcrop=2 if foodcrop==1 & cashcrop==1
				replace cashfoodcrop=3 if foodcrop==0 & cashcrop==1
				
				label define cashfoodcrop 1 "1 Food crops only" 2 "2 Food and cash crops" 3 "3 Cash crops only" 
				label values cashfoodcrop cashfoodcrop
							

					
tabulate s16aq08, generate(crop_)


foreach v of var * {
local l`v' : variable label `v'
      if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
 }
collapse crop_*, by(hhid)

 foreach v of var * {
 label var `v' "`l`v''"
  }
  
  
  foreach var of varlist crop*  {
  replace `var' = 1 if `var'>0 
  replace `var' = 0 if `var' ==. 
  }

* Crop sales 
use "C:\Users\ddiatta\Downloads\Menage\s16c_me_SEN2018.dta", clear 

capture gen hhid=grappe*1000+menage
capture gen hhid=grappe*1000+id_menage
drop if hhid==.
gen anycropsell_int=(s16cq15==1)
bysort hhid: egen anycropsell=max(anycropsell_int)

keep hhid s16cq04 s16cq03b s16cq15
reshape long s16cq04

gen sold_mil = 1 if s16cq04==1 & s16cq15 ==1 
gen sold_rice = 1 if s16cq04==3 & s16cq15 ==1 
gen sold_maize = 1 if s16cq04==4 & s16cq15 ==1 
gen sold_niebe = 1 if s16cq04==8 & s16cq15 ==1 
gen sold_groundnut = 1 if s16cq04==10 & s16cq15 ==1 

collapse sold*, by(hhid)
foreach var of varlist sold*{
replace `var' = 0 if `var' ==. 
}
sum sold*