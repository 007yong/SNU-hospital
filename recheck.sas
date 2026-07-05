/* COHORT A*/
/* COHORT A 파악완료*/
DATA NEWDEMO.COHORT_A;
SET NEWDEMO.final_casecontrol_3;
IF SMOKE = 4 OR WEEK_TARGET = 5 OR alcohol_target = 2 THEN DELETE;
RUN;
PROC SQL;SELECT COUNT(*),COUNT(DISTINCT INDI_DSCM_NO) FROM NEWDEMO.COHORT_A; QUIT;

PROC TABULATE DATA = NEWDEMO.COHORT_A;
CLASS SMOKE  TARGET;
TABLE (all SMOKE),TARGET*(N colPCTN);
RUN;
PROC TABULATE DATA = NEWDEMO.COHORT_A;
CLASS WEEK_TARGET  TARGET;
TABLE (all WEEK_TARGET),TARGET*(N colPCTN);
RUN;
PROC TABULATE DATA = NEWDEMO.COHORT_A;
CLASS alcohol_target   TARGET;
TABLE (all alcohol_target),TARGET*(N colPCTN);
RUN;

PROC TABULATE DATA = NEWDEMO.COHORT_A;
CLASS Q_SMK_YN  TARGET;
TABLE (all Q_SMK_YN),TARGET*(N colPCTN);
RUN;

DATA CHECK;
SET  NEWDEMO.COHORT_A;
IF Q_SMK_YN = 4;
KEEP INDI_DSCM_NO Q_SMK_YN Q_SMK_PRE_DRT Q_SMK_NOW_DRT Q_SMK_PRE_AMT Q_SMK_NOW_AMT_V09N py ;
RUN;


/* 흡연력 */
if Q_SMK_YN = '.' then Q_SMK_YN = 4;
if Q_SMK_YN = 1 AND (Q_SMK_PRE_DRT ^= '.' OR Q_SMK_PRE_AMT ^= '.' OR Q_SMK_NOW_DRT ^= '.' OR Q_SMK_NOW_AMT_V09N ^= '.') THEN Q_SMK_YN=4;
if Q_SMK_YN = 2 AND (Q_SMK_NOW_DRT ^= '.' OR Q_SMK_NOW_AMT_V09N ^= '.') THEN Q_SMK_YN = 4;
if Q_SMK_YN = 3 AND (Q_SMK_PRE_DRT ^= '.' OR Q_SMK_PRE_AMT ^= '.') THEN Q_SMK_YN = 4; 

py= ((Q_SMK_PRE_DRT*Q_SMK_PRE_AMT )/20); /* 해당 변수로 고려 */

/** former **/
IF Q_SMK_YN = 2 & py ^= '.' & 0 < py < 15 then smoke_target = 1; /* 15보다 작으면 */
IF Q_SMK_YN = 2 & py ^= '.' & 15 =< py < 30 then smoke_target = 2; /* 15 =<  30보다 크면 */
IF Q_SMK_YN = 2 & py ^= '.' &  30 =< py then smoke_target = 3;

/* (Missing) */
IF Q_SMK_YN = 2 & py = 0 THEN smoke_target = 4;  /* 0과 같은경우  (Missing) */
IF Q_SMK_YN = 2 & py = '.' THEN  smoke_target = 5; /* unknown */
IF Q_SMK_YN = 2 & py < 0 THEN smoke_target = 6;  /* 보다 작은경우  (Missing)  */

/* 최종 */
IF smoke_target = 1 THEN SMOKE = 1;
IF smoke_target = 2 THEN SMOKE = 2;
IF smoke_target = 3 THEN SMOKE = 3;
IF smoke_target = 4 OR smoke_target = 5 OR smoke_target = 6 THEN SMOKE = 4; 






/* CHI 검정 */
%MACRO CAI_TEST(DATA=, VAR1=, VAR2=);
ODS TRACE ON;
ODS OUTPUT ChiSq = Chi_&VAR1._&VAR2.;
PROC FREQ DATA= &DATA;
TABLES &VAR1.*&VAR2./CHISQ; 
RUN;
DATA &VAR1._&VAR2.;
SET Chi_&VAR1._&VAR2.;
if _n_ = 1;
run;
%MEND CAI_TEST; 
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=SEX_TYPE,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=AGE_GRP,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=insurance,VAR2 = TARGET);

