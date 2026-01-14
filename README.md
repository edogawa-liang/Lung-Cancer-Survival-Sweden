# Lung Cancer Survival Analysis in Sweden 🇸🇪

This repository contains a course project for Analysis of Survival Data, based on lung cancer patients in Sweden. The aim is to examine whether survival differs across treatment groups and whether other patient characteristics have effects on survival that vary over time.

---

## Kaplan–Meier Survival Curves

<table>
  <tr>
    <td align="center">
      <img src="./KM_plot/km_treatment.png" width="300"><br>
      Treatment Type
    </td>
    <td align="center">
      <img src="./KM_plot/km_age.png" width="300"><br>
      Age Groups
    </td>
    <td align="center">
      <img src="./KM_plot/km_hypertension.png" width="300"><br>
      Hypertension
    </td>
  </tr>
</table>


These Kaplan–Meier curves provide descriptive insights prior to adjustment.
Survival curves largely overlap across treatment types, while clearer separation
is observed by age group and hypertension status.



## Cox Model

Covariates included in the final model were selected based on clinical relevance and
model diagnostics; details are provided in the report.

Survival was analyzed using a *stratified Cox proportional hazards model* with a time-dependent
effect for hypertension. Let $T_i$ denote the survival time for individual $i$. The model is

```tex
h_i(t \mid Z_i) = h_{0,\text{stage}(i)}(t)
\exp\!\left(
\beta_{\text{age}}\,\text{age}_i
+ \beta_{\text{cir}}\,\text{cirrhosis}_i
+ \beta_{\text{trt}}^\top \text{treatment}_i
+ \beta_{\text{ht}}\,\text{hypertension}_i
+ \beta_{\text{ht},t}\,\text{hypertension}_i \log t
\right).
```

The baseline hazard is stratified by cancer stage, and hypertension is allowed to have a
time-dependent effect through an interaction with $\log(t)$.


---

## Results

After adjusting for patient characteristics and cancer stage:

- **Treatment type** shows no clear association with survival; hazard ratios are close to 1.
- **Age** is associated with a higher risk of death, with an approximate **1.2% increase in risk per year**.

- **Hypertension** has a strong **time-dependent effect**, with substantially higher risk early
  in follow-up that decreases over time.

Overall, survival differences are largely explained by patient characteristics rather than
treatment choice.



---

## Folder Structure

```
Lung-Cancer-Survival-Sweden/
├── assignment/
│   ├── assignment1_description.pdf   # Assignment 1 task description and requirements
│   └── assignment2_description.pdf   # Assignment 2 task description and requirements
│
├── data/
│   └── lung_cancer_sweden.csv         # Lung cancer survival dataset (Sweden)
│
├── pdf/
│   ├── km_group_survival.pdf          # Assignment 1 report: Kaplan–Meier analysis
│   ├── cox_model_adjusted_survival.pdf# Assignment 2 report: Cox regression results
│   └── lung_cancer_survival_slides.pdf# Presentation slides summarizing the project
│
├── analysis/
│   ├── data_prep.ipynb                # Data preprocessing and time-to-event construction
│   ├── eda_survival.ipynb             # Exploratory analysis of survival-related variables
│   ├── km_group_survival.sas          # SAS code for Kaplan–Meier analysis (Assignment 1)
│   └── cox_model_adjusted_survival.sas# SAS code for Cox model and diagnostics (Assignment 2)
│
└── README.md                          # Project overview and main results

```