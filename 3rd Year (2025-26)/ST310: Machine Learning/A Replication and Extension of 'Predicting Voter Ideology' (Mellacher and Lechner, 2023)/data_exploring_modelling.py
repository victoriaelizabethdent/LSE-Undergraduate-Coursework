import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn.preprocessing import LabelEncoder


# DATA PREPARATION
ees = pd.read_csv('data/original data/ZA7581_v2-0-1.csv')
ches = pd.read_csv('data/original data/CHES2019_experts.csv')

# renaming columns
ees.rename(columns = {
    'Q11': 'ees_lrgen',
    'Q14_1': 'ees_interven',
    'Q14_2': 'ees_redistribution',
    'Q14_3': 'ees_sociallife',
    'Q14_4': 'ees_civlib',
    'Q14_5': 'ees_immigration',
    'Q14_6': 'ees_environment'
}, inplace=True)

ches.rename(columns = {
    'econ_interven': 'ches_interven',
    'environment': 'ches_environment',
    'redistribution': 'ches_redistribution',
    'civlib_laworder': 'ches_civlib',
    'immigrate_policy': 'ches_immigration',
    'sociallifestyle': 'ches_sociallife'
}, inplace=True)

# selecting columns for analysis
ees_columns = ['ees_lrgen', 'ees_interven', 'ees_redistribution', 'ees_sociallife', 'ees_civlib', 'ees_immigration', 'ees_environment']
ees_full = ees[ees_columns]
ches_columns = ['lrgen', 'lrecon', 'galtan', 'ches_interven', 'ches_redistribution', 'ches_sociallife', 'ches_civlib', 'ches_immigration', 'ches_environment']
ches_full = ches[ches_columns]

# reverse the scale of immigration in EES so 0 is fully liberal
ees_full.loc[:, 'ees_immigration'] = 10 - ees_full['ees_immigration']

# removing all rows containing missing data in the dependent (policy) variables
ees_full = ees_full.apply(pd.to_numeric, errors='coerce')
ees_full = ees_full.where(ees_full.apply(lambda col: col.between(0, 10)))
ees_dependent = [col for col in ees_columns if col != 'ees_lrgen']
ees_full = ees_full.dropna() # simple dropna() as the paper suggests 20,186 rows - which is only achieved through no NAs

ches_full = ches_full.apply(pd.to_numeric, errors='coerce')
ches_full = ches_full.where(ches_full.apply(lambda col: col.between(0, 10)))
ches_dependent = [col for col in ches_columns if col not in ['galtan', 'lrecon', 'lrgen']]
ches_full = ches_full.dropna(subset = ches_dependent) # dropna() on dependent variables, NAs remain in the IVs

# reducing EES and CHES target variable to a 3-point scale where 0-3 is left, 4-6 is center, 7-10 is right
def reduce_scale(x):
    if 0 <= x <= 3:
        return 'l'  
    elif 4 <= x <= 6:
        return 'c'  
    elif 7 <= x <= 10:
        return 'r'  
    else:
        return x
    
ches_3pt = ches_full.copy()
ches_3pt['lrgen_3'] = ches_3pt['lrgen'].apply(reduce_scale)
ches_3pt['lrecon_3'] = ches_3pt['lrecon'].apply(reduce_scale)
ches_3pt['galtan_3'] = ches_3pt['galtan'].apply(reduce_scale)

ches_3pt = ches_3pt.drop(columns=['lrgen', 'lrecon', 'galtan'])

ees_3pt = ees_full.copy()
ees_3pt['ees_lrgen_3'] = ees_3pt['ees_lrgen'].apply(reduce_scale)

ees_3pt = ees_3pt.drop(columns=['ees_lrgen'])

# complete observations for each independent variable in CHES, remove all data rows where the value for the ideological scale is missing
ches_lrgen3_df = ches_3pt.dropna(subset=ches_dependent + ['lrgen_3'])
ches_lrecon3_df = ches_3pt.dropna(subset=ches_dependent + ['lrecon_3'])
ches_galtan3_df = ches_3pt.dropna(subset=ches_dependent + ['galtan_3'])

ches_lrgen11_df = ches_full.dropna(subset=ches_dependent + ['lrgen'])
ches_lrecon11_df = ches_full.dropna(subset=ches_dependent + ['lrecon'])
ches_galtan11_df = ches_full.dropna(subset=ches_dependent + ['galtan'])

# splitting datasets for validation, training, and testing (90% training and validation at the rate of 4 to 1, 10% test)

def split_train_val_test(df, target_col, test_size=0.10, val_size=0.20, random_state=42):
    X = df[ches_dependent]
    y = df[target_col]

    X_train_val, X_test, y_train_val, y_test = train_test_split(
        X, y,
        test_size=test_size,
        random_state=random_state,
        stratify=y
    )

    X_train, X_val, y_train, y_val = train_test_split(
        X_train_val, y_train_val,
        test_size=val_size,
        random_state=random_state,
        stratify=y_train_val
    )

    return X_train, X_val, X_test, y_train, y_val, y_test

predictors = ches_dependent

X_train_lrgen3, X_val_lrgen3, X_test_lrgen3, y_train_lrgen3, y_val_lrgen3, y_test_lrgen3 = \
    split_train_val_test(ches_lrgen3_df, 'lrgen_3')

X_train_lrecon3, X_val_lrecon3, X_test_lrecon3, y_train_lrecon3, y_val_lrecon3, y_test_lrecon3 = \
    split_train_val_test(ches_lrecon3_df, 'lrecon_3')

