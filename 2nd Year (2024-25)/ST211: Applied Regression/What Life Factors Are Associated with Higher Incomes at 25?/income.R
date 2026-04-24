library(arm)
library(car)
library(dplyr)
library(visdat)
library(scales)
library(ggplot2)
library(tidyverse)
library(gridExtra)

# -----------------------------------------------------------------------------#
income <- read.csv("Data/INC.csv", header = TRUE, stringsAsFactors = TRUE)
income <- income %>% select(-NSID)

# ----------------------- RENAMING VARIABLES ----------------------------------#
income <- income %>%
  rename(
    # continuous
    "annualincMP" = "W1GrssyrMP",
    "annualincHH" = "W1GrssyrHH",
    "attitudeW1" = "W1yschat1",
    "ghq12W2" = "W2ghq12scr",
    "attitudeW4" = "W4schatYP",
    "debtattitude" = "W6DebtattYP",
    "weeklyinc" = "W8DINCW",
    "ghq12W8" = "W8DGHQSC",
    "debt" = "W8QDEB2",
    
    # categorical
    "workstatusMP" = "W1wrk1aMP",
    "computer" = "W1condur5MP",
    "illnessMP" = "W1hea2MP",
    "youngsib" = "W1NoldBroHS",
    "incare" = "W1InCarHH",
    "tenureHH" = "W1hous12HH",
    "caruse" = "W1usevcHH",
    "hiqualM" = "W1hiqualmum",
    "hiqualD" = "W1hiqualdad",
    "fulltimeM" = "W1wrkfullmum",
    "fulltimeD" = "W1wrkfulldad",
    "jobstatusM" = "W1empsmum",
    "jobstatusD" = "W1empsdad",
    "infants" = "W1ch0_2HH",
    "preteen" = "W1ch3_11HH",
    "tween" = "W1ch12_15HH",
    "teen" = "W1ch16_17HH",
    "indschool" = "IndSchool",
    "maritalM" = "W1marstatmum",
    "depkids" = "W1depkids",
    "singleparent" = "W1famtyp2",
    "NSSEC" = "W1nssecfam",
    "ethnicity" = "W1ethgrpYP",
    "uniapp" = "W1heposs9YP",
    "homework" = "W1hwndayYP",
    "truant" = "W1truantYP",
    "tryalcW1" = "W1alceverYP",
    "bullied" = "W1bulrc",
    "illnessYP" = "W1disabYP",
    "teachdisc" = "W2disc1YP",
    "depress" = "W2depressYP",
    "alcfreq" = "W4AlcFreqYP",
    "canntry" = "W4CannTryYP",
    "names" = "W4NamesYP",
    "racism" = "W4RacismYP",
    "jobstatusYP" = "W4empsYP",
    "haschildW4" = "W4Childck1YP",
    "jobstatusW5" = "W5JobYP",
    "schoolW5" = "W5EducYP",
    "apprentW5" = "W5Apprent1YP",
    "jobW6" = "W6JobYP",
    "uniW6" = "W6UnivYP",
    "schoolW6" = "W6EducYP",
    "hiqualW6" = "W6acqno",
    "numgcse" = "W6gcse",
    "numals" = "W6als",
    "haschildW6" = "W6OwnchiDV",
    "NEETact" = "W6NEETAct",
    "maritalCM" = "W8DMARSTAT",
    "backact" = "W8DACTIVITYC",
    "employed" = "W8DWRK",
    "sex" = "W8CMSEX",
    "tenureCM" = "W8TENURE",
    "currentact" = "W8DACTIVITY",
    "finmanage" = "W8QMAFI"
  )

# --------------------DEALING WITH MISSING DATA--------------------------------#
continuous <- c("annualincMP", "annualincHH", "attitudeW1", "ghq12W2", "attitudeW4",
  "debtattitude", "ghq12W8", "debt") # excluding weeklyinc, as there is no missing data for this variable

categorical <- c("workstatusMP", "computer", "illnessMP", "youngsib", "incare",
  "tenureHH", "caruse", "hiqualM", "hiqualD", "fulltimeM", "fulltimeD",
  "jobstatusM", "jobstatusD", "infants", "preteen", "tween", "teen", 
  "indschool", "maritalM", "depkids", "singleparent", "NSSEC", "ethnicity",
  "uniapp", "homework", "truant", "tryalcW1", "bullied", "illnessYP",
  "teachdisc", "depress", "alcfreq", "canntry", "names", "racism",
  "jobstatusYP", "haschildW4", "jobstatusW5", "schoolW5", "apprentW5", "jobW6", "uniW6", 
  "schoolW6", "hiqualW6", "numgcse", "numals", "haschildW6", "NEETact", "maritalCM",   
  "backact", "employed", "sex", "tenureCM", "currentact", "finmanage")

# replacing all missing data with NAs
income_cleaned <- income %>%
  mutate(across(all_of(continuous), ~ ifelse(. >= -999 & . <= -1, NA, .))) %>%
  mutate(across(all_of(categorical), ~ ifelse(. >= -999 & . <= -1, NA, .)))

# identify the percentage of missing data per categorical variable
num_NAs <- colSums(is.na(income_cleaned[categorical])) / nrow(income_cleaned) * 100
add_category <- names(num_NAs[num_NAs > 10])
to_remove <- names(num_NAs[num_NAs < 10])

# remove rows where categorical variables are missing < 10% of data
income_cleaned <- income_cleaned %>%
  filter(if_all(all_of(to_remove), ~ !is.na(.)))

# create a new category, "Missing", for categorical variables missing > 10% data
# i.e. replace NAs with "Missing" for these variables
income_cleaned <- income_cleaned %>%
  mutate(across(all_of(add_category), ~ replace(., is.na(.), "Missing")))

# making all categorical variables factors
income_cleaned <- income_cleaned %>%
  mutate(across(all_of(categorical), as.factor))

# -------------------------- DATA MERGING -------------------------------------#
# workstatusMP
income_cleaned$workstatusMP <- 
  ifelse(income_cleaned$workstatusMP %in% c("1", "2","3", "4"), "Employed",
  ifelse(income_cleaned$workstatusMP %in% c("5", "7"), "Unemployed/Seeking Work",
  ifelse(income_cleaned$workstatusMP %in% c("6"), "Full Time Education",
  ifelse(income_cleaned$workstatusMP %in% c("8", "9"), "Sick/Disabled",
  ifelse(income_cleaned$workstatusMP %in% c("10", "11"), "Retired/Not Seeking Work",
  ifelse(income_cleaned$workstatusMP %in% c("12"), "Other", NA))))))

# hiqualM
income_cleaned$hiqualM <- 
  ifelse(income_cleaned$hiqualM %in% c("1", "2","3", "4", "5", "6"), "Higher Education",
  ifelse(income_cleaned$hiqualM %in% c("7", "8", "9", "10", "11", "12"), "Further Education",
  ifelse(income_cleaned$hiqualM %in% c("13", "14", "17", "18"), "Apprentice/Vocational Training",
  ifelse(income_cleaned$hiqualM %in% c("15", "16"), "GCSE",
  ifelse(income_cleaned$hiqualM %in% c("19", "20"), "Other/Unspecified", NA)))))

# hiqualD
income_cleaned$hiqualD <- 
  ifelse(income_cleaned$hiqualD %in% c("1", "2","3", "4", "5", "6"), "Higher Education",
  ifelse(income_cleaned$hiqualD %in% c("7", "8", "9", "10", "11", "12"), "Further Education",
  ifelse(income_cleaned$hiqualD %in% c("13", "14", "17", "18"), "Apprentice/Vocational Training",
  ifelse(income_cleaned$hiqualD %in% c("15", "16"), "GCSE",
  ifelse(income_cleaned$hiqualD %in% c("19", "20"), "Unspecified/Not Mentioned", 
  # keep "Missing" separate as it is a new category (see Dealing with Missing Data)
  ifelse(income_cleaned$hiqualD == "Missing", "Missing", NA))))))

# jobstatusM
income_cleaned$jobstatusM <- 
  ifelse(income_cleaned$jobstatusM %in% c("1", "2"), "Employed",
  ifelse(income_cleaned$jobstatusM %in% c("3"), "Unemployed/Seeking Work",
  ifelse(income_cleaned$jobstatusM %in% c("4", "5"), "In Education/Training",
  ifelse(income_cleaned$jobstatusM %in% c("6", "7"), "Retired/Not Seeking Work",
  ifelse(income_cleaned$jobstatusM %in% c("8"), "Sick/Disabled",
  ifelse(income_cleaned$jobstatusM %in% c("9"), "Other", NA))))))

# jobstatusD
income_cleaned$jobstatusD <- 
  ifelse(income_cleaned$jobstatusD %in% c("1", "2"), "Employed",
  ifelse(income_cleaned$jobstatusD %in% c("3"), "Unemployed/Seeking Work",
  ifelse(income_cleaned$jobstatusD %in% c("4", "5"), "In Education/Training",
  ifelse(income_cleaned$jobstatusD %in% c("6", "7"), "Retired/Not Seeking Work",
  ifelse(income_cleaned$jobstatusD %in% c("8"), "Sick/Disabled",
  ifelse(income_cleaned$jobstatusD %in% c("9"), "Other",
  # keep "Missing" separate as it is a new category (see Dealing with Missing Data)
  ifelse(income_cleaned$jobstatusD == "Missing", "Missing", NA)))))))

