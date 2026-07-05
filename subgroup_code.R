install.packages("Publish")
install.packages("gt")

library(gt)
library(Publish)
library(survival);library(survminer);library(tidyverse);library(tableone)
library(ggplot2);
require(data.table)


##############################################################
data <- data.frame(
  # 범주형 변수들 (factor)
  SEX_TYPE = factor(sample(c("Male", "Female"), 1000, replace = TRUE)),
  AGE_GRP = factor(sample(c("20-29", "30-39", "40-49", "50-59", "60+"), 1000, replace = TRUE)),
  insurance = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  WEEK_TARGET = factor(sample(c("0-1 times", "2-3 times", "4+ times"), 1000, replace = TRUE)),
  MVPA_TARGET = factor(sample(c("Yes", "No"), 1000, replace = TRUE)),
  regular_exercise = factor(sample(c("1", "0","'"), 1000, replace = TRUE)),
  BMI_TARGET = factor(sample(c("Normal", "Overweight", "Obese"), 1000, replace = TRUE)),
  central = factor(sample(c("1", "0","'"), 1000, replace = TRUE)),
  
  Q_SMK_YN = factor(sample(c("Non-smoker","former_Smoker","current_Smoker"), 1000, replace = TRUE)),
  SMOKE = factor(sample(1:4, 1000, replace = TRUE)),
  SMOKE_1 = factor(sample(1:4, 1000, replace = TRUE)),
  SMOKE_2 = factor(sample(1:4, 1000, replace = TRUE)),
  smoke_target = factor(sample(1:6, 1000, replace = TRUE)),
  smoke_target_1 = factor(sample(1:6, 1000, replace = TRUE)),
  SMK2 = factor(sample(1:6, 1000, replace = TRUE)),
  
  alcohol_target = factor(sample(c("1", "0","'"), 1000, replace = TRUE)),
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



# EVENT_TIME 계산
data$EVENT_TIME <- ifelse(data$osa == 1 & data$DEATH != '', 
                          data$MDCARE_STRT_DT_DAY - data$HME_DT_C, 
                          NA)

# CENSORED_TIME 계산
data$CENSORED_TIME <- ifelse(data$osa == 0 & data$DEATH == 0, 
                             data$END_DATE_C - data$HME_DT_C, 
                             ifelse(data$osa == 0 & data$DEATH == 1, 
                                    data$DTH_ASSMD_DT_C - data$HME_DT_C, 
                                    NA))

# SURVIVAL_TIME 계산
data$SURVIVAL_TIME <- pmin(data$EVENT_TIME, data$CENSORED_TIME, na.rm = TRUE)





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




##############################################################
#변수명 변경(다른 이유없음)
#Smoking status1
data$time <- data$SURVIVAL_TIME
data$osa <- as.factor(data$osa)

##############################################################


str(data)


# income 보험분위 4분위수로 계산해야함
fit <- coxph(Surv(time, osa == 1) ~ age + SEX_TYPE + BMI_TARGET + WEEK_TARGET + cci_hp , data = data)

publish(fit)

#변환 
setDT(data)


data[, `:=`(
  # Age 그룹 생성
  age_2 = fifelse(age < 65, "under65", "over65") |> as.factor(),
  
  # BMI 그룹 생성 (0 포함)
  BMI = fcase(
    G1E_BMI == 0, "0",        # BMI가 0인 경우
    G1E_BMI < 25, "<25",      # BMI가 25 미만인 경우
    G1E_BMI >= 25, ">=25"     # BMI가 25 이상인 경우
  ) |> as.factor(),
  BMI_2 = fcase(
    is.na(G1E_BMI), "Unknown",         # BMI가 NA인 경우
    G1E_BMI < 18.5, "<18.5",           # BMI가 18.5 미만인 경우
    G1E_BMI >= 18.5 & G1E_BMI < 23, "18.5-23",   # 18.5 <= BMI < 23
    G1E_BMI >= 23 & G1E_BMI < 25, "23-25",       # 23 <= BMI < 25
    G1E_BMI >= 25 & G1E_BMI < 30, "25-30",       # 25 <= BMI < 30
    G1E_BMI >= 30, ">=30",                        # BMI가 30 이상인 경우
    default = "Unknown"                           # 다른 정의되지 않은 값의 경우
  ) |> as.factor(),
  
  # Central obesity 그룹 생성
  Central_obesity = fcase(
    is.na(central), "Unknown",    # central이 NA인 경우 "Unknown" 반환
    central == 1, "Yes",          # central이 1인 경우 "Yes" 반환
    central == 0, "No"            # central이 0인 경우 "No" 반환
  ) |> as.factor(),

  # Alcohol target 그룹 생성
  alcohol_status = fcase(
    alcohol_target == 1, "Yes",
    alcohol_target == 0, "No"
  ) |> as.factor(),
  
  # Alcohol target1 그룹 생성
  alcohol_status1 = fcase(
    alcohol_target1 == 1, "0 (음주 안함)",
    alcohol_target1 == 2, "Mild (<105g)",
    alcohol_target1 == 3, "Moderate (105-120g)",
    alcohol_target1 == 4, "Heavy (>120g)"
  ) |> as.factor(),
  
  #Regular exercise 그룹 생성
  Regular_exercise = fcase(
    regular_exercise  == 1, "Yes",
    regular_exercise  == 0, "No"
  ) |> as.factor(),
  
  # Physical activity 그룹 생성
  Physical_activity = fcase(
    WEEK_TARGET == 1, "inactive_group",
    WEEK_TARGET == 2, "insufficiently_active_group",
    WEEK_TARGET == 3, "active_group",
    WEEK_TARGET == 4, "highly_active_group"
  ) |> as.factor(),

  CCI = fifelse(
    CCI_FREQ == 0, "cci=0","cci>=1"
  ) |> as.factor(),
  
  #icd 그룹 생성
  HTN_history  = fcase(ICD_CH_HT == 1, "Yes",ICD_CH_HT == 0, "No") |> as.factor(),
  T2DM_history   = fcase(ICD_CH_DIAB == 1, "Yes",ICD_CH_DIAB == 0, "No") |> as.factor(),
  Dyslipidemia_history    = fcase(ICD_CH_Dyslipidemia == 1, "Yes",ICD_CH_Dyslipidemia == 0, "No") |> as.factor(),
  Ischemic_heart_diseases_history  = fcase(ICD_CH_IHD == 1, "Yes",ICD_CH_IHD == 0, "No") |> as.factor(),
  Heart_failure_history = fcase(ICD_CH_HF == 1, "Yes", ICD_CH_HF == 0, "No") |> as.factor(),
  Transient_cerebral = fcase(ICD_CH_TC == 1, "Yes", ICD_CH_TC == 0, "No") |> as.factor(),
  Atrial_or_flutter_history  = fcase(ICD_CH_FOF == 1, "Yes", ICD_CH_FOF == 0, "No") |> as.factor(),
  COPD_history = fcase(ICD_CH_COPD == 1, "Yes", ICD_CH_COPD == 0, "No") |> as.factor(),
  Chronic_kidney_disease_history = fcase(ICD_CH_CKD_NEW == 1, "Yes", ICD_CH_CKD_NEW == 0, "No") |> as.factor(),
  Any_Cancer = fcase(ICD_CH_CANCER == 1, "Yes", ICD_CH_CANCER == 0, "No") |> as.factor(),
  Lung_cancer = fcase(ICD_CH_LUNG_CANCER == 1, "Yes", ICD_CH_LUNG_CANCER == 0, "No") |> as.factor(),
  Smoking_related_cancer = fcase(ICD_CH_SRC == 1, "Yes", ICD_CH_SRC == 0, "No") |> as.factor(),
  Alcohol_related_cancer  = fcase(ICD_CH_ARC == 1, "Yes", ICD_CH_ARC == 0, "No") |> as.factor(),
  Obesity_related_cancer  = fcase(ICD_CH_ORC == 1, "Yes", ICD_CH_ORC == 0, "No") |> as.factor(),
  Physical_activity_related_history = fcase(ICD_CH_PRC == 1, "Yes", ICD_CH_PRC == 0, "No") |> as.factor(),
  Gastroesophageal_reflux_disease = fcase(ICD_CH_GRD == 1, "Yes", ICD_CH_GRD == 0, "No") |> as.factor(),
  Depression = fcase(ICD_CH_DP == 1, "Yes", ICD_CH_DP == 0, "No") |> as.factor(),
  Fatty_liver = fcase(ICD_CH_FL == 1, "Yes", ICD_CH_FL == 0, "No") |> as.factor()
)]
    

  


subgroups <- c(
  "age_2",
  "BMI",
  "BMI_2",
  "Central_obesity",
  "alcohol_status",
  "alcohol_status1",
  "Regular_exercise",
  "Physical_activity",
  "CCI",
  "HTN_history",
  "T2DM_history",
  "Dyslipidemia_history",
  "Ischemic_heart_diseases_history",
  "Heart_failure_history",
  "Transient_cerebral",
  "Atrial_or_flutter_history",
  "COPD_history",
  "Chronic_kidney_disease_history",
  "Any_Cancer",
  "Lung_cancer",
  "Smoking_related_cancer",
  "Alcohol_related_cancer",
  "Obesity_related_cancer",
  "Physical_activity_related_history",
  "Gastroesophageal_reflux_disease",
  "Depression",
  "Fatty_liver"
)



#혹시 범주형 안되어있을까봐 변환 
data$Q_SMK_YN <- as.factor(data$Q_SMK_YN)
data$osa <- as.numeric(as.character(data$osa))


str(data$Q_SMK_YN)
data$Q_SMK_YN

sub_fit <- subgroupAnalysis(fit, 
                            data = data,
                            treatment = "osa",
                            subgroups = subgroups)
sub_fit_tbl <- copy(sub_fit) |> as.data.table()




## when the main analysis is already adjusted
# income 보험분위 4분위수로 계산해야함

fit_1 <- coxph(Surv(time, osa == 1) ~ age + SEX_TYPE + BMI_TARGET + WEEK_TARGET + cci_hp , data = data[Q_SMK_YN==1])
fit_1


fit_a <- coxph(Surv(time, osa == 1) ~ age + SEX_TYPE + BMI_TARGET + WEEK_TARGET + cci_hp + alcohol_target1 , data = data)




data$Q_SMK_YN <- as.factor(data$Q_SMK_YN)
data$osa <- as.numeric(data$osa)


sub_fit <- subgroupAnalysis(fit_a, 
                            data = data,
                            treatment = "alcohol_target1",
                            subgroups = subgroups)

sub_fit_tbl <- copy(sub_fit) |> as.data.table()



# 결측치를 제거하고 모델을 적합
data_clean <- na.omit(data)  # 결측치가 있는 행 제거

# Cox 모델 적합
fit_a <- coxph(Surv(time, osa == 1) ~ age + SEX_TYPE + BMI_TARGET, data = data_clean)

# 하위 그룹 분석 수행
sub_fit <- subgroupAnalysis(
  fit_a, 
  data = data_clean,               # 결측치가 없는 클린 데이터 사용
  treatment = "alcohol_target1",   # 치료 변수
  subgroups = subgroups            # 하위 그룹 변수 리스트
)








# Note that a real subgroup analysis would be to subset the data
fit_cox1a <- coxph(Surv(observationTime,dead)~treatment,data=traceR[smoking=="never"])
fit_cox1b <- coxph(Surv(observationTime,dead)~treatment,data=traceR[smoking=="current"])
fit_cox1c <- coxph(Surv(observationTime,dead)~treatment,data=traceR[smoking=="prior"])


sub_cox_adj <- subgroupAnalysis(fit,
                                data,
                                treatment="treatment",
                                subgroups=c("smoking","sex","wmi2","abd2")) # subgroups as character string

sub_cox_adj




?subgroupAnalysis



data
subgroups <- c("age_2","sex_2")



data$osa <- as.factor(data$osa)
sub_fit <- subgroupAnalysis(fit, 
                            data = data,
                            treatment = "osa",
                            subgroups = subgroups)
sub_fit_tbl <- copy(sub_fit) |> as.data.table()



















data[, `:=`(
  # Age 그룹 생성
  age_2 = fifelse(age < 65, "under65", "over65") |> as.factor(),
  # Sex 그룹 생성
  sex_2 = fifelse(SEX_TYPE == "Male", "Male", "Female") |> as.factor(),
  
  # Income 그룹 생성
  income_2 = fifelse(income %in% c("Q1-2", "Q3-4"), income, "Unknown") |> as.factor(),
  
  # BMI 그룹 생성
  BMI_2 = fifelse(BMI < 25, "<25", ">=25") |> as.factor(),
  BMI_3 = case_when(
    BMI < 18.5 ~ "<18.5",
    BMI >= 18.5 & BMI < 23 ~ "18.5 ≤ BMI <23",
    BMI >= 23 & BMI < 25 ~ "23 ≤ BMI < 25",
    BMI >= 25 & BMI < 30 ~ "25 ≤ BMI <30",
    BMI >= 30 ~ "≥30",
    TRUE ~ "Unknown"
  ) |> as.factor(),
  
  # Central obesity 생성
  central_obesity_2 = fifelse(central_obesity == "Yes", "Yes", fifelse(central_obesity == "No", "No", "Unknown")) |> as.factor(),
  
  # 주간 음주량 그룹 생성
  weekly_alcohol_2 = fifelse(weekly_alcohol >= 105, "Yes", "No") |> as.factor(),
  weekly_alcohol_3 = case_when(
    weekly_alcohol == 0 ~ "0 (음주 안함)",
    weekly_alcohol < 105 ~ "Mild (<105g)",
    weekly_alcohol >= 105 & weekly_alcohol <= 120 ~ "Moderate (105-120)",
    weekly_alcohol > 120 ~ "Heavy (>120g)",
    TRUE ~ "Unknown"
  ) |> as.factor(),
  
  # Regular exercise 생성
  regular_exercise_2 = fifelse(regular_exercise == "Yes", "Yes", "No") |> as.factor(),
  
  # Physical activity 그룹 생성
  physical_activity_2 = case_when(
    physical_activity == 0 ~ "inactive group : 0 MET-min/wk",
    physical_activity > 0 & physical_activity <= 499 ~ "insufficiently active group : 1-499 MET-min/wk",
    physical_activity >= 500 & physical_activity < 1000 ~ "active group : 500-999 MET-min/wk",
    physical_activity >= 1000 ~ "highly active group : >=1000 MET-min/wk",
    TRUE ~ "Unknown"
  ) |> as.factor(),
  
  # CCI 그룹 생성
  CCI_2 = fifelse(CCI == 0, "0", ">=1") |> as.factor(),
  
  # Disease history 그룹 생성
  HTN_history_2 = fifelse(HTN_history == "Yes", "Yes", "No") |> as.factor(),
  T2DM_history_2 = fifelse(T2DM_history == "Yes", "Yes", "No") |> as.factor(),
  Dyslipidemia_history_2 = fifelse(Dyslipidemia_history == "Yes", "Yes", "No") |> as.factor(),
  Ischemic_heart_diseases_history_2 = fifelse(Ischemic_heart_diseases_history == "Yes", "Yes", "No") |> as.factor(),
  Heart_failure_history_2 = fifelse(Heart_failure_history == "Yes", "Yes", "No") |> as.factor(),
  Transient_cerebral_ischemic_attack_2 = fifelse(Transient_cerebral_ischemic_attack == "Yes", "Yes", "No") |> as.factor(),
  Atrial_fibrillation_history_2 = fifelse(Atrial_fibrillation_history == "Yes", "Yes", "No") |> as.factor(),
  COPD_history_2 = fifelse(COPD_history == "Yes", "Yes", "No") |> as.factor(),
  Chronic_kidney_disease_history_2 = fifelse(Chronic_kidney_disease_history == "Yes", "Yes", "No") |> as.factor(),
  Any_cancer_2 = fifelse(Any_cancer == "Yes", "Yes", "No") |> as.factor(),
  Lung_cancer_2 = fifelse(Lung_cancer == "Yes", "Yes", "No") |> as.factor(),
  Smoking_related_cancer_2 = fifelse(Smoking_related_cancer == "Yes", "Yes", "No") |> as.factor(),
  Alcohol_related_cancer_2 = fifelse(Alcohol_related_cancer == "Yes", "Yes", "No") |> as.factor(),
  Obesity_related_cancer_2 = fifelse(Obesity_related_cancer == "Yes", "Yes", "No") |> as.factor(),
  Physical_activity_related_cancer_2 = fifelse(Physical_activity_related_cancer == "Yes", "Yes", "No") |> as.factor(),
  Gastroesophageal_reflux_disease_2 = fifelse(Gastroesophageal_reflux_disease == "Yes", "Yes", "No") |> as.factor(),
  Depression_2 = fifelse(Depression == "Yes", "Yes", "No") |> as.factor(),
  Fatty_liver_2 = fifelse(Fatty_liver == "Yes", "Yes", "No") |> as.factor()
)]





data[, `:=`(
  # Age 그룹 생성
  age_2 = fifelse(age < 65, "under65", "over65") |> as.factor(),
  
  # Sex 그룹 생성
  sex_2 = fifelse(SEX_TYPE == "Male", "Male", "Female") |> as.factor()
)] 
  

subgroups <- c("age_2","sex_2")



data$osa <- as.factor(data$osa)

sub_fit <- subgroupAnalysis(fit, 
                            data = data,
                            treatment = "osa",
                            subgroups = subgroups)


sub_fit_tbl <- copy(sub_fit) |> as.data.table()


