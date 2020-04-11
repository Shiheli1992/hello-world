*Lean the loop in STATA and append multiple files
*URL:https://www.lianxh.cn/news/ca5082adbf97f.html

*Download csv data from internet
cd "D:\Leo\STATA_learning\"       /*address to save data*/

local URL="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/" /*link*/
forvalue month=1/4{
forvalue day=1/31{
local month=string(`month',"%02.0f")/*adjust the sytle to 2-digit*/
local day=string(`day',"%02.0f")
local year="2020"
local today= "`month'-`day'-`year'"
local Filename="`URL'`today'.csv"
clear
capture import delimited "`Filename'" /*capture command will let the error continue, as some day the data might be missing, which cause error and stop the loop*/
capture rename ïprovincestate provincestate /*adjust the variable names*/
capture rename province_state provincestate
capture rename country_region countryregion
capture rename last_update lastupdate
capture rename lat latitude
capture rename long_ longitude
capture rename ïfips fips
capture rename 
capture save "`today'", replace /*the data will be saved in .dta file*/ 
}
}

*append the data 
clear
forvalue month=1/4{
forvalue day=1/31{
local month=string(`month',"%02.0f")
local day=string(`day',"%02.0f")
local year="2020"
local today= "`month'-`day'-`year'"
capture append using "`today'"     /*not need to state .dta*/ 
}
}

clear 
forvalue month=1/4{
forvalue day=1/31{
local month=string(`month',"%02.0f")
local day=string(`day',"%02.0f")
local year="2020"
local today= "`month'-`day'-`year'"
capture use "`today'"
capture gen date="`today'"
save "`today'",replace  
clear
}
}


/*twoway bar- daily 1/30 */
use "D:\Leo\STATA_learning\04-08-2020.dta"
gen current_confirmed = confirmed - deaths - recovered
replace current_confirmed = 0 if current_confirmed < 0
bys countryregion : egen cc=total( current_confirmed)
duplicates drop country cc, force
gsort - cc 
keep in 1/30
sencode countryregion, gen(country_id)
drop countryregion
rename country_id country
label variable country "Country"
twoway bar cc country,sort horizontal barwidth(0.5) fcolor(red) ylabel(1(1)30, valuelabel angle(0) labsize(*0.5))