# youngsib
income_cleaned$youngsib <- 
  ifelse(income_cleaned$youngsib %in% c("0"), "None",
  ifelse(income_cleaned$youngsib %in% c("1"), "One",
  ifelse(income_cleaned$youngsib %in% c("2"), "Two",
  ifelse(income_cleaned$youngsib %in% c("3"), "Three",
  ifelse(income_cleaned$youngsib %in% c("4", "5", "6", "7", "8", "9"), "Four +", NA))))) 

# depkids
income_cleaned$depkids <-
  ifelse(income_cleaned$depkids %in% c("0"), "None",
  ifelse(income_cleaned$depkids %in% c("1"), "One",
  ifelse(income_cleaned$depkids %in% c("2"), "Two",
  ifelse(income_cleaned$depkids %in% c("3"), "Three",
  ifelse(income_cleaned$depkids %in% c("4", "5", "6", "7", "8", "9", "10"), "Four +", NA)))))

# infants
income_cleaned$infants <- 
  ifelse(income_cleaned$infants == 0, "None",
  ifelse(income_cleaned$infants == 1, "One",
  ifelse(income_cleaned$infants == 2, "Two", NA)))

# preteen
income_cleaned$preteen <- 
  ifelse(income_cleaned$preteen == 0, "None",
  ifelse(income_cleaned$preteen == 1, "One",
  ifelse(income_cleaned$preteen == 2, "Two",
  ifelse(income_cleaned$preteen %in% c(3, 4, 5), "Three+", NA))))

# tween
income_cleaned$tween <- 
  ifelse(income_cleaned$tween == 0, "None",
  ifelse(income_cleaned$tween == 1, "One",
  ifelse(income_cleaned$tween == 2, "Two",
  ifelse(income_cleaned$tween %in% c(3, 4), "Three+", NA))))

# teen
income_cleaned$teen <- 
  ifelse(income_cleaned$teen == 0, "None",
  ifelse(income_cleaned$teen == 1, "One",
  ifelse(income_cleaned$teen == 2, "Two", NA)))

# NSSEC
income_cleaned$NSSEC <- 
  ifelse(income_cleaned$NSSEC %in% c(1, 2), "Professional/Managerial",
  ifelse(income_cleaned$NSSEC %in% c(3, 4, 5), "Intermediate/Skilled",
  ifelse(income_cleaned$NSSEC %in% c(6, 7), "Routine/Manual",
  ifelse(income_cleaned$NSSEC == 8, "Unemployed/Inactive", NA))))

# ghq12W2 (see Appendix)
income_cleaned$ghq12W2 <- 
  ifelse(income_cleaned$ghq12W2 >= 3, 1,
  ifelse(income_cleaned$ghq12W2 < 3, 0, NA))

# hiqualW6
income_cleaned$hiqualW6 <- 
  ifelse(income_cleaned$hiqualW6 %in% c(1, 2), "Higher Education",
  ifelse(income_cleaned$hiqualW6 %in% c(3, 4), "AS/A-level",
  ifelse(income_cleaned$hiqualW6 %in% c(5, 6), "GCSE",
  ifelse(income_cleaned$hiqualW6 %in% c(7, 8, 9), "Other/None", NA))))

# alcfreq
income_cleaned$alcfreq <- 
  ifelse(income_cleaned$alcfreq %in% c(1, 2), "Frequent",
  ifelse(income_cleaned$alcfreq %in% c(3, 4), "Occasional",
  ifelse(income_cleaned$alcfreq %in% c(5, 6), "Rare",
  # keep "Missing" separate as it is a new category (see Dealing with Missing Data)
  ifelse(income_cleaned$alcfreq == "Missing", "Missing", NA))))

# jobstatusYP
income_cleaned$jobstatusYP <-
  ifelse(income_cleaned$jobstatusYP %in% c("1", "2"), "Employed",
  ifelse(income_cleaned$jobstatusYP %in% c("3"), "Unemployed/Seeking Work",
  ifelse(income_cleaned$jobstatusYP %in% c("4", "5"), "In Education/Training",
  ifelse(income_cleaned$jobstatusYP %in% c("6", "7"), "Retired/Not Seeking Work",
  ifelse(income_cleaned$jobstatusYP %in% c("8"), "Sick/Disabled",
  ifelse(income_cleaned$jobstatusYP %in% c("9"), "Other", NA))))))

# ghq12W8 (see Appendix)
income_cleaned$ghq12W8 <- 
  ifelse(income_cleaned$ghq12W8 >= 3, 1,
  ifelse(income_cleaned$ghq12W8 < 3, 0, NA))

# currentact
income_cleaned$currentact <-
  ifelse(income_cleaned$currentact %in% c("1", "2", "3", "4"), "Employed",
  ifelse(income_cleaned$currentact %in% c("11"), "Unpaid/Volunteer Work",
  ifelse(income_cleaned$currentact %in% c("5"), "Unemployed",
  ifelse(income_cleaned$currentact %in% c("6", "7", "8", "12"), "In Education/Training",
  ifelse(income_cleaned$currentact %in% c("9", "10"), "Sick/Disabled",
  ifelse(income_cleaned$currentact %in% c("13"), "Not Seeking Work",
  ifelse(income_cleaned$currentact %in% c("14"), "Other", NA)))))))

# backact
income_cleaned$backact <-
  ifelse(income_cleaned$backact %in% c("1", "2"), "Employed",
  ifelse(income_cleaned$backact %in% c("3"), "Unpaid/Volunteer Work",
  ifelse(income_cleaned$backact %in% c("4"), "Unemployed",
  ifelse(income_cleaned$backact %in% c("5", "6", "7"), "In Education/Training",
  ifelse(income_cleaned$backact %in% c("8"), "Sick/Disabled",
  ifelse(income_cleaned$backact %in% c("9"), "Not Seeking Work",
  ifelse(income_cleaned$backact %in% c("10"), "Other", NA)))))))

# -------------------------EXPLORING MISSINGNESS-------------------------------#
# what values cause missingness?
table(income$hiqualD)
table(income$fulltimeD)
table(income$jobstatusD)
table(income$haschildW4)
table(income$alcfreq)
table(income$schoolW6)
table(income$NEETact)

# continuous predictors with >10% missing
continuous_NAs <- colSums(is.na(income_cleaned[continuous])) / nrow(income_cleaned) * 100
high_missing <- names(num_NAs[num_NAs > 10])

# creating a binary dataframe - Missing vs. Non-Missing Data, except weeklyinc
missingness <- income_cleaned
all_predictors <- c(continuous, categorical)
for (predictor in all_predictors) {
  missingness[[predictor]] <-
    ifelse(is.na(missingness[[predictor]]) | missingness[[predictor]] == "Missing" , 0, 1)
}

# how does missingness affect the outcome variable?
ggplot(data = missingness, aes(x = as.factor(hiqualD), y = weeklyinc)) +
  geom_boxplot() +
  xlab("Father's Highest Qualification") +
  ylab("Continuous Weekly Income")

ggplot(data = missingness, aes(x = as.factor(fulltimeD), y = weeklyinc)) +
  geom_boxplot() +
  xlab("Father's Full Time Status") +
  ylab("Continuous Weekly Income")

ggplot(data = missingness, aes(x = as.factor(jobstatusD), y = weeklyinc)) +
  geom_boxplot() +
  xlab("Father's Job Status") +
  ylab("Continuous Weekly Income")

ggplot(data = missingness, aes(x = as.factor(alcfreq), y = weeklyinc)) +
  geom_boxplot() +
  xlab("Alcohol Frequency") +
  ylab("Continuous Weekly Income")

ggplot(data = missingness, aes(x = as.factor(haschildW4), y = weeklyinc)) +
  geom_boxplot() +
  xlab("Whether CM has Child") +
  ylab("Continuous Weekly Income")

ggplot(data = missingness, aes(x = as.factor(schoolW6), y = weeklyinc)) +
  geom_boxplot() +
  xlab("Is CM in School or College?") +
  ylab("Continuous Weekly Income")

ggplot(data = missingness, aes(x = as.factor(NEETact), y = weeklyinc)) +
  geom_boxplot() +
  xlab("Activity of NEETs") +
  ylab("Continuous Weekly Income")

ggplot(data = missingness, aes(x = as.factor(annualincMP), y = weeklyinc)) +
  geom_boxplot() +
  xlab("Gross Income of Main Parent") +
  ylab("Continuous Weekly Income")

ggplot(data = missingness, aes(x = as.factor(annualincHH), y = weeklyinc)) +
  geom_boxplot() +
  xlab("Gross Household Income") +
  ylab("Continuous Weekly Income")