/* 흡연력 */
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=Q_SMK_YN,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=SMOKE,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=SMOKE_1,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=SMOKE_2,VAR2 = TARGET);

/* 음주력 */
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=alcohol_target,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=alcohol_target1,VAR2 = TARGET);

/* 신체활동 */
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=WEEK_TARGET,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=MVPA_TARGET,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=regular_exercise,VAR2 = TARGET);

/* 체질량*/
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=BMI_TARGET,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= central,VAR2 = TARGET);

/* CCI */
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= CCI_FREQ,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= CCI_0,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= CCI_2,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= CCI_5,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= CCI_8,VAR2 = TARGET);

/* 동반질환 */
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_HT,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_DIAB,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_Dyslipidemia,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_IHD,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_HF,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_TC,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_FOF,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_CKD_NEW,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_CANCER,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_SRC,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_ARC,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_ORC,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1= ICD_CH_PRC,VAR2 = TARGET);

/* 새롭게 추가된 부분 240328*/
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=ICD_CH_LUNG_CANCER,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=ICD_CH_GRD,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=ICD_CH_DP,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=ICD_CH_FL,VAR2 = TARGET);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=ICD_CH_COPD,VAR2 = TARGET);

%MACRO SET_CHI(VAR1=);
DATA NEWDEMO.CHI_TABLE_&VAR1;
SET SEX_TYPE_&VAR1 AGE_GRP_&VAR1 insurance_&VAR1 Q_SMK_YN_&VAR1 SMOKE_&VAR1 SMOKE_1_&VAR1 SMOKE_2_&VAR1
alcohol_target_&VAR1 alcohol_target1_&VAR1 WEEK_TARGET_&VAR1 MVPA_TARGET_&VAR1
regular_exercise_&VAR1 BMI_TARGET_&VAR1 central_&VAR1
CCI_FREQ_&VAR1 CCI_0_&VAR1 CCI_2_&VAR1 CCI_5_&VAR1 CCI_8_&VAR1
ICD_CH_HT_&VAR1 ICD_CH_DIAB_&VAR1 ICD_CH_Dyslipidemia_&VAR1 ICD_CH_IHD_&VAR1
ICD_CH_HF_&VAR1 ICD_CH_TC_&VAR1 ICD_CH_FOF_&VAR1 ICD_CH_CKD_NEW_&VAR1
ICD_CH_CANCER_&VAR1 ICD_CH_SRC_&VAR1 ICD_CH_ARC_&VAR1 ICD_CH_ORC_&VAR1 ICD_CH_PRC_&VAR1
ICD_CH_LUNG_CANCER_&VAR1 ICD_CH_GRD_&VAR1 ICD_CH_DP_&VAR1 ICD_CH_FL_&VAR1 ICD_CH_COPD_&VAR1;
RUN;
%MEND SET_CHI; 
%SET_CHI(VAR1= TARGET)


*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 
SEX_TYPE (성별)
AGE_GRP(연령)
insurance (소득) 
Q_SMK_YN (흡연력)
alcohol_target (음주습관)
alcohol_target1 (주간 음주량)
WEEK_TARGET (신체활동량 카테고리)
MVPA_TARGET 
regular_exercise (규칙적 운동)
BMI_TARGET (체질량 지수)
central (허리 둘레) 
CCI 
*/

