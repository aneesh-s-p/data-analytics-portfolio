# Customer Churn Analysis (Python)

**Business question:** Which telecom customers are most likely to leave, why, and what should the business do to keep them?

**Data:** IBM Telco Customer Churn dataset (7,043 customers, 21 columns), free on Kaggle. The data file is not included here; download `WA_Fn-UseC_-Telco-Customer-Churn.csv` from Kaggle.
**Tools:** Python, pandas, matplotlib, seaborn, scikit-learn

## What I did
1. Cleaned the data (11 blank `TotalCharges` values for brand-new customers, 22 duplicate rows noted) and measured overall churn.
2. Compared churn across contract, tenure, internet service, payment method and support services.
3. Built and compared Logistic Regression and Random Forest models.
4. Identified the biggest churn drivers and estimated monthly revenue at risk.

## Results
- **Overall churn:** 26.5% of customers; churned customers account for 30.5% of monthly revenue (139,131).
- **Contract:** month-to-month 42.7%, one-year 11.3%, two-year 2.8%.
- **Tenure:** 47.4% churn in the first 12 months, falling to 9.5% after 49+ months.
- **Service and payment:** fiber optic 41.9% (DSL 19.0%); electronic check 45.3% (other methods 15-19%).
- **Churned customers** were newer (average tenure 18.0 vs 37.6 months) and paid more (74.4 vs 61.3 per month).
- **Models:** both reached ROC-AUC 0.84. Random Forest caught 271 of 374 churners in the test set (recall 0.72, precision 0.55); Logistic Regression had recall 0.78 and precision 0.50.
- **Business impact:** the Random Forest flagged 494 high-risk customers worth about 36.8K in monthly revenue. At an assumed 20% save rate, a retention offer would keep about 7.4K per month.

## Recommendations
1. Move month-to-month customers to 1-year plans with a discount, especially in their first year.
2. Encourage autopay for electronic-check customers.
3. Review price and service quality for fiber optic customers.
4. Bundle online security and tech support for new customers.
5. Give the retention team a monthly list of the highest-risk customers.

## Limitations
- One snapshot of data: results show association, not proof of cause.
- The 20% save rate is an assumption; real impact should be tested with an A/B test.
- Only about half of flagged customers would actually leave, so the model prioritizes outreach rather than predicting with certainty.

## How to run
1. Download the Kaggle file and put it in this folder.
2. `pip install -r requirements.txt`
3. Open `Customer_Churn_Analysis.ipynb` (or paste `Customer_Churn_Analysis.py` into one Colab cell) and run all cells.

`Customer_Churn_Analysis_output.pdf` shows the notebook with all outputs.

## AI assistance
Built with AI assistance (Claude) for code drafting and structure; I ran, checked and interpreted every result myself.
