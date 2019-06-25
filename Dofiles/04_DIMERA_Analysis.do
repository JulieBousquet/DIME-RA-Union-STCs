/*====================================================================
project:       DIME RA Union - Analysis Do File
Author:        Julie Bousquet 
Dependencies:  World Bank
----------------------------------------------------------------------
Creation Date:    17 May 2019 - 11:45:31
Modification Date:   
Do-file version:    01
References:          
Output:             
====================================================================*/

/*====================================================================
                        0: Program set up
====================================================================*/
version 14.2
drop _all

/*====================================================================
                        1: Personal Information
====================================================================*/


use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

*--------------------1.1: How long have you been working at DIME (in months)?

tab dime_duration, m
histogram dime_duration, discrete percent
gen 	cat_dime_duration = 1 if dime_duration <= 12
replace cat_dime_duration = 2 if dime_duration > 12 ///
								 & dime_duration <= 24
replace cat_dime_duration = 3 if dime_duration > 24 ///
								 & dime_duration <= 36

lab def cat_dime_duration 1 "One year" 2 "Two years" ///
						  3 "Three years or more" ///
						  , modify

lab val cat_dime_duration cat_dime_duration

tab cat_dime_duration,m 

graph bar, over(cat_dime_duration) ///
	exclude0 stack xalternate ///
	blabel(bar, color(white) position(center) ///
		format(%4.0g)) yscale(off) ///
	ylabel(, nolabels noticks nogrid) ///
	title(Duration of work at DIME (in percentage)) ///
	subtitle(How long have you been working at DIME (in months)?) ///
	note(Note: Question answered by 29 individuals)

graph export "$analysis_out\01_duration_dime.png", as(png) replace

/*====================================================================
                        2: About your work
====================================================================*/

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

*--------------------2.1:  World Region of the country of work
tab region, m

*--------------------2.2:  In which country are you based?
tab country, m

*--------------------2.3: What is your contract type?

tab contract_type, m

*--------------------2.4: What is your job title?

tab job_title, m
codebook job_title
replace job_title = 2 if job_title == 3
lab def job_title 1 "Field Coordinator" ///
			2 "Research Assistant/Coordinator", modify
lab val job_title job_title

graph pie, over(job_title) ///
	plabel(_all percent, color(white) format(%4.0g)) ///
	title(Job Title) subtitle(What is your job title?) ///
	note(Note: Question answered by 29 individuals)

graph export "$analysis_out\02_job_title.png", as(png) replace

*--------------------2.5: What is the nature of your daily work?

*----- [NOT INCLUDED] -----*

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

tab type_daily_work, m
tab daily_work_coord, m
tab daily_work_data, m
tab daily_work_survey, m
tab daily_work_write, m
tab daily_work_gov, m

/*
graph hbar (sum) daily_work_coord (sum) ///
			daily_work_data (sum) ///
			daily_work_survey (sum) ///
			daily_work_write (sum) ///
			daily_work_gov, ///
			showyvars ///
			yvaroptions(relabel(1 "Coordination" 2 "Data"  3 "Survey Support" 4 "Writing" 5 "Government Liaison")) ///
			bargap(5) blabel(bar, color(white) position(center) ///
				format(%4.0g)) ///
			ylabel(, nolabels noticks nogrid) ///
			title(Daily Work) ///
			subtitle(What is the nature of your daily work?) ///
			note(Note: The data is based on 31 answers) ///
			legend(off)

graph export 	"$analysis_out/03_Nature_Job.png", width(4000) replace
*/
global daily_work daily_work_coord daily_work_data ///
				  daily_work_survey daily_work_write  ///
				  daily_work_gov

collapse (mean) $daily_work
xpose, v clear
list

ren _varname categories_work
ren v1 average_work

replace average_work = average_work*100

replace categories_work = "Coordination" if categories_work == "daily_work_coord" 
replace categories_work = "Data" if categories_work == "daily_work_data" 
replace categories_work = "Survey Support" if categories_work == "daily_work_survey" 
replace categories_work = "Writing" if categories_work == "daily_work_write" 
replace categories_work = "Government Liaison" if categories_work == "daily_work_gov" 