/* smoke_target smoke_target_1 smoke_target_2  CCI 이변수들은 따로 봐야함 */
PROC TABULATE DATA = NEWDEMO.final_casecontrol_3 OUT= TABLE_CHECK;
CLASS SEX_TYPE AGE_GRP insurance Q_SMK_YN alcohol_target alcohol_target1 
WEEK_TARGET MVPA_TARGET regular_exercise BMI_TARGET central CCI_FREQ 
ICD_CH_HT ICD_CH_DIAB ICD_CH_Dyslipidemia ICD_CH_IHD ICD_CH_HF ICD_CH_TC 
ICD_CH_FOF ICD_CH_CKD_NEW ICD_CH_CANCER ICD_CH_SRC ICD_CH_ARC ICD_CH_ORC ICD_CH_PRC 
ICD_CH_LUNG_CANCER ICD_CH_GRD ICD_CH_DP ICD_CH_FL ICD_CH_COPD TARGET;
TABLE (all SEX_TYPE AGE_GRP insurance Q_SMK_YN 
alcohol_target alcohol_target1 WEEK_TARGET MVPA_TARGET regular_exercise 
BMI_TARGET central CCI_FREQ 
ICD_CH_HT ICD_CH_DIAB ICD_CH_Dyslipidemia ICD_CH_IHD ICD_CH_HF ICD_CH_TC
ICD_CH_FOF ICD_CH_CKD_NEW ICD_CH_CANCER ICD_CH_SRC ICD_CH_ARC ICD_CH_ORC ICD_CH_PRC
ICD_CH_LUNG_CANCER ICD_CH_GRD ICD_CH_DP ICD_CH_FL ICD_CH_COPD),TARGET*(N colPCTN);
RUN;
/* 흡연력 */
PROC TABULATE DATA =  NEWDEMO.final_casecontrol_3 OUT =  TABLE_CHECK_1;
CLASS SMOKE TARGET;
TABLE (all SMOKE),TARGET*(N colPCTN);
RUN;
PROC TABULATE DATA =  NEWDEMO.final_casecontrol_3 OUT =  TABLE_CHECK_2;
CLASS SMOKE_1 TARGET;
TABLE (all SMOKE_1),TARGET*(N colPCTN);
RUN;
PROC TABULATE DATA =  NEWDEMO.final_casecontrol_3 OUT =  TABLE_CHECK_3;
CLASS SMOKE_2 TARGET;
TABLE (all SMOKE_2),TARGET*(N colPCTN);
RUN;
/* CCI */
PROC TABULATE DATA =  NEWDEMO.final_casecontrol_3 OUT =  TABLE_CHECK_CCI;
CLASS CCI_0 CCI_2 CCI_5 CCI_8 TARGET;
TABLE (CCI_0 CCI_2 CCI_5 CCI_8),TARGET*(N colPCTN);
RUN;



*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 연속형 변수 검정 */

%MACRO TTEST(DATA=,VAR1= , VAR2= );
ODS TRACE ON;
ODS OUTPUT Statistics=stat; ODS OUTPUT TTests = TTest; ODS OUTPUT Equality = Equality;
proc ttest data=NEWDEMO.final_casecontrol_3; var &VAR1; class &VAR2; run;
ODS TRACE OFF;
DATA TABLE_1; 
SET STAT;
IF MEthod = " "; 
DROP Method;
RUN;
DATA TABLE_2;
SET TABLE_1;
NC=compress(put(n,20.0));
mesd = compress(put(mean,20.2)||"("||put(StdDev,20.2)||")");
run;
proc transpose data= table_2 out=table_3;
var Variable Class nc mesd;
run;
data p_val;
merge ttest equality;
by variable;
/* probtc = put(probt,8.4);*/
if probF >= 0.05 & Variances = "Equal" THEN output P_VAL;
if probF < 0.05 & Variances = "Unequal" THEN output P_VAL;
run;
data stat_pval;
merge table_3 p_val;
run;
data &VAR1._&VAR2.(keep=_NAME_ COL1 COL2 Probt);
set stat_pval; run;

%MEND TTEST; 


/* 연속형 */
/* 연령 */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=age,VAR2=TARGET);

/* 운동량 */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=Q_PA_VD,VAR2=TARGET);
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=Q_PA_MD,VAR2=TARGET);
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=Q_PA_WALK,VAR2=TARGET);
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=WEEK_MET,VAR2=TARGET);
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=MVPA,VAR2=TARGET);

/* 흡연력 */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=PY,VAR2=TARGET);
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=PY1,VAR2=TARGET);
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=PY_total,VAR2=TARGET);

/* 체질량 지수 */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_BMI,VAR2=TARGET);
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_HGHT,VAR2=TARGET);
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_WGHT,VAR2=TARGET);

/* 허리 둘레 */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_WSTC,VAR2=TARGET);

/* CCI */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=CCI_FREQ,VAR2=TARGET);

