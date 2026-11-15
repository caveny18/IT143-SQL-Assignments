/*
    IT 143 - W3.4
    AdventureWorks 2022 - Questions and Answers
    Student: Carlos Ruiz
    Database: AdventureWorks2022 (OLTP)
    File: EC_IT143_W3.4_cr.sql

    Purpose: Answer eight business-user and metadata questions using SQL.
    Runtime estimate: Queries are expected to complete in seconds on a local
    AdventureWorks2022 installation. Actual runtime depends on the environment.
    All queries are read-only.
*/

USE AdventureWorks2022;
GO

/* QUESTION 1
   Category: Business User - Marginal Complexity
   Original Author: Jose Valderrama Almanza
   Question: What are our ten most expensive products based on list price?
   Estimated Runtime: Less than 1 second
*/
SELECT TOP (10)
    ProductID,
    Name AS ProductName,
    ListPrice
FROM Production.Product
ORDER BY ListPrice DESC, Name;
GO

/* QUESTION 2
   Category: Business User - Marginal Complexity
   Original Author: Dmytro Ivanytskyi
   Question: What is the total number of products that have a color of 'Black'?
   Estimated Runtime: Less than 1 second
*/
SELECT
    COUNT(*) AS BlackProductCount
FROM Production.Product
WHERE Color = 'Black';
GO

/* QUESTION 3
   Category: Business User - Moderate Complexity
   Original Author: Elie Flaurice Dieudonne
   Question: Which product subcategories contain the greatest number of products?
   Show each subcategory name and its product count, including only subcategories
   that have at least one product.
   Estimated Runtime: Less than 1 second
*/
SELECT
    psc.ProductSubcategoryID,
    psc.Name AS SubcategoryName,
    COUNT(p.ProductID) AS ProductCount
FROM Production.ProductSubcategory AS psc
INNER JOIN Production.Product AS p
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
GROUP BY
    psc.ProductSubcategoryID,
    psc.Name
HAVING COUNT(p.ProductID) > 0
ORDER BY
    ProductCount DESC,
    psc.Name;
GO

/* QUESTION 4
   Category: Business User - Moderate Complexity
   Original Author: John Allotey
   Question: Which bicycle product subcategories made the most money in 2013?
   Estimated Runtime: Less than 2 seconds
*/
SELECT
    psc.Name AS ProductSubcategory,
    SUM(sod.LineTotal) AS TotalSalesRevenue
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
    ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS p
    ON p.ProductID = sod.ProductID
INNER JOIN Production.ProductSubcategory AS psc
    ON psc.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
    ON pc.ProductCategoryID = psc.ProductCategoryID
WHERE
    pc.Name = 'Bikes'
    AND soh.OrderDate >= '20130101'
    AND soh.OrderDate < '20140101'
GROUP BY
    psc.Name
ORDER BY
    TotalSalesRevenue DESC;
GO

/* QUESTION 5
   Category: Business User - Increased Complexity
   Original Author: Elie Flaurice Dieudonne
   Question: Prepare a monthly 2013 sales report for the Bikes category,
   including product subcategory, total quantity sold, and total sales amount.
   Estimated Runtime: Less than 2 seconds
*/
SELECT
    YEAR(soh.OrderDate) AS SalesYear,
    MONTH(soh.OrderDate) AS SalesMonth,
    psc.Name AS ProductSubcategory,
    SUM(sod.OrderQty) AS TotalQuantitySold,
    SUM(sod.LineTotal) AS TotalSalesAmount
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
    ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS p
    ON p.ProductID = sod.ProductID
INNER JOIN Production.ProductSubcategory AS psc
    ON psc.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
    ON pc.ProductCategoryID = psc.ProductCategoryID
WHERE
    pc.Name = 'Bikes'
    AND soh.OrderDate >= '20130101'
    AND soh.OrderDate < '20140101'
GROUP BY
    YEAR(soh.OrderDate),
    MONTH(soh.OrderDate),
    psc.Name
ORDER BY
    SalesMonth,
    psc.Name;
GO

/* QUESTION 6
   Category: Business User - Increased Complexity
   Original Author: Jonathan Obodai Squire
   Question: Who was the salesperson who generated the highest total sales
   revenue in 2013? Please provide their full name.
   Note: SubTotal is used as revenue, excluding tax and freight.
   Estimated Runtime: Less than 2 seconds
*/
SELECT TOP (1)
    sp.BusinessEntityID AS SalesPersonID,
    CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName,
    SUM(soh.SubTotal) AS TotalSalesRevenue
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesPerson AS sp
    ON sp.BusinessEntityID = soh.SalesPersonID
INNER JOIN Person.Person AS p
    ON p.BusinessEntityID = sp.BusinessEntityID
WHERE
    soh.OrderDate >= '20130101'
    AND soh.OrderDate < '20140101'
GROUP BY
    sp.BusinessEntityID,
    p.FirstName,
    p.LastName
ORDER BY
    TotalSalesRevenue DESC;
GO

/* QUESTION 7
   Category: Metadata
   Original Author: Elie Flaurice Dieudonne
   Question: List all base tables available in AdventureWorks, including
   their schema names, using INFORMATION_SCHEMA.TABLES.
   Estimated Runtime: Less than 1 second
*/
SELECT
    TABLE_SCHEMA AS SchemaName,
    TABLE_NAME AS TableName
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;
GO

/* QUESTION 8
   Category: Metadata
   Original Author: Dmytro Ivanytskyi
   Question: Which tables contain a column named ModifiedDate according
   to the information schema?
   Estimated Runtime: Less than 1 second
*/
SELECT
    TABLE_SCHEMA AS SchemaName,
    TABLE_NAME AS TableName,
    COLUMN_NAME AS ColumnName,
    DATA_TYPE AS DataType
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'ModifiedDate'
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;
GO
