/*** SQL 2 Homework ***/


/** Part 1 Answer following questions **/

-- What is a result set?
	--Ans: a set of data returned by a database after executing a query.

-- What is the difference between Union and Union All?
	--Ans: UNION selects only distinct value wherreas UNION ALL allows duplicate values.

-- What are the other Set Operators SQL Server has?
	--Ans: except UNION and UNION ALL, INTERSECT and EXCEPT are also Set Operators.

-- What is the difference between Union and Join?
  --Ans: UNION is used to combined the result set of two or more  SELECT statement, whereas 
  --JOIN is used to combine rows from two or more tables

-- What is the difference between INNER JOIN and FULL JOIN?
	-- Ans: INNER JOIN is used to select the records that has matching value in both tables, 
	-- whereas FULL JOIN is used to select all records once it matches in left or right table.

-- What is difference between left join and outer join
	-- Ans: LEFT JOIN returns all records from the left table and the matching records from the right table
	-- Outer Join include Left join, right join and full join.

-- What is cross join?
	-- Ans: create a Cartesiasn product for two tables. It list all possible combination.

-- What is the difference between WHERE clause and HAVING clause?
	-- WHERE is used to filter recordsbefore groupin or aggregation, whereas HAVING is used to specify conditions on aggrregated data and grouping data.

-- Can there be multiple group by columns?
	--Ans: Yes. we can have mutiple columns in the GROUP BY clause.


/** Part 2 Write queries for following scenarios **/

/* Select master Database */
USE master
GO

/* Query 1
How many products can you find in the Products table?
*/
--SELECT COUNT(productID) FROM Products
SELECT COUNT(*) FROM Products

/* Query 2
Write a query that retrieves the number of products in the Products table that are out of stock. 
The rows that have 0 in column UnitsInStock are considered to be out of stock. 
*/
SELECT COUNT(*) 
FROM Products
Where UnitsInStock = 0

/* Query 3
How many Products reside in each Category? Write a query to display the results with the following titles.
CategoryID CountedProducts
---------- ---------------
*/
SELECT CategoryID, COUNT(ProductID) AS CountedProducts
FROM Products
GROUP BY CategoryID
/* Query 4
How many products that are not in category 6. 
*/
SELECT COUNT(ProductID)
FROM Products
Where CategoryID <> 6

/* Query 5
Write a query to list the sum of products UnitsInStock in Products table.
*/
SELECT SUM(UnitsInStock) 
FROM Products

/* Query 6 
Write a query to list the sum of products by category in the Products table 
and UnitPrice over 25 and limit the result to include just summarized quantities larger than 10.
CategoryID			TheSum
-----------        ----------
*/
SELECT CategoryID, SUM(UnitsInStock) AS TheSum
FROM Products
WHERE UnitPrice >25
GROUP BY CategoryID
HAVING SUM(UnitsInStock) > 10

/* Query 7
Write a query to list the sum of products with productID by category in the Products table 
and UnitPrice over 25 and limit the result to include just summarized quantities larger than 10.
ProductID  CategoryID	  TheSum
---------- -----------    -----------
*/
SELECT ProductID, CategoryID, SUM(UnitsInStock) AS TheSum
FROM Products
WHERE UnitPrice >25
GROUP BY ProductID, CategoryID
HAVING SUM(UnitsInStock) > 10


/* Query 8
Write the query to list the average UnitsInStock for products 
where column CategoryID has the value of 2 from the table Products.
*/

SELECT AVG(UnitsInStock)
FROM Products
WHERE CategoryID = 2

/* Query 9
Write query to see the average quantity of products by Category from the table Products.
CategoryID      TheAvg
----------    -----------
*/
SELECT CategoryID, AVG(UnitsInStock) AS TheAvg
FROM Products
GROUP BY CategoryID


/* Query 10
Write query  to see the average quantity  of  products by Category and product id
excluding rows that has the value of 1 in the column Discontinued from the table Products
ProductID   CategoryID   TheAvg
----------- ----------   -----------
*/
SELECT ProductID, CategoryID, AVG(UnitsInStock) AS TheAvg
FROM Products
WHERE Discontinued != 1
GROUP BY ProductID, CategoryID


/* Query 11
List the number of members (rows) and average UnitPrice in the Products table. 
This should be grouped independently over the SupplierID and the CategoryID column. Exclude the discountinued products (discountinue = 1)
SupplierID      CategoryID		TheCount   		AvgPrice
--------------	------------ 	----------- 	---------------------
*/
SELECT SupplierID, CategoryID, COUNT(*) AS theCount, AVG(UnitPrice) AS AvgPrice
FROM Products
WHERE Discontinued <> 1  
GROUP BY SupplierID, CategoryID

-- Joins
-- Using Northwnd Database: (Use aliases for all the Joins)
USE Northwind
GO

/* Query 12
Write a query that lists the Territories and Regions names from Territories and Region tables. 
Join them and produce a result set similar to the following. 
Territory           Region
---------         ----------------------
*/
SELECT t.TerritoryDescription AS Territory, r.RegionDescription AS Region
FROM Territories t
JOIN Region r
ON t.RegionID = r.RegionID


/* Query 13
Write a query that lists the Territories and Regions names from Territories and Region tables. 
and list the Territories filter them by Eastern and Northern. Join them and produce a result set similar to the following.
Territory           Region
---------     ----------------------
*/
SELECT t.TerritoryDescription AS Territory, r.RegionDescription AS Region
FROM Territories t
JOIN Region r
ON t.RegionID = r.RegionID
WHERE r.RegionDescription = 'Eastern' OR r.RegionDescription = 'Northern'


