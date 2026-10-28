# E-commerce Sales & Customer Analysis (BigQuery SQL + Looker Studio)

**Business question:** Where do revenue and profit come from, which customers and channels matter most, and where is the business losing money?

**Data:** `bigquery-public-data.thelook_ecommerce` (a free, synthetic public e-commerce dataset in Google BigQuery). Results below were run on 27 Oct 2026; the dataset updates, so figures may change. Revenue excludes Cancelled and Returned items. Amounts are in USD.

**Tools:** BigQuery SQL (joins, CTEs, window functions, CASE), Looker Studio

## Headline numbers
| Metric | Value |
|---|---|
| Orders | 93,644 |
| Customers | 65,981 |
| Revenue | $8.09M |
| Average order value | $86.40 |

## Key findings
1. **Repeat buyers carry the business.** 69.3% of customers bought only once (49.0% of revenue). Repeat and loyal buyers are 30.7% of customers but generate 51.0% of revenue. Loyal buyers (4+ orders) are only 2.4% of customers but 6.7% of revenue.
2. **Few customers come back.** On average only about 2.4% of a cohort orders again in the month after their first order, staying around 2% through month 6.
3. **Channel does not change customer value.** Revenue per customer is almost identical across Search ($122.80), Organic ($121.98), Facebook ($123.46), Email ($121.49) and Display ($121.86). Search leads on volume alone, with about 70% of revenue.
4. **Revenue is concentrated by country.** China (34.1%), the United States (22.4%) and Brazil (14.4%) generate 70.9% of revenue.
5. **Category mix.** Outerwear & Coats is the top category by revenue ($994.7K, 55.5% margin), followed by Jeans ($924.8K, 46.4%). Blazers & Jackets has the highest margin (62.1%) but the lowest revenue of the top 15 ($220.7K). Tops & Tees has the lowest margin (44.1%).
6. **Returns are broad.** Even the highest categories return only 10.1-11.3% of items (Skirts 11.3%, Blazers & Jackets 11.2%), so returns are a general issue, not one problem category.
7. **Brands.** Calvin Klein earns the most profit ($81.2K), followed by Carhartt ($70.8K) and Diesel ($67.6K).
8. **Growth.** Annual revenue grew about 41% in 2024 and 45% in 2025. The latest month (Oct 2026) shows a sharp jump that I treat with caution, since the month may be incomplete.

## Recommendations
1. Run a second-purchase campaign (discount or reminder within 30 days) for one-time buyers, since the repeat segment earns about 3x more per customer.
2. Do not pay more for one channel on the assumption it brings better customers; compare channels on acquisition cost, which this dataset does not include.
3. Promote high-margin categories (Blazers & Jackets, Accessories, Suits) and review pricing in Tops & Tees.
4. Reduce dependence on three countries by testing marketing in mid-size markets such as the UK, Germany and France.
5. Add better size and fit information to lower the 10-11% return rate.

## Limitations
- Synthetic data, so findings show method, not real company performance.
- No marketing cost data, so channels are compared on revenue only.
- Retention counts customers who return, not their purchase value.

## Files
- `ecommerce_sales_analysis.sql`: the nine BigQuery queries.
- `results/`: the exported results of queries 2-9 (query 1 is the headline table above).
- `dashboard/ecommerce_dashboard.html`: a dashboard built from the results (download and open in a browser).

## AI assistance
Built with AI assistance (Claude) for query drafting and structure; I ran, checked and interpreted every result myself.
