-- ============================================================
--  ASSIGNMENT 02 — Joins
--  Database : BikeStores
-- ============================================================
USE BikeStores;

-- ============================================================
--  Question 1
--  Retrieve the product_name, list_price, and category_name
--  for every product.
--  Use production.products and production.categories.
--  Sort the results by product_name ascending.
-- ============================================================

-- Write your query below:
SELECT 
	product_name,
	list_price,
	category_name
FROM production.products prd
LEFT JOIN production.categories cat
ON prd.category_id = cat.category_id
ORDER BY product_name;


-- ============================================================
--  Question 2
--  Show the customer full name (as full_name), order_id,
--  and order_date for all customers who have placed an order.
--  Use sales.customers and sales.orders.
--  Sort by order_date descending.
-- ============================================================

-- Write your query below:
SELECT 
	cst.first_name + ' ' + cst.last_name  Full_Name,
	ord.order_id,
	ord.order_date
FROM sales.customers cst
JOIN sales.orders ord
ON cst.customer_id = ord.customer_id
ORDER BY ord.order_date DESC;

-- ============================================================
--  Question 3
--  Retrieve product_name, list_price, category_name, and
--  brand_name for every product.
--  Use production.products, production.categories,
--  and production.brands.
--  Sort by brand_name then product_name (both ascending).
-- ============================================================

-- Write your query below:
SELECT 
	product_name,
	list_price,
	category_name,
	brand_name
FROM production.products prd
LEFT JOIN production.categories cat
ON prd.category_id = cat.category_id
LEFT JOIN  production.brands brnd
ON prd.brand_id = brnd.brand_id
ORDER BY brand_name,product_name;

-- ============================================================
--  Question 4
--  List all products along with their order_id and item_id.
--  Make sure products that have NEVER been ordered also appear
--  in the result (those rows will have NULL for order_id
--  and item_id).
--  Use production.products and sales.order_items.
--  Sort by order_id ascending.
-- ============================================================

-- Write your query below:
SELECT 
	prd.product_id,
	product_name,
	order_id,
	item_id
FROM production.products prd
LEFT JOIN sales.order_items ord_it
ON prd.product_id = ord_it.product_id
ORDER BY ord_it.order_id;

-- ============================================================
--  Question 5
--  Using your answer from Question 4 as a base, filter the
--  results to show ONLY the products that have never been
--  ordered.
--  Display only product_id and product_name.
-- ============================================================

-- Write your query below:
SELECT 
	prd.product_id,
	product_name
FROM production.products prd
LEFT JOIN sales.order_items ord_it
ON prd.product_id = ord_it.product_id
WHERE order_id IS NULL AND item_id IS NULL
ORDER BY ord_it.order_id;

-- ============================================================
--  Question 6
--  Show all stores along with any orders placed at each store.
--  Display store_name, store_id (from stores), order_id,
--  and order_date.
--  Every store must appear in the result, even if it has
--  no orders yet.
--  Use sales.orders and sales.stores.
-- ============================================================

-- Write your query below:
SELECT 
	st.store_id,
	store_name,
	order_id,
	order_date
FROM sales.stores st
LEFT JOIN sales.orders ord
ON st.store_id = ord.store_id;


-- ============================================================
--  Question 7
--  List every staff member alongside their manager's name.
--  Display:
--    • staff full name   (as staff_name)
--    • manager full name (as manager_name)
--  Use only the sales.staffs table.
--  Staff who have no manager should NOT appear in the result.
-- ============================================================

-- Write your query below:
SELECT 
	stf.first_name + ' ' + stf.last_name as Staff_FullName,
	mng.first_name + ' ' + mng.last_name as Mng_FullName
FROM sales.staffs stf
JOIN sales.staffs mng
ON stf.manager_id = mng.staff_id;

-- ============================================================
--  Question 8
--  Generate every possible combination of store name and
--  brand name.
--  Display store_name and brand_name.
--  Use sales.stores and production.brands.
--  How many total rows do you expect?
--  Write the expected count as a comment next to your query.
-- ============================================================

-- Write your query below:
SELECT 
	store_name,
	brand_name
FROM sales.stores str
CROSS JOIN production.brands brnd;
-- 3 * 9 = 27 rows

-- ============================================================
--  Question 9
--  Retrieve the customer full name (as full_name), order_id,
--  order_date, product_name, and list_price for every order
--  that has been placed.
--  Use sales.customers, sales.orders, sales.order_items,
--  and production.products.
--  Sort by order_date ascending, then full_name ascending.
-- ============================================================

-- Write your query below:
SELECT 
	cst.first_name + ' ' + cst.last_name Cst_FullName,
	ord.order_id,
	ord.order_date,
	product_name,
	prd.list_price
FROM sales.customers cst
JOIN sales.orders ord
ON cst.customer_id = ord.customer_id
JOIN sales.order_items ord_it
ON ord.order_id = ord_it.order_id
JOIN production.products prd
ON ord_it.product_id = prd.product_id
ORDER BY ord.order_date,Cst_FullName;
