require("survival")

#KM code
##############################################################
#survival time 수정하기

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

##############################################################
#변수명 변경(다른 이유없음)
#Smoking status1
data$time <- data$SURVIVAL_TIME
#survfit 함수 고려시에 변수형 연속형이여야 한다.
data$osa <- as.numeric(data$osa)
data$Q_SMK_YN <- as.numeric(data$Q_SMK_YN)

fit <- survfit(Surv(time, osa) ~ Q_SMK_YN, data = data)

# Basic survival curves
ggsurvplot(fit, data = data)

##############################################################
#Smoking status2
#변수 생성 
data$Q_SMK_YN_1 <- ifelse(data$Q_SMK_YN == 2|data$Q_SMK_YN == 3,1,0)

#check
data$Q_SMK_YN
data$Q_SMK_YN_1

#survfit 함수 고려시에 변수형 연속형이여야 한다.
data$Q_SMK_YN_1 <- as.numeric(data$Q_SMK_YN_1)

fit<- survfit(Surv(time, osa) ~ Q_SMK_YN_1, data = data)

# Basic survival curves
ggsurvplot(fit, data = data)


##############################################################
#py_all_patient
#check
data$SMOKE_2

#survfit 함수 고려시에 변수형 연속형이여야 한다.
data$SMOKE_2 <- as.numeric(data$SMOKE_2)

fit<- survfit(Surv(time, osa) ~ SMOKE_2, data = data)

# Basic survival curves
ggsurvplot(fit, data = data)


##############################################################
#py_all_patient_2

#변수 생성 
data$py_all_total <- ifelse(data$Q_SMK_YN == 1,1,
                            ifelse(data$Q_SMK_YN == 2 & data$SMOKE_2 == 1,2,
                                   ifelse(data$Q_SMK_YN == 2 & data$SMOKE_2 == 2,3,
                                     ifelse(data$Q_SMK_YN == 2 & data$SMOKE_2 == 3,4,
                                       ifelse(data$Q_SMK_YN == 3 & data$SMOKE_2 == 1,5,
                                         ifelse(data$Q_SMK_YN == 3 & data$SMOKE_2 == 2,6,7
                                           )
                                         )
                                       )
                                     )
                                   )
                            )
                            

data$py_all_total

#survfit 함수 고려시에 변수형 연속형이여야 한다.
data$py_all_total <- as.numeric(data$py_all_total)

fit<- survfit(Surv(time, osa) ~ py_all_total, data = data)

# Basic survival curves
ggsurvplot(fit, data = data)


##############################################################
#alcohol_1
#check
data$alcohol_target

#survfit 함수 고려시에 변수형 연속형이여야 한다.
data$alcohol_target <- as.numeric(data$alcohol_target)

fit<- survfit(Surv(time, osa) ~ alcohol_target, data = data)

# Basic survival curves
ggsurvplot(fit, data = data)


##############################################################
#alcohol_2
#check
data$alcohol_target1

#survfit 함수 고려시에 변수형 연속형이여야 한다.
data$alcohol_target1 <- as.numeric(data$alcohol_target1)

fit<- survfit(Surv(time, osa) ~ alcohol_target1, data = data)

# Basic survival curves
ggsurvplot(fit, data = data)


##############################################################
#physical
#check
data$WEEK_TARGET

#survfit 함수 고려시에 변수형 연속형이여야 한다.
data$WEEK_TARGET <- as.numeric(data$WEEK_TARGET)

fit<- survfit(Surv(time, osa) ~ WEEK_TARGET, data = data)

# Basic survival curves
ggsurvplot(fit, data = data) 


##############################################################
#physical_2
#check
data$MVPA_TARGET

#survfit 함수 고려시에 변수형 연속형이여야 한다.
data$MVPA_TARGET <- as.numeric(data$MVPA_TARGET)

fit<- survfit(Surv(time, osa) ~ MVPA_TARGET, data = data)

# Basic survival curves
ggsurvplot(fit, data = data)


##############################################################
#physical_3
#check
data$regular_exercise

#survfit 함수 고려시에 변수형 연속형이여야 한다.
data$regular_exercise <- as.numeric(data$regular_exercise)

fit<- survfit(Surv(time, osa) ~ regular_exercise, data = data)

# Basic survival curves
ggsurvplot(fit, data = data)