/* Query 14
List all Products that has been sold at least once in last 25 years.
*/
SELECT p.ProductID, p.ProductName
From Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -25,  GETDATE())

/* Query 15
List top 5 locations (Zip Code) where the products sold most.
*/
SELECT TOP 5 o.ShipPostalCode, SUM(od.quantity) AS TotalSale
FROM Orders o
JOIN [Order Details] od ON od.OrderID =  o.OrderID
GROUP BY o.ShipPostalCode
ORDER BY TotalSale DESC

/* Query 16
List top 5 locations (Zip Code) where the products sold most in last 25 years.
*/
SELECT TOP 5 o.ShipPostalCode, SUM(od.quantity) AS TotalSale
FROM Orders o
JOIN [Order Details] od ON od.OrderID =  o.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -25,  GETDATE())
GROUP BY o.ShipPostalCode
ORDER BY TotalSale DESC

/* Query 17
List all city names and number of customers in that city. 
*/

SELECT c.City, COUNT(c.CustomerID)
FROM Customers c
GROUP BY c.City


/* Query 18
List city names which have more than 2 customers, and number of customers in that city 
*/
SELECT c.City, COUNT(c.CustomerID)
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) > 2

/* Query 19
List the names of customers who placed orders after 1/1/98 with order date.
*/
SELECT DISTINCT c.CompanyName, o.OrderDate 
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >'1998-1-1'
ORDER BY o.OrderDate


/* Query 20 **
List the names of all customers with most recent order dates 
*/
--list each custonmer with their most recent order date
SELECT c.CompanyName, MAX(o.OrderDate) AS [Most Recent Date]
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
ORDER BY [Most Recent Date] DESC

--list customers who placed the order on the most recent date
SELECT c.CompanyName, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate = (SELECT MAX(OrderDate) FROM Orders)


/* Query 21
Display the names of all customers along with the count of products they bought
*/
--"count of products" in here: count of differenr products trhe customer purchased 
SELECT c.CompanyName, COUNT(DISTINCT od.ProductID) AS [Product Count]
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName

--"count of products" in here: total quantity of products the customer purchased
SELECT c.CompanyName, SUM(od.quantity) AS [Product Count]
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName

/* Query 22
Display the customer ids who bought more than 100 Products with count of products.
*/

-- Assume the "count of products" is the total quantity of products the customer purchased
SELECT c.CustomerID, SUM(od.quantity) AS [Product Count]
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING SUM(od.quantity) > 100


/* Query 23
List all of the possible ways that suppliers can ship their products. Display the results as below
Supplier Company Name   	Shipping Company Name
----------------------      ----------------------------------
*/
SELECT s.CompanyName AS [Supplier Company Name], sh.CompanyName AS [Shipping Company Name]
FROM Suppliers s CROSS JOIN Shippers sh

/* Query 24
Display the products order each day. Show Order date and Product Name.
*/
SELECT o.OrderDate, p.ProductName
FROM Orders o
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
LEFT JOIN Products p ON od.ProductID = p.ProductID
ORDER BY o.OrderDate
/*
SELECT o.OrderDate, p.ProductName
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
ORDER BY o.OrderDate
*/ 

/* Query 25
Displays pairs of employees who have the same job title.
*/
SELECT e1.FirstName + ' ' + e1.LastName AS [Employee Name 1], e2.FirstName + ' ' + e2.LastName AS [Employee Name 2]
FROM Employees e1
JOIN Employees e2 ON e1.Title = e2.Title AND e1.EmployeeID < e2.EmployeeID

/* Query 26
Display all the Managers who have more than 2 employees reporting to them.
*/
SELECT COUNT(e.EmployeeID) AS [Employee Count], m.FirstName + ' ' + m.LastName AS Manager
FROM Employees e 
INNER JOIN Employees m ON e.ReportsTo = m.EmployeeID
GROUP BY m.FirstName + ' ' + m.LastName
HAVING COUNT(e.EmployeeID) > 2

/* Query 27
Display the customers and suppliers by city. The results should have the following columns
City 
Name 
Contact Name,
Type (Customer or Supplier)
*/
SELECT City, CompanyName AS Name, ContactName AS [Contact Name], 'Customer' AS Type
FROM Customers
UNION ALL
SELECT City, CompanyName, ContactName, 'Supplier'
FROM Suppliers

/* Query 28
For example, you have two exactly the same tables T1 and T2 with two columns F1 and F2
	F1	F2
	--- ---
	1	2
	2	3
	3	4
Please write a query to inner join these two tables and write down the result of this query.
*/

SELECT  T1.F1 AS T1_F1, T1.F2 AS T1_F2, T2.F1 AS T2_F1, T2.F2 AS T2_F2
FROM T1
INNER JOIN T2 ON T1.F1 = T2.F1 AND T1.F2 = T2.F2

/*
Result: 
T1_F1	T1_F2  T2_F1  T2_F2
---		---  	--- 	---
1		2		1		2
2		3		2		3
3		4		3		4
*/

/* Query 29
Based on above two table, Please write a query to left outer join these two tables and write down the result of this query.
*/
SELECT  T1.F1 AS T1_F1, T1.F2 AS T1_F2, T2.F1 AS T2_F1, T2.F2 AS T2_F@
FROM T1
LEFT JOIN T2 ON T1.F1 = T2.F1 AND T1.F2 = T2.F2

/*
Result: 
T1_F1	T1_F2  T2_F1  T2_F2
---		---  	--- 	---
1		2		1		2
2		3		2		3
3		4		3		4
*/