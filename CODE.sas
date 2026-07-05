/* 제외 기준 */
proc sql;select count(*), count(distinct indi_dscm_no)from  real.ptn1;quit;  /* 5361 */
proc sql;select count(*), count(distinct indi_dscm_no)from  real.ptn2;quit;  /* 12215*/
proc sql;select count(*), count(distinct indi_dscm_no)from  real.ptn3;quit;  /* 1864 */
proc sql;select count(*), count(distinct indi_dscm_no)from  real.ptn4;quit;  /* 2975 */
proc sql;select count(*), count(distinct indi_dscm_no)from  real.ptn5;quit;  /* 13631 */


/* 대상자*/
proc sql;select count(*), count(distinct indi_dscm_no)from  real.step1;quit;  /* 4048540 */
proc sql;select count(*), count(distinct indi_dscm_no)from  real.step2;quit;  /* 4036325 */
proc sql;select count(*), count(distinct indi_dscm_no)from  real.step3;quit;  /* 4034461 */
proc sql;select count(*), count(distinct indi_dscm_no)from  real.step4;quit;  /* 4031486 */
proc sql;select count(*), count(distinct indi_dscm_no)from  real.step5;quit;  /* 4017855 */


/* case grp*/
proc sql;select count(*), count(distinct indi_dscm_no)from  cg.case_final_1;quit;  /* 6504 */
proc sql;select count(*), count(distinct indi_dscm_no)from  cg.case_final_2;quit;  /* 6460 */
proc sql;select count(*), count(distinct indi_dscm_no)from  cg.case_final_3;quit;  /* 6372 */
proc sql;select count(*), count(distinct indi_dscm_no)from  cg.case_final_4;quit;  /* 5017 */
proc sql;select count(*), count(distinct indi_dscm_no)from  cg.case_final_5;quit;  /* 5017 */
proc sql;select count(*), count(distinct indi_dscm_no)from  cg.case_final_6;quit;  /* 5016 */



/* 일반건강검진 수검자 */
/* 11-12 검진데이터 */
data final.total_g1eq;
set 
db.g1eq_2011
db.g1eq_2012;
run;
proc sql;select count(*), count(distinct indi_dscm_no)from  final.total_g1eq;quit;  /* 4053903 */
/* 자격자료 */
data bfc.total_bfc;
set 
db.bfc_2011
db.bfc_2012;
run;
proc sql;select count(*), count(distinct indi_dscm_no)from  bfc.total_bfc;quit;  /* 4053903 */


/* patient flow를 검진일자가 존재하고 청구데이터가 존재하는 대상자로 정의 */
/* 검진일자를 갖고있는 사람중에 청구데이터가 있는 대상자 (이게 전체 대상자) */
/* 검진INDI만으로 추출 */
PROC SQL;
CREATE TABLE NEWDATA.TARGET AS
SELECT a.indi_dscm_no,b.*
FROM final.total_g1eq AS a
LEFT JOIN T2040.t2040_target_check_total AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;
PROC SQL;
CREATE TABLE NEWDATA.TARGET_1 AS
SELECT a.indi_dscm_no,b.*
FROM final.total_g1eq AS a
INNER JOIN T2040.t2040_target_check_total AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;

/* 제외 대상자 831명 뭔지 확인 */
proc sql;
create table NEWDATA.CHECK_FINAL as
select a.indi_dscm_no
from NEWDATA.TARGET as a /* 대상자 확인 */
except
select b.indi_dscm_no
from  NEWDATA.TARGET_1 as b; 
quit;

proc sql;select count(*), count(distinct indi_dscm_no)from  NEWDATA.CHECK_FINAL;quit; 


PROC SQL;
CREATE TABLE NEWDATA.check_final_1 AS
SELECT a.indi_dscm_no,b.*
FROM NEWDATA.CHECK_FINAL AS a
INNER JOIN T2040.t2040_target_check_total AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;

/* 매크로로 찾아보기 */

%macro year(year);

PROC SQL;
CREATE TABLE NEWDATA.check_final_&year. AS
SELECT a.indi_dscm_no,b.*
FROM NEWDATA.CHECK_FINAL AS a
INNER JOIN T2040.t2040_target_check_&year. AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;