graph hbar (mean) average_work, over(categories_work) ///
	bargap(5) blabel(bar, color(white) position(center) /// 
		format(%4.0g)) yscale(off) ///
	ylabel(, nolabels noticks nogrid) ///
	title(Daily Work (in percentage of the whole sample)) ///
	subtitle(What is the nature of your daily work?) ///
	note(Note: Question answered by 31 individuals) legend(off)

graph export 	"$analysis_out/[NI]_03_Nature_Job.png", width(4000) replace

*--------------------2.6: Have you ever helped on a Public Goods type task (like briefs, DIME level or programmatic things)?
use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

tab public_good, m

*--------------------2.7: In the last 12 months, how many meetings did you join where an operations TTL was present?

tab meet_operation, m

*--------------------2.8: In the last 12 months, how many meetings did you join where a Government member was present?

tab meet_gov, m

/*====================================================================
                        3:  About your experience at DIME
====================================================================*/

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

*--------------------3.1: Which DIME program(s) would you say you are a member of / work with directly ? 

*----- [NOT INCLUDED] -----*

tab dime_prog, m 
tab dime_prog_agri, m 
tab dime_prog_gov, m 
tab dime_prog_private, m 
tab dime_prog_fcv, m 
tab dime_prog_social_prot, m 
tab dime_prog_climate, m 
tab dime_prog_health, m 
tab dime_prog_transport, m 
tab dime_prog_energy, m 
tab dime_prog_educ, m

global programs dime_prog_agri dime_prog_gov ///
				dime_prog_private dime_prog_fcv ///
				dime_prog_social_prot dime_prog_climate ///
				dime_prog_health dime_prog_transport ///
				dime_prog_energy dime_prog_educ

collapse (mean) $programs
xpose, v clear
list

ren _varname categories_prog
ren v1 average_prog

replace categories_prog = "Agriculture" if categories_prog == "dime_prog_agri" 
replace categories_prog = "Government" if categories_prog == "dime_prog_gov" 
replace categories_prog = "Private" if categories_prog == "dime_prog_private" 
replace categories_prog = "FCV" if categories_prog == "dime_prog_fcv" 
replace categories_prog = "Social Protection" if categories_prog == "dime_prog_social_prot" 
replace categories_prog = "Climate" if categories_prog == "dime_prog_climate" 
replace categories_prog = "Health" if categories_prog == "dime_prog_health" 
replace categories_prog = "Transport" if categories_prog == "dime_prog_transport" 
replace categories_prog = "Energy" if categories_prog == "dime_prog_energy" 
replace categories_prog = "Education" if categories_prog == "dime_prog_educ" 


graph pie average_prog, over(categories_prog) ///
	pie(_all, explode) ///
	plabel(_all percent, color(black) size(vsmall) format(%4.0g)) ///
	line(lcolor(white) lwidth(none))  ///
	title("Programs at DIME", span nobox)  ///
	subtitle("Which DIME program(s) do you work with?", span nobox)  /// 
	note("Question answered by 31 individuals", nobox)  ///
	legend(on nocolfirst nostack cols(1) rowgap(minuscule)  ///
		colgap(zero) keygap(minuscule) size(medsmall)  ///
		color(black) margin(zero) box fcolor(white)  ///
		lcolor(white) linegap(zero) region(fcolor(white)  ///
			margin(zero) lcolor(white) lwidth(none)  ///
			lpattern(blank))  ///
		bmargin(zero) bexpand title(, margin(tiny) nobox)  ///
		position(9) span)  ///
	graphregion(margin(zero) fcolor(white) lcolor(white) /// 
		lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))  ///
	plotregion(margin(zero) fcolor(white) lcolor(white)  ///
		lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))

graph export	"$analysis_out/[NI]_04_Program.png", width(4000) replace
 

*--------------------3.2: Have you ever worked with any other teams?
use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

tab other_team, m

graph hbar, over(other_team) bargap(5) ///
	blabel(bar, color(white) position(center) ///
		format(%4.0g)) yscale(off) ///
	ylabel(, nolabels noticks nogrid) ///
	title(Work with other team (in percentage)) ///
	subtitle(Have you ever worked with any other teams?) ///
	note(Note: Question answered by 30 individuals) ///
	legend(off)

graph export	"$analysis_out/05_other_team.png", width(4000) replace

*--------------------3.2.1:	Which other teams have you worked with?

