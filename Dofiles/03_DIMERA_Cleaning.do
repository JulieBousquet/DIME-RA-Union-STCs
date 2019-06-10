/*====================================================================
project:       DIME RA Union - Cleaning Do File
Author:        Julie Bousquet 
Dependencies:  World Bank
----------------------------------------------------------------------
Creation Date:    17 May 2019 - 11:43:39
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

use "$analysis_dt/02. Base/DIMERA_Union_agenda_Prep.dta", clear

/*====================================================================
                        1: Issues
====================================================================*/


*--------------------1.1: Categories

list issue1, table notrim
list issue2, table notrim
list issue3, table notrim

preserve
keep iid issue1
tempfile issue1
save `issue1'
restore

preserve
keep iid issue2
tempfile issue2
save `issue2'
restore

preserve
keep iid issue3
tempfile issue3
save `issue3'
restore

use `issue1', clear
append using `issue2'
append using `issue3'

sort iid
gen aid = _n

*Number of issues
gen issue = issue1
replace issue = issue2 if mi(issue)
replace issue = issue3 if mi(issue)
tab issue
*74 issues

/*Categorie 1: Working Condition
9) Working conditions in Country Offices, for example in my 
case most of the times I cannot even find a desk to work, 
and given the internet poor conditions in the country 
(outside WB office), going to a cafÃ© or working from home 
is not an option.
34) Support to those working largely in isolation in COs  */
gen is_working_condition = 1 if ///
			aid == 9 | ///
			aid == 34 

/*Categorie 2: Visas
89) Help for visas/ paid travels for visas  
83) visa compliance 
93) Leaving the country for visa compliance: 1. it's costly 
and 2. it's WAY more costly if you're from a developing 
country that needs visa for everywhere.   
43) For sake of getting work visa renewal in country of work, 
would be better to have ETC style contract */			
gen is_visa = 1 if ///
			aid == 89 | ///
			aid == 83 | ///
			aid == 93 | ///
			aid == 43

/*Categorie 3: Horizontal Mobility
10) Not very open to inter-sector mobility within DIME
13) Lack of flexibility to work on different projects 
(RAs/FCs may be interested in more than one thematic area)   */
gen is_horizontal_mobility = 1 if ///
			aid == 10 | ///
			aid == 13 

/*Categorie 4: Length contract
21) Contract type and respect of the limit of days: if STC, en
sure RAs do not work more than 150 days to incentivize TTLs 
to transition STCs to ETCs 
31) All RAs and FCs need to be ETCs, it is impossible for a FC or 
RA to work on more than 1 IE in a fiscal year within 150 days. 
Every RA that is working on 2 or more IEs currently is working 
more than the allotted 150 days on the STCs contract. For an RA 
to work from data collection to the final report for 2 or more 
projects it takes more than 150 days. Especially, if the TTL 
expects final report that is of good quality where all the 
data cleaning and analysis are solid and sound and do-files 
have been double-checked.  
59) Contract is too short: I have worked for more number of 
days than I could bill.
65) Working full time with a part time contract, or more days 
than formally in the contract.  
81) Mismatch between long-term needs and type of contract: 
When a position is needed on a single project over several 
years, what's the logic in filling it with an STC contract? 
79) Working the number of days we're paid: There needs to be 
clear guidance that STCs cannot be asked to work more 
days than they're paid for   */
gen is_contract_length = 1 if ///
			aid == 21 | ///
			aid == 31 | ///
			aid == 59 | ///
			aid == 65 | ///
			aid == 81 | ///
			aid == 79

/*Category 5: Contracts
27) Improvement on contract structure situation
6) Contract type
8) Benefits
13)  Nature of STC contract 
22) Contract type
37) Contract Type
48) contract type
56) Contract type
77) contract type
28)  Understanding the difference between the contract types 
and if any regimes for health insurance and pension scheme 
could be provided with some contracts. 
44) Should be possible to hold ETC contract and be based in 
'field' for those of us that are interested to do ETC contract, 
but have no desire to be based in DC. How can we make this 
possible (ex, couple of trips a year to DC with frequent video calls)?  
7) Contract type. As FC is implied that we are available 
everyday, and coordinating logistics, or doing data analysis, 
however, our contract doesn't cover any health insurance. 
In many cases it doesn't take into account the differences in 
housing/food/other expenses. */
gen is_contract_type = 1 if ///
			aid == 27 | ///
			aid == 8  | ///
			aid == 13 | ///
			aid == 22 | ///
			aid == 37 | ///
			aid == 48 | ///
			aid == 56 | ///
			aid == 77 | ///
			aid == 28 | ///
			aid == 44 | ///
			aid == 7

