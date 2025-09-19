#### "What Actions Can Be Justified? Are There Regional Differences When it Comes to This?"

This project explores global attitudes toward moral and ethical issues using Wave 7 of the World Values Survey (WVS) data. We analyze justification scores for various actions (e.g., divorce, abortion, political violence) through descriptive statistics, similarity metrics, and clustering techniques. Our approach aims to identify patterns in moral reasoning and uncover regional differences in justification across countries to answer the questions above, solely using **unsupervised modelling**. 

## Why Is This Project Useful?

-   It provides insight into social attitudes towards certain actions, and if these differ across cultural and regional boundaries.

-   It identifies cases of polarisation by analysing statistical measures such as mode, median, and variance, highlighting areas of divided opinion.

-   It examines justification patterns across countries and actions using Jensen-Shannon divergence and clustering (hierarchical and DBSCAN)

-   It initially analyses each country's mean scores for all questions, before moving to using Jensen-Shannon divergence and hierarchical clustering to determine if differences are regional

-   Create classification model and plot decision tree to determine potential significant predictors of attitudes towards divorce

## **The Structure**

1.  [World Values Survey](WVS.csv.zip), is the original data from the WVS.

2.  All individual contribution files are stored in the `reflections` folder.

3.  All previous elements of the project, alternate attempts to answer our research questions, and older versions of our approaches are stored in `evidence from previous commits`, and can be used to support our individual contributions.

Finally, [group8.qmd](group8.md) and [group8.html](group8.html) detail our entire project. We have expanded on what can be found in these files below.

## Part 1: What Actions Can Be Justified?

### 1.1 Introduction to the WVS

### 1.2 Loading and Cleaning Data

-   The pre-processing of the WVS to create a reduced dataset

    -   Selecting relevant variables (the actions, explanatory variables, regional columns)

    -   Adding question labels for visualisations to describe each actions

    -   Handling missing values and recoding responses

### 1.3 Exploring Measures of Difference

-   Examination of descriptive statistics such as the arithmetic and geometric means, median, mode, variance, and standard distribution, and further exploration into skew, upper and lower quartiles (including the interquartile range), and relative frequency graphs

### 1.4 Final Classification of Justification Levels

-   Based on statistical insights from the descriptive statistics, a final evaluation is given for each action with insights from academic literature.

### 1.5 Clustering Justification Patterns

-   Outlining an intuitive grouping of three broad categories:

    1.  Individual Liberties
    2.  Economic/Corruption-Related Actions
    3.  Violence-Related Actions

-   Exploration of relationships between actions using Jensen-Shannon divergence and Spearman correlations to explore if our hypothesis aligns with the data

    -   Further testing our hypothesis through using hierarchical clustering and DBSCAN

-   Evaluation of the final clusters

## Part 2: Are There Regional Differences When it Comes to This?

### 2.1 Country Means

-   Using geometric means for each country-question pair to analyse differences in responses across countries and comparing to the global mean for each question

-   Viewing the global distribution of mean responses to the justifiability of homosexuality and the death penalty

### 2.2 National Divergence

-   Selecting a set of questions for analysis: Homosexuality, Abortion, Divorce, Sex before marriage, Suicide, Euthanasia, Casual sex

-   Calculating Jensen-Shannon divergence between countries

-   Calculation and exploration of similarity between countries

### 2.3 Clustering

-   Perform hierarchical clustering to group countries then compare groups to geographic regions

### 2.4 Prediction

-   Create classification model and plot decision tree to determine potential significant predictors of attitudes towards divorce