/*검진 결과*/
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_BP_SYS,VAR2=TARGET); 
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_BP_DIA,VAR2=TARGET); 
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_TG,VAR2=TARGET); 
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_TOT_CHOL,VAR2=TARGET); 
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_HDL,VAR2=TARGET); 
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_LDL,VAR2=TARGET); 
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_FBS,VAR2=TARGET);   /* 식전 혈당 */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_HGB,VAR2=TARGET); /* 혈색소 */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_CRTN,VAR2=TARGET); /* 혈청크레아티닌수치 */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_GFR,VAR2=TARGET); /* 신사구체여과율 */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_SGOT,VAR2=TARGET); /* ast 수치 */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_SGPT,VAR2=TARGET); /* alt 수치 */
%TTEST(DATA=NEWDEMO.final_casecontrol_3,VAR1=G1E_GGT,VAR2=TARGET); /* 감마 gpt */

%MACRO SET(VAR1=);
DATA NEWDEMO.FINAL_TABLE;
SET 
age_&VAR1
Q_PA_VD_&VAR1
Q_PA_MD_&VAR1
Q_PA_WALK_&VAR1
WEEK_MET_&VAR1
MVPA_&VAR1
PY_&VAR1
PY1_&VAR1
PY_total_&VAR1
G1E_BMI_&VAR1
G1E_HGHT_&VAR1
G1E_WGHT_&VAR1
G1E_WSTC_&VAR1
CCI_FREQ_&VAR1
G1E_BP_SYS_&VAR1
G1E_BP_DIA_&VAR1
G1E_TG_&VAR1
G1E_TOT_CHOL_&VAR1
G1E_HDL_&VAR1 
G1E_LDL_&VAR1
G1E_FBS_&VAR1
G1E_HGB_&VAR1
G1E_CRTN_&VAR1
G1E_GFR_&VAR1
G1E_SGOT_&VAR1
G1E_SGPT_&VAR1
G1E_GGT_&VAR1;
RUN;
%MEND SET; 
%SET(VAR1= TARGET)



*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 결측값 찾기 */
%LET T = TARGET;

%macro MISS(DATA = ,VAR1= ,VAR2=);
DATA MISS_CHECK;
SET &DATA.;
IF &VAR1. ^= '.' THEN MISS_&VAR1._&VAR2. = 1;
ELSE MISS_&VAR1._&VAR2. = 0;
RUN;
ODS TRACE ON;
ODS OUTPUT CrossTabFreqs = MISSTABLE;
PROC FREQ DATA= MISS_CHECK;
TABLE MISS_&VAR1._&VAR2.*&VAR2.; RUN;
DATA MISSTABLE_&VAR1._&VAR2.(KEEP= MISS_&VAR1._&VAR2. &VAR2. Frequency Percent);
SET MISSTABLE;
IF MISS_&VAR1._&VAR2. = 0 & TARGET ^= '.';
RUN; 
%MEND MISS;


/* BMI 키 몸무게 */
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_BMI, VAR2 = &T.)
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_HGHT, VAR2 = &T.)
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_WGHT, VAR2 = &T.)

%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_BP_SYS, VAR2 = &T.)
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_BP_DIA, VAR2 = &T.)
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_TG, VAR2 = &T.)
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_TOT_CHOL, VAR2 = &T.)
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_HDL, VAR2 = &T.)
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_LDL, VAR2 = &T.)
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_FBS, VAR2 = &T.) /* 식전 혈당 */
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_HGB, VAR2 = &T.)  /* 혈색소 */
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_CRTN, VAR2 = &T.) /* 혈청크레아티닌수치 */
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_GFR, VAR2 = &T.) /* 신사구체여과율 */
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_SGOT, VAR2 = &T.) /* ast 수치 */
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_SGPT, VAR2 = &T.)  /* alt 수치 */
%MISS(DATA = NEWDEMO.final_casecontrol_3, VAR1 = G1E_GGT, VAR2 = &T.)   /* 감마 gpt */