%mend;
%year(2002);%year(2003);%year(2004);%year(2005);
%year(2006);%year(2007);%year(2008);%year(2009);
%year(2010);%year(2011);%year(2012);%year(2013);
%year(2014);%year(2015);%year(2016);%year(2017);
%year(2018);%year(2019);%year(2020);%year(2021);

/* 전체 없는것 확인하였음 */


%macro year(year);

PROC DELETE DATA= NEWDATA.check_final_&year.;RUN;

%mend;
%year(2002);%year(2003);%year(2004);%year(2005);
%year(2006);%year(2007);%year(2008);%year(2009);
%year(2010);%year(2011);%year(2012);%year(2013);
%year(2014);%year(2015);%year(2016);%year(2017);
%year(2018);%year(2019);%year(2020);%year(2021);



/* 전체 대상자 찾기 */
/*일단 먼저 찾았으니까 코드를 줄일방법 생각 */
DATA NEWDATA.TARGET_2;
SET NEWDATA.TARGET_1;
IF substr(MCEX_SICK_SYM,1,4) in ('G473');
RUN; 
PROC SQL;
CREATE TABLE NEWDATA.TARGET_RE_CHECK AS
SELECT a.*,b.HME_DT
FROM NEWDATA.TARGET_2 AS a
LEFT JOIN final.total_g1eq AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;
/* 검진일보다 진단일자가 빠르면 제외기준 */
DATA NEWDATA.TARGET_RE_CHECK_1;
SET NEWDATA.TARGET_RE_CHECK;
IF DATE =< HME_DT ; /* 진단일 >= 검진일 */
RUN; 
proc sql;select count(*), count(distinct indi_dscm_no)from  NEWDATA.TARGET_RE_CHECK_1;quit;  /* 69407명 제외*/

/* 전체에서 G473X 대상자제외 */
proc sql;
create table NEWDATA.TARGET_3 as
select a.indi_dscm_no
from NEWDATA.TARGET_1 as a /* 대상자 확인 */
except
select b.indi_dscm_no
from NEWDATA.TARGET_RE_CHECK_1 as b; /* 69407명 제외 */
quit;


PROC SORT DATA= NEWDATA.TARGET_1 NODUPKEY OUT=NEWDATA.TARGET_1_CHECK;
BY INDI_DSCM_NO;
RUN;
/* N수 check */
DATA NEWDATA.TARGET_2_CHECK;
SET NEWDATA.TARGET_1_CHECK;
KEEP INDI_DSCM_NO; 
RUN;



proc sql;select count(*), count(distinct indi_dscm_no)from  NEWDATA.TARGET_2_CHECK;quit;  /* 831명 제외한 대상자 -> 4053072 */
proc sql;select count(*), count(distinct indi_dscm_no)from  NEWDATA.TARGET_3;quit;  /* 3983665 */


*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;

/*전체에서 찾기*/
/* 자격자료에서도 통일 */
PROC SQL;
CREATE TABLE NEWDATA.new_target AS
SELECT a.indi_dscm_no,b.*
FROM final.total_g1eq AS a /* 대상자 */
INNER JOIN BFC.bfc_total AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;
proc sql;select count(*), count(distinct indi_dscm_no)from  NEWDATA.new_target;quit;  /* 4053903명*/

*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 1월 30일 코드 확인 */
/* 안돌아가면 앞에 코드 사용 */
PROC SQL;
CREATE TABLE NEWDATA.new_target_1 AS
SELECT a.*,b.*
FROM NEWDATA.new_target AS a
INNER JOIN T2040.t2040_target_check_total AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;
/* 831명 제외 되는거 확인해야함 */

proc sql;select count(*), count(distinct indi_dscm_no)from NEWDATA.new_target_1;quit;  /* 4053903명*/


*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/*2월 1일 */
/* 831 다 붙음 다시 확인 */
/* 831명 데이터가 없었음 */
PROC SQL;
CREATE TABLE JUST_CHECK AS
SELECT a.*,b.*
FROM NEWDATA.CHECK_FINAL AS a /* 831명 INDI에 없는사람  */
LEFT JOIN NEWDATA.new_target_1 AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT; 
*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 여기 다시 */
/* NEWDATA.new_target_1  <- 완전 row-data*/

PROC SQL;
CREATE TABLE NEWDATA.new_target_row AS
SELECT a.*,b.*
FROM NEWDATA.new_target_1 AS a
INNER JOIN final.total_g1eq AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;


*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;

/* 2월 6일 코드 */
/* STEP1. */
/* 전체에서 자격자료없는 대상자제외 */
/* setting 다시 확인함 */
/* 너무 느려서 안됨; 정리하고 대상자 추출해야함 */
data j;
options obs=max;
set NEWDATA.new_target_row5;
run;


/* 대상자에서 indi만 추출 */
DATA NEWDATA.new_target_row_INDI;
SET final.total_g1eq;
KEEP INDI_DSCM_NO;
RUN; 

proc sort data=NEWDATA.new_target_row_INDi noduprecs out=NEWDATA.new_target_row_INDi1; 
by indi_dscm_no; run;
proc sql;select count(*), count(distinct indi_dscm_no)from NEWDATA.new_target_row_INDi1;quit;  /* 4053903명*/
proc sql;
create table NEWDATA.new_target_row1 as
select a.indi_dscm_no
from NEWDATA.new_target_row_INDI1 as a /* 전체 대상자 확인 */
except
select b.indi_dscm_no
from NEWDATA.CHECK_FINAL as b; /* 831명 제외 청구자료에 존재하지않음(뭔지 모르겠음)  */
quit;
proc sql;select count(*), count(distinct indi_dscm_no)from NEWDATA.new_target_row1;quit;  /* 4053072명 831제외 */

PROC SQL;
CREATE TABLE NEWDATA.new_target_row2 AS
SELECT a.*,b.HME_DT,B.EXMD_BZ_YYYY
FROM NEWDATA.new_target_row1 AS a
LEFT JOIN final.total_g1eq AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;
proc sql;select count(*), count(distinct indi_dscm_no)from NEWDATA.new_target_row2;quit;  /* 4053072명 831제외 */

PROC SORT DATA=NEWDATA.new_target_row2; BY INDI_DSCM_NO HME_DT; RUN;
DATA NEWDATA.new_target_row3;
SET NEWDATA.new_target_row2;
by indi_dscm_no HME_DT;
if first.indi_dscm_no then n_row=1; else n_row +1;
RUN;
PROC FREQ DATA=NEWDATA.new_target_row3; TABLE EXMD_BZ_YYYY*n_row; RUN;
DATA NEWDATA.new_target_row4;
SET NEWDATA.new_target_row3;
if n_row=1;
RUN;


/* row 데이터와 결합 */
PROC SQL;
CREATE TABLE NEWDATA.new_target_row5 AS
SELECT a.*,b.DATE,b.MDCARE_STRT_DT,b.MCEX_SICK_SYM
FROM NEWDATA.new_target_row4 AS a
INNER JOIN T2040.t2040_target_check_total AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.new_target_row5;quit;  /* ??????명*/

/* 날짜 셋팅 */
DATA NEWDATA.new_target_row6;
SET NEWDATA.new_target_row5;

if MDCARE_STRT_DT = ' ' then  MDCARE_STRT_DT = compress(date)||compress('15');

/*날짜 정리 */
MDCARE_STRT_DT_DAY = input(compress(MDCARE_STRT_DT),yymmdd8.);
HME_DT_DAY = input(compress(HME_DT),yymmdd8.);

format MDCARE_STRT_DT_DAY yymmdd8.;
format HME_DT_DAY yymmdd8.;
RUN;
DATA NEWDATA.new_target_row7;
SET NEWDATA.new_target_row6;

DIFF_DAY  = HME_DT_DAY - MDCARE_STRT_DT_DAY ; /* 검진일자 - 진단일자 */

IF substr(MCEX_SICK_SYM,1,4) in ('G473') THEN TARGET = 1;  ELSE TARGET = 0;

