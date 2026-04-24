library(haven)
setwd("/Users/victoriadent/Desktop/2023-2026 (LSE)/3rd Year, 2025-2026/ST310, Machine Learning/Assessments/GitHub for AT Summative03")

ees <- read_sav('ST310-AT-Summative03/data/original_data/ZA7581_v2-0-1 (1).sav', encoding = "latin1")
write.csv(ees, 'ST310-AT-Summative03/data/original_data/ZA7581_v2-0-1.csv', row.names = FALSE)
