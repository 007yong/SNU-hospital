/* 최종  */
/* 보험 분위수 파악*/
PROC UNIVARIATE DATA=NEWDATA.FINAL_CASECONTROL_8;
VAR CALC_CTRB_VTILE_FD; 
class target;
run;

/* 여기부터 있음 */
PROC SQL;
CREATE TABLE NEWDATA.FINAL_CASECONTROL_9 AS
SELECT A.*,B.*
FROM NEWDATA.FINAL_CASECONTROL_8 AS A
LEFT JOIN NEWDEMO.casecontrol_CCI_4_RE AS B
ON A.INDI_DSCM_NO=B.INDI_DSCM_NO;
QUIT;
DATA NEWDATA.FINAL_CASECONTROL_10;
SET NEWDATA.FINAL_CASECONTROL_9;
IF cci_hp = '.' THEN cci_hp = 0;
run;
proc sql;select count(*), count(distinct indi_dscm_no)from NEWDATA.FINAL_CASECONTROL_10;quit;  /* 4018387 */
proc sql;select count(*), count(distinct indi_dscm_no)from NEWDEMO.final_casecontrol;quit;  /* 4018387 */

/* 완전 최종 */
PROC SQL;
CREATE TABLE NEWDATA.FINAL_CASECONTROL_11 AS
SELECT A.*,B.*
FROM NEWDATA.FINAL_CASECONTROL_10 AS A
LEFT JOIN NEWDEMO.casecontrol_como_1 AS B /* 동반질환 결합 */
ON A.INDI_DSCM_NO=B.INDI_DSCM_NO;
QUIT;
DATA NEWDATA.FINAL_CASECONTROL_12;
SET NEWDATA.FINAL_CASECONTROL_11;
IF ICD_CH_HT = '.' THEN ICD_CH_HT = 0;
IF ICD_CH_DIAB = '.' THEN ICD_CH_DIAB = 0;
IF ICD_CH_Dyslipidemia = '.' THEN ICD_CH_Dyslipidemia = 0;
IF ICD_CH_IHD = '.' THEN ICD_CH_IHD = 0;
IF ICD_CH_HF = '.' THEN ICD_CH_HF = 0;
IF ICD_CH_TC = '.' THEN ICD_CH_TC = 0;
IF ICD_CH_FOF = '.' THEN ICD_CH_FOF = 0;
IF ICD_CH_COPD = '.' THEN ICD_CH_COPD = 0;
/* IF ICD_CH_CKD = '.' THEN ICD_CH_CKD = 0; (제외 시킴둥)*/
IF ICD_CH_CANCER = '.' THEN ICD_CH_CANCER = 0;
IF ICD_CH_SRC =  '.' THEN ICD_CH_SRC = 0;
IF ICD_CH_ARC = '.' THEN ICD_CH_ARC = 0;
IF ICD_CH_ORC = '.' THEN ICD_CH_ORC = 0;
IF ICD_CH_PRC = '.' THEN ICD_CH_PRC = 0;
run;
/*라벨 */
DATA NEWDATA.FINAL_CASECONTROL_12;
SET NEWDATA.FINAL_CASECONTROL_12;
LABEL ICD_CH_HT = Hypertension;
RUN;


proc sql;select count(*), count(distinct indi_dscm_no)from NEWDATA.FINAL_CASECONTROL_11;quit;  /* 4018387 */
proc sql;select count(*), count(distinct indi_dscm_no)from  NEWDATA.FINAL_CASECONTROL_12;quit;  /* 4018387 */

/* 변수정리 */
data NEWDEMO.final_casecontrol;
set NEWDATA.FINAL_CASECONTROL_12;

/* 나이 분위수 고려*/ 
/* 검진 당시의 나이 */
/* 연령 */
age = EXMD_BZ_YYYY - BYEAR;

if 39 <= age< 45 then age_grp= 1;
if 45 <= age< 50 then age_grp= 2;
if 50 <= age< 55 then age_grp= 3;
if 55 <= age< 60 then age_grp= 4;
if 60 <= age< 65 then age_grp= 5;
if 65 <= age< 70 then age_grp= 6;
if 70 <= age< 75 then age_grp= 7;
if 75 <= age< 80 then age_grp= 8;
if 80 <= age  then age_grp= 9;


/* 정의에 따라서 case / control 분류 */