/* PATTERN 확인 */
IF TARGET = 0 THEN PTN = 0;
IF TARGET = 1 & MDCARE_STRT_DT_DAY =< HME_DT_DAY THEN PTN = 1; 
IF TARGET = 1 & -365 =< DIFF_DAY < 0 then PTN =2;
IF TARGET = 1 & PTN^=1 & PTN ^= 2 THEN PTN = 3; 

RUN;


/* case군은 진단일자로 & control군은 검진 시점으로 */
PROC SORT DATA = NEWDATA.new_target_row7; 
BY INDI_DSCM_NO MDCARE_STRT_DT_DAY; 
RUN;


*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 대상자 전체에서 분류  파악 */
/* 기존 */
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.new_target_CASE;quit;  /* 기존 46655명*/

/* 대상자 전체에서 분류  파악 */
/* INDI로 고려해야함 */
DATA NEWDATA.new_target_CASE;
SET NEWDATA.new_target_row7;
IF TARGET = 1;
RUN;

/* CONTROL GROUP 확인 */
/* indi */
/* 한번이라도 존재하였던사람 완전 제외 */
proc sql;
create table NEWDATA.new_target_CONTROL as
select a.indi_dscm_no
from NEWDATA.new_target_row7 as a /* 전체 대상자 확인 */
except
select b.indi_dscm_no
from NEWDATA.new_target_CASE as b; /* CASE_GROUP 제외 한번이라도 473X  */
quit;
PROC SQL;
CREATE TABLE NEWDATA.new_target_CONTROL1 AS
SELECT a.*,b.*
FROM NEWDATA.new_target_CONTROL AS a
INNER JOIN NEWDATA.new_target_row7 AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;

PROC FREQ DATA=NEWDATA.new_target_CASE; TABLE PTN; RUN;
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.new_target_CASE;quit;  /*  69407명 */
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.new_target_CONTROL;quit;  /*  3983665명*/
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.new_target_CONTROL1;quit;  /*  ????명*/



/* CASE GROUP 파악 */
/* 가장 빠른 진단일자 고려 */
/* 첫번째 청구자료 진단시점에서 추출한 자료 */
PROC SORT DATA=NEWDATA.new_target_CASE OUT=NEWDATA.new_target_CASE1 NODUPRECS; 
BY INDI_DSCM_NO MDCARE_STRT_DT_DAY; RUN;
DATA NEWDATA.new_target_CASE2(DROP=N_ROW);
SET NEWDATA.new_target_CASE1;
RUN;
DATA NEWDATA.new_target_CASE3;
SET NEWDATA.new_target_CASE2;
by indi_dscm_no MDCARE_STRT_DT;  /* G473X로 진단받은 가장 빠른일자 */
if first.indi_dscm_no then n_row=1; else n_row +1;
RUN;
DATA NEWDATA.new_target_CASE4;
SET NEWDATA.new_target_CASE3;
IF N_ROW = 1;
RUN;

/* 중복대상자 제외한 최종결과 */
PROC FREQ DATA=NEWDATA.new_target_CASE4; TABLE PTN; RUN;


DATA NEWDATA.new_target_CASE5(KEEP=INDI_DSCM_NO);
SET NEWDATA.new_target_CASE4;
IF PTN = 3;
RUN;
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.new_target_CASE5;quit;  /* 42026명 */


/* 최종 대상자 추출 */
PROC SQL;
CREATE TABLE NEWDATA.new_target_CASE_FINAL AS
SELECT a.*,b.*
FROM NEWDATA.new_target_CASE5 AS a
LEFT JOIN NEWDATA.new_target_CASE AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;
/* 인디 동일 최초 시점에 검지일 12개월 이후에 존재하는 환자 */
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.new_target_CASE_FINAL;quit;  /* 42026명 */


PROC SORT DATA=NEWDATA.new_target_CASE_FINAL; BY INDI_DSCM_NO MDCARE_STRT_DT_DAY; RUN;
DATA NEWDATA.new_target_CASE_FINAL_1;
SET NEWDATA.new_target_CASE_FINAL;
by indi_dscm_no MDCARE_STRT_DT;  /* 청구자료가 존재하는 가장 빠른일자 */
if first.indi_dscm_no then C_row=1; else C_row +1;
DROP N_ROW;
RUN;
PROC FREQ DATA=NEWDATA.new_target_CASE_FINAL_1; TABLE MCEX_SICK_SYM; RUN;


/* 정확한 대상자 파악 */
proc transpose data= NEWDATA.new_target_CASE_FINAL_1 out = NEWDATA.new_target_CASE_FINAL_2 prefix=dx;
by INDI_DSCM_NO; var MCEX_SICK_SYM;
run;

PROC contents data=NEWDATA.new_target_CASE_FINAL_2 out=coutentsdata(keep=name) noprint; run;
PROC SQL; SELECT COUNT(*) AS NumberOfColumns FROM coutentsdata; quit; /* 526 - 3 = 523*/



/* 동반질환 분석 */
%macro CHECK_TARGET (CHECK_TARGET); 

data NEWDATA.&CHECK_TARGET;
	set NEWDATA.new_target_CASE_FINAL_2;

/* 17. Acquired immune deficiency syndrome/human immunodeficiency virus */
	%LET DIS1=G473;
	%LET DC1=%STR('G473');
	%LET LBL1=%STR(TARGET1);

	%LET DIS2=G4730;
	%LET DC2=%STR('G4730');
	%LET LBL2=%STR(TARGET2);

	%LET DIS3=G4731;
	%LET DC3=%STR('G4731');
	%LET LBL3=%STR(TARGET3);

	%LET DIS4=G4732;
	%LET DC4=%STR('G4732');
	%LET LBL4=%STR(TARGET4);

	%LET DIS5=G4738;
	%LET DC5=%STR('G4738');
	%LET LBL5=%STR(TARGET5);

	%do DI=1 %to 5;/*KCD10 Charlson: 15 groups*/
		A&DI=0; 						
		%do DX=1 %to 523; 	/* DX .*/
			B&DX=0;
			%do SN=3 %to 5;
				if substr(dx&DX,1,&SN) in (&&DC&DI) then C&SN=1;Else C&SN=0;
				B&DX=B&DX+C&SN;
				drop C&SN;
			%end;
			A&DI=A&DI+B&DX;
			DROP B&DX;
		%end;
		if A&DI>0 then 	&&DIS&DI =1;else &&DIS&DI=0;
		label 			&&DIS&DI = &&LBL&DI;
		DROP A&DI;	
	%end;
run;

%mend CHECK_TARGET;
%CHECK_TARGET(CHECK_TARGET);


DATA NEWDATA.CHECK_TARGET1(KEEP=INDI_DSCM_NO G473 G4730 G4731 G4732 G4738 DELETE_TARGET FINAL_TARGET );
SET NEWDATA.CHECK_TARGET;
IF G4731 OR G4732 THEN DELETE_TARGET = 1;
ELSE DELETE_TARGET = 0;
IF G4730 = 1 THEN FINAL_TARGET = 1;
ELSE FINAL_TARGET = 0;
RUN;
DATA NEWDATA.CHECK_TARGET2;
SET NEWDATA.CHECK_TARGET1;
IF FINAL_TARGET = 1;
RUN;
DATA NEWDATA.CHECK_TARGET3(KEEP=INDI_DSCM_NO);
SET NEWDATA.CHECK_TARGET2;
RUN;

/* CASE_GROUP 전체 대상자  (G473) */
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.CHECK_TARGET1;quit;  /*  동일함 기존과 뽑았던것과 42026명 */
/* G4731,G4732 */
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.CHECK_TARGET2;quit;  /*  동일함 기존과 뽑았던것과 41610명 */
/* 기존 최종 대상자 */
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.CHECK_TARGET3;quit;  /*  동일함 기존과 뽑았던것과 34067명 */


PROC SQL;
CREATE TABLE NEWDATA.FINAL_CASE AS
SELECT a.*,b.*
FROM NEWDATA.CHECK_TARGET3 AS a
LEFT JOIN NEWDATA.new_target_CASE AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.FINAL_CASE;quit;  /* 34067명 */


*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;

/* CONTROL GROUP 파악 */
/* CASE CONTROL 두그룹 모두 BASELINE시점이 검진일자! */