DATA FREQ.FINAL_MISS_TABLE_&T.;
SET 
MISSTABLE_G1E_BMI_&T.
MISSTABLE_G1E_HGHT_&T.
MISSTABLE_G1E_WGHT_&T.
MISSTABLE_G1E_BP_SYS_&T.
MISSTABLE_G1E_BP_DIA_&T.
MISSTABLE_G1E_TG_&T.
MISSTABLE_G1E_TOT_CHOL_&T.
MISSTABLE_G1E_HDL_&T.
MISSTABLE_G1E_LDL_&T.
MISSTABLE_G1E_FBS_&T.
MISSTABLE_G1E_HGB_&T.
MISSTABLE_G1E_CRTN_&T.
MISSTABLE_G1E_GFR_&T.
MISSTABLE_G1E_SGOT_&T.
MISSTABLE_G1E_SGPT_&T.
MISSTABLE_G1E_GGT_&T.;
RUN;


PROC PRINT DATA=FREQ.FINAL_MISS_TABLE_&T.; RUN;

*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* SEX */
*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;


/* insurance (소득분위수) */
%MACRO CTRB(VAR1=);
ODS TRACE ON;
ODS OUTPUT Quantiles= Q;
PROC UNIVARIATE DATA=NEWDEMO.final_casecontrol_3;
VAR CALC_CTRB_VTILE_FD; 
class &VAR1.;
run;
ODS TRACE OFF;
DATA Q1;
SET Q;
Quantile = COMPRESS(Quantile);
IF SUBSTR(Quantile,1,10) IN ('0%최솟값','25%Q1','50%중위수','75%Q3');
RUN;
%MEND CTRB; 
%CTRB(VAR1 = SEX_TYPE);


%MACRO CTRB_2(VAR1=);
DATA NEWDEMO.final_casecontrol_&VAR1.;
SET NEWDEMO.final_casecontrol_3;
/* 정의에 따라서 case / control 분류 */

/* 보험분위수 */
IF &VAR1. = 1 & 0 =< CALC_CTRB_VTILE_FD =< 8  then insurance =1;
IF &VAR1. = 1 & 8  < CALC_CTRB_VTILE_FD =< 14 then insurance =2;
IF &VAR1. = 1 & 14 < CALC_CTRB_VTILE_FD =< 18  then insurance =3;
IF &VAR1. = 1 & 18 < CALC_CTRB_VTILE_FD  then insurance =4;

IF &VAR1. = 2 & 0 =< CALC_CTRB_VTILE_FD =< 5  then insurance =1;
IF &VAR1. = 2 & 5  < CALC_CTRB_VTILE_FD =< 12 then insurance =2;
IF &VAR1. = 2 & 12 < CALC_CTRB_VTILE_FD =< 17  then insurance =3;
IF &VAR1. = 2 & 17 < CALC_CTRB_VTILE_FD  then insurance =4;

RUN;
%MEND CTRB_2; 
%CTRB_2(VAR1 = SEX_TYPE);

%LET S = SEX_TYPE;
/* CHI 검정 */
%MACRO CAI_TEST(DATA=, VAR1=, VAR2=);
ODS TRACE ON;
ODS OUTPUT ChiSq = Chi_&VAR1._&VAR2.;
PROC FREQ DATA= &DATA;
TABLES &VAR1.*&VAR2./CHISQ; 
RUN;
DATA &VAR1._&VAR2.;
SET Chi_&VAR1._&VAR2.;
if _n_ = 1;
run;
%MEND CAI_TEST; 

%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=AGE_GRP,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=insurance,VAR2 = &S.);

/* 흡연력 */
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=Q_SMK_YN,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=SMOKE,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=SMOKE_1,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=SMOKE_2,VAR2 = &S.);

/* 음주력 */
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=alcohol_target,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=alcohol_target1,VAR2 = &S.);

/* 신체활동 */
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=WEEK_TARGET,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=MVPA_TARGET,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=regular_exercise,VAR2 = &S.);

/* 체질량*/
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=BMI_TARGET,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1= central,VAR2 = &S.);

/* CCI */
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1= CCI_FREQ,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= CCI_0,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= CCI_2,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= CCI_5,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= CCI_8,VAR2 = &S.);

/* 동반질환 */
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_HT,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_DIAB,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_Dyslipidemia,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_IHD,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_HF,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_TC,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_FOF,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_COPD,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_CKD_NEW,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_CANCER,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_SRC,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_ARC,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_ORC,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1= ICD_CH_PRC,VAR2 = &S.);

