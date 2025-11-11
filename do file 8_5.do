cd "D:\IRDHA\KULIAH\SEMESTER 8\SKRIPSI"
use "Irdha_Potensi Desa 2024.dta"
rename R101 prov
rename R102 kab
rename R103 kec
rename R104 desa
rename R1004 internet
rename R1005A bts
rename R1005B telp
rename R1005C signal
rename signal signal_t
help label
label variable signal_t "Sinyal telepon seluler"
rename R1005D signal_i
label variable signal_i "Sinyal internet telepon seluler"
rename R1006A pc
rename R1006B fas
label variable fas "Fasilitas internet di kantor kepala desa"
sum R105
rename R105 status
keep IDDESA prov kab kec desa internet bts telp signal_t signal_i pc fas status
collapse (mean) bts_kab = bts, by(kab)
clear all
cd "D:\IRDHA\KULIAH\SEMESTER 8\SKRIPSI"
use "Irdha_Potensi Desa 2024.dta"
rename R101 prov
rename R102 kab
rename R103 kec
rename R104 desa
rename R1004 internet
rename R1005A bts
rename R1005B telp
rename R1005C signal
rename signal signal_t
help label
label variable signal_t "Sinyal telepon seluler"
rename R1005D signal_i
label variable signal_i "Sinyal internet telepon seluler"
rename R1006A pc
rename R1006B fas
label variable fas "Fasilitas internet di kantor kepala desa"
sum R105
rename R105 status
keep IDDESA prov kab kec desa internet bts telp signal_t signal_i pc fas status
br
destring kab, replace
describe bts telp signal_t signal_i pc fas
save "Podes24_1 8_5.dta", replace
tab bts
set more off
collapse(mean) bts_kab = bts, by(kab)
br
sum bts_kab
tab bts_kab
br
clear
use "Podes24_1 8_5.dta"
collapse (sum) bts_kab = bts (sum) fas_kab = fas (sum) internet_kab = internet (sum) telp_kab = telp (sum) signal_tk = signal_t (sum) signal_ik = signal_i, by(kab)
br
clear
use "Podes24_1 8_5.dta"
destring prov, replace
gen kodekab = prov + kab
save "Podes24_1 8_5.dta", replace
clear
use "Irdha_Sakernas Februari 2024.dta"
sum B5R7_KAB
clear
use "Podes24_1 8_5.dta"
collapse (sum) bts_kab = bts (sum) fas_kab = fas (sum) internet_kab = internet (sum) telp_kab = telp (sum) signal_tk = signal_t (sum) signal_ik = signal_i, by(kodekab)
save "Podes24_2 8_5.dta"
clear
use "Irdha_Sakernas Februari 2024.dta"
rename B5R7_KAB kodekab
sum
sum kodekab
drop if kodekab == .
rename PSU psu
rename STRATA strata
rename KLAS status_s
rename B4K4 gender
rename B4K10 umur
rename B5R4 marital
tab B5R5
tab B5R6A
rename B5R6A edu
tab B5R9A
tab B5R9B
rename KODE_PROV prov
br
rename B5R9A kerja
rename B5R13A status_kerja
rename B5R14AKATE kbli20
rename B5R14AKAT0 kbli15
br
sum B5R15_1
sum B5R15_2
br
rename B5R15_1 wage
rename B5R16A sektor
sum sektor
sum
sum B5R18A_JML
sum B5R18A_BLT
tab B5R18A_JML
tab B5R18A_BLT
rename B5R18A_JML jam
rename B5R18A_BLT jam_blt
rename B5R19A1 pc
rename B5R19A2 hp
rename B5R19A3 tech_o
rename B5R19B internet
rename B5R19C1 i_kom
rename B5R19C2 i_prom
rename B5R19C3 i_jual
rename i_jual i_jual_s
rename B5R19C4 i_jual_w
rename B5R19C5 i_o
rename B5R20 instansi
rename B5R23A1 frwage
keep prov status_s psu strata gender umur marital edu kodekab kerja status_kerja kbli20 kbli15 wage sektor jam jam_blt pc hp tech_o internet i_kom i_prom i_jual_s i_jual_w i_o instansi frwage
br
save "Sakernas24_1 8_5.dta"
tab kbli20
keep if inlist(sektor, 1, 3, 5, 7)
clear
use "Sakernas24_1 8_5.dta"
keep if inlist(sektor, 1,2,3,4,6,8,9,15,17)
tab sektor
clear
use "Sakernas24_1 8_5.dta"
keep if inlist(sektor, 1, 2, 3, 4, 6, 8, 9, 15, 17)
clear
use "Sakernas24_1 8_5.dta"
drop if inlist(sektor, 5, 7, 10, 11, 12, 13, 14, 16)
tab sektor
br
clear
use "Sakernas24_1 8_5.dta"
br
destring sektor, replace
tab sektor
keep if inlist(kbli20, 1, 2, 3, 4, 6, 8, 9, 15, 17)
tab kbli20
br
tab wage
drop if wage ==.
br
br
tab internet
drop if internet==.
tab umur
keep if umur >= 15 & umur <= 60
br
drop frwage
tab i_kom
save "Sakernas24_2 8_5.dta", replace
use "Sakernas24_2 8_5.dta"
set more off
merge m:1 kodekab using "Podes24_2 8_5.dta"
br
clear
use "Sakernas24_2 8_5.dta"
set more off
merge m:1 kodekab using "Podes24_2 8_5.dta"
drop if internet==.
reg wage internet, r
reg wage internet gender umur marital edu status_kerja pc hp tech_o, r
reg wage internet gender umur marital edu status_kerja pc hp tech_o jam_blt , r
gen lnwage=.
drop lnwage
gen lnwage=ln(wage)
br
drop if lnwage==.
reg lnwage internet gender umur marital edu status_kerja pc hp tech_o jam_blt , r
reg lnwage internet gender umur marital edu status_kerja jam_blt , r
tab internet
replace internet=1 if internet==1
replace internet=0 if internet==2
label variable internet "Aksesibilitas Internet sakernas, Punya=1 ; TIdak Punya=0"
reg lnwage internet gender umur marital edu status_kerja jam_blt , r
****OLS
reg lnwage internet gender umur marital edu status_kerja jam_blt , r
*****firs stage
tab internet
tab bts_kab
br
clear
use "Sakernas24_2 8_5.dta"
tab kodekab
destring kodekab, replace
clear
use "Podes24_1 8_5.dta"
tab kodekab
clear
use "Podes24_1 8_5.dta"
clear
use "Podes24_2 8_5.dta"
tab kodekab
clear
use "Podes24_1 8_5.dta"
tab prov
drop kodekab
gen kodekab = string(prov, "%02.0f") + string(kab, "%02.0f")
tab kodekab
save "Podes24_2 8_5.dta", replace
clear
use "Sakernas24_2 8_5.dta"
destring kodekab, replace
tab kodekab
clear
use "Podes24_2 8_5.dta"
desc kodekab
destring kodekab, replace
save "Podes24_2 8_5.dta", replace
use "Sakernas24_2 8_5.dta"
sum kodekab
clear
use "Podes24_2 8_5.dta"
sum kodekab
clear
use "Sakernas24_2 8_5.dta"
clear
use "Podes24_2 8_5.dta"
clear
use "Podes24_1 8_5.dta"
clear
use "Podes24_2 8_5.dta"
tab kodekab
save "Podes24_1 8_5.dta", replace
use "Podes24_1 8_5.dta"
collapse (sum) bts_kab = bts (sum) fas_kab = fas (sum) internet_kab = internet (sum) telp_kab = telp (sum) signal_tk = signal_t (sum) signal_ik = signal_i, by(kodekab)
save "Podes24_2 8_5.dta", replace
clear
use "Podes24_2 8_5.dta"
tab kodekab
clear
use "Sakernas24_2 8_5.dta"
merge m:1 kodekab using "Podes24_2 8_5.dta"
sum bts_kab
br
drop if internet==.
*****firs stage
reg internet bts_kab signal_ik umur gender edu kerja, r
reg internet bts_kab signal_ik umur gender kerja, r
reg internet bts_kab signal_ik signal_tk fas_kab internet_kab status_s pc hp tech_o, r
reg internet bts_kab signal_ik signal_tk fas_kab status_s pc hp tech_o, r
reg internet_kab bts_kab signal_ik signal_tk fas_kab status_s pc hp tech_o, r
reg internet bts_kab signal_ik fas_kab status_s pc hp tech_o, r
gen lnwage=ln(wage)
drop if lnwage==.
ivregress 2sls lnwage (internet = bts_kab) umur status_s gender marital edu kerja jam_blt, r
sum
sum _merge
sum _merge
tab _merge
drop if _merge ==1
reg internet bts_kab signal_ik fas_kab status_s pc hp tech_o, r
drop if internet==.
drop if bts_kab==.
drop if lnwage==.
tab gender
br
sum
reg internet bts_kab signal_ik fas_kab status_s pc hp tech_o internet_kab, r
reg internet signal_ik bts_kab, r
reg internet bts_kab internet, r
reg internet bts_kab signal_ik, r
reg internet bts_kab signal_ik fas_kab status_s pc hp tech_o telp_kab, r
sum
save "Merge_1.dta"
reg bts_kab umur,r
reg bts_kab signal_ik, r
reg internet bts_kab status_s umur edu kerja,r
tab kerja
replace kerja=0 if kerja==2
reg internet bts_kab status_s umur edu kerja,r
reg internet bts_kab signal_ik status_s umur edu kerja,r
***model first stage 1
reg internet bts_kab signal_ik status_s umur edu kerja,r
***kontrol = yang memengaruhi internet accesibility individu tapi nggak memengaruhi jumlah stasiun pemancar sinyal
reg bts_kab signal_ik, r
reg bts_kab umur, r
reg bts_kab kerja, r
reg bts_kab status_s
reg lnwage bts_kab status_s umur edu kerja gender, r
reg lnwage internet status_s umur edu kerja gender, r
estimates store reg
reg lnwage internet status_s umur edu kerja gender jam_blt,r
estimates store reg
ivregress 2sls lnwage (internet = bts_kab) status_s umur edu kerja gender jam_blt,r
ivregress 2sls lnwage (internet = bts_kab) status_s umur edu kerja gender jam_blt, robust first
ivregress 2sls lnwage (internet = bts_kab) signal_ik status_s umur edu kerja gender jam_blt,r
ivregress 2sls lnwage (internet = bts_kab) signal_ik status_s umur edu kerja gender jam_blt,robust first
ivregress 2sls lnwage (internet = bts_kab) signal_ik status_s umur edu kerja gender jam,robust first
ivregress 2sls lnwage (internet = bts_kab) signal_ik status_s umur edu kerja gender jam pc hp tech_o,robust first
ivregress 2sls lnwage (internet = bts_kab) signal_ik signal_tk status_s umur edu kerja gender jam pc hp tech_o, robust first
ivregress 2sls lnwage (internet = bts_kab) kbli20 status_s umur edu kerja gender jam pc hp tech_o, robust first
ivregress 2sls lnwage (internet = bts_kab) signal_ik kbli20 status_s umur edu kerja gender jam pc hp tech_o, robust first
ivregress 2sls lnwage (internet = bts_kab) kbli20 status_s umur edu kerja gender marital jam pc hp tech_o, robust first
ivregress 2sls lnwage (internet = bts_kab) kbli20 status_s umur edu kerja gender marital jam pc hp tech_o status_kerja , robust first
ivregress 2sls lnwage (internet = bts_kab) kbli20 status_s umur edu kerja gender marital jam pc hp tech_o, robust first
ivregress 2sls lnwage (internet = bts_kab) kbli20 status_s umur edu kerja gender marital jam_blt pc hp tech_o, robust first
xtset kodekab
xtivreg lnwage (internet = bts_kab) kbli20 status_s umur edu kerja gender marital jam pc hp tech_o status_kerja , fe
xtset kodekab
xtivreg lnwage (internet = bts_kab) kbli20 status_s umur edu kerja gender marital jam pc hp tech_o status_kerja , fe
reg internet bts_kab kbli20 status_s umur edu kerja gender marital jam pc hp tech_o status_kerja i.kodekab, robust
predict internet_hat, xb
reg internet bts_kab status_s umur edu kerja jam pc hp tech_o i.kodekab, robust
drop internet_hat
predict internet_hat, xb
drop internet_hat
reg internet bts_kab status_s umur edu kerja jam pc hp tech_o i.kodekab, robust
br
reg internet bts_kab status_s umur edu kerja jam pc hp tech_o i.kodekab, robust
reg internet bts_kab signal_ik status_s umur edu kerja jam pc hp tech_o i.kodekab, robust
reg internet bts_kab status_s umur edu kerja jam pc hp tech_o i.kodekab, robust
predict internet_hat, xb
reg lnwage internet_hat kbli20 status_s umur edu kerja gender marital jam pc hp tech_o status_kerja i.kodekab, robust
reg lnwage internet_hat kbli20 status_s umur edu kerja gender marital jam status_kerja i.kodekab, robust
drop internet_hat
reg internet bts_kab kbli20 status_s umur edu gender jam status_kerja i.kodekab, robust
reg internet bts_kab kbli20 status_s umur edu gender status_kerja i.kodekab, robust
reg internet bts_kab kbli20 status_s umur edu gender status_kerja, robust
ivregress 2sls lnwage (internet = bts_kab signal_ik) kbli20 status_s umur edu gender status_kerja, robust
ivregress 2sls lnwage (internet = bts_kab signal_ik) kbli20 status_s umur edu gender status_kerja, robust first
ivregress 2sls lnwage (internet = bts_kab) kbli20 status_s umur edu gender status_kerja, robust first
reg internet bts_kab kbli20 status_s umur edu gender status_kerja, robust
ivregress 2sls lnwage (internet = bts_kab) kbli20 status_s umur edu gender status_kerja, robust
estat firststage
ivregress 2sls lnwage (internet = signal_ik) kbli20 status_s umur edu gender status_kerja, robust
estat firststage
ivregress 2sls lnwage (internet = bts_kab) signal_ik kbli20 status_s umur edu gender status_kerja, robust
estat firststage
ivregress 2sls lnwage (internet = bts_kab) kbli20 status_s umur edu gender status_kerja, robust