DATA NEWDATA.new_target_CONTROL2;
SET NEWDATA.new_target_CONTROL1;
IF PTN = 0;
DROP n_row;
RUN;
PROC SORT DATA = NEWDATA.new_target_CONTROL2; 
BY INDI_DSCM_NO MDCARE_STRT_DT_DAY; 
RUN;
DATA NEWDATA.new_target_CONTROL3;
SET NEWDATA.new_target_CONTROL2;
by indi_dscm_no MDCARE_STRT_DT;  /* 청구자료가 존재하는 가장 빠른 검진일자 */
if first.indi_dscm_no then n_row=1; else n_row +1;
RUN;

proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.new_target_CONTROL1;quit;  /*  ????명*/
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.new_target_CONTROL2;quit;  /* 기존 ???명*/



*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 0213 */
/* baseline 시점 첫번째 검진일자를 기준으로 고려  */
/* 최종 대상자 추출 */
/* 제외 대상자 정리 */ 
/* CONTROL_INDI CODE */
/* NEWDATA.new_target_CONTROL; */

proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.CHECK_TARGET4;quit;  /*  34067명*/
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.new_target_CONTROL;quit;  /*  3983665명*/


DATA NEWDATA.CHECK_TARGET4;
SET NEWDATA.CHECK_TARGET3;
TARGET = 1;
RUN;
DATA NEWDATA.new_target_CONTROL1;
SET NEWDATA.new_target_CONTROL;
TARGET = 0;
RUN;
DATA NEWDATA.FINAL_CASECONTROL;
SET 
NEWDATA.CHECK_TARGET4
NEWDATA.new_target_CONTROL1;
RUN;

PROC FREQ DATA=NEWDATA.FINAL_CASECONTROL; TABLE TARGET; RUN;


/* 검진자료 & 자격자료 JOIN*/
/* 검진자료 */
PROC SQL;
CREATE TABLE NEWDATA.FINAL_CASECONTROL_1 AS
SELECT A.*,B.*
FROM NEWDATA.FINAL_CASECONTROL AS a
LEFT JOIN final.total_g1eq AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;
/* 여기서 한번 정리 */
/* 가장 첫번째 검진시점 기준*/
PROC SORT DATA=NEWDATA.FINAL_CASECONTROL_1; BY INDI_DSCM_NO HME_DT; RUN;
DATA NEWDATA.FINAL_CASECONTROL_2;
SET NEWDATA.FINAL_CASECONTROL_1;
by indi_dscm_no HME_DT; 
if first.indi_dscm_no then n_row=1; else n_row +1;
RUN;
DATA NEWDATA.FINAL_CASECONTROL_3;
SET NEWDATA.FINAL_CASECONTROL_2;
if n_row=1; 
RUN;


*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;

/* 여기 0214 자격자료 포함하기로 했음 */
/* 자격자료 */
/* 자격자료에서 검진연도와 자격자료 일치하지않는사람 2명 */
PROC SQL;
CREATE TABLE NEWDATA.FINAL_CASECONTROL_4 AS
SELECT A.*,B.*
FROM NEWDATA.FINAL_CASECONTROL_3 AS a
LEFT JOIN bfc.total_bfc AS b
ON a.indi_dscm_no = b.indi_dscm_no
WHERE A.EXMD_BZ_YYYY = B.STD_YYYY;
QUIT;

/* 최종 BASELINE 시점 대상자 조건 2명 포함 */
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.FINAL_CASECONTROL_3;quit;  /*  4017732명*/ 
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.FINAL_CASECONTROL_4;quit;  /*  4017730명*/ 

proc sql;
create table NEWDATA.FINAL_CASECONTROL_CHECK as
select a.indi_dscm_no
from NEWDATA.FINAL_CASECONTROL_3 as a /* 이미 만들어놓은 전체 대상자에서  */
except
select b.indi_dscm_no
from NEWDATA.FINAL_CASECONTROL_4 as b; /*  176명 제외  */
quit;


/* 자격자료 2명에대한 */
PROC SQL;
CREATE TABLE NEWDATA.ADD_TARGET AS
SELECT A.*,B.*
FROM NEWDATA.FINAL_CASECONTROL_3 AS a
LEFT JOIN bfc.total_bfc AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;
PROC SQL;
CREATE TABLE NEWDATA.ADD_TARGET_1 AS
SELECT A.*,B.*
FROM NEWDATA.FINAL_CASECONTROL_CHECK AS a
LEFT JOIN NEWDATA.ADD_TARGET AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;

