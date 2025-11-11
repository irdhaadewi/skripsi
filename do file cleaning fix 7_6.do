cd "D:\IRDHA\KULIAH\SEMESTER 8\SKRIPSI"
use "Irdha_Sakernas Agustus 2024-rev2.dta"
set more off
destring KODE_PROV, replace
destring KODE_KAB, replace
gen kodekab = string(KODE_PROV, "%02.0f") + string(KODE_KAB, "%02.0f")
sum kodekab
destring kodekab, replace
sum kodekab
rename STRATA strata
rename KLASIFIKAS status_s
rename K4 gender
rename K10 umur
rename R4 marital
rename R6A edu
rename R10A kerja
rename R14A status_kerja
rename R15A_KBLI2 kbli20
rename R15B_KBJI2 kbji14
rename R16_1 wage
rename R17A sektor
rename R19A_JML jam
rename R19A_BLT jam_blt
rename R20A2 hp_k
rename R20A3 tech_o_k
rename R20A4 internet_k
rename R20B1 ik_kom
rename R20B2 ik_prom
rename R20B3 ik_info
rename R20B4 ik_jual_
rename ik_jual_ ik_jual_s
rename R20B5 ik_jual_w
rename R20B6 ik_beli_s
rename R20B7 ik_beli_w
rename R20B8 ik_bank
rename R20B9 ik_o
label var internet_k "Internet yang digunakan di pekerjaan utama dalam seminggu terakhir"
rename R9A hp
rename R9B1 pc
rename hp hp_punya
rename R9B2 hp
rename R9B3 tech_o
rename R9B4 internet
rename R9C1 i_kom
rename R9C2 i_info
rename R9C3 i_jual
rename R9C4 i_beli
rename R9C5 i_bank
rename R9C6 i_o
label var i_o "Memanfaatkan internet untuk lainnya, o;others"
rename R21 instansi
rename R23A lok
rename KODE_PROV kodeprov
rename KODE_KAB kodekab2
rename R5 part_edu
label var internet "Menggunakan internet dalam sebulan terakhir"
rename URUTAN urutan
rename R16_2 wage_brg
rename B2R1 hh_size
tab edu
gen yreduc = .
replace yreduc = 3 if edu == 1
replace yreduc = 6 if edu == 2
replace yreduc = 9 if edu == 3
replace yreduc = 12 if edu == 4
replace yreduc = 12 if edu == 5
replace yreduc = 12 if edu == 6
replace yreduc = 14 if edu == 7
replace yreduc = 16 if edu == 8
replace yreduc = 16 if edu == 9
replace yreduc = 18 if edu == 10
replace yreduc = 18 if edu == 11
replace yreduc = 21 if edu == 12
gen survei = 2024
gen lahir = survei - umur
gen lulus = R6C_THN - lahir
gen sekolah = 7
gen yreduc_2 = lulus - sekolah
tab yreduc
tab yreduc_2
rename R20A1 pc_k
label variable yreduc_2 "dihitung pakai tahun lulus"
label variable yreduc "dihitung pakai tingkat pendidikan tertinggi"
tab TAHUN
keep urutan kodeprov kodekab2 status_s PSU strata hh_size gender umur marital part_edu edu hp_punya pc hp tech_o internet i_kom i_info i_jual i_beli i_bank i_o kerja status_kerja kbli20 kbji14 wage wage_brg sektor jam jam_blt pc_k hp_k tech_o_k internet_k ik_kom ik_prom ik_info ik_jual_s ik_jual_w ik_beli_s ik_beli_w ik_bank ik_o instansi lok kodekab yreduc survei lahir lulus sekolah yreduc_2
save "saker fix 1 7_6.dta"
merge m:1 kodekab using "Podes24_2 8_5.dta"
keep if _merge == 3
keep if umur >= 15 & umur <= 64
drop if wage==.
tab internet_k
replace internet_k=0 if internet_k==4
replace internet_k=1 if internet_k==3
replace internet=0 if internet==4
replace internet=1 if internet==3
tab internet
tab internet_k
tab gender
replace gender=0 if gender==2
rename gender lakilaki
label variable lakilaki "Laki-laki = 1, Perempuan = 2"
tab status_s
replace status_s=0 if status_s==2
rename status_s urban
label variable urban "Urban = 1, Rural = 0"
br
gen lnwage = ln(wage)
drop if lnwage==.
histogram lnwage, normal kdensity
summarize wage, meanonly
display r(mean)
tab wage if wage>= 100000000
tab wage if wage>= 50000000
summarize wage, meanonly
display "Mean: " r(mean)
display "SD: " r(sd)
sum wage
sum wage
display "Mean: " r(mean)
display "SD: " r(sd)
display "Lower Bound (3 SD): " r(mean) - 3*r(sd)
display "Upper Bound (3 SD): " r(mean) + 3*r(sd)
br
save "Merge Fix 1"
*Merge Fix 1 belum clean outliner sama sekali, basically data raw
drop if wage < 10000
tab wage if wage <=100000
drop if wage > 150000000
tab wage if wage>=100000000
save "Merge Fix 2.dta"
*Merge Fix 2 ada di range 10.000 - 150.000.000
sum wage
display "Mean: " r(mean)
display "SD: " r(sd)
display "Lower Bound (3 SD): " r(mean) - 3*r(sd)
display "Upper Bound (3 SD): " r(mean) + 3*r(sd)
tab umur
drop if wage>=100000000
save "Merge Fix 3"
*Merge Fix 3 range 10.000 - 100.000.000"
tab wage if wage>=50000000
display "Mean: " r(mean)
display "SD: " r(sd)
display "Lower Bound (3 SD): " r(mean) - 3*r(sd)
sum wage
clear
use "Merge Fix 2.dta"
drop if wage >100000000
sum wage
save "Merge Fix 3",replace
sum wage
display "Mean: " r(mean)
display "SD: " r(sd)
display "Lower Bound (3 SD): " r(mean) - 3*r(sd)
display "Upper Bound (3 SD): " r(mean) + 3*r(sd)
tab wage if wage>50000000
tab wage if wage>=50000000
histogram lnwage, normal kdensity
histogram wage, normal kdensity
*untuk filter green sector aja
keep if inlist(kbli20, 1, 2, 3, 4, 6, 8, 9, 15, 17)
rename kbli20 green
