library(arm)
library(car)
library(ggplot2)
library(dplyr)
library(tidyr)
library(reshape2)
library(scales)
library(gridExtra)

# ---------------------------------------------------------------------------- #
gambling <- read.csv('Data/gambling2.csv', header = TRUE, stringsAsFactors = TRUE)

# ---------------------------------------------------------------------------- #
gambling$PROBGAM <- 
  ifelse(gambling$PROBGAM == 0, 0,
  ifelse(gambling$PROBGAM == 1, 1, NA))

gambling <- gambling %>%
  mutate(across(-PROBGAM, ~ ifelse(. >= -999 & . <= -1, NA, .)))

# ---------------------------------------------------------------------------- #
# ghq12scr (Goldberg, 1997)
gambling$ghq12scr <- 
  ifelse(gambling$ghq12scr >= 3, 1,
  ifelse(gambling$ghq12scr < 3, 0, NA))

# HHSize
gambling$HHSize <- 
  ifelse(gambling$HHSize == 1, 1,
  ifelse(gambling$HHSize == 2, 2,
  ifelse(gambling$HHSize == 3, 3,
  ifelse(gambling$HHSize == 4, 4,
  ifelse(gambling$HHSize > 4, 5, NA)))))

# totinc
gambling$totinc <- 
  ifelse(gambling$totinc %in% c(1, 2, 3, 4, 5), 1,
  ifelse(gambling$totinc %in% c(6, 7, 8, 9, 10), 2,
  ifelse(gambling$totinc %in% c(11, 12, 13, 14, 15), 3,
  ifelse(gambling$totinc %in% c(16, 17, 18, 19, 20), 4,
  ifelse(gambling$totinc %in% c(21, 22, 23, 24, 25), 5, 
  ifelse(gambling$totinc %in% c(26, 27), 6,
  ifelse(gambling$totinc %in% c(28, 29), 7,
  ifelse(gambling$totinc %in% c(30, 31), 8, 
  ifelse(gambling$totinc == 96 | gambling$totinc == 97, NA, NA)))))))))
  
# ---------------------- EXPLORATORY DATA ANALYSIS --------------------------- #
# DEMOGRAPHIC FACTORS
p1 <- ggplot(gambling, aes(x=factor(PROBGAM), y=age))+ geom_boxplot()+ coord_flip()+
  ggtitle("PROBGAM x Age")+ xlab("PROBGAM")+ ylab("Age")

p2 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(Sex), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Sex")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p3 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(SXORIEN), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Sexual Orientation")+ 
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p4 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(Religsc), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Religion")+ 
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p5 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(ethnicC), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Ethnicity")+ 
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p1
grid.arrange(p2, p3, p4, p5, nrow = 2)

# LIFESTYLE FACTORS
p1 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(EducEnd), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Age Finished Full-Time Education")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p2 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(HHSize), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Household Size")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p3 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(maritalg), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Marital Status")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p4 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(country), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Country")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p5 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(hhdtypb), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Household Type")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p6 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(RG15a), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Caring Responsibilities")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p1, p2, p3, p4, p5, p6, nrow = 3)

# SOCIOECONOMIC FACTORS
p1 <- ggplot(gambling, aes(x=factor(PROBGAM), y=eqvinc))+ geom_boxplot()+ coord_flip()+
  ggtitle("PROBGAM x Equivalised Income")+ xlab("PROBGAM")+ ylab("Equivalised Income")+ 
  scale_y_continuous(labels = comma)

p1

p2 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(totinc), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Total Household Income")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p3 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(SrcInc7), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Income Support")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p4 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(SrcInc15), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x No Source of Income")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p5 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(eqv5), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Equivalised Income Quintiles")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p2, p3, p4, p5, nrow = 3)

p6 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(OwnRnt08), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Household Tenure")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p7 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(numcars), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Number of Cars")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p6, p7, nrow = 1)

p8 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(HighQual), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Highest Educational Qualification")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p8

p9 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(Econact_2), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Economic Activity")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p10 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(hpnssec5), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x NS-SEC")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p9, p10, nrow = 1)

# HEALTH FACTORS
p1 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(docinfo1), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Doctor Diagnosed Diabetes")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p2 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(compm7), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x VII Heart & Circulatory System")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p3 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(compm8), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x VIII Respiratory System")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p4 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(compm9), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x IX Digestive System")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p5 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(longill12), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Longstanding Illness")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p6 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(compm3), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Mental Disorders")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p1, p2, p3, p4, p5, p6, nrow = 2)