/*Category 6: Health Insureance  
28)  Understanding the difference between the contract types 
and if any regimes for health insurance and pension scheme 
could be provided with some contracts
19) Lack of Health Insurance for STCs which can be dangerous   
7) Contract type. As FC is implied that we are available 
everyday, and coordinating logistics, or doing data analysis, 
however, our contract doesn't cover any health insurance. 
In many cases it doesn't take into account the differences in 
housing/food/other expenses.
12) Health insurance*/
gen is_health_insurance = 1 if ///
			aid == 28 | ///
			aid == 19 | ///
			aid == 7  | ///
			aid == 12

/*Category 7: Transparency 
24) Salary transparency for all DIME members
74) Payments lack of transparency for STC. The number of days 
I am allocated always seem to come from nowhere. Why 60 days 
and not 80 or 40? My TTL has full discretion on that, no matter 
how many days I actually spend working. Because of this lack 
of transparency, it is very difficult to signal when the number 
of days is not enough.
89) ETCs opening and advertising. 
20) Transparency in contracting and positions,...
32) There needs to be greater transparency of hiring and the 
career structure within DIME. If an RA or FC has proven 
himself/herself to be worthy of a promotion than give that 
person a promotion, do not open an ETC contract and say it 
is open and competitive when all the RA's are well aware who 
the contract is for. The RAs work hard and they should 
be compensated with promotions or contract improvements.  
58)  Greater transparency with regards to hiring.  */
gen is_transparency = 1 if ///
			aid == 24 | ///
			aid == 74 | ///
			aid == 89 | ///
			aid == 20 | ///
			aid == 32 | ///
			aid == 58 

/*Category 8: Career Guidance
34) Career guidance
38) Career Guidance
46) career guidance
53) Career guidance
57) Career guidance
78) career guidance
11) Lack of guidance that is needed in a professional 
environment (there is a lot of work-related guidance from 
TTLs, this issue is about fostering a place the employee 
feels more valued)  
15) Lack of career guidance/mentoring.
26) Mentorship program: road to a solid Phd program  
39) Mentorship 
60) More interactions with DIME economists: I would like the 
opportunity to interact with other TTLs who could give me 
guidance regarding career, new research projects etc. Currently, 
there is a disconnect between the economists and STCs, in 
that STCs do not get to interact with an yone other than our TTLs.
84) future for RAs/FCs, career guidance  
8) Career Guidance: As a person that entered the Bank directly 
into the field, there's no institutional guidance on how to 
open up other opportunities -- and the networking opportunity of 
being in HQ is out of the formula -- the little information 
that I have is through my TTL, but it's not enough.
55) Personal development 
71) Career guidance and mentoring program
90) Mentorship program on how to get a phd and get feedback 
on proposal
23) Career tracks
29) Understanding the type of skills or qualifications needed 
to become a staff   
*/

gen is_career_guidance = 1 if ///
			aid == 34 | ///
			aid == 38 | ///
			aid == 46 | ///
			aid == 53 | ///
			aid == 57 | ///
			aid == 78 | ///
			aid == 11 | ///
			aid == 15 | ///
			aid == 26 | ///
			aid == 39 | ///
			aid == 60 | ///
			aid == 84 | ///
			aid == 8  | ///
			aid == 55 | ///
			aid == 71 | ///
			aid == 90 | ///
			aid == 23 | ///
			aid == 29 

/*Category 9: Career Progress
35) Future for STCs
62) Future for STCs
42) Clear path to ETC or Staff positions
47) future for FCs
50)  Personal development and career progression as FCs: what 
to expect in terms of future pathways within and outside DIME, 
available training for people in the field, opportunities to 
collaborate with other teams. Who do we turn to for these issues?
54) future for RAs/FCs 
84) future for RAs/FCs, career guidance  
33)  There needs to be a future (career path) for RA's after 2 
years, especially for those that do not want to pursue a PhD 
but want to continue working in DIME. Not every RA wants to get 
a PhD, some want to continue to work in research and move up 
the ranks. If an RA works hard within DIME for several years 
learning all he/she can from their TTL about running and 
implementing an IE there is no reason why that RA should not 
eventually grow within DIME and potential start to help implement 
and lead their own projects. Pursing a PhD is a substantial 
financial and emotional cost for an individual, an economics PhD 
in the US takes about 5-7 years to complete. What if an RA 
spent that time implementing and working on IEs for TTLs. 
That is just a good as an education on working in the 
development economics field.   
 */
gen is_career_progress = 1 if ///
			aid == 35 | ///
			aid == 62 | ///
			aid == 42 | ///
			aid == 47 | ///
			aid == 50 | ///
			aid == 54 | ///
			aid == 84 | ///
			aid == 33

/*Category 10: Learning Opportunities
45) Would be nice to have more training opportunities 
and chances to attend workshops/conferences on behalf of our 
projects.
52) Training  */
gen is_learning_opportunities = 1 if ///
			aid == 45 | ///
			aid == 52 

/*Category 11: Management
2) Lack of professionalism 
6) Lack of constructive criticism/feedback
66) Lack of constant feedback and clear channels to express 
concerns and ask questions   */
gen is_management  = 1 if ///
			aid == 6  | ///
			aid == 66 | ///
			aid == 2

/* Category 12: Communication Field
1) How to improve links between DIME and CMU: how to engage 
dialogue between researchers on the one hand and CMU staff
and clients on the other.  */
gen is_communication_field = 1 if ///
			aid == 50 

/*Category 13: Misunderstanding in DIME changes
72) Changes being discussed now about future for RAs/FCs
with DIME as a department  
14) Specific roles and future for RAs/FCs is not clear with 
the recent management changes.
26) Future of DIME internal communications: RA/FC "union"? 
 */
gen is_misund_DIME_changes = 1 if ///
			aid == 72 | ///
			aid == 14 | ///
			aid == 26 

/*Categroy 14: Misunderstanding STC contract and roles
74)  Scope of the tasks TTL can assign to FC. It is always 
difficult to know whether our TTL is too demanding. For instance,
I was a bit puzzled when my TTL required me to draft a working 
paper from the baseline data, with no guidelines. I clearly 
thought it was too much to ask. But I did not know how to check 
whether that was the case or not.  
91) Lack of clarity even when you start working, TTLs and staff 
cannot provide information and you have to ask 
other RAs and consultants.  
92) Lack of clarity of contract conditions before accepting 
job (under-report, leaving the country for visa compliance) 
51)  Contractual arrangements: have a clearer visibility 
beyond the typical 150-day contract (especially as one's 
contract draws towards the end), more transparency on salary 
grids and benefits across contract types (STC, ETC, staff, etc.) 
 */
gen is_misund_contract = 1 if ///
			aid == 74 | ///
			aid == 91 | ///
			aid == 92 | ///
			aid == 51 

/*
Category 15: Misunderstanding in career and growth
28) Understanding career opportunities after short term contract 
(for instance ETC seem to be limited to 2 years max, what can 
be offered next? Or what could a person do after multiple 
missions as an STC? Is there any more stable position opened)  
84) STC conditions: what to do after 150 days of work 
51)  Contractual arrangements: have a clearer visibility 
beyond the typical 150-day contract (especially as one's 
contract draws towards the end), more transparency on salary 
grids and benefits across contract types (STC, ETC, staff, etc.)    
71) Current stats at DIME, i.e. average time of being RA/FC, 
RA/FC proportion of all DIME staff, career path stats of 
previous RA/FCs (PhD placements, staff placements, other 
if possible, etc)  */
gen is_misund_career = 1 if ///
			aid == 28 | ///
			aid == 84 | ///
			aid == 51 | ///
			aid == 71


global var_issues 	is_working_condition is_visa is_horizontal_mobility ///
					is_contract_length is_contract_type is_health_insurance ///
					is_transparency is_career_guidance is_career_progress ///
					is_learning_opportunities is_management ///
					is_communication_field is_misund_DIME_changes ///
					is_misund_contract is_misund_career					


collapse (sum) $var_issues, by(iid)

merge 1:1 iid using "$analysis_dt/02. Base/DIMERA_Union_agenda_Prep.dta"

order $var_issues, a(issue3)
drop _merge

summarize $var_issues

save "$analysis_dt/03. Temp/DIMERA_Issues", replace

use "$analysis_dt/03. Temp/DIMERA_Issues", clear

collapse (mean) $var_issues
cap ssc inst sxpose
xpose, v clear
list

ren _varname categories_issues
ren v1 average_issues

replace categories_issues = "Working Conditions" if categories_issues == "is_working_condition" 
replace categories_issues = "Visa" if categories_issues == "is_visa" 
replace categories_issues = "Horizontal Mobility" if categories_issues == "is_horizontal_mobility" 
replace categories_issues = "Contract Length" if categories_issues == "is_contract_length" 
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