*----- [NOT INCLUDED] -----*

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

global other_teams  other_team_fcv other_team_gov ///
					other_team_private other_team_transport ///
					other_team_water

collapse (mean) $other_teams
xpose, v clear
list

ren _varname categories_ot
ren v1 average_ot

replace categories_ot = "FCV" if categories_ot == "other_team_fcv" 
replace categories_ot = "Governance" if categories_ot == "other_team_gov" 
replace categories_ot = "Private" if categories_ot == "other_team_private" 
replace categories_ot = "Transport" if categories_ot == "other_team_transport" 
replace categories_ot = "WASH" if categories_ot == "other_team_water" 


graph pie average_ot, over(categories_ot) ///
	plabel(_all percent, color(black) size(vsmall) format(%4.0g)) ///
	line(lcolor(white) lwidth(none))  ///
	title("Work with other team (percent of the whole sample)", span nobox)  ///
	subtitle("Which other teams have you worked with?", span nobox)  /// 
	note("Question answered by 8 individuals", nobox)  ///
	legend(on nocolfirst nostack cols(1) rowgap(minuscule)  ///
		colgap(zero) keygap(minuscule) size(medsmall)  ///
		color(black) margin(zero) box fcolor(white)  ///
		lcolor(white) linegap(zero) region(fcolor(white)  ///
			margin(zero) lcolor(white) lwidth(none)  ///
			lpattern(blank))  ///
		bmargin(zero) bexpand title(, margin(tiny) nobox)  ///
		position(9) span)  ///
	graphregion(margin(zero) fcolor(white) lcolor(white) /// 
		lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))  ///
	plotregion(margin(zero) fcolor(white) lcolor(white)  ///
		lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))

graph export	"$analysis_out/[NI]_06_other_team_pie.png", width(4000) replace

*--------------------3.2.2: How often did you work with another team in the last 12 months?

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

tab other_team_often
codebook other_team_often

lab def other_team_often 	1 "Once a week" 2 "Once every 6 month" ///
							3 "Once in the last year", modify
lab val other_team_often other_team_often

graph hbar, over(other_team_often) bargap(5) ///
	blabel(bar, color(white) position(center) ///
		format(%4.0g)) yscale(off) ///
	ylabel(, nolabels noticks nogrid) ///
	title(Frequency of work with other team (in percentage)) ///
	subtitle(How often did you work with another team in the last 12 months?) ///
	note(Note: Question answered by 7 individuals) /// 
	legend(off)
	
graph export	"$analysis_out/07_other_team_freq.png", width(4000) replace


*--------------------3.3: How many IEs have you been working on since the beginning of your contract? 

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

tab number_ie_beginning, m
replace number_ie_beginning = 2 if number_ie_beginning >= 2
lab def number_ie_beginning 	1 "One" 2 "More than one", modify
lab val number_ie_beginning number_ie_beginning

graph bar, over(number_ie_beginning) ///
	exclude0 stack  ///
	blabel(bar, color(white) position(center) ///
		format(%4.0g)) yscale(off) ///
	ylabel(, nolabels noticks nogrid) ///
	title(Number of IEs since beginning (in percentage)) ///
	subtitle(How many IEs have you been working on since the beginning of your contract? ) ///
	note(Note: Question answered by 29 individuals)

graph export	"$analysis_out/08_nb_ie_begin.png", width(4000) replace

*--------------------3.4: How many IEs are you working on currently? 

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

tab number_ie_now, m
replace number_ie_now = 2 if number_ie_now >= 2
lab def number_ie_now 	1 "One" 2 "More than one", modify
lab val number_ie_now number_ie_now


graph bar, over(number_ie_now) ///
	exclude0 stack  ///
	blabel(bar, color(white) position(center) ///
		format(%4.0g)) yscale(off) ///
	ylabel(, nolabels noticks nogrid) ///
	title(Number of IEs now (in percentage)) ///
	subtitle(How many IEs are you working on currently?) ///
	note(Note: Question answered by 29 individuals)

graph export	"$analysis_out/09_nb_ie_now.png", width(4000) replace


*--------------------3.5: How many DIME TTLs do you have?

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

tab number_ttl, m

