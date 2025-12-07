use DATAB
select * from Procurement_DA
alter table procurement_DA
add Delay_Days INT;
update procurement_DA
SET Delay_days = DATEDIFF(DAY,Order_Date,Delivery_Date);

alter table procurement_DA
add Cost_Savings Decimal(10,2)
update procurement_DA
SET Cost_Savings = Unit_Price-Negotiated_Price

alter table Procurement_DA
add ON_TIME int
update procurement_DA
SET On_Time =CASE
  WHEN Delay_days<=0 and order_status='Delivered' then 1
  else 0
  end;
 

 CREATE TABLE dim_supplier (
    SupplierID INT IDENTITY PRIMARY KEY,
    Supplier VARCHAR(255));
INSERT INTO dim_supplier (Supplier)
SELECT DISTINCT Supplier
FROM Procurement_DA;

CREATE TABLE dim_item (
    ItemID INT IDENTITY PRIMARY KEY,
    Item_Category VARCHAR(255));
INSERT INTO dim_item (Item_Category)
SELECT DISTINCT Item_Category
FROM Procurement_DA;

CREATE TABLE dim_status (StatusID INT IDENTITY PRIMARY KEY,
 Order_Status VARCHAR(50));
INSERT INTO dim_status (Order_Status)
SELECT DISTINCT Order_Status
FROM procurement_DA;

CREATE TABLE dim_date (
    DateID INT IDENTITY PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Month INT,
    Day INT);
INSERT INTO dim_date (FullDate, Year, Month, Day)
SELECT DISTINCT 
    d.DateValue,
    YEAR(d.DateValue),
    MONTH(d.DateValue),
    DAY(d.DateValue)
FROM (
SELECT Order_Date AS DateValue FROM Procurement_DA
    UNION
    SELECT Delivery_Date FROM Procurement_DA
) d
WHERE d.DateValue IS NOT NULL;


CREATE TABLE fact_procurement (
    PO_ID VARCHAR(50),
    SupplierID INT,
    ItemID INT,
    OrderDateID INT,
    DeliveryDateID INT,
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    Negotiated_Price DECIMAL(10,2),
    Defective_Units INT,
    Compliance VARCHAR(50),
    Delay_Days INT,
    On_Time INT,

    FOREIGN KEY (SupplierID) REFERENCES dim_supplier(SupplierID),
    FOREIGN KEY (ItemID) REFERENCES dim_item(ItemID),
    FOREIGN KEY (OrderDateID) REFERENCES dim_date(DateID),
    FOREIGN KEY (DeliveryDateID) REFERENCES dim_date(DateID));

    INSERT INTO fact_procurement (
    PO_ID, SupplierID, ItemID, OrderDateID, DeliveryDateID,
    Quantity, Unit_Price, Negotiated_Price,
    Defective_Units, Compliance, Delay_Days, On_Time
)
SELECT 
    p.PO_ID,
    s.SupplierID,
    i.ItemID,
    od.DateID,
    dd.DateID,
    p.Quantity,
    p.Unit_Price,
    p.Negotiated_Price,
    p.Defective_Units,
    p.Compliance,
    p.Delay_Days,
    p.On_Time

FROM Procurement_DA p

JOIN dim_supplier s 
    ON p.Supplier = s.Supplier

JOIN dim_item i 
    ON p.Item_Category = i.Item_Category

LEFT JOIN dim_date od 
    ON p.Order_Date = od.FullDate

LEFT JOIN dim_date dd
    ON p.Delivery_Date = dd.FullDate;

SELECT * FROM dim_supplier;
SELECT * FROM dim_item;
SELECT * FROM dim_date;
SELECT * FROM dim_status;

select top 20 * from fact_procurement