/* 보험분위수 */
IF target = 1 & 0 =< CALC_CTRB_VTILE_FD =< 9  then insurance =1;
IF target = 1 & 9  < CALC_CTRB_VTILE_FD =< 15 then insurance =2;
IF target = 1 & 15 < CALC_CTRB_VTILE_FD =< 18  then insurance =3;
IF target = 1 & 18 < CALC_CTRB_VTILE_FD  then insurance =4;

IF target = 0 & 0 =< CALC_CTRB_VTILE_FD =< 7  then insurance =1;
IF target = 0 & 7  < CALC_CTRB_VTILE_FD =< 13 then insurance =2;
IF target = 0 & 13 < CALC_CTRB_VTILE_FD =< 17  then insurance =3;
IF target = 0 & 17 < CALC_CTRB_VTILE_FD  then insurance =4;

if insurance = '.' then insurance = 5;  /* unknown */



/* 운동량 */
IF 3 =< Q_PA_VD OR 5 =< Q_PA_MD THEN regular_exercise = 1;
ELSE IF regular_exercise ^=1 AND Q_PA_VD ='.' AND Q_PA_MD = '.' THEN regular_exercise = 2;
ELSE regular_exercise = 0;


WEEK_MET = (((Q_PA_WALK*3)*30) + ((Q_PA_MD*4)*30) + ((Q_PA_VD*8)*20));
MVPA = Q_PA_VD + Q_PA_MD;

IF WEEK_MET = 0 THEN WEEK_TARGET = 1;
IF 1 =< WEEK_MET =< 499 THEN WEEK_TARGET = 2;
IF 500 =< WEEK_MET =< 999 THEN WEEK_TARGET = 3;
IF 1000 =< WEEK_MET  THEN WEEK_TARGET = 4;
IF WEEK_MET ='.' THEN WEEK_TARGET = 5;





IF MVPA = 0 THEN MVPA_TARGET = 1;
IF 1 =< MVPA =< 2 THEN MVPA_TARGET = 2;
IF 3 =< MVPA =< 4 THEN MVPA_TARGET = 3;
IF 5 =< MVPA THEN MVPA_TARGET = 4;
IF MVPA = '.' THEN MVPA_TARGET = 5;

IF G1E_URN_PROT = '.' THEN G1E_URN_PROT = 7;

/*BMI*/
IF G1E_BMI= '.' then G1E_BMI = ((G1E_WGHT*G1E_WGHT)/G1E_HGHT);

/* BMI */
IF G1E_BMI ^= '.' & G1E_BMI < 18.5 THEN BMI_TARGET = 1;
IF G1E_BMI ^= '.' & 18.5 =< G1E_BMI < 23 THEN BMI_TARGET = 2;
IF G1E_BMI ^= '.' & 23 =< G1E_BMI < 25 THEN BMI_TARGET = 3;
IF G1E_BMI ^= '.' & 25 =< G1E_BMI < 30 THEN BMI_TARGET = 4;
IF G1E_BMI ^= '.' & 30 =< G1E_BMI THEN BMI_TARGET = 5;
IF BMI_TARGET = '.' THEN BMI_TARGET = 6; /* unknown */


/* 허리둘레 */
IF SEX_TYPE=1 & G1E_WSTC ^= '.' & G1E_WSTC < 90 then central = 0;
IF SEX_TYPE=1 & G1E_WSTC ^= '.' & 90 =< G1E_WSTC then central = 1;  

IF SEX_TYPE=2 & G1E_WSTC ^= '.' & G1E_WSTC < 85 then central = 0;
IF SEX_TYPE=2 & G1E_WSTC ^= '.' & 85 =< G1E_WSTC then central = 1; 
IF central = '.' THEN central = 2;  /* unknown */


IF G1E_LDL = '.' THEN G1E_LDL = G1E_LDL_MSR;

/* CCI */
IF cci_hp = '.' THEN cci_hp = 0;
IF cci_hp = 0  THEN CCI_0 = 0;
if cci_hp = 0  THEN  CCI_2 = 0;
if cci_hp = 0  THEN  CCI_5 = 0;
if cci_hp = 0  THEN  CCI_8 = 0;

IF cci_hp > 10 THEN CCI_FREQ = 11; ELSE CCI_FREQ = CCI_HP;