graph bar, over(number_ttl) ///
	exclude0 stack  ///
	blabel(bar, color(white) position(center) ///
		format(%4.0g)) yscale(off) ///
	ylabel(, nolabels noticks nogrid) ///
	title(Number of DIME TTLs (in percentage)) ///
	subtitle(How many DIME TTLs do you have?) ///
	note(Note: Question answered by 30 individuals)

graph export	"$analysis_out/10_nb_ttl.png", width(4000) replace


/*====================================================================
                        4: Your career 
====================================================================*/

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

*--------------------4.1: Are you working on a sector (agriculture, conflict, health, etc.) that you want to pursue your career in or would you want to work on a different sector?

tab sector_want, m

graph pie, over(sector_want) ///
	plabel(_all percent, color(white) format(%4.0g)) ///
	title(Career) subtitle(Are you working on a sector you want to pursue your career in?) ///
	note(Note: Question answered by 30 individuals)

graph export "$analysis_out\11_sector_good.png", as(png) replace

*--------------------4.2: What would you like to do after being an RA/FC? (tick all that apply)

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

tab after_dime, m

global after_dime  after_dime_dkn after_dime_phd ///
					after_dime_staff after_dime_field ///
					after_dime_oth_io after_dime_public ///
					after_dime_private after_dime_ra ///
					after_dime_ngo after_dime_master ///
					after_dime_postdoc after_dime_academia


collapse (mean) $after_dime
xpose, v clear
list

ren _varname categories_ad
ren v1 average_ad

replace categories_ad = "Do not Know" if categories_ad == "after_dime_dkn" 
replace categories_ad = "Academia" if categories_ad == "after_dime_phd" 
replace categories_ad = "Staff" if categories_ad == "after_dime_staff" 
replace categories_ad = "Field Work" if categories_ad == "after_dime_field" 
replace categories_ad = "Other IO or NGO" if categories_ad == "after_dime_oth_io" 
replace categories_ad = "Public" if categories_ad == "after_dime_public" 
replace categories_ad = "Private" if categories_ad == "after_dime_private" 
replace categories_ad = "RA" if categories_ad == "after_dime_ra" 
replace categories_ad = "Other IO or NGO" if categories_ad == "after_dime_ngo" 
replace categories_ad = "Academia" if categories_ad == "after_dime_master" 
replace categories_ad = "Academia" if categories_ad == "after_dime_postdoc" 
replace categories_ad = "Academia" if categories_ad == "after_dime_academia" 

graph pie average_ad, over(categories_ad) ///
	plabel(_all percent, color(black) size(vsmall) format(%4.0g)) ///
	line(lcolor(white) lwidth(none))  ///
	title("Career Plan", span nobox)  ///
	subtitle("What would you like to do after being an RA/FC? ", span nobox)  /// 
	note("Question answered by 31 individuals", nobox)  ///
	legend(on nocolfirst nostack cols(1) rowgap(minuscule)  ///
		colgap(zero) keygap(minuscule) size(medsmall)  ///
		color(black) margin(zero) box fcolor(white)  ///
		lcolor(white) linegap(zero) region(fcolor(white)  ///
			margin(zero) lcolor(white) lwidth(none)  ///
			lpattern(blank))  ///
		bmargin(zero) bexpand title(, margin(tiny) nobox)  ///
		position(9) span)  ///
	graphregion(margin(zero) fcolor(white) lcolor(white) /// 
		lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))  ///
	plotregion(margin(zero) fcolor(white) lcolor(white)  ///
		lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))

graph export	"$analysis_out/12_career_plan.png", width(4000) replace

/*====================================================================
                        5: Satisfatiction
====================================================================*/

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

*--------------------5.1: Are you generally satisfied with your type of contract?

tab satisf_contract, m  
codebook satisf_contract
*replace satisf_contract = 4 if satisf_contract == 5

graph pie, over(satisf_contract) ///
	plabel(_all percent, color(white) format(%4.0g)) ///
	title(Satisfation with Contract) subtitle(Are you generally satisfied with your type of contract?) ///
	note("Note: Question answered by 31 individuals")

graph export "$analysis_out\13_satisf_contract.png", as(png) replace


*--------------------5.2: Are you generally satisfied with your working conditions?

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

tab satisf_working_cond, m  
codebook satisf_working_cond
*replace satisf_working_cond = 4 if satisf_working_cond == 5

