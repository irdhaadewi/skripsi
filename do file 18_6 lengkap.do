cd "D:\IRDHA\KULIAH\SEMESTER 8\SKRIPSI"
use "Merge Fix 2 Green 3.dta"

***model terbaru, gak pakai kontrol sinyal, jam kerja udah disesuaikan, dihapus yang 0, wage 20k - 100jt
**summarize
asdoc summarize wage internet_k bts_kab umur lakilaki urban marital yreduc informal jam_blt instansi hh_size pc_k hp_k tech_o_k kodeprov instansi lnwage, label replace save(summary_4.doc), replace

***OLS
***pake marital status yang ordinal 1-4
* Full sample
reg lnwage internet_k pc_k hp_k tech_o_k urban lakilaki umur yreduc informal jam_blt hh_size i.marital i.instansi i.green i.kodeprov, robust
est store ols_all_3
**save ols
esttab ols_all_3 using hasil_18_6_ols.doc, b(%9.3f) p star label replace rtf stats(Fstat N, fmt(2 0) labels("F-stat" "Obs")) mtitle("Upah")

***first stage
***pake marital status yang ordinal 1-4
* Full sample
reg internet_k bts_kab pc_k hp_k tech_o_k urban lakilaki umur yreduc informal jam_blt hh_size i.marital i.instansi i.green i.kodeprov, robust
est store first_all_3

* Kuantil 0.25
reg internet_k bts_kab pc_k hp_k tech_o_k urban lakilaki umur yreduc informal jam_blt hh_size i.marital i.instansi i.green i.kodeprov if wage_q==1, robust
est store first_25

* Kuantil 0.50
reg internet_k bts_kab pc_k hp_k tech_o_k urban lakilaki umur yreduc informal jam_blt hh_size i.marital i.instansi i.green i.kodeprov if wage_q==2, robust
est store first_50

* Kuantil 0.75
reg internet_k bts_kab pc_k hp_k tech_o_k urban lakilaki umur yreduc informal jam_blt hh_size i.marital i.instansi i.green i.kodeprov if wage_q==3, robust
est store first_75

* Kuantil 1.00
reg internet_k bts_kab pc_k hp_k tech_o_k urban lakilaki umur yreduc informal jam_blt hh_size i.marital i.instansi i.green i.kodeprov if wage_q==4, robust
est store first_100
**save first stage
esttab first_all_3 first_25_3 first_50_3 first_75_3 first_100_3 using hasil_18_6_first.doc, b(%9.3f) p star label replace rtf stats(Fstat r2 ar2 N, fmt(2 0) labels("First-stage F-stat" "R-Squared" "Adjusted R-Squared" "Obs")) mtitle("Internet" "Internet Q1" "Internet Q2" "Internet Q3" "Internet Q4")

***second stage 2sls
***pake marital status yang ordinal 1-4
* Full sample
ivregress 2sls lnwage (internet_k = bts_kab) pc_k hp_k tech_o_k urban lakilaki umur yreduc informal jam_blt hh_size i.marital i.instansi i.green i.kodeprov, robust first
est store est_all_3
estat firststage

* Kuantil 0.25
ivregress 2sls lnwage (internet_k = bts_kab) pc_k hp_k tech_o_k urban lakilaki umur yreduc informal jam_blt hh_size i.marital i.instansi i.green i.kodeprov if wage_q==1, robust first
est store eq25_3
estat firststage

* Kuantil 0.50
ivregress 2sls lnwage (internet_k = bts_kab) pc_k hp_k tech_o_k urban lakilaki umur yreduc informal jam_blt hh_size i.marital i.instansi i.green i.kodeprov if wage_q==2, robust first
est store eq50_3
estat firststage

* Kuantil 0.75
ivregress 2sls lnwage (internet_k = bts_kab) pc_k hp_k tech_o_k urban lakilaki umur yreduc informal jam_blt hh_size i.marital i.instansi i.green i.kodeprov if wage_q==3, robust first
est store eq75_3
estat firststage

* Kuantil 1.00
ivregress 2sls lnwage (internet_k = bts_kab) pc_k hp_k tech_o_k urban lakilaki umur yreduc informal jam_blt hh_size i.marital i.instansi i.green i.kodeprov if wage_q==4, robust first
est store eq100_3
estat firststage
**save IV
esttab est_all_3 eq25_3 eq50_3 eq75_3 eq100_3 using hasil_18_6_iv.doc, b(%9.3f) p star label replace rtf stats(Fstat r2 ar2 N, fmt(2 0) labels("First-stage F-stat" "R-Squared" "Adjusted R-Squared" "Obs")) mtitle("Wage" "Upah Q1" "Upah Q50" "Upah Q75" "Upah Q100")

**wage quantil
gen wage_group = .
replace wage_group = 1 if wage < 1000000
replace wage_group = 2 if wage >= 1000000 & wage < 2000000
replace wage_group = 3 if wage >= 2000000 & wage < 3000000
replace wage_group = 4 if wage >= 3000000
label define wagegrp 1 "Upah<1jt" 2 "Upah 1-2jt" 3 "Upah 2-3jt" 4 "Upah >3jt"
label values wage_group wagegrp
asdoc summarize wage if wage_group == 1, save(wage_summary_3.doc) replace title(Summary Upah <1 Juta)
asdoc summarize wage if wage_group == 2, save(wage_summary_3.doc) append title(Summary Upah 1–2 Juta)
asdoc summarize wage if wage_group == 3, save(wage_summary_3.doc) append title(Summary Upah 2–3 Juta)
asdoc summarize wage if wage_group == 4, save(wage_summary_3.doc) append title(Summary Upah >3 Juta)
asdoc summarize wage, save(wage_summary_3.doc) append title(Summary Upah Seluruhnya)

***cek endogenity 
estat endogenous
