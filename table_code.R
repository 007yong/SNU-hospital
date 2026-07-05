str(data)


# 변수들을 factor로 변환하는 코드
data$SEX_TYPE <- as.factor(data$SEX_TYPE)
data$AGE_GRP <- as.factor(data$AGE_GRP)
data$insurance <- as.factor(data$insurance)
data$alcohol_target <- as.factor(data$alcohol_target)
data$alcohol_target1 <- as.factor(data$alcohol_target1)
data$WEEK_TARGET <- as.factor(data$WEEK_TARGET)
data$MVPA_TARGET <- as.factor(data$MVPA_TARGET)
data$regular_exercise <- as.factor(data$regular_exercise)
data$BMI_TARGET <- as.factor(data$BMI_TARGET)
data$central <- as.factor(data$central)

#흡연력 
data$Q_SMK_YN <- as.factor(data$Q_SMK_YN)

data$SMOKE <- as.factor(data$SMOKE)
data$SMOKE_1 <- as.factor(data$SMOKE_1)
data$SMOKE_2 <- as.factor(data$SMOKE_2)

data$smoke_target <- as.factor(data$smoke_target)
data$smoke_target_1 <- as.factor(data$smoke_target_1)
data$SMK2 <- as.factor(data$SMK2)

data$cci_hp <- as.factor(data$cci_hp)
data$CCI_0 <- as.factor(data$CCI_0)
data$cci_2 <- as.factor(data$cci_2)
data$cci_5 <- as.factor(data$cci_5)
data$cci_8 <- as.factor(data$cci_8)
data$CCI_FREQ <- as.factor(data$CCI_FREQ)

data$ICD_CH_HT <- as.factor(data$ICD_CH_HT)
data$ICD_CH_DIAB <- as.factor(data$ICD_CH_DIAB)
data$ICD_CH_Dyslipidemia <- as.factor(data$ICD_CH_Dyslipidemia)
data$ICD_CH_IHD <- as.factor(data$ICD_CH_IHD)
data$ICD_CH_HF <- as.factor(data$ICD_CH_HF)
data$ICD_CH_TC <- as.factor(data$ICD_CH_TC)
data$ICD_CH_FOF <- as.factor(data$ICD_CH_FOF)
data$ICD_CH_COPD <- as.factor(data$ICD_CH_COPD)
data$ICD_CH_CKD_NEW <- as.factor(data$ICD_CH_CKD_NEW)
data$ICD_CH_CANCER <- as.factor(data$ICD_CH_CANCER)
data$ICD_CH_SRC <- as.factor(data$ICD_CH_SRC)
data$ICD_CH_ARC <- as.factor(data$ICD_CH_ARC)
data$ICD_CH_ORC <- as.factor(data$ICD_CH_ORC)
data$ICD_CH_PRC <- as.factor(data$ICD_CH_PRC) 
data$ICD_CH_LUNG_CANCER <- as.factor(data$ICD_CH_LUNG_CANCER)
data$ICD_CH_GRD <- as.factor(data$ICD_CH_GRD)
data$ICD_CH_DP <- as.factor(data$ICD_CH_DP)
data$ICD_CH_FL <- as.factor(data$ICD_CH_FL) 


#연속형 변환
data$age <- as.numeric(data$age)

data$Q_PA_VD <- as.numeric(data$Q_PA_VD)
data$Q_PA_MD <- as.numeric(data$Q_PA_MD)
data$Q_PA_WALK <- as.numeric(data$Q_PA_WALK)
data$WEEK_MET <- as.numeric(data$WEEK_MET)
data$MVPA <- as.numeric(data$MVPA)

data$G1E_BMI <- as.numeric(data$G1E_BMI)
data$G1E_HGHT <- as.numeric(data$G1E_HGHT)
data$G1E_WGHT <- as.numeric(data$G1E_WGHT)
data$G1E_WSTC <- as.numeric(data$G1E_WSTC)
data$G1E_BP_SYS <- as.numeric(data$G1E_BP_SYS)
data$G1E_BP_DIA <- as.numeric(data$G1E_BP_DIA)
data$G1E_TG <- as.numeric(data$G1E_TG)
data$G1E_TOT_CHOL <- as.numeric(data$G1E_TOT_CHOL)
data$G1E_HDL <- as.numeric(data$G1E_HDL)
data$G1E_LDL <- as.numeric(data$G1E_LDL)
data$G1E_FBS <- as.numeric(data$G1E_FBS)
data$G1E_HGB <- as.numeric(data$G1E_HGB)
data$G1E_CRTN <- as.numeric(data$G1E_CRTN)
data$G1E_GFR <- as.numeric(data$G1E_GFR)
data$G1E_SGOT <- as.numeric(data$G1E_SGOT)
data$G1E_SGPT <- as.numeric(data$G1E_SGPT)
data$G1E_GGT <- as.numeric(data$G1E_GGT)