graph pie, over(satisf_working_cond) ///
	plabel(_all percent, color(white) format(%4.0g)) ///
	title(Satisfation with Working Conditions) subtitle(Are you generally satisfied with your working conditions?) ///
	note("Note: Question answered by 31 individuals")

graph export "$analysis_out\14_satisf_work_cond.png", as(png) replace


*--------------------5.3: Would you like to have a mentorship program at DIME that helps you with your career?

tab mentorship, m  


graph bar, over(mentorship) ///
	exclude0 stack  ///
	blabel(bar, color(white) position(center) ///
		format(%4.0g)) yscale(off) ///
	ylabel(, nolabels noticks nogrid) ///
	title("Mentorship Program (in percentage)") ///
	subtitle("Would you like to have a mentorship program at DIME?") ///
	note("Note: Question answered by 31 individuals")

graph export	"$analysis_out/15_mentorship.png", width(4000) replace


/*====================================================================
                        6: Solutions and Issues
====================================================================*/


*--------------------6.1: Issues

* 1. general categorization
	use "$analysis_dt/03. Temp/DIMERA_Issues", clear

	tab issue_cat, gen(issue_cat_)
	collapse (mean) issue_cat_*
	lab var issue_cat_1 "Working conditions"
	lab var issue_cat_2 "Career"
	lab var issue_cat_3 "Communication"
	graph pie issue_cat_1 issue_cat_2 issue_cat_3, pie(_all, explode) ///
		plabel(_all percent, color(black) size(vsmall) format(%4.0g)) ///
		line(lcolor(white) lwidth(none))  ///
		title(Categories of issues at DIME, span nobox)  ///
		subtitle("What issues would you like to see on the agenda?", span nobox)  /// 
		note("Data based on a total of 31 respondents" "for a total of 74 issues reported", nobox)  ///
		legend(on nocolfirst nostack cols(1) rowgap(minuscule)  ///
			colgap(zero) keygap(minuscule) size(medsmall)  ///
			color(black) margin(zero) box fcolor(white)  ///
			lcolor(white) linegap(zero) region(fcolor(white)  ///
				margin(zero) lcolor(white) lwidth(none)  ///
				lpattern(blank))  ///
			bmargin(zero) bexpand title(, margin(tiny) nobox)  ///
			position(9) span)  ///
		graphregion(margin(zero) fcolor(white) lcolor(white) /// 
			lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))  ///
		plotregion(margin(zero) fcolor(white) lcolor(white)  ///
			lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none)) name(issues_type, replace)
	graph export "$analysis_out/16_cat_issues.png", width(4000) replace


* 2. Smaller categorization

use "$analysis_dt/03. Temp/DIMERA_Issues", clear
loc num_is_1 "29"
loc num_is_2 "25"
loc num_is_3 "26"


