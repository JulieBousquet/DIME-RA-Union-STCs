/*====================================================================
project:       DIME-RA-Union - Master Do File
Author:        Julie Bousquet 
----------------------------------------------------------------------
Creation Date:    17 May 2019 - 11:32:59
====================================================================*/

/*====================================================================
                        0: Program set up
====================================================================*/


*Master do file, analysis CDD

 clear all

	*Change the data path 
	if c(username)=="julie" | c(username)=="WB527175" {
		global projectfolder	`"/users/`c(username)'/Dropbox/WB_DRC_Eastern_Recovery/18_Data/03. Component 2/Thimo Urbain"'
	}
	
if inlist(c(username), "wb527175", "julie") == 1 {
   
	global github 	`"/users/julie/OneDrive/Documents/GitHub/DIME-RA-Union-STCs/"'
	global dropbox	`"/users/julie/Dropbox/DIME-RA-Union-STCs"'
   
   }


 *Randomization folder globals
   global analysis_dt               "$dropbox/DataSets" 
   global analysis_do               "$github/Dofiles" 
   global analysis_out              "$dropbox/Output" 



exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
