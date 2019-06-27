/*====================================================================
project:       DIME RA Union - Preparation Do File
Author:        Julie Bousquet 
Dependencies:  World Bank
----------------------------------------------------------------------
Creation Date:    17 May 2019 - 11:44:34
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

import delimited "$analysis_dt/01. Raw/DIMERA_Union_agenda.csv", clear

/*====================================================================
                        1: Variable Definitions
====================================================================*/


*--------------------1.1: Renaming

desc * 

ren timestamp 							time_date
ren doyouconsenttoanonymouslyshareyo 	consent
ren nameoptional 						name
ren howlonghaveyoubeenworkingatdimei 	dime_duration
ren inwhichcountryareyoubased 			country
ren whatisyourcontracttype  			contract_type
ren whatisyourjobtitle 					job_title
ren whatisthenatureofyourdailywork 		type_daily_work
ren haveyoueverhelpedonapublicgoodst 	public_good
ren inthelast12monthshowmanymeetings 	meet_operation
ren v11 								meet_gov
ren whichdimeprogramswouldyousayyoua 	dime_prog
ren haveyoueverworkedwithanyothertea 	other_team
ren whichotherteamshaveyouworkedwith 	other_team_who
ren howoftendidyouworkwithanothertea 	other_team_often
ren howmanyieshaveyoubeenworkingonsi  	number_ie_beginning
ren howmanyiesareyouworkingoncurrent 	number_ie_now
ren howmanydimettlsdoyouhave 			number_ttl
ren areyouworkingonasectoragricultur 	sector_want
ren whatwouldyouliketodoafterbeingan 	after_dime
ren areyougenerallysatisfiedwithyour 	satisf_contract
ren v22 								satisf_working_cond
ren wouldyouliketohaveamentorshippro 	mentorship
ren wouldyouliketoaddanythingelseany 	add_other

desc *

*--------------------1.2: Labeling values

lab def yesno 0 "No" 1 "Yes", modify

*Time and date
tab time_date, m 

*Consent
tab consent, m
replace consent = "1" if consent == "Yes"
destring consent, replace
lab val consent yesno

*Name [TO ENCRYPT]
tab name, m 

*Time work at DIME
tab dime_duration, m 

*Country
tab country, m 
replace country = "USA"  if country == "DC" | ///
							country == "DC - USA" | ///
							country == "US" | ///
							country == "US (Washington D.C.)" | ///
							country == "United States" | ///
							country == "Washington DC"
replace country = "Comoros"  if country == "Comoros | France"
replace country = "DRC" if country == "Democratic Republic of Congo (DRC)"
replace country = "Nepal" if country == "nepal"
replace country = "Africa" if country == "Outside DC - Africa"

replace country = "1" if country == "Africa"
replace country = "2" if country == "Comoros"
replace country = "3" if country == "DRC"
replace country = "4" if country == "Nepal"
replace country = "5" if country == "Senegal"
replace country = "6" if country == "USA"
replace country = ".d" if country == ""

destring country, replace

lab def country 1 "Africa" 2 "Comoros" 3 "DRC" 4 "Nepal" ///
				5 "Senegal" 6 "USA", modify

lab val country country

*Region
gen 	region = 1 if 	country == 1 | country == 2 | ///
						country == 3 | country == 5
replace region = 2 if 	country == 4
replace region = 3 if 	country == 6
replace region = .d if country == .d

lab def region 	1 "Africa" 2 "South Asia" 3 "North America" ///
				, modify
lab val region region
order region, b(country)
lab var region "World Region of the country of work"
tab region, m

*Contract type
tab contract_type, m 
replace contract_type = "1" if contract_type == "STAFF" 
replace contract_type = "2" if contract_type == "STC: Short Term Consultant"
replace contract_type = ".d" if contract_type == ""
destring contract_type, replace
lab def contract_type 1 "Staff" 2 "STC", modify
lab val contract_type contract_type

*Job Title
tab job_title, m 
replace job_title = "1" if job_title == "Field Coordinator"
replace job_title = "2" if job_title == "Research Assistant"
replace job_title = "3" if job_title == "Research Coordinator"
replace job_title = ".d" if job_title == ""
destring job_title, replace
lab def job_title 	1 "Field Coordinator" ///
					2 "Research Assistant" ///
					3 "Research Coordinator" ///
					, modify
lab val job_title job_title

*Type daily work
tab type_daily_work, m 
 desc type_daily_work
split type_daily_work, parse(";")
tab type_daily_work1, m 
tab type_daily_work2, m 
tab type_daily_work3, m 
tab type_daily_work4, m