p7 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(genhelf2), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Self-Assessed General Health")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p8 <- 
  gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(ghq12scr), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x GHQ-12 Score")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p7, p8, nrow = 2)

p9 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(cigst1), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Cigarette Smoker")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p9

p10 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(Active), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Physical Activity at Work")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p11 <- gambling %>%
  filter(!is.na(PROBGAM)) %>%
  ggplot(aes(x = factor(ActPhy), fill = factor(PROBGAM))) +
  geom_bar(position = "fill") +  ggtitle("PROBGAM x Monthly Exercise")+
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p10, p11, nrow = 1)

p12 <- ggplot(gambling, aes(x=factor(PROBGAM), y=wemwbs))+ geom_boxplot()+ coord_flip()+
  ggtitle("PROBGAM x WEMWBS Score")+ xlab("PROBGAM")+ ylab("WEMWBS")

p13 <- ggplot(gambling, aes(x=factor(PROBGAM), y=drating))+ geom_boxplot()+ coord_flip()+
  ggtitle("PROBGAM x Alcoholic Units/Week")+ xlab("PROBGAM")+ ylab("Alcoholic Units/Week")

p14 <- ggplot(gambling, aes(x=factor(PROBGAM), y=bmival))+ geom_boxplot()+ coord_flip()+
  ggtitle("PROBGAM x BMI")+ xlab("PROBGAM")+ ylab("BMI")

grid.arrange(p12, p13, p14, nrow = 3)

# ---------------------------- HEALTH MODEL ---------------------------------- #
# ALL PREDICTORS
health.glm <- glm(PROBGAM ~ as.factor(docinfo1) + as.factor(compm3) + as.factor(compm7) +
                    as.factor(compm8) + as.factor(compm9) + as.factor(genhelf2) + 
                    as.factor(longill12) + as.factor(ghq12scr) + as.factor(cigst1) +
                    as.factor(Active) + as.factor(ActPhy) + drating + wemwbs + bmival,
                  data=gambling, family=binomial(link="logit"))

display(health.glm, detail = T)
qchisq(0.95, 19)
vif(health.glm)
Anova(health.glm)

# ONLY SIGNIFICANT PREDICTORS
health.glm2 <- glm(PROBGAM ~ as.factor(docinfo1) + as.factor(genhelf2) + as.factor(ActPhy),
                   data=gambling, family=binomial(link="logit"))

display(health.glm2, detail = T)
qchisq(0.95, 4)
Anova(health.glm2)

# ONLY docinfo1
health.glm3 <- glm(PROBGAM ~ as.factor(docinfo1), data=gambling, family=binomial(link="logit"))

display(health.glm3, detail = T)
qchisq(0.95, 1)
Anova(health.glm3)

# EDA PREDICTORS
health.glm4 <- glm(PROBGAM ~ as.factor(longill12) + as.factor(cigst1) + as.factor(ghq12scr) +
                     drating + wemwbs + bmival, data=gambling, family=binomial(link="logit"))

display(health.glm4, detail = T)
qchisq(0.95, 8)
Anova(health.glm4)

# EDA AND docinfo1
health.glm5 <- glm(PROBGAM ~ as.factor(docinfo1) + as.factor(longill12) + as.factor(cigst1) + 
                     as.factor(ghq12scr) + drating + wemwbs + bmival, 
                   data=gambling, family=binomial(link="logit"))

display(health.glm5, detail = T)
qchisq(0.95, 7)
Anova(health.glm5)

# EDA (SIGNIFICANT) AND docinfo1
health.glm6 <- glm(PROBGAM ~ as.factor(docinfo1) + as.factor(longill12) + as.factor(cigst1) + 
                     drating + wemwbs, data=gambling, family=binomial(link="logit"))

display(health.glm6, detail = T)
qchisq(0.95, 7)
Anova(health.glm6)

# EDA (SIGNIFICANT)
health.glm7 <- glm(PROBGAM ~ as.factor(longill12) + as.factor(cigst1) + 
                     drating + wemwbs, data=gambling, family=binomial(link="logit"))

display(health.glm7, detail = T)
qchisq(0.95, 7)
Anova(health.glm7)

# FINAL HEALTH MODEL
final.health <- glm(PROBGAM ~ as.factor(longill12) + as.factor(cigst1) + 
                      drating + wemwbs, data=gambling, family=binomial(link="logit"))