/* ckd 추가 재정의*/
/* 
2011년 검진데이터에는 신사구체여과율이 없음. 혈청크레아티닌 (Cr) 수치만 있고, 
신사구체여과율 (GFR) 수치는 없는 경우에는,
MDRD  변환 공식 기반으로 혈청크레아티닌 수치를 이용해 신사구체여과율을 새로 계산한 후 CKD 정의에 사용해주세요.

CKD=yes: 
GFR <60 또는 GFR이 missing 일 경우 ICD code (N18.x, N19.x, Z49.x, Z99.2) 

CKD = NO;
CKD=no: GFR >=60 또는 GFR이 missing 일 경우 ICD code (N18.x, N19.x, Z49.x, Z99.2) 없을 경우
*/


IF SEX_TYPE = 1 & G1E_GFR = '.' THEN G1E_GFR = (175*((G1E_CRTN**(-1.154))*(age**(-0.203))));
IF SEX_TYPE = 2 & G1E_GFR = '.' THEN G1E_GFR = (175*((G1E_CRTN**(-1.154))*(age**(-0.203)))*(0.742));

IF ICD_CH_CKD = 1 OR G1E_GFR < 60 THEN ICD_CH_CKD_NEW = 1; 
IF ICD_CH_CKD ^= 1 & G1E_GFR >= 60 THEN ICD_CH_CKD_NEW = 0;

RUN;
proc sql;select count(*), count(distinct indi_dscm_no)from NEWDEMO.final_casecontrol;quit;  /* 4018387 */
*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;

/* setting 2 */
/* 1. 주간음주일수가 0 일때 = 0
2. 주간음주일수가 0 이고 일간음주가  0또는  missing 일경우 */

data NEWDEMO.final_casecontrol_1;
set NEWDEMO.final_casecontrol;

/* 음주력 */
alcohol = (Q_DRK_AMT_V09N*7.5*Q_DRK_FRQ_V09N);

IF Q_DRK_FRQ_V09N = 0 AND Q_DRK_AMT_V09N = '.' THEN alcohol = 0;
IF Q_DRK_FRQ_V09N > 0 AND Q_DRK_AMT_V09N = '.' THEN alcohol = '.';     /* 주간 음주량이 0보다 큰데 일일음주량이  결측이면 결측 */
IF Q_DRK_FRQ_V09N = '.' AND Q_DRK_AMT_V09N ^= '.' THEN alcohol = '.';   /* 주간 음주량이 결측이면 일일음주량이 존재해도 결측 */


IF alcohol ^= '.' &  alcohol < 105   then alcohol_target = 0;
IF alcohol ^= '.' & alcohol >= 105  then alcohol_target =1;
if alcohol_target = '.' then alcohol_target = 2; /* unknown */

IF alcohol = 0 then alcohol_target1 = 1;
IF alcohol ^= '.' & 0 < alcohol < 105 then alcohol_target1 = 2;
IF alcohol ^= '.' & 105 =< alcohol =< 120 then alcohol_target1 = 3 ;
IF alcohol ^= '.' & 120 < alcohol  then alcohol_target1 = 4;
if alcohol_target1 = '.' then alcohol_target1 = 5;  /* unknown */


/* 흡연력 */
if Q_SMK_YN = '.' then Q_SMK_YN = 4;
if Q_SMK_YN = 1 AND (Q_SMK_PRE_DRT ^= '.' OR Q_SMK_PRE_AMT ^= '.' OR Q_SMK_NOW_DRT ^= '.' OR Q_SMK_NOW_AMT_V09N ^= '.') THEN Q_SMK_YN=4; /* 비흡연자인데 흡연력을 계산하는 경우가 있는경우 */
if Q_SMK_YN = 2 AND (Q_SMK_NOW_DRT ^= '.' OR Q_SMK_NOW_AMT_V09N ^= '.') THEN Q_SMK_YN = 4; /* former인데 current를 계산하는 항목이 있는경우 */
if Q_SMK_YN = 3 AND (Q_SMK_PRE_DRT ^= '.' OR Q_SMK_PRE_AMT ^= '.') THEN Q_SMK_YN = 4; /* current인데 former를 계산하는 항목이 있는경우 */

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


py1 = ((Q_SMK_NOW_DRT*Q_SMK_NOW_AMT_V09N)/20);

/** current **/
IF Q_SMK_YN = 3 & py1 ^= '.' & 0 < py1 < 15 then smoke_target_1 = 1; /* 15보다 작으면 */
IF Q_SMK_YN = 3 & py1 ^= '.' & 15 =< py1 < 30 then smoke_target_1 = 2; /* 15 =<  30보다 크면 */
IF Q_SMK_YN = 3 & py1 ^= '.' &  30 =< py1 then smoke_target_1 = 3; 

/* (Missing) */
IF Q_SMK_YN = 3 & PY1 = 0 THEN smoke_target_1 = 4;  /* 0과 같은경우  (Missing)  */
IF Q_SMK_YN = 3 & py1 = '.'  then smoke_target_1 = 5; /* unknown */ 
IF Q_SMK_YN = 3 & PY1 < 0 THEN smoke_target_1 = 6;  /* 보다 작은경우  (Missing)  */

/* 최종 */
IF smoke_target_1 = 1 THEN SMOKE_1 = 1;
IF smoke_target_1 = 2 THEN SMOKE_1 = 2;
IF smoke_target_1 = 3 THEN SMOKE_1 = 3;
IF smoke_target_1 = 4 OR smoke_target_1 = 5 OR smoke_target_1 = 6 THEN SMOKE_1 = 4; 


IF PY ^= '.'   AND PY < 0 THEN PY = '.'; /*** former ***/
IF PY1 ^= '.'  AND PY1 < 0 THEN PY1 = '.'; /* ** current ***/

/* former & current */
if Q_SMK_YN = 2 or Q_SMK_YN = 3 then py_total_target = 1; else py_total_target = 0;

IF  SMOKE    ^= '.'  & py_total_target = 1 THEN  py_total = py;
IF SMOKE_1  ^= '.'  & py_total_target = 1 THEN  py_total = PY1;

IF  py_total_target = 1 & 0 < py_total < 15 then SMK2 = 1; /* 15보다 작으면 */
IF  py_total_target = 1 & 15 =< py_total < 30 then SMK2 = 2; /* 15 =<  30보다 크면 */
IF  py_total_target = 1 & 30 =< py_total then SMK2 = 3;

/* (Missing) */
IF py_total_target = 1 & py_total = 0 then SMK2 = 4;
IF py_total_target = 1 & py_total = '.'  then SMK2 = 5; /* unknown */
IF py_total_target = 1 & py_total ^= '.' AND py_total < 0   then SMK2 = 6; /* unknown (없음)*/

/* 최종 */
IF SMK2 = 1 THEN SMOKE_2 = 1;
IF SMK2 = 2 THEN SMOKE_2 = 2;
IF SMK2 = 3 THEN SMOKE_2 = 3;
IF SMK2 = 4 OR SMK2 = 5 OR SMK2 = 6 THEN SMOKE_2 = 4; 

run; 
proc sql;select count(*), count(distinct indi_dscm_no)from NEWDEMO.final_casecontrol_1;quit;  /* 4018387 */

/* 없는거 확인하였음 */
data check_p;
set NEWDEMO.final_casecontrol_1;
if Q_SMK_YN = '.';
run;

/* 기존 정의에서 CODP 제외 */
DATA NEWDEMO.final_casecontrol_2(DROP=ICD_CH_COPD);
SET NEWDEMO.final_casecontrol_1;
RUN;
PROC SQL;
CREATE TABLE NEWDEMO.final_casecontrol_3 AS
SELECT A.*,B.*
FROM NEWDEMO.final_casecontrol_2 AS A
LEFT JOIN NEWDEMO.como_2_cci AS B
ON A.INDI_DSCM_NO=B.INDI_DSCM_NO;
QUIT;
proc sql;select count(*), count(distinct indi_dscm_no)from NEWDEMO.final_casecontrol_1;quit;  /* 4018387 */

*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 최종 데이터 셋 */
/* 추가된 변수 COMO */
DATA NEWDEMO.final_casecontrol_4;
SET NEWDEMO.final_casecontrol_3;
IF ICD_CH_LUNG_CANCER = '.' THEN  ICD_CH_LUNG_CANCER = 0;
IF ICD_CH_GRD = '.' THEN ICD_CH_GRD = 0;
IF ICD_CH_DP = '.' THEN ICD_CH_DP = 0;
IF ICD_CH_FL = '.' THEN ICD_CH_FL = 0;
IF ICD_CH_COPD = '.' THEN ICD_CH_COPD = 0;
RUN;

/* 최종 데이터 셋 */
/* 추가된 변수 COMO */
DATA NEWDEMO.final_casecontrol_3;
SET NEWDEMO.final_casecontrol_3;
IF ICD_CH_LUNG_CANCER = '.' THEN  ICD_CH_LUNG_CANCER = 0;
IF ICD_CH_GRD = '.' THEN ICD_CH_GRD = 0;
IF ICD_CH_DP = '.' THEN ICD_CH_DP = 0;
IF ICD_CH_FL = '.' THEN ICD_CH_FL = 0;
IF ICD_CH_COPD = '.' THEN ICD_CH_COPD = 0;
RUN;

