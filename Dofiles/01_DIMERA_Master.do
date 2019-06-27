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

if inlist(c(username), "wb527175", "julie") == 1 {
   
	global github 	`"/users/julie/OneDrive/Documents/GitHub/DIME-STCs-Conversation/"'
	global dropbox	`"/users/julie/Dropbox/DIME-STCs-Conversation"'
   
   }
   
  if inlist(c(username), "mcayala") == 1 {
   
	global github 	`"/Volumes/Camila/GitHub/DIME-STCs-Conversation/"'
	global dropbox	`"/Volumes/Camila/Dropbox/World Bank/DIME-STCs-Conversation/"'
   
   }
 


 *Randomization folder globals
   global analysis_dt               "$dropbox/DataSets" 
   global analysis_do               "$github/Dofiles" 
   global analysis_out              "$dropbox/Output" 



exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