ggplot(data = missingness, aes(x = as.factor(debt), y = weeklyinc)) +
  geom_boxplot() +
  xlab("Debt") +
  ylab("Continuous Weekly Income")

# adding new columns to income_cleaned with the binary results
income_cleaned$hiqualD_missing <- missingness$hiqualD
income_cleaned$fulltimeD_missing <- missingness$fulltimeD
income_cleaned$jobstatusD_missing <- missingness$jobstatusD
income_cleaned$alcfreq_missing <- missingness$alcfreq
income_cleaned$haschildW4_missing <- missingness$haschildW4
income_cleaned$schoolW6_missing <- missingness$schoolW6
income_cleaned$NEETact_missing <- missingness$NEETact
income_cleaned$annualincMP_missing <- missingness$annualincMP
income_cleaned$annualincHH_missing <- missingness$annualincHH
income_cleaned$debt_missing <- missingness$debt

p1 <- ggplot(income_cleaned, aes(x = ethnicity, fill = factor(hiqualD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Highest Qualification by Ethnic Group") +
  xlab("Ethnic Group") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p2 <- ggplot(income_cleaned, aes(x = ethnicity, fill = factor(fulltimeD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Full Time Status by Ethnic Group") +
  xlab("Ethnic Group") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p3 <- ggplot(income_cleaned, aes(x = ethnicity, fill = factor(jobstatusD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Job Status by Ethnic Group") +
  xlab("Ethnic Group") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p4 <- ggplot(income_cleaned, aes(x = ethnicity, fill = factor(alcfreq_missing))) +
  geom_bar(position = "fill") + ggtitle("Alcohol Frequency by Ethnic Group") +
  xlab("Ethnic Group") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p5 <- ggplot(income_cleaned, aes(x = ethnicity, fill = factor(haschildW4_missing))) +
  geom_bar(position = "fill") + ggtitle("Whether CM has Child by Ethnic Group") +
  xlab("Ethnic Group") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p6 <- ggplot(income_cleaned, aes(x = ethnicity, fill = factor(schoolW6_missing))) +
  geom_bar(position = "fill") + ggtitle("schoolW6  by Ethnic Group") +
  xlab("Ethnic Group") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p7 <- ggplot(income_cleaned, aes(x = ethnicity, fill = factor(NEETact_missing))) +
  geom_bar(position = "fill") + ggtitle("NEETact by Ethnic Group") +
  xlab("Ethnic Group") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p8 <- ggplot(income_cleaned, aes(x = ethnicity, fill = factor(annualincMP_missing))) +
  geom_bar(position = "fill") + ggtitle("annualincMP by Ethnic Group") +
  xlab("Ethnic Group") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p9 <- ggplot(income_cleaned, aes(x = ethnicity, fill = factor(annualincHH_missing))) +
  geom_bar(position = "fill") + ggtitle("annualincHH by Ethnic Group") +
  xlab("Ethnic Group") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p10 <- ggplot(income_cleaned, aes(x = ethnicity, fill = factor(debt_missing))) +
  geom_bar(position = "fill") + ggtitle("debt by Ethnic Group") +
  xlab("Ethnic Group") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, nrow = 5)

p1 <- ggplot(income_cleaned, aes(x = singleparent, fill = factor(hiqualD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Highest Qualification by Single Parent Household") +
  xlab("Single Parent Household (1 = Yes)") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p2 <- ggplot(income_cleaned, aes(x = singleparent, fill = factor(fulltimeD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Full Time Status by Single Parent Household") +
  xlab("Single Parent Household (1 = Yes)") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p3 <- ggplot(income_cleaned, aes(x = singleparent, fill = factor(jobstatusD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Job Status by Single Parent Household") +
  xlab("Single Parent Household (1 = Yes)") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p4 <- ggplot(income_cleaned, aes(x = singleparent, fill = factor(alcfreq_missing))) +
  geom_bar(position = "fill") + ggtitle("Alcohol Frequency by Single Parent Household") +
  xlab("Single Parent Household (1 = Yes)") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p5 <- ggplot(income_cleaned, aes(x = singleparent, fill = factor(haschildW4_missing))) +
  geom_bar(position = "fill") + ggtitle("Whether CM has Child by Single Parent Household") +
  xlab("Single Parent Household (1 = Yes)") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p6 <- ggplot(income_cleaned, aes(x = singleparent, fill = factor(schoolW6_missing))) +
  geom_bar(position = "fill") + ggtitle("schoolW6 by Single Parent Household") +
  xlab("Single Parent Household (1 = Yes)") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p7 <- ggplot(income_cleaned, aes(x = singleparent, fill = factor(NEETact_missing))) +
  geom_bar(position = "fill") + ggtitle("NEETact by Single Parent Household") +
  xlab("Single Parent Household (1 = Yes)") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p8 <- ggplot(income_cleaned, aes(x = singleparent, fill = factor(annualincMP_missing))) +
  geom_bar(position = "fill") + ggtitle("annualincMP by Single Parent Household") +
  xlab("Single Parent Household (1 = Yes)") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p9 <- ggplot(income_cleaned, aes(x = singleparent, fill = factor(annualincHH_missing))) +
  geom_bar(position = "fill") + ggtitle("annualincHH by Single Parent Household") +
  xlab("Single Parent Household (1 = Yes)") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p10 <- ggplot(income_cleaned, aes(x = singleparent, fill = factor(debt_missing))) +
  geom_bar(position = "fill") + ggtitle("debt by Single Parent Household") +
  xlab("Single Parent Household (1 = Yes)") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, nrow = 5)

p1 <- ggplot(income_cleaned, aes(x = NSSEC, fill = factor(hiqualD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Highest Qualification by NS-SEC Class") +
  xlab("NS-SEC Class") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p2 <- ggplot(income_cleaned, aes(x = NSSEC, fill = factor(fulltimeD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Full Time Status by NS-SEC Class") +
  xlab("NS-SEC Class") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p3 <- ggplot(income_cleaned, aes(x = NSSEC, fill = factor(jobstatusD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Job Status by NS-SEC Class") +
  xlab("NS-SEC Class") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p4 <- ggplot(income_cleaned, aes(x = NSSEC, fill = factor(alcfreq_missing))) +
  geom_bar(position = "fill") + ggtitle("Alcohol Frequency by NS-SEC Class") +
  xlab("NS-SEC Class") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p5 <- ggplot(income_cleaned, aes(x = NSSEC, fill = factor(haschildW4_missing))) +
  geom_bar(position = "fill") + ggtitle("Whether CM has Child by NS-SEC Class") +
  xlab("NS-SEC Class") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p6 <- ggplot(income_cleaned, aes(x = NSSEC, fill = factor(schoolW6_missing))) +
  geom_bar(position = "fill") + ggtitle("schoolW6 by NS-SEC Class") +
  xlab("NS-SEC Class") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p7 <- ggplot(income_cleaned, aes(x = NSSEC, fill = factor(NEETact_missing))) +
  geom_bar(position = "fill") + ggtitle("NEETact by NS-SEC Class") +
  xlab("NS-SEC Class") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p8 <- ggplot(income_cleaned, aes(x = NSSEC, fill = factor(annualincMP_missing))) +
  geom_bar(position = "fill") + ggtitle("annualincMP by NS-SEC Class") +
  xlab("NS-SEC Class") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p9 <- ggplot(income_cleaned, aes(x = NSSEC, fill = factor(annualincHH_missing))) +
  geom_bar(position = "fill") + ggtitle("annualincHH by NS-SEC Class") +
  xlab("NS-SEC Class") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p10 <- ggplot(income_cleaned, aes(x = NSSEC, fill = factor(debt_missing))) +
  geom_bar(position = "fill") + ggtitle("debt by NS-SEC Class") +
  xlab("NS-SEC Class") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, nrow = 5)

p1 <- ggplot(income_cleaned, aes(x = illnessYP, fill = factor(hiqualD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Highest Qualification by Disability") +
  xlab("Disability") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p2 <- ggplot(income_cleaned, aes(x = illnessYP, fill = factor(fulltimeD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Full Time Status by Disability") +
  xlab("Disability") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p3 <- ggplot(income_cleaned, aes(x = illnessYP, fill = factor(jobstatusD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Job Status by Disability") +
  xlab("Disability") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p4 <- ggplot(income_cleaned, aes(x = illnessYP, fill = factor(alcfreq_missing))) +
  geom_bar(position = "fill") + ggtitle("Alcohol Frequency by Disability") +
  xlab("Disability") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p5 <- ggplot(income_cleaned, aes(x = illnessYP, fill = factor(haschildW4_missing))) +
  geom_bar(position = "fill") + ggtitle("Whether CM has Child by Disability") +
  xlab("Disability") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p6 <- ggplot(income_cleaned, aes(x = illnessYP, fill = factor(schoolW6_missing))) +
  geom_bar(position = "fill") + ggtitle("schoolW6 by Disability") +
  xlab("Disability") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p7 <- ggplot(income_cleaned, aes(x = illnessYP, fill = factor(NEETact_missing))) +
  geom_bar(position = "fill") + ggtitle("NEETact by Disability") +
  xlab("Disability") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p8 <- ggplot(income_cleaned, aes(x = illnessYP, fill = factor(annualincMP_missing))) +
  geom_bar(position = "fill") + ggtitle("annualincMP by Disability") +
  xlab("Disability") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p9 <- ggplot(income_cleaned, aes(x = illnessYP, fill = factor(annualincHH_missing))) +
  geom_bar(position = "fill") + ggtitle("annualincHH by Disability") +
  xlab("Disability") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p10 <- ggplot(income_cleaned, aes(x = illnessYP, fill = factor(debt_missing))) +
  geom_bar(position = "fill") + ggtitle("debt by Disability") +
  xlab("Disability") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, nrow = 5)

p1 <- ggplot(income_cleaned, aes(x = sex, fill = factor(hiqualD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Highest Qualification by Gender") +
  xlab("Gender") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p2 <- ggplot(income_cleaned, aes(x = sex, fill = factor(fulltimeD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Full Time Status by Gender") +
  xlab("Gender") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p3 <- ggplot(income_cleaned, aes(x = sex, fill = factor(jobstatusD_missing))) +
  geom_bar(position = "fill") + ggtitle("Father's Job Status by Gender") +
  xlab("Gender") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p4 <- ggplot(income_cleaned, aes(x = sex, fill = factor(alcfreq_missing))) +
  geom_bar(position = "fill") + ggtitle("Alcohol Frequency by Gender") +
  xlab("Gender") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p5 <- ggplot(income_cleaned, aes(x = sex, fill = factor(haschildW4_missing))) +
  geom_bar(position = "fill") + ggtitle("Whether CM has Child by Gender") +
  xlab("Gender") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p6 <- ggplot(income_cleaned, aes(x = sex, fill = factor(schoolW6_missing))) +
  geom_bar(position = "fill") + ggtitle("schoolW6 by Gender") +
  xlab("Gender") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p7 <- ggplot(income_cleaned, aes(x = sex, fill = factor(NEETact_missing))) +
  geom_bar(position = "fill") + ggtitle("NEETact by Gender") +
  xlab("Gender") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p8 <- ggplot(income_cleaned, aes(x = sex, fill = factor(annualincMP_missing))) +
  geom_bar(position = "fill") + ggtitle("annualincMP by Gender") +
  xlab("Gender") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p9 <- ggplot(income_cleaned, aes(x = sex, fill = factor(annualincHH_missing))) +
  geom_bar(position = "fill") + ggtitle("annualincHH by Gender") +
  xlab("Gender") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

p10 <- ggplot(income_cleaned, aes(x = sex, fill = factor(debt_missing))) +
  geom_bar(position = "fill") + ggtitle("debt by Gender") +
  xlab("Gender") +
  labs(fill = "Missing (0 = Missing)") +
  scale_y_continuous(name = "Within-Group Percentage", labels = scales::percent)

grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, nrow = 5)

# removing the _missing, income_cleaned back to original form post-cleaning
income_cleaned <- income_cleaned %>%
  select(-hiqualD_missing, -fulltimeD_missing, -jobstatusD_missing, -alcfreq_missing,
         -haschildW4_missing, -schoolW6_missing, -NEETact_missing, -annualincMP_missing,
         -annualincHH_missing, -debt_missing)

# ----------------------EXPLORATORY DATA ANALYSIS------------------------------#
# CM'S PARENTS (WAVE 1)
ggplot(data=income_cleaned, aes(x=as.factor(workstatusMP), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Main Parent's Job Status") +
  xlab("Job Status") +
  ylab("Continuous Weekly Income")

p1 <- ggplot(data=income_cleaned, aes(x=as.factor(hiqualM), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Mother's Higest Qualification") +
  xlab("Mother's Higest Qualification") +
  ylab("Continuous Weekly Income")

p2 <- ggplot(data=income_cleaned, aes(x=as.factor(hiqualD), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Father's Highest Qualification") +
  xlab("Father's Highest Qualification") +
  ylab("Continuous Weekly Income")

grid.arrange(p1, p2, nrow = 1)

p3 <- ggplot(data=income_cleaned, aes(x=as.factor(jobstatusM), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Mother's Employment Status") +
  xlab("Mother's Employment Status vs. Part-Time") +
  ylab("Continuous Weekly Income")

p4 <- ggplot(data=income_cleaned, aes(x=as.factor(jobstatusD), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Father's Employment Status") +
  xlab("Father's Employment Status vs. Part-Time") +
  ylab("Continuous Weekly Income")

grid.arrange(p3, p4, nrow = 1)

p5 <- ggplot(data=income_cleaned, aes(x=as.factor(fulltimeM), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Mother Full/Part-Time") +
  xlab("Mother Full vs. Part-Time") +
  ylab("Continuous Weekly Income")

p6 <- ggplot(data=income_cleaned, aes(x=as.factor(fulltimeD), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Father Full/Part-Time") +
  xlab("Father Full vs. Part-Time") +
  ylab("Continuous Weekly Income")

grid.arrange(p5, p6, nrow = 1)

# CM'S HOUSEHOLD (WAVE 1)
p1 <- ggplot(data=income_cleaned, aes(x=as.factor(singleparent), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Single Parent Household") +
  xlab("Single Parent Household") +
  ylab("Continuous Weekly Income")

p2 <- ggplot(data=income_cleaned, aes(x=as.factor(maritalM), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Mother's Marital Status") +
  xlab("Mother's Marital Status") +
  ylab("Continuous Weekly Income")

grid.arrange(p1, p2, nrow = 1)

p3 <- ggplot(data=income_cleaned, aes(x=as.factor(youngsib), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Number of Younger Siblings") +
  xlab("Number of Younger Siblings") +
  ylab("Continuous Weekly Income")

p4 <- ggplot(data=income_cleaned, aes(x=as.factor(depkids), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Number of Dependent Children in Household") +
  xlab("Number of Dependent Children in Household") +
  ylab("Continuous Weekly Income")

grid.arrange(p3, p4, nrow = 1)

p5 <- ggplot(data=income_cleaned, aes(x=as.factor(infants), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Children 0-2 in Household") +
  xlab("Number of Dependent Children in Household") +
  ylab("Continuous Weekly Income")

p6 <- ggplot(data=income_cleaned, aes(x=as.factor(preteen), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Children 3-11 in Household") +
  xlab("Number of Dependent Children in Household") +
  ylab("Continuous Weekly Income")

p7 <- ggplot(data=income_cleaned, aes(x=as.factor(tween), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Children 12-15 in Household") +
  xlab("Number of Dependent Children in Household") +
  ylab("Continuous Weekly Income")

p8 <- ggplot(data=income_cleaned, aes(x=as.factor(teen), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Children 16-17 in Household") +
  xlab("Number of Dependent Children in Household") +
  ylab("Continuous Weekly Income")

grid.arrange(p5, p6, p7, p8, nrow=2)

p9 <- ggplot(data=income_cleaned, aes(x=as.factor(computer), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Owning a Home Computer") +
  xlab("Home Computer") +
  ylab("Continuous Weekly Income")

p10 <- ggplot(data=income_cleaned, aes(x=as.factor(caruse), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Motor Vehicle Access in Household") +
  xlab("Motor Vehicle Access in Household") +
  ylab("Continuous Weekly Income")

grid.arrange(p9, p10, nrow = 1)

p11 <- ggplot(data=income_cleaned, aes(x=as.factor(incare), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Is CM in a Private Household?") +
  xlab("Is CM in a Private Household") +
  ylab("Continuous Weekly Income")

p12 <- ggplot(data=income_cleaned, aes(x=as.factor(tenureHH), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Household Tenure") +
  xlab("Household Tenure") +
  ylab("Continuous Weekly Income")


p13 <- ggplot(data=income_cleaned, aes(x=as.factor(NSSEC), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("NS-SEC Class") +
  xlab("NS-SEC Class") +
  ylab("Continuous Weekly Income")

grid.arrange(p11, p12, p13, nrow = 1)

# CM'S ACADEMIC INFORMATION (WAVES 1 AND 6)
p1 <- ggplot(data=income_cleaned, aes(x=as.factor(indschool), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Private Education") +
  xlab("Private School") +
  ylab("Continuous Weekly Income")

p2 <- ggplot(data=income_cleaned, aes(x=as.factor(homework), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Evenings Spent Doing Homework") +
  xlab("Evenings Spent Doing Homework") +
  ylab("Continuous Weekly Income")

grid.arrange(p1, p2, nrow = 1)

p3 <- ggplot(data=income_cleaned, aes(x=as.factor(truant), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Truant in the Last 12 Months") +
  xlab("Truant in the Last 12 Months") +
  ylab("Continuous Weekly Income")

p4 <- ggplot(data=income_cleaned, aes(x=as.factor(bullied), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Has CM Been Bullied in the Last 12 Months?") +
  xlab("Has CM Been Bullied in the Last 12 Months?") +
  ylab("Continuous Weekly Income")

grid.arrange(p3, p4, nrow = 1)

p5 <- ggplot(data=income_cleaned, aes(x=as.factor(uniapp), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Likelihood of Applying to University") +
  xlab("Likelihood of Applying to University") +
  ylab("Continuous Weekly Income")

p6 <- ggplot(data=income_cleaned, aes(x=as.factor(hiqualW6), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Highest Academic Qualification in at Wave 6") +
  xlab("Highest Academic Qualification in at Wave 6") +
  ylab("Continuous Weekly Income")

p7 <- ggplot(data=income_cleaned, aes(x=as.factor(uniW6), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Is Currently in University?") +
  xlab("Is Currently in University? (Wave 5)") +
  ylab("Continuous Weekly Income")

grid.arrange(p5, p6, p7, nrow = 1)

p8 <- ggplot(data=income_cleaned, aes(x=as.factor(numgcse), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Number of GCSES") +
  xlab("Number of GCSES") +
  ylab("Continuous Weekly Income")

p9 <- ggplot(data=income_cleaned, aes(x=as.factor(numals), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Number of A-Levels Studied") +
  xlab("Number of A-Levels Studied") +
  ylab("Continuous Weekly Income")

grid.arrange(p8, p9, nrow = 1)

# CM'S HEALTH AND IDENTITY (WAVES 1, 2, 4, AND 8)
p1 <- ggplot(data=income_cleaned, aes(x=as.factor(sex), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("CM's Sex") +
  xlab("CM's Sex") +
  ylab("Continuous Weekly Income")

p2 <- ggplot(data=income_cleaned, aes(x=as.factor(ethnicity), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("CM's Ethnic Group") +
  xlab("CM's Ethnic Group") +
  ylab("Continuous Weekly Income")

grid.arrange(p1, p2, nrow = 1)

p3 <- ggplot(data=income_cleaned, aes(x=as.factor(ghq12W2), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Wave 2 GHQ12 Score") +
  xlab("GHQ-12 Score") +
  ylab("Continuous Weekly Income")

p4 <- ggplot(data=income_cleaned, aes(x=as.factor(ghq12W8), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Wave 8 GHQ12 Score") +
  xlab("GHQ-12 Score") +
  ylab("Continuous Weekly Income")

p5 <- ggplot(data=income_cleaned, aes(x=as.factor(depress), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Has CM Been Feeling Unhappy/Depressed Recently?") +
  xlab("Has CM Been Feeling Unhappy/Depressed Recently?") +
  ylab("Continuous Weekly Income")

grid.arrange(p3, p4, p5, nrow = 1)

p6 <- ggplot(data=income_cleaned, aes(x=as.factor(illnessYP), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("(CM) Long-Standing Illness, Disability or Infirmity") +
  xlab("(CM) Long-Standing Illness, Disability or Infirmity") +
  ylab("Continuous Weekly Income")

p7 <- ggplot(data=income_cleaned, aes(x=as.factor(illnessMP), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("(MP) Long-Standing Illness, Disability or Infirmity") +
  xlab("MP Long-Standing Illness, Disability or Infirmity") +
  ylab("Continuous Weekly Income")

grid.arrange(p6, p7, nrow = 1)

p8 <- ggplot(data=income_cleaned, aes(x=as.factor(tryalcW1), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("(Wave 1) Has CM had 'Proper Alcohol'") +
  xlab("Has CM had 'Proper Alcohol'") +
  ylab("Continuous Weekly Income")

p9 <- ggplot(data=income_cleaned, aes(x=as.factor(alcfreq), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("CM's Alcohol Frequency in the Last 12 Months") +
  xlab("CM's Alcohol Frequency in the Last 12 Months (Wave 4)") +
  ylab("Continuous Weekly Income")

p10 <- ggplot(data=income_cleaned, aes(x=as.factor(canntry), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Has CM Tried Cannabis") +
  xlab("Has CM Tried Cannabis (Wave 4)") +
  ylab("Continuous Weekly Income")

grid.arrange(p8, p9, p10, nrow = 1)

p11 <- ggplot(data=income_cleaned, aes(x=as.factor(names), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Has CM Been Bullied in the Last 12 Months?") +
  xlab("Has CM Been Bullied in the Last 12 Months? (Wave 4)") +
  ylab("Continuous Weekly Income")

p12 <- ggplot(data=income_cleaned, aes(x=as.factor(teachdisc), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Has CM Been Treated Unfairly by Teachers due to Skin Colour/Ethnicity?") +
  xlab("Has CM Been Treated Unfairly by Teachers due to Skin Colour/Ethnicity?") +
  ylab("Continuous Weekly Income")

p13 <- ggplot(data=income_cleaned, aes(x=as.factor(racism), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Has CM Been Targeted in the Last 12 Months due to Skin Colour/Ethnicity?") +
  xlab("Has CM Been Targeted in the Last 12 Months due to Skin Colour/Ethnicity?") +
  ylab("Continuous Weekly Income")

grid.arrange(p11, p12, p13, nrow = 1)

# CM FROM SCHOOL TO EMPLOYMENT (WAVES 4, 5, 6, AND 8)
ggplot(data=income_cleaned, aes(x=as.factor(jobstatusYP), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Employement Status") +
  xlab("Employement Status (Wave 4)") +
  ylab("Continuous Weekly Income")

p1 <- ggplot(data=income_cleaned, aes(x=as.factor(jobstatusW5), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Is Currently in Paid Employment?") +
  xlab("Is Currently in Paid Employment? (Wave 5)") +
  ylab("Continuous Weekly Income")

p2 <- ggplot(data=income_cleaned, aes(x=as.factor(jobW6), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Is Currently in Paid Employment?") +
  xlab("Is Currently in School/College? (Wave 6)") +
  ylab("Continuous Weekly Income")

p3 <- ggplot(data=income_cleaned, aes(x=as.factor(employed), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Is Currently in Paid Employment?") +
  xlab("Is Currently in Paid Employment? (Wave 8)") +
  ylab("Continuous Weekly Income")

grid.arrange(p1, p2, p3, nrow = 1)

p4 <- ggplot(data=income_cleaned, aes(x=as.factor(schoolW5), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Is Currently in School/College?") +
  xlab("Is Currently in School/College? (Wave 5)") +
  ylab("Continuous Weekly Income")

p5 <- ggplot(data=income_cleaned, aes(x=as.factor(apprentW5), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Is Currently Doing an Apprenticeship?") +
  xlab("Is Currently Doing an Apprenticeship? (Wave 5)") +
  ylab("Continuous Weekly Income")

p6 <- ggplot(data=income_cleaned, aes(x=as.factor(schoolW6), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Is Currently in School/College?") +
  xlab("Is Currently in School/College? (Wave 6)") +
  ylab("Continuous Weekly Income")

grid.arrange(p4, p5, p6, nrow = 1)

p7 <- ggplot(data=income_cleaned, aes(x=as.factor(NEETact), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Activity of NEETs") +
  xlab("Activity of NEETs (Not in Employment, Education, or Training") +
  ylab("Continuous Weekly Income")

p8 <- ggplot(data=income_cleaned, aes(x=as.factor(backact), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Activity of CM") +
  xlab("Activity of CM") +
  ylab("Continuous Weekly Income")

grid.arrange(p7, p8, nrow = 1)

# CM'S MARITAL/FAMILIAL STATUS (WAVES 4, 6, AND 8)
p1 <- ggplot(data=income_cleaned, aes(x=as.factor(haschildW4), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Does CM Have a Child?") +
  xlab("Does CM Have a Child? (Wave 4)") +
  ylab("Continuous Weekly Income")

p2 <- ggplot(data=income_cleaned, aes(x=as.factor(haschildW6), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Does CM Have a Child?") +
  xlab("Does CM Have a Child? (Wave 6)") +
  ylab("Continuous Weekly Income")

p3 <- ggplot(data=income_cleaned, aes(x=as.factor(maritalCM), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("CM's Marital Status") +
  xlab("CM's Marital Status") +
  ylab("Continuous Weekly Income")

p4 <- ggplot(data=income_cleaned, aes(x=as.factor(tenureCM), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("Household Tenure") +
  xlab("Household Tenure") +
  ylab("Continuous Weekly Income")

grid.arrange(p1, p2, p3, p4, nrow = 2)

# CM'S FINANCIAL MANAGEMENT (WAVE 8)
ggplot(data=income_cleaned, aes(x=as.factor(finmanage), y=weeklyinc)) +
  geom_boxplot() +
  ggtitle("How is CM Managing Financially?") +
  xlab("How is CM Managing Financially?") +
  ylab("Continuous Weekly Income")

# GROSS INCOME OF MAIN PARENT AND OF HOUSEHOLD (WAVE 1)
ggplot(data=income_cleaned, aes(x=annualincMP, y=weeklyinc))+
  geom_point()+
  ggtitle("Gross Income of Main Parent")+
  xlab("Gross Income of Main Parent")+
  ylab("Continuous Weekly Income at 25")

ggplot(data=income_cleaned, aes(x=annualincHH, y=weeklyinc))+
  geom_point()+
  ggtitle("Household Gross Income")+
  xlab("Household Gross Income")+
  ylab("Continuous Weekly Income at 25")+
  scale_x_continuous(labels = comma)

# CM'S ATTITUDE TO SCHOOL (WAVES 1 AND 4)
p1 <- ggplot(data=income_cleaned, aes(x=attitudeW1, y=weeklyinc))+
  geom_point()+
  ggtitle("Wave 1 Attitude to School")+
  xlab("Wave 1 Attitude to School")+
  ylab("Continuous Weekly Income at 25")

p2 <- ggplot(data=income_cleaned, aes(x=attitudeW4, y=weeklyinc))+
  geom_point()+
  ggtitle("Wave 4 Attitude to School")+
  xlab("Wave 4 Attitude to School")+
  ylab("Continuous Weekly Income at 25")

grid.arrange(p1, p2, nrow=1)

# CM'S DEBT INFORMATION (WAVES 6 AND 8)
p1 <- ggplot(data=income_cleaned, aes(x=factor(debtattitude), y=weeklyinc))+
  geom_point()+
  ggtitle("Young Person's Attitude to Debt")+
  xlab("Young Person's Attitude to Debt")+
  ylab("Continuous Weekly Income at 25")

p2 <- ggplot(data=income_cleaned, aes(x=debt, y=weeklyinc))+
  geom_point()+
  ggtitle("Amount of Debt")+
  xlab("Amount of Debt (Wave 8)")+
  ylab("Continuous Weekly Income at 25")+
  scale_x_continuous(labels = comma)

grid.arrange(p1, p2, nrow=1)

# ------------------APPROACH I: BACKWARDS ELIMINATION--------------------------#
# ITERATION 1: ALL PREDICTORS
all.lm <- lm(weeklyinc ~ ., data = income_cleaned)

summary(all.lm)

# ITERATION 2: ADDRESSING MULTICOLLINEARITY (in groups)
parent <- lm(weeklyinc ~ jobstatusM + fulltimeM + hiqualM + jobstatusD + fulltimeD + hiqualD, data = income_cleaned)
# aliased coefficients, so reduce the variables
reduced_parent <- lm(weeklyinc ~ fulltimeM + fulltimeD + hiqualM + hiqualD, data = income_cleaned)
vif(reduced_parent)
# multicollinearity, so reduce again
reduced_parent2 <- lm(weeklyinc ~ fulltimeM + hiqualM + hiqualD, data = income_cleaned)
vif(reduced_parent2)

household <- lm(weeklyinc ~ depkids + infants + preteen + tween + teen, data = income_cleaned)
vif(household)
# remove infants, preteen, tween, teen as redundant

education <- lm(weeklyinc ~ hiqualW6 + numgcse + numals + schoolW6 + uniW6 + jobW6 +NEETact, data = income_cleaned)
reduced_education <- lm(weeklyinc ~ hiqualW6 + uniW6 + jobW6 + NEETact, data = income_cleaned)
vif(reduced_education)

activity <- lm(weeklyinc ~ currentact + backact, data = income_cleaned)
# aliased coefficients, so remove currentact as it has more levels

# running vif, removing singleparent
all.lm2 <- lm(weeklyinc ~ .- jobstatusM - jobstatusD - fulltimeD - infants - preteen - tween - teen - 
  schoolW6 - numgcse - numals - currentact - employed, data = income_cleaned)

vif(all.lm2)

all.lm2 <- lm(weeklyinc ~ .- jobstatusM - jobstatusD - fulltimeD - infants - preteen - tween - teen - 
  singleparent - schoolW6 - numgcse - numals - currentact - employed, data = income_cleaned)

summary(all.lm2)

# ITERATION 3: REMOVING NON-SIGNIFICANT PREDICTORS
all.lm3 <- lm(weeklyinc ~ annualincMP + workstatusMP + illnessMP + tenureHH + hiqualM + maritalM + NSSEC + 
  ethnicity + uniapp + homework + illnessYP + canntry + apprentW5  + uniW6 + NEETact + 
  maritalCM + sex,data = income_cleaned)

summary(all.lm3)

Anova(all.lm3) # to see which predictors are wholly significant

# ITERATION 4: REMOVING WHOLLY NON-SIGNIFICANT PREDICTORS (using Anova())
all.lm4 <- lm(weeklyinc ~ annualincMP + workstatusMP + illnessMP + hiqualM + maritalM + NSSEC + ethnicity + 
  uniapp + illnessYP + canntry + apprentW5  + uniW6 + NEETact + sex, data = income_cleaned)

summary(all.lm4)

# Iteration 5: Transformations
par(mfrow=c(2,2))
plot(all.lm4, which=c(1,2))
hist(rstandard(all.lm4), freq = FALSE ,
     main="Histogram of standardised residuals",
     cex.main=0.8, xlab="Standardised residuals")

all.lm5 <- lm(log(weeklyinc) ~ annualincMP + workstatusMP + illnessMP + hiqualM + maritalM + NSSEC + ethnicity + 
  uniapp + illnessYP + canntry + apprentW5  + uniW6 + NEETact + sex, data = income_cleaned)

summary(all.lm5)

# removing annualincMP as non-significant
all.lm5 <- lm(log(weeklyinc) ~  workstatusMP + illnessMP + hiqualM + maritalM + NSSEC + ethnicity + uniapp + 
  illnessYP + canntry + apprentW5  + uniW6 + NEETact + sex, data = income_cleaned)

summary(all.lm5)

# # INVESTIGATING INTERACTIONS NSSEC AND workstatusMP, illnessMP and workstatusMP, AND canntry and sex
ggplot(data=income_cleaned, aes(x=NSSEC, y=weeklyinc, fill=workstatusMP)) + geom_boxplot() + scale_fill_discrete(name = "MP's Working Status")
ggplot(data=income_cleaned, aes(x=illnessMP, y=weeklyinc, fill=workstatusMP)) + geom_boxplot() + scale_fill_discrete(name = "MP's Long-Standing Illness")
## to reading the graph easier
income_cleaned$canntry <- ifelse(income_cleaned$canntry == 1, "Yes", ifelse(income_cleaned$canntry == 2, "No", NA))
income_cleaned$sex <- ifelse(income_cleaned$sex == 1, "Male", ifelse(income_cleaned$sex == 2, "Female", NA))

ggplot(data=income_cleaned, aes(x=canntry, y=weeklyinc, fill=sex)) + geom_boxplot() + scale_fill_discrete(name = "CM's Sex")

interaction1 <- lm(log(weeklyinc) ~ workstatusMP*NSSEC + illnessMP + hiqualM + 
  maritalM + NSSEC + ethnicity + uniapp + illnessYP + 
  canntry + apprentW5  + uniW6 + NEETact + sex, data = income_cleaned)

summary(interaction1)
Anova(interaction1)

interaction2 <- lm(log(weeklyinc) ~ workstatusMP*illnessMP + hiqualM + maritalM + NSSEC + 
  ethnicity + uniapp + illnessYP + canntry+ apprentW5  + uniW6 + NEETact + 
  sex, data = income_cleaned)

summary(interaction2)
Anova(interaction2)

interaction3 <- lm(log(weeklyinc) ~ workstatusMP + illnessMP + hiqualM + maritalM + NSSEC + 
  ethnicity + uniapp + illnessYP + apprentW5  + uniW6 + NEETact + canntry*sex, 
  data = income_cleaned)

summary(interaction3)
Anova(interaction3)

# ITERATION 6: ADDRESSING OUTLIERS
show_outliers <- function(the.linear.model, topN) {
  # length of data
  n = length(fitted(the.linear.model))
  # number of parameters estimated
  p = length(coef(the.linear.model))
  # standardised residuals over 3
  res.out <- which(abs(rstandard(the.linear.model)) > 3) #sometimes >2
  # topN values
  res.top <- head(rev(sort(abs(rstandard(the.linear.model)))), topN)
  # high leverage values
  lev.out <- which(lm.influence(the.linear.model)$hat > 2 * p/n)
  # topN values
  lev.top <- head(rev(sort(lm.influence(the.linear.model)$hat)), topN)
  # high diffits
  dffits.out <- which(dffits(the.linear.model) > 2 * sqrt(p/n))
  # topN values
  dffits.top <- head(rev(sort(dffits(the.linear.model))), topN)
  # Cook's over 1
  cooks.out <- which(cooks.distance(the.linear.model) > 1)
  # topN cooks
  cooks.top <- head(rev(sort(cooks.distance(the.linear.model))), topN)
  # Create a list with the statistics -- cant do a data frame as different
  # lengths
  list.of.stats <- list(Std.res = res.out, Std.res.top = res.top, Leverage = lev.out,
    Leverage.top = lev.top, DFFITS = dffits.out, DFFITS.top = dffits.top,
    Cooks = cooks.out, Cooks.top = cooks.top)
  # return the statistics
  list.of.stats
}

logall.out.stats <- show_outliers(all.lm5, 5) 

# removing points that show both high influence (DFFITS) and high leverage
common_outliers <- Reduce(intersect, list(
  logall.out.stats$DFFITS,
  logall.out.stats$Leverage))

# new data with no outliers
backwards_no_outliers <- income_cleaned[-common_outliers, ]

# running the model with no outliers
all.lm5 <- lm(log(weeklyinc) ~  workstatusMP + illnessMP + hiqualM + maritalM +
  NSSEC + ethnicity + uniapp + illnessYP + canntry + apprentW5  + uniW6 + 
  NEETact + sex, data = backwards_no_outliers)

summary(all.lm5)

# ---------------------APPROACH II: FORWARD SELECTION--------------------------#
# ITERATION 1: SELECTING PREDICTORS FROM THE EDA
income.lm1 <- lm(weeklyinc ~ workstatusMP + hiqualM + fulltimeM + fulltimeD + maritalM +
  singleparent + youngsib + depkids + computer + caruse + tenureHH + schoolW6 +
  NSSEC + hiqualW6 + numgcse + numals + teachdisc + racism + ethnicity +
  employed + schoolW5 + NEETact +  backact + haschildW4 + tenureCM + annualincHH, 
  data = income_cleaned)

summary(income.lm1)

# ITERATION 2: REMOVING NON-SIGNIFICANT PREDICTORS
income.lm2 <- lm(weeklyinc ~ workstatusMP + hiqualM + fulltimeM + maritalM + tenureHH + 
  schoolW6 + NSSEC + teachdisc + ethnicity + schoolW5 + NEETact +
  backact + tenureCM, data = income_cleaned)

summary(income.lm2)

vif(income.lm2)

# ITERATION 3: TRANSFORMATIONS
par(mfrow=c(2,2))
plot(income.lm2, which=c(1,2))
hist(rstandard(income.lm2), freq = FALSE ,
  main="Histogram of standardised residuals",
  cex.main=0.8, xlab="Standardised residuals")

income.lm3 <- lm(log(weeklyinc) ~ workstatusMP + hiqualM + fulltimeM + maritalM + teachdisc +
  schoolW6 + NSSEC + tenureHH + ethnicity + schoolW5 + NEETact + backact +
  tenureCM, data = income_cleaned)

summary(income.lm3)

# INVESTIGATING INTERACTIONS tenureCM AND backact, schoolW5 and schoolW6, AND workstatusMP and NSSEC
ggplot(data=income_cleaned, aes(x=tenureCM, y=weeklyinc, fill=backact)) + geom_boxplot()
ggplot(data=income_cleaned, aes(x=schoolW5, y=weeklyinc, fill=schoolW6)) + geom_boxplot()
ggplot(data=income_cleaned, aes(x=NSSEC, y=weeklyinc, fill=workstatusMP)) + geom_boxplot()

interaction1 <- lm(log(weeklyinc) ~ workstatusMP + hiqualM + fulltimeM + maritalM + teachdisc +
  schoolW6 + NSSEC + tenureHH + ethnicity + schoolW5 + NEETact + 
  backact*tenureCM, data = income_cleaned)

summary(interaction1)
Anova(interaction1)

interaction2 <- lm(log(weeklyinc) ~ workstatusMP + hiqualM + fulltimeM + maritalM + teachdisc +
  NSSEC + tenureHH + ethnicity + schoolW5*schoolW6 + NEETact + backact +
  tenureCM, data = income_cleaned)

summary(interaction2)
Anova(interaction2)

interaction3 <- lm(log(weeklyinc) ~ workstatusMP*NSSEC + hiqualM + fulltimeM + maritalM + teachdisc +
  schoolW6 + tenureHH + ethnicity + schoolW5 + NEETact + backact +
  tenureCM, data = income_cleaned)

summary(interaction3)
Anova(interaction3)

# ITERATION 4: ADDRESSING OUTLIERS
income.out.stats <- show_outliers(income.lm3, 5) 

common_outliers <- Reduce(intersect, list(
  income.out.stats$DFFITS,
  income.out.stats$Leverage)
)

forwards_no_outliers <- income_cleaned[-common_outliers, ]

income.lm3 <- lm(log(weeklyinc) ~ workstatusMP + hiqualM + fulltimeM + maritalM + teachdisc +
                   schoolW6 + NSSEC + tenureHH + ethnicity + schoolW5 + NEETact + backact +
                   tenureCM, data = forwards_no_outliers)

summary(income.lm3)

# -------------------------CROSS-VALIDATION------------------------------------#
# BACKWARDS SELECTION MODEL
prop<-c(0.5,0.7,0.9) # 50/50, 70/30, and 90/10 splits
for(i in 1:3){
  # create training and test sets
  cross.val<-sample(1:nrow(backwards_no_outliers),prop[i]*nrow(backwards_no_outliers), replace=FALSE)
  training.set<-backwards_no_outliers[cross.val,] # the 50/70/90% to fit the model
  test.set<-backwards_no_outliers[-cross.val,] # the 50/30/10% to use as validation sample
  # fit the model
  backwards.lm <- lm(log(weeklyinc) ~  workstatusMP + illnessMP + hiqualM + maritalM
                     + NSSEC + ethnicity + uniapp + illnessYP + canntry 
                     + apprentW5  + uniW6 + NEETact + sex, data = training.set)
  # data frame to use in plots
  pred.val.set <- data.frame(
    predicted = predict(backwards.lm, test.set),
    original = log(test.set$weeklyinc),
    error = predict(backwards.lm, test.set) - log(test.set$weeklyinc)
  )
  
  # the first iteration
  if(i==1){
    # predicted vs.original
    p1<-ggplot(data=pred.val.set, aes(x=predicted,y=original))+geom_point()+theme_bw()
    p1<-p1+geom_smooth(method="lm", se=FALSE) 
    p1<-p1+geom_abline(slope=1,intercept=0, linetype="dashed")
    # predicted vs. error
    p2<-ggplot(data=pred.val.set, aes(x=predicted,y=error))+geom_point()+theme_bw()
  }else{
    
    # the second iteration  
    if(i==2){
      # predicted vs. original (adding points)
      p1<-p1+geom_point(data=pred.val.set, aes(x=predicted,y=original), color="red")
      p1<-p1+geom_smooth(method="lm", se=FALSE, color="darkred") 
      # predicted vs. error (adding points)
      p2<-p2+geom_point(data=pred.val.set, aes(x=predicted,y=error), color="red")
    }else{
      
      # the third iteration
      # predicted vs. original
      p1<-p1+geom_point(data=pred.val.set, aes(x=predicted,y=original), color="green")
      p1<-p1+geom_smooth(method="lm", se=FALSE, color="darkgreen") 
      # predicted vs. error (adding points)
      p2<-p2+geom_point(data=pred.val.set, aes(x=predicted,y=error), color="green")
      
      #lines at 0 and +/- one std deviation of error
      p2<-p2+geom_abline(slope=0,intercept=sd(pred.val.set$error), linetype="dashed")
      p2<-p2+geom_abline(slope=0,intercept=0)
      p2<-p2+geom_abline(slope=0,intercept=-sd(pred.val.set$error), linetype="dashed")
    }}}

grid.arrange(p1,p2,nrow=1)

# FORWARDS SELECTION MODEL
prop<-c(0.5,0.7,0.9) # 50/50, 70/30, and 90/10 splits 
for(i in 1:3){
  # create training and test sets
  cross.val<-sample(1:nrow(income_cleaned),prop[i]*nrow(income_cleaned), replace=FALSE)
  training.set<-income_cleaned[cross.val,] # the 50/70/90% to fit the model
  test.set<-income_cleaned[-cross.val,] # the 50/30/10% to use as validation sample
  # fit the model
  forwards.lm <- lm(log(weeklyinc) ~ workstatusMP + hiqualM + fulltimeM + maritalM + teachdisc +
                      schoolW6 + NSSEC + tenureHH + ethnicity + schoolW5 + backact +
                      tenureCM, data = training.set)
  # data frame to use in plots
  pred.val.set<-data.frame(predicted=predict(forwards.lm,test.set), 
    # predicted vs. original
    original=test.set$weeklyinc,error=(predict(forwards.lm,test.set)-test.set$weeklyinc))
  
  # the first iteration
  if(i==1){
    # predicted vs.original
    p1<-ggplot(data=pred.val.set, aes(x=predicted,y=original))+geom_point()+theme_bw()
    p1<-p1+geom_smooth(method="lm", se=FALSE) 
    p1<-p1+geom_abline(slope=1,intercept=0, linetype="dashed")
    # predicted vs. error
    p2<-ggplot(data=pred.val.set, aes(x=predicted,y=error))+geom_point()+theme_bw()
  }else{
    
    # the second iteration  
    if(i==2){
      # predicted vs. original (adding points)
      p1<-p1+geom_point(data=pred.val.set, aes(x=predicted,y=original), color="red")
      p1<-p1+geom_smooth(method="lm", se=FALSE, color="darkred") 
      # predicted vs. error (adding points)
      p2<-p2+geom_point(data=pred.val.set, aes(x=predicted,y=error), color="red")
    }else{
      
      # the third iteration
      # predicted vs. original
      p1<-p1+geom_point(data=pred.val.set, aes(x=predicted,y=original), color="green")
      p1<-p1+geom_smooth(method="lm", se=FALSE, color="darkgreen") 
      # predicted vs. error (adding points)
      p2<-p2+geom_point(data=pred.val.set, aes(x=predicted,y=error), color="green")
      
      #lines at 0 and +/- one std deviation of error
      p2<-p2+geom_abline(slope=0,intercept=sd(pred.val.set$error), linetype="dashed")
      p2<-p2+geom_abline(slope=0,intercept=0)
      p2<-p2+geom_abline(slope=0,intercept=-sd(pred.val.set$error), linetype="dashed")
    }}}

grid.arrange(p1,p2,nrow=1)

# ATTEMPTING TO CREATE A DATAFRAME OF RARE VALUES TO PERFORM CROSS-VALIDATION ON THE FORWARDS SELECTION MODEL
table(forwards_no_outliers$maritalM) # to identify rare values
prop<-c(0.5,0.7,0.9) # 50/50, 70/30, and 90/10 splits 
for(i in 1:3){
  # create training and test sets
  cross.val<-sample(1:nrow(forwards_no_outliers),prop[i]*nrow(forwards_no_outliers), replace=FALSE)
  training.set<-forwards_no_outliers[cross.val,] # the 50/70/90% to fit the model
  rare.vals <- data.frame(maritalM = 6, maritalM = 7)
  training.set <- rbind(training.set, rare.vals)
  test.set<-forwards_no_outliers[-cross.val,] # the 50/30/10% to use as validation sample
  # fit the model
  forwards.lm <- lm(log(weeklyinc) ~ workstatusMP + hiqualM + fulltimeM + maritalM + teachdisc +
    schoolW6 + NSSEC + tenureHH + ethnicity + schoolW5 + backact + tenureCM, data = training.set)
  # data frame to use in plots
  pred.val.set<-data.frame(predicted=predict(forwards.lm,test.set), 
    # predicted vs. original
    original=test.set$weeklyinc,error=(predict(forwards.lm,test.set)-test.set$weeklyinc))
  
  # the first iteration
  if(i==1){
    # predicted vs.original
    p1<-ggplot(data=pred.val.set, aes(x=predicted,y=original))+geom_point()+theme_bw()
    p1<-p1+geom_smooth(method="lm", se=FALSE) 
    p1<-p1+geom_abline(slope=1,intercept=0, linetype="dashed")
    # predicted vs. error
    p2<-ggplot(data=pred.val.set, aes(x=predicted,y=error))+geom_point()+theme_bw()
  }else{
    
    # the second iteration  
    if(i==2){
      # predicted vs. original (adding points)
      p1<-p1+geom_point(data=pred.val.set, aes(x=predicted,y=original), color="red")
      p1<-p1+geom_smooth(method="lm", se=FALSE, color="darkred") 
      # predicted vs. error (adding points)
      p2<-p2+geom_point(data=pred.val.set, aes(x=predicted,y=error), color="red")
    }else{
      
      # the third iteration
      # predicted vs. original
      p1<-p1+geom_point(data=pred.val.set, aes(x=predicted,y=original), color="green")
      p1<-p1+geom_smooth(method="lm", se=FALSE, color="darkgreen") 
      # predicted vs. error (adding points)
      p2<-p2+geom_point(data=pred.val.set, aes(x=predicted,y=error), color="green")
      
      # adding lines at 0 and +/- one std deviation of error
      p2<-p2+geom_abline(slope=0,intercept=sd(pred.val.set$error), linetype="dashed")
      p2<-p2+geom_abline(slope=0,intercept=0)
      p2<-p2+geom_abline(slope=0,intercept=-sd(pred.val.set$error), linetype="dashed")
    }}}

grid.arrange(p1,p2,nrow=1)

# ATTEMPTING set.seed() TO PERFORM CROSS-VALIDATION ON THE FORWARDS SELECTION MODEL (uncomment to see results)
# set.seed(123)
# set.seed(12)
# set.seed(23)
# set.seed(100)
# set.seed(200)
# set.seed(30)
# set.seed(40)
# set.seed(50)
# set.seed(60)
# set.seed(70)
set.seed(80)

prop<-c(0.5,0.7,0.9) # 50/50, 70/30, and 90/10 splits 
for(i in 1:3){
  # create training and test sets
  cross.val <- sample(1:nrow(forwards_no_outliers), prop[i] * nrow(forwards_no_outliers), replace = FALSE)
  training.set<-forwards_no_outliers[cross.val,] # the 50/70/90% to fit the model
  rare.vals <- data.frame(maritalM = 6, maritalM = 7)
  training.set <- rbind(training.set, rare.vals)
  test.set<-forwards_no_outliers[-cross.val,] # the 50/30/10% to use as validation sample
  # fit the model
  forwards.lm <- lm(log(weeklyinc) ~ workstatusMP + hiqualM + fulltimeM + maritalM + teachdisc +
                      schoolW6 + NSSEC + tenureHH + ethnicity + schoolW5 + backact + tenureCM, data = training.set)
  # data frame to use in plots
  pred.val.set<-data.frame(predicted=predict(forwards.lm,test.set), 
                           # predicted vs. original
                           original=test.set$weeklyinc,error=(predict(forwards.lm,test.set)-test.set$weeklyinc))
  
  # the first iteration
  if(i==1){
    # predicted vs.original
    p1<-ggplot(data=pred.val.set, aes(x=predicted,y=original))+geom_point()+theme_bw()
    p1<-p1+geom_smooth(method="lm", se=FALSE) 
    p1<-p1+geom_abline(slope=1,intercept=0, linetype="dashed")
    # predicted vs. error
    p2<-ggplot(data=pred.val.set, aes(x=predicted,y=error))+geom_point()+theme_bw()
  }else{
    
    # the second iteration  
    if(i==2){
      # predicted vs. original (adding points)
      p1<-p1+geom_point(data=pred.val.set, aes(x=predicted,y=original), color="red")
      p1<-p1+geom_smooth(method="lm", se=FALSE, color="darkred") 
      # predicted vs. error (adding points)
      p2<-p2+geom_point(data=pred.val.set, aes(x=predicted,y=error), color="red")
    }else{
      
      # the third iteration
      # predicted vs. original
      p1<-p1+geom_point(data=pred.val.set, aes(x=predicted,y=original), color="green")
      p1<-p1+geom_smooth(method="lm", se=FALSE, color="darkgreen") 
      # predicted vs. error (adding points)
      p2<-p2+geom_point(data=pred.val.set, aes(x=predicted,y=error), color="green")
      
      # adding lines at 0 and +/- one std deviation of error
      p2<-p2+geom_abline(slope=0,intercept=sd(pred.val.set$error), linetype="dashed")
      p2<-p2+geom_abline(slope=0,intercept=0)
      p2<-p2+geom_abline(slope=0,intercept=-sd(pred.val.set$error), linetype="dashed")
    }}}

grid.arrange(p1,p2,nrow=1)

# NEITHER set.seed() NOR CREATING A DATAFRAME OF RARE VALUES WORKED, WE CANNOT COMPLETE THIS ANALYSIS
# ADDITIONALLY, WE WOULD RUN MSPE FOR BOTH MODELS TO COMPARE THE ACCURACY OF IN SAMPLE AND OUT-OF-SAMPLE PREDICTIONS
# AS NEITHER APPROACH DETAILED PREVIOUSLY WORKED, WE COULD NOT - THIS IS DETAILED IN THE REPORT'S APPENDIX

# ---------------- INVESTIGATING MISSINGNESS IN THE MODELS --------------------#
# REPLACING "Missing" WITH NA
backwards_NAs <- backwards_no_outliers %>%
  mutate(across(all_of(add_category), ~ na_if(as.character(.), "Missing"))) %>%
  mutate(across(all_of(categorical), as.factor))

forwards_NAs <- forwards_no_outliers %>%
  mutate(across(all_of(add_category), ~ na_if(as.character(.), "Missing"))) %>%
  mutate(across(all_of(categorical), as.factor))

# REPLACE IN REGRESSION
backwards.lm <- lm(log(weeklyinc) ~  workstatusMP + illnessMP + hiqualM + maritalM
              + NSSEC + ethnicity + uniapp + illnessYP + canntry 
              + apprentW5  + uniW6 + sex, data = backwards_NAs)

forwards.lm <- lm(log(weeklyinc) ~ workstatusMP + hiqualM + fulltimeM + maritalM + teachdisc +
                    schoolW6 + NSSEC + tenureHH + ethnicity + schoolW5 + backact +
                    tenureCM, data = forwards_NAs)

summary(backwards.lm)
summary(forwards.lm)

# THE FINAL MODEL INCLUDES THE "Missing" CATEGORY, AND HAS NO OUTLIERS:
backwards.lm <- lm(log(weeklyinc) ~  workstatusMP + illnessMP + hiqualM + maritalM
                   + NSSEC + ethnicity + uniapp + illnessYP + canntry 
                   + apprentW5  + uniW6 + NEETact + sex, data = backwards_no_outliers)

summary(backwards.lm)