/* 새롭게 추가된 부분 240409*/
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=ICD_CH_LUNG_CANCER,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=ICD_CH_GRD,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=ICD_CH_DP,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=ICD_CH_FL,VAR2 = &S.);
%CAI_TEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=ICD_CH_COPD,VAR2 = &S.);

%MACRO SET_CHI(VAR1=);
DATA CHI.CHI_TABLE_&VAR1;
SET 
AGE_GRP_&VAR1 insurance_&VAR1
Q_SMK_YN_&VAR1 SMOKE_&VAR1 SMOKE_1_&VAR1 SMOKE_2_&VAR1
alcohol_target_&VAR1 alcohol_target1_&VAR1 
WEEK_TARGET_&VAR1 MVPA_TARGET_&VAR1 regular_exercise_&VAR1
BMI_TARGET_&VAR1 central_&VAR1
CCI_FREQ_&VAR1 CCI_0_&VAR1 CCI_2_&VAR1 CCI_5_&VAR1 CCI_8_&VAR1
ICD_CH_HT_&VAR1 ICD_CH_DIAB_&VAR1 ICD_CH_Dyslipidemia_&VAR1 ICD_CH_IHD_&VAR1
ICD_CH_HF_&VAR1 ICD_CH_TC_&VAR1 ICD_CH_FOF_&VAR1 ICD_CH_COPD_&VAR1 ICD_CH_CKD_NEW_&VAR1
ICD_CH_CANCER_&VAR1 ICD_CH_SRC_&VAR1 ICD_CH_ARC_&VAR1 ICD_CH_ORC_&VAR1 ICD_CH_PRC_&VAR1
ICD_CH_LUNG_CANCER_&VAR1 ICD_CH_GRD_&VAR1 ICD_CH_DP_&VAR1 ICD_CH_FL_&VAR1 ICD_CH_COPD_&VAR1;
RUN;
%MEND SET_CHI; 
%SET_CHI(VAR1= SEX_TYPE)

*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 
SEX_TYPE (성별)
AGE_GRP(연령)
insurance (소득) 
Q_SMK_YN (흡연력)
alcohol_target (음주습관)
alcohol_target1 (주간 음주량)
WEEK_TARGET (신체활동량 카테고리)
MVPA_TARGET 
regular_exercise (규칙적 운동)
BMI_TARGET (체질량 지수)
central (허리 둘레) 
CCI (E
*/


PROC TABULATE DATA = NEWDEMO.final_casecontrol_3 OUT= TABLE_CHECK_&S.;
CLASS AGE_GRP insurance Q_SMK_YN alcohol_target alcohol_target1 
WEEK_TARGET MVPA_TARGET regular_exercise BMI_TARGET central CCI_FREQ 
ICD_CH_HT ICD_CH_DIAB ICD_CH_Dyslipidemia ICD_CH_IHD ICD_CH_HF ICD_CH_TC 
ICD_CH_FOF ICD_CH_COPD ICD_CH_CKD_NEW ICD_CH_CANCER ICD_CH_SRC ICD_CH_ARC ICD_CH_ORC ICD_CH_PRC
ICD_CH_LUNG_CANCER ICD_CH_GRD ICD_CH_DP ICD_CH_FL ICD_CH_COPD &S.;
TABLE (all SEX_TYPE AGE_GRP insurance Q_SMK_YN 
alcohol_target alcohol_target1 WEEK_TARGET MVPA_TARGET regular_exercise 
BMI_TARGET central CCI_FREQ 
ICD_CH_HT ICD_CH_DIAB ICD_CH_Dyslipidemia ICD_CH_IHD ICD_CH_HF ICD_CH_TC
ICD_CH_FOF ICD_CH_COPD ICD_CH_CKD_NEW ICD_CH_CANCER ICD_CH_SRC ICD_CH_ARC ICD_CH_ORC ICD_CH_PRC
ICD_CH_LUNG_CANCER ICD_CH_GRD ICD_CH_DP ICD_CH_FL ICD_CH_COPD),&S.*(N colPCTN);
RUN;
/* 흡연력 */
PROC TABULATE DATA =  NEWDEMO.final_casecontrol_3 OUT =  TABLE_CHECK_&S._1;
CLASS SMOKE &S.;
TABLE (all SMOKE),&S.*(N colPCTN);
RUN;
PROC TABULATE DATA =  NEWDEMO.final_casecontrol_3 OUT =  TABLE_CHECK_&S._2;
CLASS SMOKE_1 &S.;
TABLE (all SMOKE_1),&S.*(N colPCTN);
RUN;
PROC TABULATE DATA =  NEWDEMO.final_casecontrol_3 OUT =  TABLE_CHECK_&S._3;
CLASS SMOKE_2 &S.;
TABLE (all SMOKE_2),&S.*(N colPCTN);
RUN;
/* CCI */
PROC TABULATE DATA =  NEWDEMO.final_casecontrol_3 OUT =  TABLE_CHECK_&S._CCI;
CLASS CCI_0 CCI_2 CCI_5 CCI_8 &S.;
TABLE (CCI_0 CCI_2 CCI_5 CCI_8),&S.*(N colPCTN);
RUN;


%MACRO TTEST(DATA=,VAR1= , VAR2= );
ODS TRACE ON;
ODS OUTPUT Statistics=stat; ODS OUTPUT TTests = TTest; ODS OUTPUT Equality = Equality;
proc ttest data=NEWDEMO.final_casecontrol_&VAR2.; var &VAR1; class &VAR2; run;
ODS TRACE OFF;
DATA TABLE_1; 
SET STAT;
IF MEthod = " "; 
DROP Method;
RUN;
DATA TABLE_2;
SET TABLE_1;
NC=compress(put(n,20.0));
mesd = compress(put(mean,20.2)||"("||put(StdDev,20.2)||")");
run;
proc transpose data= table_2 out=table_3;
var Variable Class nc mesd;
run;
data p_val;
merge ttest equality;
by variable;
/* probtc = put(probt,8.4);*/
if probF >= 0.05 & Variances = "Equal" THEN output P_VAL;
if probF < 0.05 & Variances = "Unequal" THEN output P_VAL;
run;
data stat_pval;
merge table_3 p_val;
run;
data &VAR1._&VAR2.(keep=_NAME_ COL1 COL2 Probt);
set stat_pval; run;
%MEND TTEST; 


/* 연속형 */
/* 연령 */
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=age,VAR2=SEX_TYPE);

