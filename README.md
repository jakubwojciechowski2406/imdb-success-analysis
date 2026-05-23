# imdb-success-analysis

Logistic regression analysis of factors associated with high IMDb ratings, based on the IMDb Top 1000 Movies dataset.

**Author:** Jakub Wojciechowski  
**Course:** Statistics for Machine Learning, Kozminski University

---

## 1. Goal

Identify which movie characteristics are associated with a higher probability of achieving an IMDb rating of at least 8 (defined as "success"). The analysis focuses on three predictors: popularity (number of votes), runtime, and release year.

## 2. Dataset

- **Source:** IMDb Top 1000 Movies — [Kaggle](https://www.kaggle.com/datasets/harshitshankhdhar/imdb-dataset-of-top-1000-movies-and-tv-shows)
- **Size:** 999 movies (after cleaning — 1 record removed due to missing release year)
- **Outcome variable:** `success` (1 if IMDb rating ≥ 8, else 0)

## 3. Method

- **Model:** Logistic regression in R (binary outcome)
- **Predictors:**
  - `log_votes` — number of IMDb votes (log-transformed to reduce skewness)
  - `Runtime_num` — runtime in minutes
  - `Released_Year_num` — release year
- **Model selection:** Compared baseline (log_votes only) with full model (3 predictors) using likelihood-ratio test
- **Diagnostics:** Multicollinearity checked via VIF (all values ≈ 1)
- **Performance:** Confusion matrix at 0.5 threshold + accuracy, sensitivity, specificity

## 4. Results

### Estimated odds ratios (full model)

| Variable | Odds Ratio | 95% CI |
|---|---|---|
| Popularity (log votes) | 1.60 | [1.41, 1.83] |
| Runtime | 1.02 | [1.01, 1.02] |
| Release year | 0.98 | [0.97, 0.98] |

### Predicted probability of success vs popularity

![Predicted probability](Plots/predicted_probability.png)

| Number of votes | Predicted P(success) |
|---|---|
| 20,000 | ~22% |
| 250,000 | ~45% |
| 2,000,000 | ~70% |

### Model performance (threshold = 0.5)

- Accuracy: ~66%
- Sensitivity: ~57%
- Specificity: ~75%

## 5. Key findings

- **Popularity is the strongest predictor** — movies with more IMDb votes are significantly more likely to achieve a rating ≥ 8.
- Runtime and release year matter, but to a lesser degree.
- Newer movies tend to have lower predicted probability of success — possibly reflecting the presence of well-established classics among top-rated titles.

## 6. Limitations

- Dataset restricted to IMDb Top 1000 (already popular films) — results may not generalize to broader populations.
- Limited set of predictors (genre, budget, director not included).
- Results describe associations, not causal relationships.

## 7. How to reproduce

1. Clone this repository
2. Make sure `imdb_top_1000.csv` is in the same folder as `Jakub_Wojciechowski_49872_Final_Project_Script.R`
3. Open in RStudio and run the script
4. Required package: `car` (for VIF)

## 8. Files

- `Jakub_Wojciechowski_49872_Final_Project_Script.R` — main R script (data prep, EDA, modeling, predictions)
- `imdb_top_1000.csv` — dataset
- `Plots/` — generated visualizations
- `Docs/Jakub_Wojciechowski_49872_Final_Project_Report.pdf` — full project report
- `Docs/Jakub_Wojciechowski_49872_Final_Project_Presentation.pdf` — slide deck

## 9. Use of AI tools

AI was used for assistance with: log transformation choice, prediction grid creation, classification metrics calculation, and report review. All results were verified and interpreted by the author.