/* 2명이 추가 */
DATA NEWDATA.FINAL_CASECONTROL_5;
SET 
NEWDATA.FINAL_CASECONTROL_4
NEWDATA.ADD_TARGET_1;
RUN;
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.FINAL_CASECONTROL_5;quit;  /*  4017732명*/ 
proc freq data=NEWDATA.FINAL_CASECONTROL_5; table target; run;


/* 831명 추가 */
/*검진자료 */
PROC SQL;
CREATE TABLE check_831 AS
SELECT A.*,B.*
FROM NEWDATA.CHECK_FINAL AS a
LEFT JOIN  final.total_g1eq AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;
/* 자격자료 */
PROC SQL;
CREATE TABLE check_831_2 AS
SELECT A.*,B.*
FROM check_831 AS a
LEFT JOIN bfc.total_bfc AS b
ON a.indi_dscm_no = b.indi_dscm_no
WHERE A.EXMD_BZ_YYYY = B.STD_YYYY;
QUIT;
PROC SORT DATA=CHECK_831_2; BY INDI_DSCM_NO HME_DT; RUN;
proc sql;select count(*), count(distinct indi_dscm_no) from CHECK_831_2;quit;  /*  831명*/ 

DATA CHECK_831_3;
SET CHECK_831_2;
BY INDI_DSCM_NO HME_DT;
IF first.INDI_DSCM_NO THEN N_ROW = 1; ELSE N_ROW +1;
RUN;
DATA CHECK_831_4;
SET CHECK_831_3;
if n_row=1; 
TARGET = 0;
RUN;
proc sql;select count(*), count(distinct indi_dscm_no) from CHECK_831_4;quit;  /*  831명*/ 

/* 831명이 추가 */
DATA NEWDATA.FINAL_CASECONTROL_6;
SET 
NEWDATA.FINAL_CASECONTROL_5 CHECK_831_4;
RUN;


/* CHECK */
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.FINAL_CASECONTROL_6;quit;  /*4018563 - 4017732명 = 831 */ 
PROC FREQ DATA=NEWDATA.FINAL_CASECONTROL_6; TABLE TARGET;RUN;


*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  ;
/* 0214 CASE 대상자 제외 */
/* G4730이 존재하면서 G4731 OR G4732가 존재하는 경우  제외 대상 */

DATA NEWDATA.DELETE_CASE;
SET NEWDATA.CHECK_TARGET1;
IF FINAL_TARGET = 1 &DELETE_TARGET = 1; /* G4730이 존재하면서 G4731 OR G4732가 존재하는 경우  제외 대상 */
RUN;
/* 176명 제외대상자  */
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.DELETE_CASE;quit;  /*  176명 */

/* 0214 CASE 대상자 제외 */
proc sql;
create table NEWDATA.FINAL_CASECONTROL_7 as
select a.indi_dscm_no
from NEWDATA.FINAL_CASECONTROL_6 as a /* 이미 만들어놓은 전체 대상자에서 4018563  */
except
select b.indi_dscm_no
from NEWDATA.DELETE_CASE as b; /*  176명 제외  */
quit;
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.FINAL_CASECONTROL_7;quit;  /*  4018563 - 4018387명 (176명 제외 확인)*/

PROC SQL;
CREATE TABLE NEWDATA.FINAL_CASECONTROL_8 AS
SELECT A.*,B.*
FROM NEWDATA.FINAL_CASECONTROL_7 AS a
LEFT JOIN NEWDATA.FINAL_CASECONTROL_6 AS b
ON a.indi_dscm_no = b.indi_dscm_no;
QUIT;

/* 0214완전 최종 데이터 */
/* 확인 */
proc sql;select count(*), count(distinct indi_dscm_no) from NEWDATA.FINAL_CASECONTROL_8;quit;  /*  4018387명 (176명 제외 확인)*/
PROC FREQ DATA=NEWDATA.FINAL_CASECONTROL_8; TABLE TARGET; RUN;