/* 운동량 */
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=Q_PA_VD,VAR2=SEX_TYPE);
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=Q_PA_MD,VAR2=SEX_TYPE);
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=Q_PA_WALK,VAR2=SEX_TYPE);
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=WEEK_MET,VAR2=SEX_TYPE);
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=MVPA,VAR2=SEX_TYPE);

/* 흡연력 */
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=PY,VAR2=SEX_TYPE);
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=PY1,VAR2=SEX_TYPE);
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=PY_total,VAR2=SEX_TYPE);

/* 체질량 지수 */
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=G1E_BMI,VAR2=SEX_TYPE);
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=G1E_HGHT,VAR2=SEX_TYPE);
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=G1E_WGHT,VAR2=SEX_TYPE);

/* 허리 둘레 */
%TTEST(DATA=NEWDEMO.final_casecontrol_SEX_TYPE,VAR1=G1E_WSTC,VAR2=SEX_TYPE);

/* CCI */
%TTEST(DATA=NEWDEMO.final_casecontrol,VAR1=CCI_FREQ,VAR2=&S.);

/*검진 결과*/
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_BP_SYS,VAR2=&S.); 
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_BP_DIA,VAR2=&S.); 
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_TG,VAR2=&S.); 
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_TOT_CHOL,VAR2=&S.); 
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_HDL,VAR2=&S.); 
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_LDL,VAR2=&S.); 
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_FBS,VAR2=&S.);   /* 식전 혈당 */
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_HGB,VAR2=&S.); /* 혈색소 */
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_CRTN,VAR2=&S.); /* 혈청크레아티닌수치 */
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_GFR,VAR2=&S.); /* 신사구체여과율 */
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_SGOT,VAR2=&S.); /* ast 수치 */
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_SGPT,VAR2=&S.); /* alt 수치 */
%TTEST(DATA=NEWDEMO.final_casecontrol_&S.,VAR1=G1E_GGT,VAR2=&S.); /* 감마 gpt */


%MACRO SET(VAR1=);
DATA TTEST.FINAL_TABLE_&VAR1.;
SET 
age_&VAR1
Q_PA_VD_&VAR1
Q_PA_MD_&VAR1
Q_PA_WALK_&VAR1
WEEK_MET_&VAR1
MVPA_&VAR1
PY_&VAR1
PY1_&VAR1
PY_total_&VAR1
G1E_BMI_&VAR1
G1E_HGHT_&VAR1
G1E_WGHT_&VAR1
G1E_WSTC_&VAR1
CCI_FREQ_&VAR1
G1E_BP_SYS_&VAR1
G1E_BP_DIA_&VAR1
G1E_TG_&VAR1
G1E_TOT_CHOL_&VAR1
G1E_HDL_&VAR1 
G1E_LDL_&VAR1
G1E_FBS_&VAR1
G1E_HGB_&VAR1
G1E_CRTN_&VAR1
G1E_GFR_&VAR1
G1E_SGOT_&VAR1
G1E_SGPT_&VAR1
G1E_GGT_&VAR1;
RUN;
%MEND SET; 
%SET(VAR1= SEX_TYPE)
PROC PRINT DATA=TTEST.FINAL_TABLE_SEX_TYPE; RUN;



*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 결측값 찾기 */
/* 240409 다시 체크 */

%macro MISS(DATA = ,VAR1= ,VAR2=);
DATA MISS_CHECK;
SET &DATA.;
IF &VAR1. ^= '.' THEN MISS_&VAR1._&VAR2. = 1;
ELSE MISS_&VAR1._&VAR2. = 0;
RUN;
ODS TRACE ON;
ODS OUTPUT CrossTabFreqs = MISSTABLE;
PROC FREQ DATA= MISS_CHECK;
TABLE MISS_&VAR1._&VAR2.*&VAR2.; RUN;
DATA MISSTABLE_&VAR1._&VAR2.(KEEP= MISS_&VAR1._&VAR2. &VAR2. Frequency Percent);
SET MISSTABLE;
IF MISS_&VAR1._&VAR2. = 0 & TARGET ^= '.';
RUN; 
%MEND MISS;


/* BMI 키 몸무게 */
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_BMI, VAR2 = &S.)
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_HGHT, VAR2 = &S.)
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_WGHT, VAR2 = &S.)

%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_BP_SYS, VAR2 = &S.)
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_BP_DIA, VAR2 = &S.)
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_TG, VAR2 = &S.)
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_TOT_CHOL, VAR2 = &S.)
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_HDL, VAR2 = &S.)
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_LDL, VAR2 = &S.)
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_FBS, VAR2 = &S.) /* 식전 혈당 */
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_HGB, VAR2 = &S.)  /* 혈색소 */
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_CRTN, VAR2 = &S.) /* 혈청크레아티닌수치 */
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_GFR, VAR2 = &S.) /* 신사구체여과율 */
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_SGOT, VAR2 = &S.) /* ast 수치 */
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_SGPT, VAR2 = &S.)  /* alt 수치 */
%MISS(DATA = NEWDEMO.final_casecontrol_&S., VAR1 = G1E_GGT, VAR2 = &S.)   /* 감마 gpt */



DATA FREQ.FINAL_MISS_TABLE_&S.;
SET 
MISSTABLE_G1E_BMI_&S.
MISSTABLE_G1E_HGHT_&S.
MISSTABLE_G1E_WGHT_&S.
MISSTABLE_G1E_BP_SYS_&S.
MISSTABLE_G1E_BP_DIA_&S.
MISSTABLE_G1E_TG_&S.
MISSTABLE_G1E_TOT_CHOL_&S.
MISSTABLE_G1E_HDL_&S.
MISSTABLE_G1E_LDL_&S.
MISSTABLE_G1E_FBS_&S.
MISSTABLE_G1E_HGB_&S.
MISSTABLE_G1E_CRTN_&S.
MISSTABLE_G1E_GFR_&S.
MISSTABLE_G1E_SGOT_&S.
MISSTABLE_G1E_SGPT_&S.
MISSTABLE_G1E_GGT_&S.;
RUN;
PROC PRINT DATA=FREQ.FINAL_MISS_TABLE_&S.; RUN;

*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/*    */






