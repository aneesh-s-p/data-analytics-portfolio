# Marketing A/B Test Analysis: Did the Ad Campaign Increase Conversions?

**Business question:** One group of users saw a real advertisement and another saw a neutral public service announcement (PSA). Did the ad increase conversions, by how much, and is the result strong enough to act on?

**Data:** "Marketing A/B Testing" dataset on Kaggle: 588,101 users with test group, converted (yes/no), total ads seen, and the day and hour of most ads.
**Tools:** Python, pandas, scipy, matplotlib, seaborn (run in Google Colab)

## What I did
1. Cleaned the data (no missing values, no duplicate user IDs) and checked group sizes.
2. Compared conversion rates and tested the difference with a two-proportion z-test and a chi-square test.
3. Calculated absolute lift, relative lift and a 95% confidence interval.
4. Looked at conversion by day, hour and number of ads seen.
5. Estimated business impact and break-even lift under stated assumptions.

## Results
| | Users | Conversions | Conversion rate |
|---|---|---|---|
| Ad (treatment) | 564,577 | 14,423 | 2.555% |
| PSA (control) | 23,524 | 420 | 1.785% |

- **Lift:** +0.77 percentage points (95% CI 0.60 to 0.94), a **43.1% relative increase**.
- **Significance:** z = 7.37, p = 1.7e-13 (chi-square p = 2.0e-13), so the difference is very unlikely to be chance.
- **Timing:** conversion was highest on Monday (3.32%) and lowest on Saturday (2.13%); the best hour was 16:00 (3.09%), with the lowest rates overnight.
- **Ads seen:** conversion rose sharply with exposure: 0.25% at 1-5 ads, 0.49% at 6-10, 0.84% at 11-20, 2.92% at 21-50, then roughly 12% at 51-100 and 17% at 100+.
- **Business impact (assumptions: 1,000,000 users, $50 per conversion, $100,000 cost):** about 7,692 extra conversions and $384.6K extra revenue, a 285% return. Break-even needs only 0.20 points of lift, and even the low end of the confidence interval (0.60 points) stays well above that.

## Recommendation
Roll out the campaign: the ad clearly outperformed the PSA and stays profitable across the whole confidence interval. Focus spend on Monday-Tuesday and afternoon-evening hours, and test frequency carefully (see limitations) before raising ad exposure. Run a follow-up test with equal-sized groups, different creatives, and revenue per user as the outcome.

## Limitations
- The groups are very unequal (96% ad, 4% PSA). I could not verify how users were assigned, so a sample-ratio check with the data owner would be a first step.
- The ads-seen pattern is an association, not proof that more ads cause more conversions: users who are already interested may simply see more ads.
- Day and hour describe when a user saw the most ads, not when conversion happened.
- Conversion is yes/no, so it says nothing about revenue per customer. Business impact uses assumed values.

## How to run
1. Download `marketing_AB.csv` from Kaggle ("Marketing A/B Testing"); the data file is not included here.
2. `pip install -r requirements.txt`
3. Open `Marketing_AB_Test_Analysis.ipynb` (or paste the `.py` file into one Colab cell), set the `FILE` path, and run all cells.

`Marketing_AB_Test_Analysis_output.pdf` shows the notebook with all outputs.

## AI assistance
Built with AI assistance (Claude) for code drafting and structure; I ran, checked and interpreted every result myself.
