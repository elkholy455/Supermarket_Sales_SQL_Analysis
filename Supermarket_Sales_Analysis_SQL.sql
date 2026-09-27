/*
===========================================================
Supermarket Sales Analysis - SQL Project
Database: Supermarket Analysis
Table: [dbo].[supermarket _sales]
Tool: SQL Server / SSMS
===========================================================
*/

USE [SUPERMARKET_ANALYSIS];
GO

-- 1. BASIC KPIs
SELECT COUNT(*) AS Total_Transactions FROM [dbo].[supermarket_sales];
SELECT SUM(Total) AS Total_Sales FROM [dbo].[supermarket_sales];
SELECT SUM(Quantity) AS Total_Quantity FROM [dbo].[supermarket_sales];
SELECT AVG(Total) AS Average_Order_Value FROM [dbo].[supermarket_sales];

-- 2. SALES ANALYSIS
SELECT City, SUM(Total) AS Total_Sales
FROM [dbo].[supermarket_sales]
GROUP BY City ORDER BY Total_Sales DESC;

SELECT Branch, SUM(Total) AS Total_Sales
FROM [dbo].[supermarket_sales]
GROUP BY Branch ORDER BY Total_Sales DESC;

SELECT [Product_line], SUM(Total) AS Total_Sales
FROM [dbo].[supermarket_sales]
GROUP BY [Product_line] ORDER BY Total_Sales DESC;

SELECT Branch, [Product_line], SUM(Quantity) AS Total_Quantity,
       SUM(Total) AS Total_Sales, AVG(Total) AS Average_Sales
FROM [dbo].[supermarket_sales]
GROUP BY Branch, [Product_line]
ORDER BY Branch, Total_Sales DESC;

-- 3. PRODUCT ANALYSIS
SELECT [Product_line], COUNT(*) AS Total_Transactions,
       SUM(Quantity) AS Total_Quantity, SUM(Total) AS Total_Sales,
       AVG(Total) AS Average_Sales
FROM [dbo].[supermarket_sales]
GROUP BY [Product_line] ORDER BY Total_Sales DESC;

SELECT [Product_line], AVG(Rating) AS Average_Rating
FROM [dbo].[supermarket_sales]
GROUP BY [Product_line] ORDER BY Average_Rating DESC;

-- 4. CUSTOMER ANALYSIS
SELECT [Customer_type], COUNT(*) AS Total_Transactions,
       SUM(Total) AS Total_Sales, AVG(Total) AS Average_Order_Value,
       SUM(Quantity) AS Total_Quantity
FROM [dbo].[supermarket_sales]
GROUP BY [Customer_type] ORDER BY Total_Sales DESC;

SELECT Branch, [Customer_type], COUNT(*) AS Total_Transactions,
       SUM(Total) AS Total_Sales, AVG(Total) AS Average_Order_Value
FROM [dbo].[supermarket_sales]
GROUP BY Branch, [Customer_type]
ORDER BY Branch, Total_Sales DESC;

SELECT [Customer_type], Gender, COUNT(*) AS Total_Transactions,
       SUM(Total) AS Total_Sales, AVG(Total) AS Average_Order_Value
FROM [dbo].[supermarket_sales]
GROUP BY [Customer_type], Gender
ORDER BY [Customer_type], Total_Sales DESC;

-- 5. PAYMENT ANALYSIS
SELECT Payment, COUNT(*) AS Total_Transactions,
       SUM(Total) AS Total_Sales, AVG(Total) AS Average_Order_Value
FROM [dbo].[supermarket_sales]
GROUP BY Payment ORDER BY Total_Sales DESC;

SELECT MONTH(Date) AS Month_Number, DATENAME(MONTH, Date) AS Month_Name,
       Payment, COUNT(*) AS Total_Transactions, SUM(Total) AS Total_Sales
FROM [dbo].[supermarket_sales]
GROUP BY MONTH(Date), DATENAME(MONTH, Date), Payment
ORDER BY Month_Number, Total_Sales DESC;

-- 6. TIME ANALYSIS
SELECT MONTH(Date) AS Month_Number, DATENAME(MONTH, Date) AS Month_Name,
       COUNT(*) AS Total_Transactions, SUM(Total) AS Total_Sales
FROM [dbo].[supermarket_sales]
GROUP BY MONTH(Date), DATENAME(MONTH, Date)
ORDER BY Month_Number;

-- 7. SALES CLASSIFICATION
SELECT CASE WHEN Total < 200 THEN 'Low'
            WHEN Total < 500 THEN 'Medium'
            ELSE 'High' END AS Sale_Category,
       COUNT(*) AS Total_Transactions, SUM(Total) AS Total_Sales
FROM [dbo].[supermarket_sales]
GROUP BY CASE WHEN Total < 200 THEN 'Low'
              WHEN Total < 500 THEN 'Medium'
              ELSE 'High' END
ORDER BY Total_Sales DESC;

-- 8. TOP TRANSACTIONS
SELECT TOP 5 [Invoice_ID], Branch, City, [Product_line], Total, Quantity, Payment
FROM [dbo].[supermarket_sales]
ORDER BY Total DESC;

-- 9. ADVANCED SQL - RANK()
SELECT Branch, [Product_line], SUM(Total) AS Total_Sales,
       RANK() OVER (PARTITION BY Branch ORDER BY SUM(Total) DESC) AS Product_Rank
FROM [dbo].[supermarket_sales]
GROUP BY Branch, [Product_line]
ORDER BY Branch, Product_Rank;

-- 10. ADVANCED SQL - ROW_NUMBER()
SELECT Branch, [Product_line], SUM(Total) AS Total_Sales,
       ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY SUM(Total) DESC) AS Row_Num
FROM [dbo].[supermarket_sales]
GROUP BY Branch, [Product_line]
ORDER BY Branch, Row_Num;

-- 11. CTE - TOP PRODUCT LINE PER BRANCH
WITH ProductSales AS
(
    SELECT Branch, [Product_line], SUM(Total) AS Total_Sales,
           ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY SUM(Total) DESC) AS Row_Num
    FROM [dbo].[supermarket_sales]
    GROUP BY Branch, [Product_line]
)
SELECT Branch, [Product_line], Total_Sales
FROM ProductSales
WHERE Row_Num = 1
ORDER BY Branch;

-- 12. CTE - TOP 3 TRANSACTIONS PER BRANCH
WITH RankedSales AS
(
    SELECT Branch, [Invoice_ID], [Product_line], Total,
           ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY Total DESC) AS Sale_Rank
    FROM [dbo].[supermarket_sales]
)
SELECT Branch, [Invoice_ID], [Product_line], Total, Sale_Rank
FROM RankedSales
WHERE Sale_Rank <= 3
ORDER BY Branch, Sale_Rank;

/*
PROJECT SUMMARY
Business Areas:
- Overall Sales KPIs
- City and Branch Performance
- Product Line Performance
- Customer Type and Gender Analysis
- Payment Method Analysis
- Monthly Sales Trends
- Transaction Classification
- Top Transactions
- Advanced SQL Window Functions and CTEs

SQL Skills:
SELECT, GROUP BY, ORDER BY, Aggregate Functions, CASE WHEN,
DATENAME, MONTH, RANK, ROW_NUMBER, PARTITION BY, CTEs
*/