/*여기부터 시작 됨*/
/* COHORT A*/
/* COHORT A 파악완료*/
DATA NEWDEMO.COHORT_A;
SET NEWDEMO.final_casecontrol_3;
IF SMOKE = 4 OR WEEK_TARGET = 5 OR alcohol_target = 2 THEN DELETE;
RUN;


/* 
SMOKE  -> 4 
WEEK_TARGET -> 5
ALCOHOL_TARGET -> 2 
*/






*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 240426 */
DATA COHORT_A;
SET NEWDEMO.final_casecontrol_4;
PY_final = py_total;
IF  Q_SMK_YN = 1 THEN PY_final = 0;
RUN;
/* 이상한값 포함되어있음 */
PROC FREQ DATA=COHORT_A;
TABLE PY_final;RUN;

/* CHECK */
/* N수 체크 */
DATA COHORT_A_1;
SET COHORT_A;
IF PY_final = '.';
RUN; 
/* 14542 명 제외됨 */
proc sql;select count(*), count(distinct indi_dscm_no)from COHORT_A_1;quit;  
/* 그냥 CHECK */
DATA COHORT_A_2;
SET COHORT_A_1;
KEEP Q_SMK_PRE_DRT Q_SMK_PRE_AMT Q_SMK_NOW_DRT Q_SMK_NOW_AMT_V09N Q_SMK_NOW_AMT
INDI_DSCM_NO Q_SMK_YN SMOKE_1 py PY1 smoke_target_1 py_total py_total_target smk2 smoke_2 py_total_final;
RUN;

/* 제외시켜야함 */
DATA COHORT_A_RE;
SET COHORT_A;
IF PY_final = '.' THEN DELETE;
RUN;
/* 없는것 확인함 */
DATA COHORT_A_CHECK ;
SET COHORT_A_RE;
if Q_SMK_YN = 1 AND (Q_SMK_PRE_DRT ^= '.' OR Q_SMK_PRE_AMT ^= '.' OR Q_SMK_NOW_DRT ^= '.' OR Q_SMK_NOW_AMT_V09N ^= '.');
RUN; 



/* COHORT A*/
/* COHORT A 파악완료*/
DATA NEWDEMO.COHORT_A;
SET COHORT_A_RE;
IF WEEK_TARGET = 5 OR alcohol_target = 2 THEN DELETE;
RUN;
PROC SQL;SELECT COUNT(*),COUNT(DISTINCT INDI_DSCM_NO) FROM NEWDEMO.COHORT_A; QUIT;

PROC FREQ DATA=COHORT_A;
TABLE Q_SMK_YN*py_total_target;
RUN;


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





*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;

/* 최종 데이터 셋 */
/* 추가된 변수 COMO */
DATA NEWDEMO.final_casecontrol_3;
SET NEWDEMO.final_casecontrol_3;
IF ICD_CH_LUNG_CANCER = '.' THEN  ICD_CH_LUNG_CANCER = 0;
IF ICD_CH_GRD = '.' THEN ICD_CH_GRD = 0;
IF ICD_CH_DP = '.' THEN ICD_CH_DP = 0;
IF ICD_CH_FL = '.' THEN ICD_CH_FL = 0;
IF ICD_CH_COPD = '.' THEN ICD_CH_COPD = 0;
RUN;

/*여기부터 시작 됨*/
/* COHORT A*/
/* COHORT A 파악완료*/
DATA NEWDEMO.COHORT_A;
SET NEWDEMO.final_casecontrol_3;
IF SMOKE = 4 OR WEEK_TARGET = 5 OR alcohol_target = 2 THEN DELETE;
RUN;









*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;

/* setting 2 */
/* 1. 주간음주일수가 0 일때 = 0
2. 주간음주일수가 0 이고 일간음주가  0또는  missing 일경우 */

data RE_CHECK;
set NEWDEMO.final_casecontrol;

/* 흡연력 */
if Q_SMK_YN = '.' then Q_SMK_YN = 4;
if Q_SMK_YN = 1 AND (Q_SMK_PRE_DRT ^= '.' OR Q_SMK_PRE_AMT ^= '.' OR Q_SMK_NOW_DRT ^= '.' OR Q_SMK_NOW_AMT_V09N ^= '.') THEN Q_SMK_YN=4;
if Q_SMK_YN = 2 AND (Q_SMK_NOW_DRT ^= '.' OR Q_SMK_NOW_AMT_V09N ^= '.') THEN Q_SMK_YN = 4;
if Q_SMK_YN = 3 AND (Q_SMK_PRE_DRT ^= '.' OR Q_SMK_PRE_AMT ^= '.') THEN Q_SMK_YN = 4; 

py= ((Q_SMK_PRE_DRT*Q_SMK_PRE_AMT )/20); /* 해당 변수로 고려 */

/** former **/
IF Q_SMK_YN = 2 & py ^= '.' & 0 < py < 15 then former_smoke = 1; /* 15보다 작으면 */
IF Q_SMK_YN = 2 & py ^= '.' & 15 =< py < 30 then former_smoke = 2; /* 15 =<  30보다 크면 */
IF Q_SMK_YN = 2 & py ^= '.' &  30 =< py then former_target = 3;

/* (Missing) 계산이 이상한경우 */
IF Q_SMK_YN = 2 & py = 0 THEN smoke_target = 4;  /* 0과 같은경우  (Missing) */
IF Q_SMK_YN = 2 & py = '.' THEN  smoke_target = 5; /* unknown */
IF Q_SMK_YN = 2 & py < 0 THEN smoke_target = 6;  /* 보다 작은경우  (Missing)  */


/* 최종 */
IF smoke_target = 1 THEN SMOKE = 1;
IF smoke_target = 2 THEN SMOKE = 2;
IF smoke_target = 3 THEN SMOKE = 3;
IF smoke_target = 4 OR smoke_target = 5 OR smoke_target = 6 THEN SMOKE = 4; 


py1 = ((Q_SMK_NOW_DRT*Q_SMK_NOW_AMT_V09N)/20);

/** current **/
IF Q_SMK_YN = 3 & py1 ^= '.' & 0 < py1 < 15 then smoke_target_1 = 1; /* 15보다 작으면 */
IF Q_SMK_YN = 3 & py1 ^= '.' & 15 =< py1 < 30 then smoke_target_1 = 2; /* 15 =<  30보다 크면 */
IF Q_SMK_YN = 3 & py1 ^= '.' &  30 =< py1 then smoke_target_1 = 3; 

/* (Missing) */
IF Q_SMK_YN = 3 & PY1 = 0 THEN smoke_target_1 = 4;  /* 0과 같은경우  (Missing)  */
IF Q_SMK_YN = 3 & py1 = '.'  then smoke_target_1 = 5; /* unknown */ 
IF Q_SMK_YN = 3 & PY1 < 0 THEN smoke_target_1 = 6;  /* 보다 작은경우  (Missing)  */

/* 최종 */
IF smoke_target_1 = 1 THEN SMOKE_1 = 1;
IF smoke_target_1 = 2 THEN SMOKE_1 = 2;
IF smoke_target_1 = 3 THEN SMOKE_1 = 3;
IF smoke_target_1 = 4 OR smoke_target_1 = 5 OR smoke_target_1 = 6 THEN SMOKE_1 = 4; 


IF PY ^= '.'   AND PY < 0 THEN PY = '.';
IF PY1 ^= '.'  AND PY1 < 0 THEN PY1 = '.';

/* former & current */
if Q_SMK_YN = 2 or Q_SMK_YN = 3 then py_total_target = 1; else py_total_target = 0;

IF  SMOKE    ^= '.'  & py_total_target = 1 THEN  py_total = py;
IF SMOKE_1  ^= '.'  & py_total_target = 1 THEN  py_total = PY1;

IF  py_total_target = 1 & 0 < py_total < 15 then SMK2 = 1; /* 15보다 작으면 */
IF  py_total_target = 1 & 15 =< py_total < 30 then SMK2 = 2; /* 15 =<  30보다 크면 */
IF  py_total_target = 1 & 30 =< py_total then SMK2 = 3;

/* (Missing) */
IF py_total_target = 1 & py_total = 0 then SMK2 = 4;
IF py_total_target = 1 & py_total = '.'  then SMK2 = 5; /* unknown */
IF py_total_target = 1 & py_total ^= '.' AND py_total < 0   then SMK2 = 6; /* unknown (없음)*/

/* 최종 */
IF SMK2 = 1 THEN SMOKE_2 = 1;
IF SMK2 = 2 THEN SMOKE_2 = 2;
IF SMK2 = 3 THEN SMOKE_2 = 3;
IF SMK2 = 4 OR SMK2 = 5 OR SMK2 = 6 THEN SMOKE_2 = 4; 

run; 
