# Lung Cancer Survival Analysis in Sweden 🇸🇪

This repository contains a course project for Analysis of Survival Data using lung cancer data from Sweden. It examines survival differences across treatment groups and time-varying effects of patient characteristics.


---

## Kaplan–Meier Survival Curves
These Kaplan–Meier curves show unadjusted survival patterns, with clearer separation by age group and hypertension.


<table>
  <tr>
    <td align="center">
      <img src="./KM_plot/KM_treatment.png" width="300"><br>
      Treatment Type
    </td>
    <td align="center">
      <img src="./KM_plot/KM_age.png" width="300"><br>
      Age Groups
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="./KM_plot/KM_hypertension.png" width="300"><br>
      Hypertension
    </td>
    <td align="center">
      <img src="./KM_plot/KM_cirrhosis.png" width="250"><br>
      Cirrhosis
    </td>
  </tr>
</table>




## Cox Model

Survival was analyzed using a *stratified Cox proportional hazards model*, with covariates selected based on model diagnostics.

The baseline hazard was stratified by cancer stage, with a time-dependent effect for hypertension.


```math
h_i(t \mid Z_i) = h_{0,\text{stage}(i)}(t)
\exp\!\left(
\beta_{\text{age}}\,\text{age}_i
+ \beta_{\text{cir}}\,\text{cirrhosis}_i
+ \beta_{\text{trt}}^\top \text{treatment}_i
+ \beta_{\text{ht}}\,\text{hypertension}_i
+ \beta_{\text{ht},t}\,\text{hypertension}_i \log t
\right).
```



---

## Results


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
├── reports/
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