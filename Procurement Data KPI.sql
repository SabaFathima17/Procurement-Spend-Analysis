use DATAB
------KPI QUERIES--------
select * from Procurement_DA
------Total Spend Per Supplier-------
SELECT Supplier,
       CAST(SUM(Negotiated_Price * Quantity)AS DECIMAL(10,2)) AS Total_Spend
FROM Procurement_DA
GROUP BY Supplier
ORDER BY Total_Spend DESC;

-------Average Delivery Delay------
SELECT Supplier,
       AVG(Delay_Days) AS Avg_Delay
FROM Procurement_DA
GROUP BY Supplier;

------Defect Rate--------
SELECT Supplier,
       CAST(SUM(Defective_Units)*1.0 / SUM(Quantity)AS DECIMAL(10,2))AS Defect_Rate
FROM Procurement_DA
GROUP BY Supplier;

------Compliance Count----
SELECT Compliance, COUNT(*) AS Compliance_count
FROM Procurement_DA
GROUP BY Compliance;

------Top 10 Purchase Order-------
SELECT TOP 10 PO_ID, CAST((Negotiated_Price * Quantity)/10 AS DECIMAL(10,1))AS PO_Value
FROM Procurement_DA
ORDER BY PO_Value DESC;

------ORDERS AT RISK------
SELECT PO_id, Order_status
FROM Procurement_DA
WHERE Order_Status IN ('Pending','Cancelled');

--------Supplier Risk Score-----
SELECT Supplier,
       CAST(((SUM(Defective_Units)*1.0 / SUM(Quantity))*0.5
        + (1 - AVG(CAST(On_Time AS FLOAT)))*0.3
        + (AVG(Delay_Days)/30)*0.2) AS DECIMAL(10,2))AS Risk_Score
FROM Procurement_DA
GROUP BY Supplier
ORDER BY Risk_Score DESC;

------AVG NEGOTIATED PRICE BY CATEGORY-------
SELECT Item_Category,
       CAST(AVG(Negotiated_Price) AS DECIMAL(10,2))AS Avg_Negotiated_Price
FROM Procurement_DA
GROUP BY Item_Category
ORDER BY Avg_Negotiated_Price DESC;

----------AVG SAVINGS BY CATEGORY-----
SELECT Item_Category,
CAST(AVG(Unit_Price - Negotiated_Price) AS DECIMAL(10,2)) AS Avg_Savings
FROM Procurement_DA
GROUP BY Item_Category
ORDER BY Avg_Savings DESC;

-------TOTAL COST SAVINGS----------
SELECT 
    CAST(SUM(Unit_Price - Negotiated_Price)AS DECIMAL(10,2)) AS Total_Savings
FROM Procurement_DA;

-------ON TIME DELIVERY---------
SELECT Supplier,
    CAST(AVG(On_Time)*100 AS DECIMAL(10,2)) AS On_Time_Delivery_Percentage
FROM Procurement_DA
GROUP BY Supplier;

-----SPEND PER ITEM CATEGORY------
SELECT  Item_Category,
CAST(SUM(Negotiated_Price * Quantity)AS DECIMAL(10,2)) AS Category_Spend
FROM Procurement_DA
GROUP BY Item_Category
ORDER BY Category_Spend DESC;

------FREQUENTLY ORDERED ITEM CATEGORY--------
SELECT Item_Category,COUNT(*) AS Order_Count
FROM Procurement_DA
GROUP BY Item_Category
ORDER BY Order_Count DESC;