display(final.health, detail = T)
qchisq(0.95, 6)
Anova(final.health)

# ------------------------------ CONFOUNDERS --------------------------------- #
confounders <- c("age", "Sex", "eqvinc", "ethnicC", "hpnssec5")

# ALL CONFOUNDERS
conf.glm <- glm(PROBGAM ~ age + eqvinc + as.factor(Sex) + as.factor(ethnicC) + 
                  as.factor(hpnssec5), data=gambling, family=binomial(link="logit"))

display(conf.glm, detail = T)
qchisq(0.95, 12)
vif(conf.glm)
Anova(conf.glm) # age, Sex, and hpnssec5 are significant

# AGE
conf.glm1 <- glm(PROBGAM ~ age + as.factor(longill12) + as.factor(cigst1) + 
                   drating + wemwbs, data=gambling, family=binomial(link="logit"))

display(conf.glm1, detail = T)
qchisq(0.95, 12)
Anova(conf.glm1) # longill12 is non-significant
anova(conf.glm1, final.health, test = "Chisq")

# SEX
conf.glm2 <- glm(PROBGAM ~ as.factor(Sex) + as.factor(longill12) + as.factor(cigst1) + 
                   drating + wemwbs, data=gambling, family=binomial(link="logit"))

display(conf.glm2, detail = T)
qchisq(0.95, 7)
Anova(conf.glm2)
anova(conf.glm2, final.health, test = "Chisq")

# AGE + SEX
conf.glm3 <- glm(PROBGAM ~ age + as.factor(Sex) + as.factor(longill12) + as.factor(cigst1) + 
                   drating + wemwbs, data=gambling, family=binomial(link="logit"))

display(conf.glm3, detail = T)
qchisq(0.95, 8)
Anova(conf.glm3) # longill12 is non-significant
anova(conf.glm3, final.health, test = "Chisq")

# COMPARING AGE + SEX TO AGE
anova(conf.glm3, conf.glm1, test = "Chisq")

# COMPARING AGE + SEX TO SEX
anova(conf.glm3, conf.glm2, test = "Chisq")

# EQUIVALISED INCOME
conf.glm4 <- glm(PROBGAM ~ eqvinc + as.factor(longill12) + as.factor(cigst1) + 
                   drating + wemwbs, data=gambling, family=binomial(link="logit"))

display(conf.glm4, detail = T)
qchisq(0.95, 7)
Anova(conf.glm4) 

# AGE + SEX + EQUIVALISED INCOME
conf.glm5 <- glm(PROBGAM ~ age + as.factor(Sex) + eqvinc + as.factor(longill12) + 
                   as.factor(cigst1) + drating + wemwbs, 
                 data=gambling, family=binomial(link="logit"))

display(conf.glm5, detail = T)
qchisq(0.95, 9)
Anova(conf.glm5) # longill12 is non-significant

# ETHNIC GROUP
conf.glm6 <- glm(PROBGAM ~ as.factor(ethnicC) + as.factor(longill12) + as.factor(cigst1) + 
                   drating + wemwbs, data=gambling, family=binomial(link="logit"))

display(conf.glm6, detail = T)
qchisq(0.95, 11)
Anova(conf.glm6) # ethnicC is non-significant

# NS-SEC CATEGORY
conf.glm7 <- glm(PROBGAM ~ as.factor(hpnssec5) + as.factor(longill12) + as.factor(cigst1) + 
                   drating + wemwbs, data=gambling, family=binomial(link="logit"))

display(conf.glm7, detail = T)
qchisq(0.95, 10)
Anova(conf.glm7) 

# AGE + SEX + EQUIVALISED INCOME + NS-SEC CATEGORY
conf.glm8 <- glm(PROBGAM ~ age + as.factor(Sex) + eqvinc + as.factor(hpnssec5) + 
                    as.factor(longill12) + as.factor(cigst1) + drating + wemwbs, 
                  data=gambling, family=binomial(link="logit"))

display(conf.glm8, detail = T)
qchisq(0.95, 13)
Anova(conf.glm8) # longill12 and eqvinc are non-significant

# AGE + SEX + NS-SEC CATEGORY (significance seen in conf.glm)
conf.glm9 <- glm(PROBGAM ~ age + as.factor(Sex) + as.factor(hpnssec5) + 
                    as.factor(longill12) + as.factor(cigst1) + drating + wemwbs, 
                  data=gambling, family=binomial(link="logit"))

display(conf.glm9, detail = T)
qchisq(0.95, 12)
Anova(conf.glm9) # longill12 is non-significant

# FINAL MODEL (INCLUDING CONFOUNDERS)
final.glm <- glm(PROBGAM ~ age + as.factor(Sex) + as.factor(hpnssec5) + 
                   as.factor(longill12) + as.factor(cigst1) + drating + wemwbs, 
                 data=gambling, family=binomial(link="logit"))

display(final.glm, detail = T)

# ------------------------ CONFUSION TABLE ----------------------------------- #
ct.op<-function(predicted,observed){ 
  df.op<-data.frame(predicted=predicted,observed=observed)
  op.tab<-table(df.op)
  op.tab<-rbind(op.tab,c(round(prop.table(op.tab,2)[1,1],2),
    round((prop.table(op.tab,2)[2,2]),2)))
  rownames(op.tab)<-c("pred=0","pred=1","%corr")
  colnames(op.tab)<-c("obs=0","obs=1")
  op.tab
}

gambling <- model.frame(final.glm)
pred.glm1 <-factor(as.numeric(final.glm$fitted.values>0.14))
ct.op(pred.glm1,as.factor(gambling$PROBGAM))

summary(gambling)

# ---------------------- CONTINUOUS APC -------------------------------------- #
matrix <- model.matrix(final.glm)
betas <- coef(final.glm)
colnames(matrix)
mm.hi <- matrix
mm.lo <- matrix

# AGE
lo.hi <- range(gambling$age, na.rm = TRUE)
mm.hi[, 2] <- rep(lo.hi[2], nrow(matrix))
mm.lo[, 2] <- rep(lo.hi[1], nrow(matrix))

delta_age<-with(gambling,(invlogit(mm.hi%*%betas) 
                          -invlogit(mm.lo%*%betas)))
mean(delta_age)

# UNITS OF ALCOHOL PER WEEK
lo.hi <- range(gambling$drating, na.rm = TRUE)
mm.hi[, 12] <- rep(lo.hi[2], nrow(matrix))  # set wemwbs to max
mm.lo[, 12] <- rep(lo.hi[1], nrow(matrix))  # set wemwbs to min

delta_drating<-with(gambling,(invlogit(mm.hi%*%betas) 
                              -invlogit(mm.lo%*%betas)))
mean(delta_drating)

# WARWICK-EDINBURGH WELLBEING SCALE
lo.hi <- range(gambling$wemwbs, na.rm = TRUE)
mm.hi[, 13] <- rep(lo.hi[2], nrow(matrix))
mm.lo[, 13] <- rep(lo.hi[1], nrow(matrix))

delta_wemwbs<-with(gambling,(invlogit(mm.hi%*%betas) 
                             -invlogit(mm.lo%*%betas)))
mean(delta_wemwbs)

# ---------------------- CATEGORICAL APC ------------------------------------- #
lo.hi<-c(0,1) # numerical dummies to check "max" and "min"
colnames(matrix)
mm.hi <- matrix
mm.lo <- matrix

# SEX
mm.hi[,3] <- rep(lo.hi[2],nrow(matrix))
mm.lo[,3] <- rep(lo.hi[1],nrow(matrix))
delta_sex<-with(gambling,(invlogit(mm.hi%*%betas) 
                               -invlogit(mm.lo%*%betas)))
mean(delta_sex)

# NS-SEC CLASS
mm.hi[,7] <- rep(lo.hi[2],nrow(matrix))
mm.lo[,4] <- rep(lo.hi[1],nrow(matrix))
delta_hpnssec5<-with(gambling,(invlogit(mm.hi%*%betas) 
                          -invlogit(mm.lo%*%betas)))
mean(delta_hpnssec5)

# LONG-TERM ILLNESS
mm.hi[,8] <- rep(lo.hi[2],nrow(matrix))
mm.lo[,8] <- rep(lo.hi[1],nrow(matrix))
delta_longill12<-with(gambling,(invlogit(mm.hi%*%betas) 
                               -invlogit(mm.lo%*%betas)))
mean(delta_longill12)

# CIGARETTE SMOKING STATUS
mm.hi[,12] <- rep(lo.hi[2],nrow(matrix))
mm.lo[,9] <- rep(lo.hi[1],nrow(matrix))
delta_cigst1<-with(gambling,(invlogit(mm.hi%*%betas) 
                                -invlogit(mm.lo%*%betas)))
mean(delta_cigst1)