gen daily_work_coord = 1 if 	type_daily_work1 == "Coordinating" | ///
								type_daily_work2 == "Coordinating" | ///
								type_daily_work3 == "Coordinating" | ///
								type_daily_work4 == "Coordinating" 
replace daily_work_coord = 0 if mi(daily_work_coord)
lab var daily_work_coord "Is the nature of your daily job: Coordinating?"
lab val daily_work_coord yesno
tab daily_work_coord, m

gen daily_work_data = 1 if 		type_daily_work1 == "Data" | ///
								type_daily_work2 == "Data" | ///
								type_daily_work3 == "Data" | ///
								type_daily_work4 == "Data" 
replace daily_work_data = 0 if mi(daily_work_data)
lab var daily_work_data "Is the nature of your daily job: Data?"
lab val daily_work_data yesno
tab daily_work_data, m

gen daily_work_survey = 1 if 	type_daily_work1 == "Survey Support" | ///
								type_daily_work2 == "Survey Support" | ///
								type_daily_work3 == "Survey Support" | ///
						 		type_daily_work4 == "Survey Support" 
replace daily_work_survey = 0 if mi(daily_work_survey)
lab var daily_work_survey "Is the nature of your daily job: Survey Support?"
lab val daily_work_survey yesno
tab daily_work_survey, m

gen daily_work_write = 1 if 	type_daily_work1 == "Writing" | ///
								type_daily_work2 == "Writing" | ///
								type_daily_work3 == "Writing" | ///
								type_daily_work4 == "Writing" 
replace daily_work_write = 0 if mi(daily_work_write)
lab var daily_work_write "Is the nature of your daily job: Writing?"
lab val daily_work_write yesno
tab daily_work_write, m

gen daily_work_gov = 1 if 		type_daily_work1 == "Government liaison" | ///
								type_daily_work2 == "Government liaison" | ///
								type_daily_work3 == "Government liaison" | ///
								type_daily_work4 == "Government liaison" 
replace daily_work_gov = 0 if mi(daily_work_gov)
lab var daily_work_gov "Is the nature of your daily job: Government Liason?"
lab val daily_work_gov yesno
tab daily_work_gov, m

drop type_daily_work1 type_daily_work2 type_daily_work3 type_daily_work4
order 	daily_work_coord daily_work_data daily_work_survey ///
		daily_work_write daily_work_gov, a(type_daily_work)

*Produced Public Good?
tab public_good, m 
replace public_good = "0" if public_good == "No"
replace public_good = "1" if public_good == "Yes"
replace public_good = ".d" if public_good == ""
destring public_good, replace
lab val public_good yesno

*Meet operation
tab meet_operation, m 
replace meet_operation = "20" if meet_operation == "More than 20"
replace meet_operation = ".d" if meet_operation == ""
destring meet_operation, replace

*Meet gov
tab meet_gov, m 
replace meet_gov = "20" if meet_gov == "More than 20"
replace meet_gov = ".d" if meet_gov == ""
destring meet_gov, replace

*Dime Programme
tab dime_prog, m 
 desc dime_prog
split dime_prog, parse(";")
tab dime_prog1, m 
tab dime_prog2, m 

gen dime_prog_agri = 1 if 	dime_prog1 == "Agriculture" | ///
							dime_prog2 == "Agriculture" 
replace dime_prog_agri = 0 if mi(dime_prog_agri)
lab var dime_prog_agri "Member of the DIME program: Agriculture"
lab val dime_prog_agri yesno
tab dime_prog_agri, m

gen dime_prog_gov = 1 if 	dime_prog1 == "Governance" | ///
							dime_prog2 == "Governance" 
replace dime_prog_gov = 0 if mi(dime_prog_gov)
lab var dime_prog_gov "Member of the DIME program: Governance"
lab val dime_prog_gov yesno
tab dime_prog_gov, m

gen dime_prog_private = 1 if 	dime_prog1 == "Private Sector" | ///
								dime_prog2 == "Private Sector" 
replace dime_prog_private = 0 if mi(dime_prog_private)
lab var dime_prog_private "Member of the DIME program: Private Sector"
lab val dime_prog_private yesno
tab dime_prog_private, m

gen dime_prog_fcv = 1 if 	dime_prog1 == "Fragile, Conflict and Violence" | ///
							dime_prog2 == "Fragile, Conflict and Violence" 
replace dime_prog_fcv = 0 if mi(dime_prog_fcv)
lab var dime_prog_fcv "Member of the DIME program: FCV"
lab val dime_prog_fcv yesno
tab dime_prog_fcv, m

gen dime_prog_social_prot = 1 if 	dime_prog1 == "Social Protection and Jobs" | ///
									dime_prog2 == "Social Protection and Jobs" 
replace dime_prog_social_prot = 0 if mi(dime_prog_social_prot)
lab var dime_prog_social_prot "Member of the DIME program: Social Protection and Jobs"
lab val dime_prog_social_prot yesno
tab dime_prog_social_prot, m

gen dime_prog_climate = 1 if 	dime_prog1 == "Climate Change" | ///
								dime_prog2 == "Climate Change" 
replace dime_prog_climate = 0 if mi(dime_prog_climate)
lab var dime_prog_climate "Member of the DIME program: Climate Change"
lab val dime_prog_climate yesno
tab dime_prog_climate, m

gen dime_prog_health = 1 if 	dime_prog1 == "Health" | ///
								dime_prog2 == "Health" 
replace dime_prog_health = 0 if mi(dime_prog_health)
lab var dime_prog_health "Member of the DIME program: Health"
lab val dime_prog_health yesno
tab dime_prog_health, m

gen dime_prog_transport = 1 if 	dime_prog1 == "Transport" | ///
								dime_prog2 == "Transport" 
replace dime_prog_transport = 0 if mi(dime_prog_transport)
lab var dime_prog_transport "Member of the DIME program: Transport"
lab val dime_prog_transport yesno
tab dime_prog_transport, m

gen dime_prog_energy = 1 if 	dime_prog1 == "Energy, Education" | ///
								dime_prog2 == "Energy, Education" 
replace dime_prog_energy = 0 if mi(dime_prog_energy)
lab var dime_prog_energy "Member of the DIME program: Energy"
lab val dime_prog_energy yesno
tab dime_prog_energy, m

gen dime_prog_educ = 1 if 	dime_prog1 == "Energy, Education" | ///
							dime_prog2 == "Energy, Education" 
replace dime_prog_educ = 0 if mi(dime_prog_educ)
lab var dime_prog_educ "Member of the DIME program: Energy"
lab val dime_prog_educ yesno
tab dime_prog_educ, m

drop 	dime_prog1 dime_prog2
order 	dime_prog_agri dime_prog_gov dime_prog_private ///
		dime_prog_fcv dime_prog_social_prot dime_prog_climate ///
		dime_prog_health dime_prog_transport dime_prog_energy ///
		dime_prog_educ, a(dime_prog)

*Work with other teams
tab other_team, m 
replace other_team = "0" if other_team == "No"
replace other_team = "1" if other_team == "Yes"
replace other_team = ".d" if other_team == ""
destring other_team, replace
lab val other_team yesno

*Who other
tab other_team_who, m 
 desc other_team_who

gen other_team_fcv = 1 if 	other_team_who == "Fragile, Conflict and Violence" 
replace other_team_fcv = 0 if mi(other_team_fcv)
lab var other_team_fcv "Member of other DIME program: FCV"
lab val other_team_fcv yesno
tab other_team_fcv, m

gen other_team_gov = 1 if 	other_team_who == "Governance" 
replace other_team_gov = 0 if mi(other_team_gov)
lab var other_team_gov "Member of other DIME program: Governance"
lab val other_team_gov yesno
tab other_team_gov, m

gen other_team_private = 1 if 	other_team_who == "Private Sector" 
replace other_team_private = 0 if mi(other_team_private)
lab var other_team_private "Member of other DIME program: Private Sector"
lab val other_team_private yesno
tab other_team_private, m

gen other_team_transport = 1 if 	other_team_who == "Transport" 
replace other_team_transport = 0 if mi(other_team_transport)
lab var other_team_transport "Member of other DIME program: Transport"
lab val other_team_transport yesno
tab other_team_transport, m

gen other_team_water = 1 if 	other_team_who == "water global practice" 
replace other_team_water = 0 if mi(other_team_water)
lab var other_team_water "Member of other DIME program: Water GP"
lab val other_team_water yesno
tab other_team_water, m

order 	other_team_fcv other_team_gov other_team_private ///
		other_team_transport other_team_water, a(other_team_who)

*How often work with other teams
tab other_team_often, m 
replace other_team_often = "1" if other_team_often == "Once a week"
replace other_team_often = "2" if other_team_often == "Once every 6 months"
replace other_team_often = "3" if other_team_often == "Once in the last year"
replace other_team_often = ".d" if other_team_often == ""
destring other_team_often, replace
lab def other_team_often 	1 "Once a week" ///
							2 "Once every 6 month" ///
							3 "ONce in the last year" ///
							, modify
lab val other_team_often other_team_often

*Number of IEs at the beginning
tab number_ie_beginning, m 
replace number_ie_beginning = .d if number_ie_beginning == . 
codebook number_ie_beginning

*Number of IEs now
tab number_ie_now, m 
replace number_ie_now = .d if number_ie_now == . 

*Number of ttls
tab number_ttl, m 
replace number_ttl = .d if number_ttl == . 

*Is it the sector you want
tab sector_want, m 
replace sector_want = "1" if sector_want == "I work on a sector that I want to pursue my career in" 
replace sector_want = "2" if sector_want == "I would want to work on a different sector" 
replace sector_want = ".d" if sector_want == ""
destring sector_want, replace 
lab def sector_want 1 "Yes" 2 "No", modify
lab val sector_want sector_want

*In the future, expectations
table after_dime
 desc after_dime
split after_dime, parse(";")
tab after_dime1, m 
tab after_dime2, m 
tab after_dime3, m 
tab after_dime4, m 
tab after_dime5, m 

gen after_dime_dkn = 1 if 	after_dime1 == "Do not know" | ///
							after_dime2 == "Do not know" | ///
							after_dime3 == "Do not know" | ///
							after_dime4 == "Do not know" | ///
							after_dime5 == "Do not know" 
replace after_dime_dkn = 0 if mi(after_dime_dkn)
lab var after_dime_dkn "What do you want to do after RA/FC?: Do not know"
lab val after_dime_dkn yesno
tab after_dime_dkn, m

gen after_dime_phd = 1 if 	after_dime1 == "PhD" | ///
							after_dime2 == "PhD" | ///
							after_dime3 == "PhD" | ///
							after_dime4 == "PhD" | ///
							after_dime5 == "PhD" 
replace after_dime_phd = 0 if mi(after_dime_phd)
lab var after_dime_phd "What do you want to do after RA/FC?: PhD"
lab val after_dime_phd yesno
tab after_dime_phd, m

gen after_dime_staff = 1 if 	after_dime1 == "Staff at the WB" | ///
								after_dime2 == "Staff at the WB" | ///
								after_dime3 == "Staff at the WB" | ///
								after_dime4 == "Staff at the WB" | ///
								after_dime5 == "Staff at the WB" 
replace after_dime_staff = 0 if mi(after_dime_staff)
lab var after_dime_staff "What do you want to do after RA/FC?: Staff at the WB"
lab val after_dime_staff yesno
tab after_dime_staff, m

gen after_dime_field = 1 if 	after_dime1 == "Field coordinator or go to the field" | ///
								after_dime2 == "Field coordinator or go to the field" | ///
								after_dime3 == "Field coordinator or go to the field" | ///
								after_dime4 == "Field coordinator or go to the field" | ///
								after_dime5 == "Field coordinator or go to the field" 
replace after_dime_field = 0 if mi(after_dime_field)
lab var after_dime_field "What do you want to do after RA/FC?: Field Work"
lab val after_dime_field yesno
tab after_dime_field, m

gen after_dime_oth_io = 1 if 	after_dime1 == "Other international organizations" | ///
								after_dime2 == "Other international organizations" | ///
								after_dime3 == "Other international organizations" | ///
								after_dime4 == "Other international organizations" | ///
								after_dime5 == "Other international organizations" 
replace after_dime_oth_io = 0 if mi(after_dime_oth_io)
lab var after_dime_oth_io "What do you want to do after RA/FC?: Other international organizations"
lab val after_dime_oth_io yesno
tab after_dime_oth_io, m

gen after_dime_public = 1 if 	after_dime1 == "Public sector" | ///
								after_dime2 == "Public sector" | ///
								after_dime3 == "Public sector" | ///
								after_dime4 == "Public sector" | ///
								after_dime5 == "Public sector" 
replace after_dime_public = 0 if mi(after_dime_public)
lab var after_dime_public "What do you want to do after RA/FC?: Public sector"
lab val after_dime_public yesno
tab after_dime_public, m

gen after_dime_private = 1 if 	after_dime1 == "Private sector" | ///
								after_dime2 == "Private sector" | ///
								after_dime3 == "Private sector" | ///
								after_dime4 == "Private sector" | ///
								after_dime5 == "Private sector" 
replace after_dime_private = 0 if mi(after_dime_private)
lab var after_dime_private "What do you want to do after RA/FC?: Private sector"
lab val after_dime_private yesno
tab after_dime_private, m

gen after_dime_ra = 1 if 	after_dime1 == "Research Assistant" | ///
							after_dime2 == "Research Assistant" | ///
							after_dime3 == "Research Assistant" | ///
							after_dime4 == "Research Assistant" | ///
							after_dime5 == "Research Assistant" 
replace after_dime_ra = 0 if mi(after_dime_ra)
lab var after_dime_ra "What do you want to do after RA/FC?: Research Assistant"
lab val after_dime_ra yesno
tab after_dime_ra, m

gen after_dime_ngo = 1 if 	after_dime1 == "NGO" | ///
							after_dime2 == "NGO" | ///
							after_dime3 == "NGO" | ///
							after_dime4 == "NGO" | ///
							after_dime5 == "NGO" 
replace after_dime_ngo = 0 if mi(after_dime_ngo)
lab var after_dime_ngo "What do you want to do after RA/FC?: NGO"
lab val after_dime_ngo yesno
tab after_dime_ngo, m


gen after_dime_master = 1 if 	after_dime1 == "Master" | ///
								after_dime2 == "Master" | ///
								after_dime3 == "Master" | ///
								after_dime4 == "Master" | ///
								after_dime5 == "Master" 
replace after_dime_master = 0 if mi(after_dime_master)
lab var after_dime_master "What do you want to do after RA/FC?: Master"
lab val after_dime_master yesno
tab after_dime_master, m

gen after_dime_postdoc = 1 if 	after_dime1 == "Economist | Post-doc" | ///
								after_dime2 == "Economist | Post-doc" | ///
								after_dime3 == "Economist | Post-doc" | ///
								after_dime4 == "Economist | Post-doc" | ///
								after_dime5 == "Economist | Post-doc" 
replace after_dime_postdoc = 0 if mi(after_dime_postdoc)
lab var after_dime_postdoc "What do you want to do after RA/FC?: Post-Doc"
lab val after_dime_postdoc yesno
tab after_dime_postdoc, m

gen after_dime_academia = 1 if 	after_dime1 == "Academia" | ///
								after_dime2 == "Academia" | ///
								after_dime3 == "Academia" | ///
								after_dime4 == "Academia" | ///
								after_dime5 == "Academia" 
replace after_dime_academia = 0 if mi(after_dime_academia)
lab var after_dime_academia "What do you want to do after RA/FC?: Academia"
lab val after_dime_academia yesno
tab after_dime_academia, m

drop 	after_dime1 after_dime2 after_dime3 after_dime4 after_dime5
order 	after_dime_dkn after_dime_phd after_dime_staff ///
		after_dime_field after_dime_oth_io after_dime_public ///
		after_dime_private after_dime_ra after_dime_ngo ///
		after_dime_master after_dime_postdoc after_dime_academia ///
		, a(after_dime)

*Satisfcation
lab def satisf 	1 "Very Satisfied" ///
				2 "Satisfied" ///
				3 "Neutral" ///
				4 "Dissatisfied" ///
				5 "Very Dissatisfied" ///
				, modify

tab satisf_contract, m 
replace satisf_contract = "1" if satisf_contract == "Very Satisfied"
replace satisf_contract = "2" if satisf_contract == "Satisfied"
replace satisf_contract = "3" if satisf_contract == "Neutral"
replace satisf_contract = "4" if satisf_contract == "Disatisfied"
replace satisf_contract = "5" if satisf_contract == "Very Disatisfied"
destring satisf_contract, replace
lab val satisf_contract satisf

tab satisf_working_cond, m 
replace satisf_working_cond = "1" if satisf_working_cond == "Very Satisfied"
replace satisf_working_cond = "2" if satisf_working_cond == "Satisfied"
replace satisf_working_cond = "3" if satisf_working_cond == "Neutral"
replace satisf_working_cond = "4" if satisf_working_cond == "Disatisfied"
replace satisf_working_cond = "5" if satisf_working_cond == "Very Disatisfied"
destring satisf_working_cond, replace
lab val satisf_working_cond satisf

*Mentorship program
tab mentorship, m 
replace mentorship = "1" if mentorship == "Yes"
replace mentorship = "2" if mentorship == "Not Sure"
destring mentorship, replace
lab def mentorship 	1 "Yes" 2 "Not Sure", modify
lab val mentorship mentorship

tab issue1, m 
tab issue2, m 
tab issue3, m 
tab solution1, m 
tab solution2, m 
tab solution3, m 
tab add_other, m

gen iid = _n

save "$analysis_dt/04. Final/DIMERA_Cleaned.dta", replace



exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control:


