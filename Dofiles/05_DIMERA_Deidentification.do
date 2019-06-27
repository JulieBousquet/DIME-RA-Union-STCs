
* DEIDENTIFIED TO SHARE

use "$analysis_dt/04. Final/DIMERA_Cleaned", clear

order iid
lab var iid "Individual ID"

tab name, m
replace name  = "[REDACTED]"

tab region, m
ren region region2 
decode region2, gen(region)
tostring region, replace
replace region = "[REDACTED]"
drop region2
order region, a(dime_duration)

tab country, m 
ren country country2 
decode country2, gen(country)
tostring country, replace
replace country = "[REDACTED]"
drop country2
order country, a(region)

tab contract_type, m
ren contract_type contract_type2 
decode contract_type2, gen(contract_type)
tostring contract_type, replace
replace contract_type = "[REDACTED]"
drop contract_type2
order contract_type, a(country)

replace issue1  = "[REDACTED]" 
replace issue2  = "[REDACTED]" 
replace issue3  = "[REDACTED]" 
replace solution1  = "[REDACTED]" 
replace solution2  = "[REDACTED]" 
replace solution3  = "[REDACTED]" 
replace add_other  = "[REDACTED]"

save "$analysis_dt/05. Shared/DIME_STCS_Clean_Deidentified", replace

use "$analysis_dt/04. Final/DIMERA_Issues", clear

lab var iid "Individual ID" 
tostring iid, replace
replace iid  = "[REDACTED]"


save "$analysis_dt/05. Shared/DIME_STCS_Issues_Deidentified", replace


use "$analysis_dt/04. Final/DIMERA_Solutions", clear

lab var iid "Individual ID" 
tostring iid, replace
replace iid  = "[REDACTED]" 



save "$analysis_dt/05. Shared/DIME_STCS_Solutions_Deidentified", replace
           