graph pie average_issues, over(categories_issues)

graph pie average_issues, over(categories_issues) ///
	pie(_all, explode) ///
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
		lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))

graph export "$analysis_out\cat_issues.pdf", as(pdf) replace
 
*--------------------1.2:


/*====================================================================
                        2: Solutions
====================================================================*/

use "$analysis_dt/03. Temp/DIMERA_Issues", clear


*--------------------2.1: Categories

tab solution1, m 
tab solution2, m 
tab solution3, m 

*--------------------2.2:
list solution1, table notrim
list solution2, table notrim
list solution3, table notrim

preserve
keep iid solution1
tempfile solution1
save `solution1'
restore

preserve
keep iid solution2
tempfile solution2
save `solution2'
restore

preserve
keep iid solution3
tempfile solution3
save `solution3'
restore

use `solution1', clear
append using `solution2'
append using `solution3'

sort iid
gen aid = _n

*Number of issues
gen solution = solution1
replace solution = solution2 if mi(solution)
replace solution = solution3 if mi(solution)
tab solution
*57 solutions 

/*Categorie 1: Mentorship
3) Have another TTL work as a "buddy" / "mentor" with you. 
(Think McKinsey has something similar where you can reach 
out to a staff member who you have not worked with)  
34) Create clear paths for career progression, including 
performance reviews, goal setting and mentoring
10) Create the mentorship program around a buddy system 
(prevalent in the private sector) where another 
sector/industry's staff member (like an Economist) meets once 
or twice a quarter with the RA/FC for coffee chats 
13) Develop a career guidance & mentoring program for RAs/FCs 
46) Set up a mentorship program to help FCs to pursue their goal   
 */
gen sol_mentorship = 1 if ///
			aid == 3 | ///
			aid == 34 | ///
			aid == 10 | ///
			aid == 13 | ///
			aid == 46  

/*Categorie 2: Position protocol
8) First screening process of candidates for new position 
should be anonymous. So it's avoided to pre-select 
"favorite candidate!" for the position, and do the first
screening based on basic profile characteristics or exam 
(with an ID), and after select a small pool, then with the 
interview the selected one will compete. 
29)  More clear and transparent career section on the dime webpage
31) Every single RA that is not currently going to be attending 
a PhD program in the Fall of 2019 should be transitioned 
from an STC to ETC by the start of the new fiscal year. This 
will make it so that every RA is not restricted by the 150 days 
contract and can spend more time working on projects without 
worrying about how many days he/she has left. This will greatly 
improve morale among RAs and lead to a better improvement in 
quality because RAs will finally be compensated for everyday 
that they have worked.  
28) More information on openings. Sometimes some STC 
opportunities are published on DIME webpage without being 
shared with the internal staff so that we are not necessarily 
aware of them  
88) Fro the mentorship, through a time allocated to RAs to do 
brainstorm and do short presentation on their proposal  
89) Open applications with information about the position but 
make it clear positions can be open expost 
 */
gen sol_openings_protocol = 1 if ///
			aid == 8 | ///
			aid == 29 | ///
			aid == 31 | ///
			aid == 28 | ///
			aid == 88 | ///
			aid == 89 
/*
Categori 3: Mobility
11) Need to create an environment where RAs can approach 
those in other sectors openly within DIME 
42)  More cross-GP work, this will enable FC/RAs to network 
and find opportunities outside DIME. 
21) Allow for more possibilities of working accross projects / 
DIME analytics or other to make it easier to get the budget 
for ETC or staff position  
35) Pair up FCs in COs with people in DC so they work together 
on projects
37) Possibility to work with other TTLs within the same team 
(at least at the beginning) 
59) Organize events for more interaction between RAs/FCs and 
Economists. Circulate lists of projects and staff requirements 
so RAs/FCs could volunteer research time with IEs that are more 
aligned with their personal research interests.  
14) Increase horizontal mobility (flexibility to work on 
different projects) */
gen sol_job_mobility = 1 if ///
			aid == 11 | ///
			aid == 42 | ///
			aid == 21 | ///
			aid == 35 | ///
			aid == 37 | ///
			aid == 59 | ///
			aid == 14

/* Categorie 4: Roles and Career Path
15) Clarify roles and possible career paths for RAs/FCs with 
the recent management changes  
35) Career structure for RAs 
43) Have a more structured path of progression of responsibility, 
even while still based in the field.
47) Perform a personnal development plan in order to be aware 
of FCs expectations in the following years
32) Create a career path for RAs who do not want to pursue PhD. 
After 2 years at working at DIME RAs should either be promoted to 
be Research Analysts or let go if the TTL does not think they 
were a fit they should not continue to be an RA while taking on 
more responsibilities as the number of IEs managed by DIME 
continues to grow. This structure will send a signal to current 
and incoming RAs that DIME will invest in you if you invest time 
and energy into the team. It will also lead to a salary 
improvement for RAs, knowing that their hard worked has been off 
after 2 years. 
57) TTLs should be following more closely RA's work, interests, 
and future plans. Also, based on this, RAs should be 
seen as potential co-authors in the future (when out of DIME) 
and therefore included more closely in project definition and 
design.
22) Horizontal mobility is great but there is virtually no 
vertical mobility for RAs/FCs. There should be more stable 
RAs/FCs so DIME can finally start building institutional 
knowledge.
49) Jointly develop (DIME management, TTLs, some representatives 
of FCs and RAs) a clear personal development strategy for its 
consultants, covering training opportunities, career pathways, 
collaboration with other teams within-beyond DIME..
55) Following the last point, it would be great to focus more of 
our time on work that will benefit as in the future (closer to 
research for RAs interested in PhDs, data for data-scientists 
geeks, operations for RAs pursuing a career in the Bank). 
I understand that some survey and data work need to be done, 
but with DIME expansion there should be some diversification 
to allow low- and high-skill jobs to be differentiated.
*/
gen sol_structure_role_career = 1 if ///
			aid == 15 | ///
			aid == 35 | ///
			aid == 43 | ///
			aid == 47 | ///
			aid == 32 | ///
			aid == 57 | ///
			aid == 22 | ///
			aid == 49 | ///
			aid == 55 

/*
Categorie 5: Heatlh Insurance
16) DIME to cover health insurance for STCs
63) Basic health coverage for FCs  
12) Not much can be done about the health insurance as it is a
Bank-wide issue and DIME probably cannot act on its own even if 
it wanted to get its RAs/FCs better coverage  
 */
gen sol_health_insurance = 1 if ///
			aid == 16 | ///
			aid == 63 | ///
			aid == 12 

/*Categroie 6: Feedback
24) There should be a mandatory feedback system between 
TTL and RA/FCs.  
51) Performance Assessment */
gen sol_performance_review = 1 if ///
			aid == 24 | ///
			aid == 51 

/* Categorie 7: Type of contract
26) ETC contracts 
56) The way STC contracts are used at the Bank ridiculous and 
should be used only for actually SHORT TERM positions and not 
for DC-based actual full-time workers. The increasing supply 
of labor coming from universities around the world is not an 
excuse. See other international organizations in DC for comparison. 
58) Increased number of days on the contract.
65) Enforce STC contracting rules. 
82) Increase number of ETCs
81)  Clear guidance sent by DIME management stating that STCs 
cannot be asked to work more days than we're paid, with 
guarantee that we'll be supported in case we resist that  
84) Provide other opportunities for STCs after 150 days of work
- with other Intl organizations / NGOs, projects, etc. */
gen sol_type_contract = 1 if ///
			aid == 26 | ///
			aid == 56 | ///
			aid == 58 | ///
			aid == 65 | ///
			aid == 82 | ///
			aid == 81 | ///
			aid == 84

/*Categorie 8: More communication
93) Explain clearly working conditions when making the offer 
and also make it part of the onboarding (how to submit your 
visa, how to change work schedule, etc) 
75) My suggestion would be that at the beginning of each 
fiscal year, the TTL provides some explanations on how the 
number of days was determined
7) Better communication between DIME and Country Office on what 
would be the working conditions, at least having a place to 
work assigned. 
17) Formal system to set up in country offices to accomodate 
and integrate FCs   
25) RA/ FC union to improve internal comms 
19)  Create a regular update of the situation of STC in DIME 
(similar to what is done at the bank level) : percentage of STC 
working without contract, working more than 150 days, working 
with no health insurance, feeling they don't have possibilities 
to grow,... with potential breakdown per main sectors 
(health, transport,... as long as it can stays anonymous) 
to be shared and discussed with whole team.
33)  Whenever there is a new position or promotion let everyone 
know by sending it out in an email to the entire team and 
bringing it up in the staff meeting. If DIME is expected to grow 
everyone needs to know that if you work hard you will be 
compensated and that should be praised. New positions should 
truly be competitive and be known to everyone within DIME so 
that everyone has an equal chance of being selected. 
48)  Communicate on this program if their already exist  
 */
