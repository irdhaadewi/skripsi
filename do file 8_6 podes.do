cd "D:\IRDHA\KULIAH\SEMESTER 8\SKRIPSI"
clear
set more off
use "Merge Fix 3 Green.dta"
sum
tab green
reg lnwage internet_k umur lakilaki urban yreduc jam belum_kawin kawin cerai_hidup cerai_mati i.instansi i.green i.kodeprov, r
ivregress 2sls lnwage (internet_k = bts_kab) umur lakilaki urban yreduc jam belum_kawin kawin cerai_hidup cerai_mati i.instansi i.green i.kodeprov, r
ivregress 2sls lnwage (internet_k = bts_kab) umur lakilaki urban yreduc jam belum_kawin kawin cerai_hidup cerai_mati i.instansi i.green i.kodeprov, robust first
ivregress 2sls lnwage (internet_k = bts_kab) umur lakilaki urban yreduc jam i.marital i.instansi i.green i.kodeprov, robust first
estat firststage
tab marital
tab sektor
ivregress 2sls lnwage (internet_k = bts_kab) umur lakilaki urban yreduc jam belum_kawin kawin cerai_hidup cerai_mati i.sektor i.green i.kodeprov, robust first
estat firststage
ivregress 2sls lnwage (internet_k = bts_kab) umur lakilaki urban yreduc jam i.instansi i.sektor i.green i.kodeprov, robust first
estat firststage
ivregress 2sls lnwage (internet_k = bts_kab) umur lakilaki urban yreduc jam i.marital i.sektor i.green i.kodeprov, robust first
tab status_kerja
gen informal = .
label variable informal "0: Formal, 1: Informal"
replace informal = 0 if status_kerja==3
replace informal = 0 if status_kerja==4
tab informal
replace informal = 1 if status_kerja==1
replace informal = 1 if status_kerja==2
replace informal = 1 if status_kerja==5
replace informal = 1 if status_kerja==6
tab status_kerja
tab informal
ivregress 2sls lnwage (internet_k = bts_kab) umur lakilaki urban yreduc jam belum_kawin kawin cerai_hidup cerai_mati informal signal_ik i.green i.kodeprov, robust first
estat firststage
ivregress 2sls lnwage (internet_k = bts_kab) umur lakilaki urban yreduc jam informal signal_ik i.marital i.instansi i.green i.kodeprov, robust first
ivregress 2sls lnwage (internet_k = bts_kab) umur lakilaki urban yreduc jam informal hh_size signal_ik i.marital i.instansi i.green i.kodeprov, robust first
gen cerai=.
replace cerai=1 if cerai_hidup==1
replace cerai=1 if cerai_mati==1
replace cerai=0 if cerai==.
tab cerai
ivregress 2sls lnwage (internet_k = bts_kab) umur lakilaki urban yreduc jam informal belum_kawin kawin cerai hh_size signal_ik i.instansi i.green i.kodeprov, robust first
estat firststage
tab signal_ik
save "Merge Fix 3 Green.dta", replace
clear
use "Irdha_Potensi Desa 2024.dta"
tab R1005C
tab R1005B
clear
use "Merge Fix 3 Green.dta"
clear
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
label variable signal_t "Sinyal telepon seluler"
rename R1005D signal_i
label variable signal_i "Sinyal internet telepon seluler"
rename R1006A pc
rename R1006B fas
label variable fas "Fasilitas internet di kantor kepala desa"
sum R105
rename R105 status
gen punya_5g=.
tab telp
tab signal_i
replace punya_5g=1 if signal_i==1
replace punya_5g=0 if punya_5g==.
gen punya_3g=.
replace punya_3g=1 if signal_i==2
replace punya_3g=0 if punya_3g==.
gen punya_2g=.
replace punya_2g=1 if signal_i==3
replace punya_2g=0 if punya_2g==.
keep signal_i signal_t telp punya_5g punya_3g punya_2g kab prov kec desa
collapse (mean) telp_kab2 = telp (mean) kab_5g = punya_5g (mean) kab_3g = punya_3g (mean) kab_2g = punya_2g (mean) signal_tm = signal_t (mean) signal_im = signal_i, by(kab)
tab kab_5g
tab kab_3g
tab kab_2g
tab signal_im
destring kab, replace
save "podes_2"
clear
use "Podes24_2 8_5.dta"
clear
use "Irdha_Potensi Desa 2024.dta"
rename R102 kab
destring kab, replace
merge m:1 kab using "Podes_2.dta"
rename R101 prov
keep prov kab telp_kab2 kab_5g kab_3g kab_2g signal_tm signal_im _merge
keep if _merge == 3
destring prov, replace
gen kodekab = prov + kab
br
drop kodekab
gen kodekab = string(prov, "%02.0f") + string(kab, "%02.0f")
br
destring kodekab, replace
save "podes3.dta"
clear
use "Merge Fix 3 Green.dta"
drop _merge
clear
use "podes3.dta"
drop _merge
clear
use "Merge Fix 3 Green.dta"
drop _merge
clear
use "podes3.dta"
drop _merge
save "Podes_3.dta"
clear
use "Merge Fix 3 Green.dta"
drop _merge
destring kodekab, replace
br
br
clear
use "Podes24_2 8_5.dta"
clear
use "Podes_3.dta"
drop prov
drop kab
save "Podes_3.dta", replace
clear
use "Merge Fix 3 Green.dta"
drop _merge
destring kodekab,replace
br
