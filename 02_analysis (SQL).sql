-------------------------------------------------------------------
-- Exploratory Queries --------------------------------------------
-------------------------------------------------------------------
-- Most selling category by units sold
SELECT 
    category,
    SUM(units_sold) AS total_units
FROM apple
GROUP BY category
ORDER BY total_units DESC;

-- Total revenue by year
SELECT 
    year,
    SUM(revenue_discounted_usd) AS total_revenue
FROM apple
GROUP BY year
ORDER BY year;

-- Country with largest revenue
SELECT 
    country,
    region,
    SUM(revenue_discounted_usd) AS total_revenue
FROM apple
GROUP BY country, region
ORDER BY total_revenue DESC;

-- Category with highest average discount
SELECT 
    category,
    AVG(discount_pct) AS avg_discount
FROM apple
GROUP BY category
ORDER BY avg_discount DESC;

-- Most common category by customer age group
SELECT
    customer_age_group,
    category,
    COUNT(*) AS transaction_count
FROM apple
GROUP BY customer_age_group, category
ORDER BY customer_age_group, transaction_count DESC;

-- Average rating by category
SELECT
    category,
    ROUND(AVG(customer_rating), 2) AS avg_rating
FROM apple
GROUP BY category
ORDER BY avg_rating DESC;

-- Age group distribution
SELECT
    customer_age_group,
    COUNT(*) AS count
FROM apple
GROUP BY customer_age_group
ORDER BY count DESC;

-- Revenue by sales channel
SELECT
    sales_channel,
    SUM(revenue_discounted_usd) AS total_revenue
FROM apple
GROUP BY sales_channel
ORDER BY total_revenue DESC;

-- Revenue by payment method
SELECT
    payment_method,
    SUM(revenue_discounted_usd) AS total_revenue
FROM apple
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- Return rate by category
SELECT
    category,
    return_status,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY category), 2) AS pct_within_category
FROM apple
GROUP BY category, return_status
ORDER BY category, return_status;

-- Return rate by country
SELECT
    country,
    return_status,
    COUNT(*) AS count
FROM apple
GROUP BY country, return_status
ORDER BY country, return_status;

-- Color popularity by units sold
SELECT
    color,
    SUM(units_sold) AS total_units,
    SUM(revenue_discounted_usd) AS total_revenue
FROM apple
GROUP BY color
ORDER BY total_units DESC;

-- Average units sold by discount level
SELECT 
    discount_pct,
    COUNT(*) AS num_transactions,
    AVG(units_sold) AS avg_units_sold,
    SUM(revenue_discounted_usd) AS total_revenue
FROM apple
GROUP BY discount_pct
ORDER BY discount_pct;

--------------------------------------------------------------------
-- Global Sales Overview -------------------------------------------
--------------------------------------------------------------------

-- Revenue by Country (Top 10)
SELECT 
    country,
    region,
    SUM(revenue_discounted_usd) AS total_revenue,
    COUNT(*) AS num_transactions
FROM apple
GROUP BY country, region
ORDER BY total_revenue DESC
LIMIT 10;

-- Revenue by Continent 
SELECT 
    region,
    SUM(revenue_discounted_usd) AS total_revenue,
    COUNT(*) AS num_transactions
FROM apple
GROUP BY region
ORDER BY total_revenue DESC;

-- Total revenue by category
SELECT 
    category,
    SUM(revenue_discounted_usd) AS total_revenue
FROM apple
GROUP BY category
ORDER BY total_revenue DESC;

--------------------------------------------------------------------
-- Product performance ---------------------------------------------
--------------------------------------------------------------------

-- Overall return rate
SELECT 
    return_status,
    COUNT(*) AS num_transactions,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM apple), 2) AS pct_of_total
FROM apple
GROUP BY return_status;

-- Highest and lowest revenue products by category
SELECT category, product_name, total_revenue, rank_within_category
FROM (
    SELECT 
        category,
        product_name,
        SUM(revenue_discounted_usd) AS total_revenue,
        RANK() OVER (PARTITION BY category ORDER BY SUM(revenue_discounted_usd) DESC) AS rank_within_category,
        RANK() OVER (PARTITION BY category ORDER BY SUM(revenue_discounted_usd) ASC) AS rank_worst
    FROM apple
    GROUP BY category, product_name
) ranked
WHERE rank_within_category = 1 OR rank_worst = 1
ORDER BY category, total_revenue DESC;

-- Units Sold vs Revenue by Category
SELECT 
    category,
    SUM(units_sold) AS total_units,
    SUM(revenue_discounted_usd) AS total_revenue
FROM apple
GROUP BY category
ORDER BY total_revenue DESC;

--------------------------------------------------------------------
-- Sales Trends -----------------------------------------------------
--------------------------------------------------------------------

-- Yearly Revenue Growth by Category
SELECT 
    category,
    year,
    SUM(revenue_discounted_usd) AS total_revenue,
    LAG(SUM(revenue_discounted_usd)) OVER (PARTITION BY category ORDER BY year) AS prev_year_revenue,
    ROUND((SUM(revenue_discounted_usd) - LAG(SUM(revenue_discounted_usd)) OVER (PARTITION BY category ORDER BY year)) / LAG(SUM(revenue_discounted_usd)) OVER (PARTITION BY category ORDER BY year) * 100, 2) AS yoy_growth_pct
FROM apple
GROUP BY category, year
ORDER BY category, year;

-- Monthly Revenue Over Time 
SELECT 
    year,
    month,
    category,
    SUM(revenue_discounted_usd) AS total_revenue
FROM apple
GROUP BY year, month, category
ORDER BY year, month;