X_train_galtan3, X_val_galtan3, X_test_galtan3, y_train_galtan3, y_val_galtan3, y_test_galtan3 = \
    split_train_val_test(ches_galtan3_df, 'galtan_3')

X_train_lrgen11, X_val_lrgen11, X_test_lrgen11, y_train_lrgen11, y_val_lrgen11, y_test_lrgen11 = \
    split_train_val_test(ches_lrgen11_df, 'lrgen')

X_train_lrecon11, X_val_lrecon11, X_test_lrecon11, y_train_lrecon11, y_val_lrecon11, y_test_lrecon11 = \
    split_train_val_test(ches_lrecon11_df, 'lrecon')

X_train_galtan11, X_val_galtan11, X_test_galtan11, y_train_galtan11, y_val_galtan11, y_test_galtan11 = \
    split_train_val_test(ches_galtan11_df, 'galtan')

# saving the datasets for easy access
ches_lrgen3_df.to_csv('data/ches_lrgen3_df.csv', index=False)
ches_lrecon3_df.to_csv('data/ches_lrecon3_df.csv', index=False)
ches_galtan3_df.to_csv('data/ches_galtan3_df.csv', index=False)

ches_lrgen11_df.to_csv('data/ches_lrgen11_df.csv', index=False)
ches_lrecon11_df.to_csv('data/ches_lrecon11_df.csv', index=False)
ches_galtan11_df.to_csv('data/ches_galtan11_df.csv', index=False)

ees_full.to_csv('data/ees_lrgen11_df.csv', index=False)
ees_3pt.to_csv('data/ees_lrgen3_df.csv', index=False)

# EXPLORATORY DATA ANALYSIS

import matplotlib.pyplot as plt 
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, confusion_matrix

# Computing mean, std, and min/max for ideological targets and policy predictors

summary_stats = ches_full[
    ['lrgen', 'lrecon', 'galtan'] + ches_dependent
].describe().T[['mean', 'std', 'min', 'max']]

print(summary_stats)

# Distribution of ideological dimensions 

plt.figure()
plt.hist(ches_full['lrgen'], bins=11)
plt.title("Distribution of LRGEN")
plt.xlabel("LRGEN")
plt.ylabel("Frequency")
plt.show() # clustered around the centre

plt.figure()
plt.hist(ches_full['lrecon'], bins=11)
plt.title("Distribution of LRECON")
plt.xlabel("LRECON")
plt.ylabel("Frequency")
plt.show() # economic ideology more centrist and clustered

plt.figure()
plt.hist(ches_full['galtan'], bins=11)
plt.title("Distribution of GALTAN")
plt.xlabel("GALTAN")
plt.ylabel("Frequency")
plt.show() # highly polarised

# Correlation matrix

corr_matrix = ches_full[
    ['lrgen', 'lrecon', 'galtan'] + ches_dependent
].corr()

print(corr_matrix)

# MODELLING: LOGISTIC REGRESSION WITH REGULARISATION

LogisticRegression(
    solver='lbfgs',
    max_iter=1000
)

# Encoding 3-point scale to numbers

le_lrgen = LabelEncoder()
y_train_lrgen3 = le_lrgen.fit_transform(y_train_lrgen3)
y_val_lrgen3   = le_lrgen.transform(y_val_lrgen3)
y_test_lrgen3  = le_lrgen.transform(y_test_lrgen3)

le_lrecon = LabelEncoder()
y_train_lrecon3 = le_lrecon.fit_transform(y_train_lrecon3)
y_val_lrecon3   = le_lrecon.transform(y_val_lrecon3)
y_test_lrecon3  = le_lrecon.transform(y_test_lrecon3)

le_galtan = LabelEncoder()
y_train_galtan3 = le_galtan.fit_transform(y_train_galtan3)
y_val_galtan3   = le_galtan.transform(y_val_galtan3)
y_test_galtan3  = le_galtan.transform(y_test_galtan3)

# Logistic Regression Modelling on 3-point and 11-point ideology scales

def run_model(name, X_train, y_train, X_val, y_val, X_test, y_test):
    model = LogisticRegression(max_iter=1000, solver='lbfgs')
    model.fit(X_train, y_train)

    y_val_pred = model.predict(X_val)
    y_test_pred = model.predict(X_test)

    print(f"\n{name}")
    print("Validation accuracy:", accuracy_score(y_val, y_val_pred))
    print("Test accuracy:", accuracy_score(y_test, y_test_pred))
    print("Confusion matrix:")
    print(confusion_matrix(y_test, y_test_pred))

run_model("LRGEN 3-point", X_train_lrgen3, y_train_lrgen3, X_val_lrgen3, y_val_lrgen3, X_test_lrgen3, y_test_lrgen3)
run_model("LRECON 3-point", X_train_lrecon3, y_train_lrecon3, X_val_lrecon3, y_val_lrecon3, X_test_lrecon3, y_test_lrecon3)
run_model("GALTAN 3-point", X_train_galtan3, y_train_galtan3, X_val_galtan3, y_val_galtan3, X_test_galtan3, y_test_galtan3)

run_model("LRGEN 11-point", X_train_lrgen11, y_train_lrgen11, X_val_lrgen11, y_val_lrgen11, X_test_lrgen11, y_test_lrgen11)
run_model("LRECON 11-point", X_train_lrecon11, y_train_lrecon11, X_val_lrecon11, y_val_lrecon11, X_test_lrecon11, y_test_lrecon11)
run_model("GALTAN 11-point", X_train_galtan11, y_train_galtan11, X_val_galtan11, y_val_galtan11, X_test_galtan11, y_test_galtan11)