foreach category in 1 2 3 {

preserve
keep if issue_cat == `category'

collapse (mean) $var_issues
cap ssc inst sxpose
xpose, v clear
list

ren _varname categories_issues
ren v1 average_issues

replace categories_issues = "Working Conditions" if categories_issues == "is_working_condition" 
replace categories_issues = "Visa" if categories_issues == "is_visa" 
replace categories_issues = "Horizontal Mobility" if categories_issues == "is_horizontal_mobility" 
replace categories_issues = "Under-reporting" if categories_issues == "is_underreporting" 
replace categories_issues = "Contract Type" if categories_issues == "is_contract_type" 
replace categories_issues = "Health Insurance" if categories_issues == "is_health_insurance" 
replace categories_issues = "Transparency" if categories_issues == "is_transparency" 
replace categories_issues = "Career Guidance" if categories_issues == "is_career_guidance" 
replace categories_issues = "Career Progress" if categories_issues == "is_career_progress" 
replace categories_issues = "Learning opportunities" if categories_issues == "is_learning_opportunities" 
replace categories_issues = "Management" if categories_issues == "is_management" 
replace categories_issues = "Communication Field" if categories_issues == "is_communication_field" 
replace categories_issues = "Misunderstanding DIME Changes" if categories_issues == "is_misund_DIME_changes" 
replace categories_issues = "Misunderstanding Contract" if categories_issues == "is_misund_contract" 
replace categories_issues = "Misunderstanding Career" if categories_issues == "is_misund_career" 
drop if average_issues ==0

* graph pie average_issues, over(categories_issues)

graph pie average_issues, over(categories_issues) ///
	pie(_all, explode) ///
	plabel(_all percent, color(black) size(vsmall) format(%4.0g)) ///
	line(lcolor(white) lwidth(none))  ///
	title(Categories of issues at DIME, span nobox)  ///
	note("Data based on a total of 31 respondents" "for a total of `num_is_`category'' issues reported", nobox)  ///
	legend(on nocolfirst nostack cols(1) rowgap(minuscule)  ///
		colgap(zero) keygap(minuscule) size(medsmall)  ///
		color(black) margin(zero) box fcolor(white)  ///
		lcolor(white) linegap(zero) region(fcolor(white)  ///
			margin(zero) lcolor(white) lwidth(none)  ///
			lpattern(blank))  ///
		bmargin(zero) bexpand title(, margin(tiny) nobox)  ///
		position(9) span)  ///
	graphregion(margin(zero) fcolor(white) lcolor(white) /// 
		lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))  ///
	plotregion(margin(zero) fcolor(white) lcolor(white)  ///
		lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none)) name(issues_type`category', replace)

*graph export "$analysis_out\16_cat_issues.pdf", as(pdf) replace
graph export "$analysis_out/16_cat_issues_type`category'.png", width(4000) replace
restore
}

*--------------------6.2: Solutions 


use "$analysis_dt/03. Temp/DIMERA_Solutions", clear

collapse (mean) $var_solutions
cap ssc inst sxpose
xpose, v clear
list

ren _varname categories_solutions
ren v1 average_solutions

replace categories_solutions = "Mentorship" if categories_solutions == "sol_mentorship" 
replace categories_solutions = "Improve Protocol Openings" if categories_solutions == "sol_openings_protocol" 
replace categories_solutions = "Job Mobility" if categories_solutions == "sol_job_mobility" 
replace categories_solutions = "Structure Roles and Career" if categories_solutions == "sol_structure_role_career" 
replace categories_solutions = "Health Insurance" if categories_solutions == "sol_health_insurance" 
replace categories_solutions = "Performance Review" if categories_solutions == "sol_performance_review" 
replace categories_solutions = "Type Contract" if categories_solutions == "sol_type_contract" 
replace categories_solutions = "Communication" if categories_solutions == "sol_communication" 
replace categories_solutions = "Dime Management" if categories_solutions == "sol_dime_management" 
replace categories_solutions = "Strucutre for free Speach" if categories_solutions == "sol_free_speech_structure" 
replace categories_solutions = "Visas" if categories_solutions == "sol_visa" 
replace categories_solutions = "Transparency" if categories_solutions == "sol_transparency" 
replace categories_solutions = "Trainings" if categories_solutions == "sol_training" 


graph pie average_solutions, over(categories_solutions)

graph pie average_solutions, over(categories_solutions) ///
	pie(_all, explode) ///
	plabel(_all percent, color(black) size(vsmall) format(%4.0g)) ///
	line(lcolor(white) lwidth(none))  ///
	title(Categories of issues at DIME, span nobox)  ///
	subtitle("What solution would you propose to improve STCs situation at DIME?", span nobox)  /// 
	note("Data based on a total of 31 respondents" "for a total of 57 solutions proposed", nobox)  ///
	legend(on nocolfirst nostack cols(1) rowgap(minuscule)  ///
		colgap(zero) keygap(minuscule) size(medsmall)  ///
		color(black) margin(zero) box fcolor(white)  ///
		lcolor(white) linegap(zero) region(fcolor(white)  ///
			margin(zero) lcolor(white) lwidth(none)  ///
			lpattern(blank))  ///
		bmargin(zero) bexpand title(, margin(tiny) nobox)  ///
		position(9) span)  ///
	graphregion(margin(zero) fcolor(white) lcolor(white) /// 
		lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))  ///
	plotregion(margin(zero) fcolor(white) lcolor(white)  ///
		lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))


*graph export "$analysis_out\17_cat_solutions.pdf", as(pdf) replace						
graph export "$analysis_out/17_cat_solutions.png", width(4000) replace



exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control:


