
library(survival);library(survminer);library(tidyverse);library(tableone)
library(ggplot2);library(openxlsx)

# 데이터 프레임 생성
set.seed(123) # 결과 재현성을 위해 시드 설정

data <- data.frame(
  # 범주형 변수들 (factor)
  SEX_TYPE = factor(sample(c("Male", "Female"), 1000, replace = TRUE)),
  AGE_GRP = factor(sample(c("20-29", "30-39", "40-49", "50-59", "60+"), 1000, replace = TRUE)),
  insurance = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  WEEK_TARGET = factor(sample(c("0-1 times", "2-3 times", "4+ times"), 1000, replace = TRUE)),
  MVPA_TARGET = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  regular_exercise = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  BMI_TARGET = factor(sample(c("Normal", "Overweight", "Obese"), 1000, replace = TRUE)),
  central = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  
  Q_SMK_YN = factor(sample(c("Non-smoker","former_Smoker","current_Smoker"), 1000, replace = TRUE)),
  SMOKE = factor(sample(1:4, 1000, replace = TRUE)),
  SMOKE_1 = factor(sample(1:4, 1000, replace = TRUE)),
  SMOKE_2 = factor(sample(1:4, 1000, replace = TRUE)),
  smoke_target = factor(sample(1:6, 1000, replace = TRUE)),
  smoke_target_1 = factor(sample(1:6, 1000, replace = TRUE)),
  SMK2 = factor(sample(1:6, 1000, replace = TRUE)),
  
  alcohol_target = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  alcohol_target1 = factor(sample(1:4, 1000, replace = TRUE)),
  
  CCI_FREQ = factor(sample(0:10, 1000, replace = TRUE)),
  cci_hp = factor(sample(0:10, 1000, replace = TRUE)),
  CCI_0 = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  cci_2 = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  cci_5 = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  cci_8 = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  
  ICD_CH_HT = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_DIAB = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_Dyslipidemia = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_IHD = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_HF = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_TC = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_FOF = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_COPD = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_CKD_NEW = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_CANCER = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_SRC = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_ARC = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_ORC = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_PRC = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_LUNG_CANCER = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_GRD = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_DP = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  ICD_CH_FL = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  
  # 연속형 변수들 (numeric)
  age = rnorm(1000, mean = 50, sd = 10),
  
  Q_PA_VD = rnorm(1000, mean = 3, sd = 1),
  Q_PA_MD = rnorm(1000, mean = 5, sd = 1.5),
  Q_PA_WALK = rnorm(1000, mean = 4, sd = 1),
  WEEK_MET = rnorm(1000, mean = 1500, sd = 500),
  MVPA = rnorm(1000, mean = 30, sd = 10),
  
  G1E_BMI = rnorm(1000, mean = 25, sd = 4),
  G1E_HGHT = rnorm(1000, mean = 165, sd = 10),
  G1E_WGHT = rnorm(1000, mean = 70, sd = 15),
  G1E_WSTC = rnorm(1000, mean = 90, sd = 15),
  G1E_BP_SYS = rnorm(1000, mean = 120, sd = 15),
  G1E_BP_DIA = rnorm(1000, mean = 80, sd = 10),
  G1E_TG = rnorm(1000, mean = 150, sd = 50),
  G1E_TOT_CHOL = rnorm(1000, mean = 200, sd = 40),
  G1E_HDL = rnorm(1000, mean = 50, sd = 15),
  G1E_LDL = rnorm(1000, mean = 100, sd = 30),
  G1E_FBS = rnorm(1000, mean = 90, sd = 20),
  G1E_HGB = rnorm(1000, mean = 13, sd = 2),
  G1E_CRTN = rnorm(1000, mean = 1, sd = 0.3),
  G1E_GFR = rnorm(1000, mean = 90, sd = 20),
  G1E_SGOT = rnorm(1000, mean = 30, sd = 10),
  G1E_SGPT = rnorm(1000, mean = 30, sd = 10),
  G1E_GGT = rnorm(1000, mean = 40, sd = 15),

  #보험 분위수 
  CALC_CTRB_VTILE_FD = rnorm(1000, mean = 30, sd = 10),
  
  #흡연력 
  py = rnorm(1000, mean = 30, sd = 10),
  py1 = rnorm(1000, mean = 40, sd = 15),
  py_total = rnorm(1000, mean = 40, sd = 15),
  
  
  #시간 변수 
  EVENT_TIME = sample(seq(as.Date('2018/01/01'), as.Date('2021/12/31'), by="day"), 1000, replace=TRUE),
  MDCARE_STRT_DT_DAY = sample(seq(as.Date('2017/01/01'), as.Date('2021/12/31'), by="day"), 1000, replace=TRUE),
  END_DATE_C = as.Date('2021-12-31'),
  DEATH = sample(c(0, 1), 1000, replace=TRUE),
  DTH_ASSMD_DT_C = sample(seq(as.Date('2017/01/01'), as.Date('2021/12/31'), by="day"), 1000, replace=TRUE),
  HME_DT_C = sample(seq(as.Date('2011/01/01'), as.Date('2012/12/31'), by="day"), 1000, replace=TRUE),
  osa = factor(sample(c("0", "1"), 1000, replace = TRUE))
  
)


# 데이터 확인
View(data)
head(data)
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


##############################################################


data <- data.frame(
  EVENT_TIME = sample(seq(as.Date('2018/01/01'), as.Date('2021/12/31'), by="day"), n, replace=TRUE),
  MDCARE_STRT_DT_DAY = sample(seq(as.Date('2017/01/01'), as.Date('2021/12/31'), by="day"), n, replace=TRUE),
  END_DATE_C = as.Date('2021-12-31'),
  CENSORED_TIME = NA,
  DEATH = sample(c(0, 1), n, replace=TRUE),
  SURVIVAL_TIME = NA,
  DTH_ASSMD_DT_C = sample(seq(as.Date('2017/01/01'), as.Date('2021/12/31'), by="day"), n, replace=TRUE),
  HME_DT_C = sample(seq(as.Date('2011/01/01'), as.Date('2012/12/31'), by="day"), n, replace=TRUE)
)

# Adjust CENSORED_TIME, SURVIVAL_TIME, and DTH_ASSMD_DT_C based on DEATH and EVENT_TIME
for(i in 1:n){
  if(data$DEATH[i] == 1){
    data$DTH_ASSMD_DT_C[i] <- data$EVENT_TIME[i] + sample(1:100, 1)
    data$SURVIVAL_TIME[i] <- min(data$DTH_ASSMD_DT_C[i], data$END_DATE_C)
  } else {
    data$CENSORED_TIME[i] <- data$END_DATE_C
    data$SURVIVAL_TIME[i] <- min(data$EVENT_TIME[i], data$CENSORED_TIME[i])
  }
}

# View the first few rows of the dataset
print(head(data, 100))
data$osa <- factor(sample(c("0", "1"), 100, replace = TRUE))




##############################################################


# EVENT_TIME 계산
data <- data %>% mutate(
  EVENT_TIME = ifelse(osa == 0, "", EVENT_TIME)
)


# EVENT_TIME 계산
data <- data %>% mutate(
  EVENT_T = ifelse(osa == 1, as.numeric(MDCARE_STRT_DT_DAY - HME_DT_C), EVENT_TIME)
)

# CENSORED_TIME 계산
data <- data %>% mutate(  
  CENSORED_T = ifelse(osa == 0 & DEATH == 0, as.numeric(END_DATE_C - HME_DT_C), CENSORED_TIME),
  CENSORED_T = ifelse(osa == 0 & DEATH == 1, as.numeric(DTH_ASSMD_DT_C - HME_DT_C), CENSORED_TIME)
)



#변수형 check 
str(data)
data$EVENT_T <- as.numeric(data$EVENT_T)

#survival time 계산 
data <- data %>% mutate(SURVIVAL_T = pmin(EVENT_T, CENSORED_T, na.rm = TRUE))


data$SEX_TYPE <- data.frame(SEX_TYPE = factor(sample(c("Male", "Female"), 100, replace = TRUE)))

# SEX_TYPE 변수를 벡터로 변환
data$SEX_TYPE <- unlist(data$SEX_TYPE)

# 또는 SEX_TYPE 변수를 팩터로 변환
data$SEX_TYPE <- as.factor(unlist(data$SEX_TYPE))



new_data <- data %>% select(SURVIVAL_T, osa, SEX_TYPE)


fit1 <- survfit(Surv(SURVIVAL_T,osa)~ SEX_TYPE, data=new_data); # ~ 이 부분만 바꿔서 보면 됨
fit1

figure1 <- ggsurvplot(fit1, data=new_data)

length(new_data$SURVIVAL_T)
length(new_data$osa)
length(new_data$SEX_TYPE)


ggsurvplot(fit1, data = data)


?ggsurvplot

summary_fit1
summary_fit1 <- summary(fit1); summary_fit1