gen sol_communication = 1 if ///
			aid == 93 | ///
			aid == 75 | ///
			aid == 7  | ///
			aid == 25 | ///
			aid == 19 | ///
			aid == 33 | ///
			aid == 48 | ///
			aid == 17

/*Categorie 9: DIME Management
20) Limit the number of STCs a TTLs can have at the same 
time (or ratio non STC to STC in the same team) 
50) Hire someone dedicated to HR/professional development 
issues or better compel/train TTL to do so 
64) Have better management within the teams and across 
DIME overall   */
gen sol_dime_management = 1 if ///
			aid == 20 | ///
			aid == 50 | ///
			aid == 64 

/*Categorie 10: Free Parole support structure
79) A process whereby STCs can speak to someone neutral at 
DIME (i.e. not the person giving them a contract) so that we 
can raise issues without fearing the contract could be 
discontinued 
51) Organize FCs and RAs regular meeting to discuss grievances 
and opportunities
53)  More social interactions across different teams and among 
RA's and FC's to share common challenges and experiences. 
74) Provide a device where FC can inquire anonymously whether 
a task assigned by TTL is justified or bit borderline. */
gen sol_free_speech_structure = 1 if ///
			aid == 79 | ///
			aid == 51 | ///
			aid == 53 | ///
			aid == 74 	

/* 
Categorie 11: Visa
90)  For the visas, provide a budget allocated to helping 
RAs to travel */
gen sol_visa = 1 if ///
			aid == 90 										


/*Categorie 12: More transparency
23) It is unclear how STC rates are set. There needs to be a 
clearer standards.
45) More transparency in terms of what RA and FC job descriptions 
are and access to trainings that can allow FC to be at RA skill 
level. Online trainings would be good for FCs based all over world.
 */
gen sol_transparency = 1 if ///
			aid == 23 | ///
			aid == 45 							


/*Categorie 13: Training
45) More transparency in terms of what RA and FC job descriptions 
are and access to trainings that can allow FC to be at RA skill 
level. Online trainings would be good for FCs based all over world.
 */

gen sol_training = 1 if ///
			aid == 45 							



global var_solutions 	sol_mentorship sol_openings_protocol ///
						sol_job_mobility sol_structure_role_career ///
						sol_health_insurance sol_performance_review ///
						sol_type_contract sol_communication ///
						sol_dime_management sol_free_speech_structure ///
						sol_visa sol_transparency sol_training

collapse (sum) $var_solutions, by(iid)

merge 1:1 iid using "$analysis_dt/03. Temp/DIMERA_Issues.dta"

order $var_solutions, a(solution3)
drop _merge

summarize $var_solutions

save "$analysis_dt/03. Temp/DIMERA_Issues_Solutions", replace

use "$analysis_dt/03. Temp/DIMERA_Issues_Solutions", clear

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

graph export "$analysis_out\cat_solutions.pdf", as(pdf) replace
 								

/*====================================================================
                        3: Others
====================================================================*/

use "$analysis_dt/03. Temp/DIMERA_Issues_Solutions", clear

*--------------------3.1:

tab add_other, m
list add_other, table notrim

*For the change in DIME Strucutre
/*
 There needs to proposal and fundraising unit within DIME. 
Economists splitting their time between fundraising for new 
project, proposal writing and research will eventually lead 
to a high burnout rate among the staff and the quality of the 
products that DIME produces will suffer. DIME needs a large 
team of proposal writes and fundraisers who can work with 
economists to obtain new projects and fundraise money for them, 
this team will be composed of operational staff who have 
experience with proposal writing and fundraising and their 
sole missing is to write proposals and fundraise for projects 
for DIME. There also needs to a an event planning and workshop 
unit. This will also be composed of operational staff that will 
solely focus on organizing and planning all the events and 
workshops that DIME leads in a fiscal year. This will take 
some pressure off economists and some RAs and will lead to 
better events and workshops since there will be a dedicated 
team to work on them instead of having economists and RAs do 
it which takes time away from them to work on their existing 
projects and sometimes leads to events and workshops that are
not a fulfilling experience.  
*/

save "$analysis_dt/04. Final/DIMERA_Cleaned", replace

*--------------------3.2:


/*====================================================================
                        4: 
====================================================================*/


*--------------------4.1:


*--------------------4.2:





exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control:


