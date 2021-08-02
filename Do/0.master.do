********************************************************************************	
** Description:This do file is the master to file to run before the other do files
** Project: Sahel shock response cash transfers - Early trigger analysis
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
*** INSTALL USER WRITTEN COMMANDS NEEDED
********************************************************************************
ssc install outreg2, replace
ssc install estout, replace
ssc install carryforward, replace
ssc install unique, replace
ssc installl ietoolkit, replace 

*ssc install dm88_1, replace // needs to be installed manually search dm88_1, then install

ieboilstart, version(15)
`r(version)'
********************************************************************************	
*** SET FOLDER PATH 
********************************************************************************

		if c(username)=="DDiatta"{
		global dir "C:/Users/DDiatta/Dropbox (Personal)"  		
}
	
			if c(username)=="ddiatta"{
		global dir "C:/Users/ddiatta/Dropbox (Personal)"  		
}
	
		* Add other users here (modify the global directory to match the relevant directory)
		
/*				if c(username)=="username"{
		global dir "C:/Users/username/Dropbox (Personal)"  		
}
*/	

********************************************************************************	
*** DEFINE GLOBALS
********************************************************************************
global 		data_raw 	"$dir/SAHEL-SHOCKS/1. Analysis/Data/Raw"	// raw data in shared DB folder
global 		data_clean 	"$dir/SAHEL-SHOCKS/1. Analysis/Data/Clean"	// cleaned data in personal DB
global 		outputs 	"$dir/SAHEL-SHOCKS/1. Analysis/Outputs" 	// path to all tables, graphs, etc
********************************************************************************	
