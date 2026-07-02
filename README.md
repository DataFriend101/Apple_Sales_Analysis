![Alt text](/apple.avif)
# Apple Global Sales Analysis
Apple global product sales analysis using Python, MySQL, and Tableau. Covers market performance, product revenue, and sales trends across 47 countries (2022–2024) 

## Data Used
This project's data was obtained from the Kaggle Apple Global Product Sales Dataset and it encompasses city-level transactions across multiple continents, currencies, sales channels,and customer demographics. **The raw data** contains 27 columns and 11 500 rows: 
| Column |	Description |	Data Type |
| ------ |  ----------- |  -------- |
| sale_id | Unique transaction ID —APPL-XXXXXXXX | string |
| sale_date | Transaction date YYYY-MM-DD | date |
| year | Year the transaction occured | int |
| quarter | The four three-month periods of the year | string |
| month | Full month name | string |
| country | Country of sale | string |
| region | Continent/geo-region | string |
| city | City of sale | string |
| product_name | Full product name | string |
| category | Category which the item belongs | string |
| storage |	Storage variant | string |
| color |	Colour option | string |
| unit_price_usd | Per-unit list price in USD | float |
| discount_pct | Discount applied | float | 
| units_sold | Quantity in this transaction | int |
| discounted_price_usd | Effective per-unit price after discount | float |
| revenue_usd | Total transaction revenue in USD | float |	
| currency | Local currency code | string |
| fx_rate_to_usd | Exchange rate used for conversion | float |
| revenue_local_currency | Revenue in local currency | float |
| sales_channel | Channel through which the product was sold | string | 
| payment_method | The customer's payment method | string |
| customer_segment | The customer group associated with the purchase | string |
| customer_age_group | Age group of the customer | string |
| previous_device_os | Previous OS (iPhone buyers only) | string |
| customer_rating |	Post-purchase rating of product | float |
| return_status | Status of product | string |

## Data Cleaning (Python)
- **Duplicates** — Checked; none found
- **Missing values**
  - `storage` → filled with `'N/A'` (non-storage products like cables have no storage variant)
  - `customer_rating` → kept NaN as-is (~30% missing, consistent with dataset design; filled only for modeling if needed)
- **Text standardization** — Strip spaces, apply `.title()` case for consistent formatting across categorical fields
- **Date parsing** — `sale_date` converted to datetime to enable time-series analysis
- **Feature engineering**
  - `discount_amount_usd` —  absolute discount value per transaction
  - `revenue_no_discount_usd` — what revenue would have been without discounting
- **Column renaming**
  - `revenue_usd` → `revenue_discounted_usd` (for clarity)
* The **clean data** contains 29 columns and 11,500 rows

## Analysis (MySQL) 

### 0. Exploratory Queries
   - Tested different queries to identify patterns worth visualizing such as category performance by units sold,
   revenue by year and country, customer demographics, sales channels, payment methods, return rates, color preferences, and discount impact. 

### 1. Global Sales Overview
   - **Revenue by Country (Top 10)** — Identified top-performing markets; Hong Kong leads at ~$485K
     with all top 10 clustered tightly in the $404K–$485K range
   - **Revenue by Continent** — Europe leads in aggregate revenue due to highest country count; no single region dominates
   - **Revenue by Category** — Mac dominates at ~$8.4M, followed by iPhone with ~$5.7M; Accessories lowest despite highest transaction volume
     
### 2. Product Performance
   - **Overall Return Rate** — 88.2% Kept, 7.81% Returned, 3.99% Exchanged; flat across all categories and countries
   - **Highest and Lowest Revenue Products by Category** — Used RANK() OVER to surface best and worst performer within
   each of 6 categories; Mac Pro (M2 Ultra) dominates at $3.7M while Accessories occupy the bottom tier
   - **Units Sold vs Revenue by Category** — Aggregated total units and revenue per category to reveal price-volume tension:
   Mac wins on revenue per unit, Accessories on transaction volume

### 3. Sales Trend
   - **Yearly Revenue Growth by Category** — Calculated YoY growth using LAG() window function; AirPods showed highest volatility
   (+17.7% in 2023, –20.8% in 2024) while Mac remained most stable
   - **Monthly Revenue Over Time** — Tracked 36 months of revenue by category; no consistent Q4 seasonal surge detected, consistent with
   randomized synthetic generation

## Dashboards (Tableau)

### Page 1 — Global Sales Overview
*Where does Apple sell, and what does it sell?*
- Top 10 markets by revenue (bar chart)
- Global revenue distribution (map)
- Revenue by product category (bar chart)

**Key finding:** Revenue is remarkably evenly distributed across all 47 markets; even the lowest-performing country generates over $280K. 
No single market dominates. Mac generates the highest category revenue despite moderate transaction volume, driven entirely by price.

### Page 2 — Product Performance
*Which products drive revenue, and which underperform?*

- Highest and lowest revenue product per category (bar chart)
- Units sold vs revenue by category (scatter)
- Overall purchase outcome (pie)

**Key finding:** Mac Pro (M2 Ultra) alone generates $3.7M; more than the entire bottom 10 products combined. The bottom 10 are exclusively 
Accessories and entry-level AirPods, which sell at high volume but low price. 88.2% of all purchases are kept, with a consistent 
~7.8% return rate across all categories.

### Page 3 — Sales Trends
*How has the product mix evolved, and what drives growth?*

- Monthly revenue trend by category (line chart)
- Yearly revenue growth by category (line chart)

**Key finding:** AirPods showed the most volatility (+17.7% in 2023, -20.8% in 2024). Mac revenue is the most stable, declining only 0.05% 
in 2023 before recovering 9.2% in 2024.

***Extra Analysis***:
- Discount level has no relationship with units sold (avg ~2.0 units across all discount levels 0–15%)
- Customer age group shows no meaningful product preference with every group purchasing similar category mixes
- Return rates are consistent across all categories (~88% kept, ~8% returned)
- Customer ratings show no variation by product or return outcome (avg ~4.0 across all segments)


