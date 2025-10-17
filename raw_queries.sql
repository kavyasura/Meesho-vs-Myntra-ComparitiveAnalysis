CREATE VIEW top_customers_by_spend AS
SELECT Top 5
    c.customer_name, 
    SUM(o.total_bill) AS total_spend
FROM customers_data c
JOIN orders_data o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE p.platform IN ('Meesho', 'Myntra')
GROUP BY c.customer_name
ORDER BY total_spend DESC;

CREATE VIEW age_brand_revenue AS
SELECT 
    p.platform,
    c.age,
    SUM(o.total_bill) AS total_revenue
FROM customers_data c
JOIN orders_data o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE p.platform IN ('Meesho', 'Myntra')
GROUP BY c.age, p.platform;

CREATE VIEW most_ordered_category_by_platform AS
WITH ranked_categories AS (
    SELECT 
        p.platform,
        p.product_category,
        SUM(o.total_bill) AS total_amount,
        RANK() OVER(PARTITION BY p.platform ORDER BY SUM(o.total_bill) DESC) AS rk
    FROM products p
    JOIN orders_data o ON p.product_id = o.product_id
    WHERE p.platform IN ('Meesho', 'Myntra')
    GROUP BY p.platform, p.product_category
)
SELECT platform, product_category
FROM ranked_categories
WHERE rk = 1;

CREATE VIEW age_group_revenue AS
SELECT 
    p.platform,
    CASE 
        WHEN c.age BETWEEN 18 AND 30 THEN 'Young'
        ELSE 'Senior'
    END AS age_group,
    SUM(o.total_bill) AS total_revenue
FROM customers_data c
JOIN orders_data o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE p.platform IN ('Meesho', 'Myntra')
GROUP BY p.platform, age;


CREATE VIEW top_3_products_per_platform AS
WITH ranked_products AS (
    SELECT 
        p.platform,
        p.product_name,
        SUM(o.total_bill) AS total_revenue,
        ROW_NUMBER() OVER(PARTITION BY p.platform ORDER BY SUM(o.total_bill) DESC) AS rn
    FROM products p
    JOIN orders_data o ON p.product_id = o.product_id
    WHERE p.platform IN ('Meesho', 'Myntra')
    GROUP BY p.platform, p.product_name
)
SELECT platform, product_name, total_revenue
FROM ranked_products
WHERE rn <= 3;

CREATE VIEW meesho_exclusive_categories AS
SELECT DISTINCT product_category
FROM products
WHERE platform = 'Meesho'
AND product_category NOT IN (
    SELECT DISTINCT product_category
    FROM products
    WHERE platform = 'Myntra'
);

CREATE VIEW yearly_sales_by_platform AS
SELECT 
    DATEPART(YEAR, o.date) AS year,
    p.platform,
    SUM(o.total_bill) AS total_revenue
FROM orders_data o
JOIN products p ON o.product_id = p.product_id
WHERE p.platform IN ('Meesho', 'Myntra')
GROUP BY DATEPART(YEAR, o.date), p.platform;

SELECT * 
FROM yearly_sales_by_platform
ORDER BY year, platform;


CREATE VIEW top_3_cities_per_brand AS
WITH city_ranks AS (
    SELECT 
        c.city,
        p.platform,
        SUM(o.total_bill) AS total_revenue,
        ROW_NUMBER() OVER(PARTITION BY p.platform ORDER BY SUM(o.total_bill) DESC) AS rn
    FROM customers_data c
    JOIN orders_data o ON c.customer_id = o.customer_id
    JOIN products p ON o.product_id = p.product_id
    WHERE p.platform IN ('Meesho', 'Myntra')
    GROUP BY c.city, p.platform
)
SELECT city, platform, total_revenue
FROM city_ranks
WHERE rn <= 3;


CREATE VIEW bottom_3_states_per_brand AS
WITH state_ranks AS (
    SELECT 
        c.state,
        p.platform,
        SUM(o.total_bill) AS total_revenue,
        ROW_NUMBER() OVER(PARTITION BY p.platform ORDER BY SUM(o.total_bill) ASC) AS rn
    FROM customers_data c
    JOIN orders_data o ON c.customer_id = o.customer_id
    JOIN products p ON o.product_id = p.product_id
    WHERE p.platform IN ('Meesho', 'Myntra')
    GROUP BY c.state, p.platform
)
SELECT state, platform, total_revenue
FROM state_ranks
WHERE rn <= 3;

CREATE VIEW monthly_yearly_saless_trend AS
SELECT 
    p.platform,
    DATEPART(YEAR, o.date) AS year,
    DATEPART(MONTH, o.date) AS month,
    SUM(o.total_bill) AS total_revenue
FROM orders_data o
JOIN products p ON o.product_id = p.product_id
WHERE p.platform IN ('Meesho', 'Myntra')
GROUP BY p.platform, DATEPART(YEAR, o.date), DATEPART(MONTH, o.date);

CREATE VIEW weekend_sales_by_platform AS
SELECT 
    p.platform,
    SUM(o.total_bill) AS weekend_total_sales
FROM orders_data o
JOIN products p ON o.product_id = p.product_id
WHERE p.platform IN ('Meesho', 'Myntra')
AND DATEPART(dw, o.date) IN (1,7) -- Sunday=1, Saturday=7
GROUP BY p.platform;


CREATE VIEW repeat_customers_per_platform AS
SELECT 
    o.customer_id,
    p.platform,
    COUNT(*) AS order_count
FROM orders_data o
JOIN products p ON o.product_id = p.product_id
WHERE p.platform IN ('Meesho', 'Myntra')
GROUP BY o.customer_id, p.platform
HAVING COUNT(*) > 3;


CREATE VIEW total_repeat_orders_summary AS
SELECT 
    platform,
    SUM(order_count) AS total_repeat_orders
FROM repeat_customers_per_platform
GROUP BY platform;
