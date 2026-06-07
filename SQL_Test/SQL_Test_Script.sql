-- Q1. List top 5 customers by total order amount.
-- Retrieve the top 5 customers who have spent the most across all sales orders. Show CustomerID,
-- CustomerName, and TotalSpent.

SELECT TOP 5
	cust.CustomerID,
	Name,
	SUM(TotalAmount) TotalSpent
FROM Customer cust
JOIN SalesOrder ord
ON cust.CustomerID = ord.CustomerID
GROUP BY cust.CustomerID,Name
ORDER BY TotalSpent DESC;

-- Q2. Find the number of products supplied by each supplier.
-- Display SupplierID, SupplierName, and ProductCount. Only include suppliers that have more than 10
-- products.

SELECT 
	sup.SupplierID,
	Name,
	COUNT(Quantity) Product_Count
FROM Supplier sup
JOIN PurchaseOrder pur_order
ON sup.SupplierID = pur_order.SupplierID
JOIN SalesOrderDetail ord_detail
ON pur_order.OrderID = ord_detail.OrderID
GROUP BY sup.SupplierID,Name
HAVING COUNT(Quantity) > 10;

-- Q3. Identify products that have been ordered but never returned.
-- Show ProductID, ProductName, and total order quantity.
-- product,returndetail,returns

SELECT TOP 5 * FROM product;
SELECT TOP 5 * FROM returndetail;
SELECT TOP 5 * FROM returns;

SELECT 
	prod.ProductID,
	Name,
	SUM(Quantity) Total_Quantity
FROM product prod
JOIN SalesOrderDetail ord_detail
ON prod.ProductID = ord_detail.ProductID
WHERE NOT EXISTS (
SELECT 1 
FROM ReturnDetail ret_detail
WHERE ret_detail.ProductID = prod.ProductID
)
GROUP BY prod.ProductID,Name;

-- Q4. For each category, find the most expensive product.
-- Display CategoryID, CategoryName, ProductName, and Price. Use a subquery to get the max price
-- per category.

SELECT 
	cat.CategoryID,
	prod.Name ProductName,
	cat.Name CategoryName,
	Price
FROM Product prod
JOIN Category cat
ON prod.CategoryID = cat.CategoryID
WHERE prod.price = (
SELECT MAX(price) Max_Price
FROM Product prod2
WHERE prod2.CategoryID = cat.CategoryID
)
ORDER BY cat.CategoryID;

-- Q5. List all sales orders with customer name, product name, category, and supplier.
-- For each sales order, display:
-- OrderID, CustomerName, ProductName, CategoryName, SupplierName, and Quantity.

SELECT 
	so.OrderID,
	cust.Name CustomerName,
	prod.Name ProdName,
	cat.Name CategoryName,
	sup.Name SupplierName,
	so_detail.Quantity
FROM SalesOrder so
JOIN SalesOrderDetail so_detail
ON so.OrderID = so_detail.OrderID
JOIN Customer cust
ON so.CustomerID = cust.CustomerID
JOIN Product prod
ON so_detail.ProductID = prod.ProductID
JOIN Category cat
ON cat.CategoryID = prod.CategoryID
JOIN PurchaseOrder pur_order
ON pur_order.OrderID = so.OrderID
JOIN Supplier sup
ON sup.SupplierID = pur_order.SupplierID;

-- Q6. Find all shipments with details of warehouse, manager, and products shipped.
-- Display:
-- ShipmentID, WarehouseName, ManagerName, ProductName, QuantityShipped, and
-- TrackingNumber.




-- Q7. Find the top 3 highest-value orders per customer using RANK(). Display CustomerID,
-- CustomerName, OrderID, and TotalAmount.

WITH RawData AS (
SELECT 
	cust.CustomerID,
	cust.Name CustomerName,
	so.OrderID,
	SUM(TotalAmount) TotalAmount
FROM Customer cust
JOIN SalesOrder so
ON cust.CustomerID = so.CustomerID
GROUP BY cust.CustomerID,Name,so.OrderID
),
RankingCustomers AS (
SELECT 
	*,
	RANK() OVER(PARTITION BY CustomerID ORDER BY TotalAmount DESC) Ranking
FROM RawData
),
Top_3_Customers AS (
SELECT *
FROM RankingCustomers
WHERE Ranking < 4
)
SELECT 
	CustomerID,
	CustomerName,
	OrderID,
	TotalAmount
FROM Top_3_Customers;

-- Q8. For each product, show its sales history with the previous and next sales quantities (based on
-- order date). Display ProductID, ProductName, OrderID, OrderDate, Quantity, PrevQuantity, and
-- NextQuantity.

-- Q9. Create a view named vw_CustomerOrderSummary that shows for each customer:
-- CustomerID, CustomerName, TotalOrders, TotalAmountSpent, and LastOrderDate.

-- Q10. Write a stored procedure sp_GetSupplierSales that takes a SupplierID as input and returns the
-- total sales amount for all products supplied by that supplier.

CREATE OR ALTER PROCEDURE sp_GetSupplierSales @SupplierID INT
AS 
BEGIN
SELECT 
	sup.SupplierID,
	SUM(so_det_order.TotalAmount) Total_Sales_Amount
FROM Supplier sup
JOIN PurchaseOrder pur_order
ON sup.SupplierID = pur_order.SupplierID
JOIN PurchaseOrderDetail pur_ord_detail
ON pur_ord_detail.OrderID = pur_order.OrderID
JOIN product prod
ON prod.ProductID = pur_ord_detail.ProductID
JOIN SalesOrderDetail so_det_order
ON so_det_order.ProductID = prod.ProductID
WHERE sup.SupplierID = @SupplierID
GROUP BY sup.SupplierID
END

EXEC sp_GetSupplierSales 4;
