--top_customers_by_spend
SELECT * FROM top_customers_by_spend ORDER BY total_spend DESC;

--age and platform wise revenue
SELECT * FROM age_brand_revenue ORDER BY total_revenue DESC;

--most_ordered_category_by_platform
SELECT * FROM most_ordered_category_by_platform;

--age_group wise revenue
SELECT * FROM age_group_revenue;

--top_3_products_per_platform
SELECT * FROM top_3_products_per_platform;

--exclusive categories per platform
SELECT * FROM meesho_exclusive_categories;

--yearly_sales_by_platform
SELECT * FROM yearly_sales_by_platform ORDER BY year, platform;

--top_3_cities_per_platform
SELECT * FROM top_3_cities_per_brand;

--bottom_3_cities_per_platform
SELECT * FROM bottom_3_states_per_brand;

--monthly_yearly_sales
SELECT * FROM monthly_yearly_sales_trend ORDER BY year, month, platform;

--weekend sales per platform
SELECT * FROM weekend_sales_by_platform ORDER BY weekend_total_sales DESC;

--repeated customers in each platform
SELECT * FROM repeat_customers_per_platform;

--total repeat orders
SELECT * FROM total_repeat_orders_summary ORDER BY total_repeat_orders DESC;