data$CALC_CTRB_VTILE_FD <- as.numeric(data$CALC_CTRB_VTILE_FD)
data$py <- as.numeric(data$py)
data$py1 <- as.numeric(data$py1)
data$py_total <- as.numeric(data$py_total)




str(data)
view(data)



# 층화 변수  (예시로 'osa' 변수 추가)
# 범주형 변수들
catVars <- c("SEX_TYPE", "AGE_GRP", "insurance", "alcohol_target", "alcohol_target1",
             "WEEK_TARGET", "MVPA_TARGET", "regular_exercise", "BMI_TARGET", "central", 
             "Q_SMK_YN", "SMOKE", "SMOKE_1", "SMOKE_2", "smoke_target", "smoke_target_1", 
             "SMK2", "cci_hp", "CCI_0", "cci_2", "cci_5", "cci_8", "CCI_FREQ", 
             "ICD_CH_HT", "ICD_CH_DIAB", "ICD_CH_Dyslipidemia", "ICD_CH_IHD", 
             "ICD_CH_HF", "ICD_CH_TC", "ICD_CH_FOF", "ICD_CH_COPD", 
             "ICD_CH_CKD_NEW", "ICD_CH_CANCER", "ICD_CH_SRC", "ICD_CH_ARC", 
             "ICD_CH_ORC", "ICD_CH_PRC", "ICD_CH_LUNG_CANCER", "ICD_CH_GRD", 
             "ICD_CH_DP", "ICD_CH_FL")



# 연속형 변수들
myVars <- c("age", "Q_PA_VD", "Q_PA_MD", "Q_PA_WALK", "WEEK_MET", "MVPA",
            "G1E_BMI", "G1E_HGHT", "G1E_WGHT", "G1E_WSTC", "G1E_BP_SYS", 
            "G1E_BP_DIA", "G1E_TG", "G1E_TOT_CHOL", "G1E_HDL", "G1E_LDL", 
            "G1E_FBS", "G1E_HGB", "G1E_CRTN", "G1E_GFR", "G1E_SGOT", 
            "G1E_SGPT", "G1E_GGT", "CALC_CTRB_VTILE_FD", "py", "py1", 
            "py_total")



##############################################################
# 요약 통계 테이블 생성
# 범주 strata에 분석할 데이터명 
tab01_osa <- CreateTableOne(vars = catVars, strata = "osa", data=data)
# 연속 
tab02_osa <- CreateTableOne(vars = myVars, strata = "osa", data=data)

print(tab01_osa)
print(tab02_osa)


##############################################################
#table2.
tab01_sex <- CreateTableOne(vars = catVars, strata = "SEX_TYPE", data=data)
# 연속 
tab02_sex <- CreateTableOne(vars = myVars, strata = "SEX_TYPE", data=data)

print(tab01_sex)
print(tab02_sex)


##############################################################
#table3.
tab01_smk <- CreateTableOne(vars = catVars, strata = "Q_SMK_YN", data=data)
# 연속 
tab02_smk <- CreateTableOne(vars = myVars, strata = "Q_SMK_YN", data=data)

print(tab01_smk)
print(tab02_smk)


##############################################################
#table4.
tab01_smk_2 <- CreateTableOne(vars = catVars, strata = "SMOKE_2", data=data)
# 연속 
tab02_smk_2 <- CreateTableOne(vars = myVars, strata = "SMOKE_2", data=data)

print(tab01_smk_2)
print(tab02_smk_2)


##############################################################
#table5.
tab01_alcohol <- CreateTableOne(vars = catVars, strata = "alcohol_target1", data=data)
# 연속 
tab02_alcohol <- CreateTableOne(vars = myVars, strata = "alcohol_target1", data=data)

print(tab01_alcohol)
print(tab02_alcohol)


##############################################################
#table6.
tab01_physical1 <- CreateTableOne(vars = catVars, strata = "WEEK_TARGET", data=data)
# 연속 
tab02_physical1 <- CreateTableOne(vars = myVars, strata = "WEEK_TARGET", data=data)

print(tab01_physical1)
print(tab02_physical1)


##############################################################
#table7.
tab01_physical2 <- CreateTableOne(vars = catVars, strata = "MVPA_TARGET", data=data)
# 연속 
tab02_physical2 <- CreateTableOne(vars = myVars, strata = "MVPA_TARGET", data=data)

print(tab01_physical2)
print(tab02_physical2)
