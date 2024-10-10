------------------------------Online Retail Dataset--------------------------------
---------------------------VIEWING OUR FULL DATASET--------------------------------
select * from "Year 2009-2010";

-------------------------REMOVE NULL VALUES----------------------------------------
delete from "Year 2009-2010"
where Invoice IS NULL;

----------------ADDITIONAL COLUMN FOR AGGREGATE FUNCTION CALCULATIONS--------------

alter table "Year 2009-2010"
add Total_Price as Price * Quantity persisted;

alter table "Year 2010-20"
add Total_Price as Price * Quantity persisted;

-------------------------TOTAL SALES FOR EACH CUSTOMER------------------------------

select [Customer ID], SUM(Total_Price) as total_customer_sales from "Year 2009-2010"
group by [Customer ID]
order by [Customer ID];

select [Customer ID], SUM(Total_Price) as total_customer_sales from "Year 2010-2011"
group by [Customer ID]
order by [Customer ID];

------------------------SALES OF INDIVIDUAL PRODUCTS PER COUNTRY------------------

select  distinct Description, SUM(Total_Price) as Sum_of_Product,  Country from "Year 2009-2010"
group by Country,Description
order by Sum_of_Product, Country;

select  distinct Description, SUM(Total_Price) as Sum_of_Product,  Country from "Year 2010-2011"
group by Country,Description
order by Sum_of_Product, Country;

---------------------------TOTAL SALES OF PRODUCTS BY YEAR------------------------

select  Description, SUM(Total_Price) as "Total Product Sales" from "Year 2009-2010"
where Total_Price > 0
group by Description
order by "Total Product Sales";

select  Description, SUM(Total_Price) as "Total Product Sales" from "Year 2010-2011"
where Total_Price > 0
group by Description
order by "Total Product Sales"; 

---------------------------BEST SELLING PRODUCTS------------------------------------
select StockCode, Description, SUM(Quantity) AS TotalQuantitySold, SUM(Total_Price) as TotalQuantityPrice from "Year 2009-2010"
where Quantity > 0
group by StockCode, Description
order by TotalQuantitySold;

select StockCode, Description, SUM(Quantity) AS TotalQuantitySold, SUM(Total_Price) as TotalQuantityPrice from "Year 2010-2011"
where Quantity > 0
group by StockCode, Description
order by TotalQuantitySold;

--------------------------------TOTAL SALES BY COUNTRY------------------------------

select distinct Country, SUM(CAST(Total_Price as decimal(18,2))) as total_sales_per_country from "Year 2009-2010"
group by Country
order by total_sales_per_country asc;

select distinct Country, SUM(CAST(Total_Price as decimal(18,2))) as total_sales_per_country from "Year 2010-2011"
group by Country
order by total_sales_per_country asc;

------------------HIGHEST SELLING PRODUCT AND COUNTRY PER PERIOD--------------------


select Description,Country,SUM(Total_Price) as Total from "Year 2009-2010"
where Total_Price = (select MAX(Total_Price)
from "Year 2010-2011"
where country = "Year 2009-2010".Country)
group by Description, Country
order by Country,Description desc;

select Description,Country,SUM(Total_Price) as Total from "Year 2010-2011"
where Total_Price = (select MAX(Total_Price)
from "Year 2010-2011"
where country = "Year 2010-2011".Country)
group by Description, Country
order by Country,Description desc;

------------------------------TOTAL SALES PER CUSTOMER-------------------------------
--Debtors
select [Customer ID],SUM(Total_Price) AS total_sales_per_customer from "Year 2009-2010"
where Total_Price > 0
group by [Customer ID]
order by total_sales_per_customer;

select [Customer ID],SUM(Total_Price) AS total_sales_per_customer from "Year 2010-2011"
where Total_Price > 0
group by [Customer ID]
order by total_sales_per_customer;

--Creditors
select [Customer ID],SUM(Total_Price) AS total_sales_per_customer from "Year 2009-2010"
where Total_Price < 0
group by [Customer ID]
order by total_sales_per_customer;

select [Customer ID],SUM(Total_Price) AS total_sales_per_customer from "Year 2010-2011"
where Total_Price < 0
group by [Customer ID]
order by total_sales_per_customer;



-----------------------------DATE WITH THE HIGHEST SALES----------------------------
select CAST(InvoiceDate as date), Sum(Total_Price) as Day_Sale from "Year 2009-2010"
where Total_Price = (select MAX(Total_Price)from "Year 2009-2010")
group by InvoiceDate;

select CAST(InvoiceDate as date), Sum(Total_Price) as Day_Sale from "Year 2010-2011"
where Total_Price = (select MAX(Total_Price)from "Year 2010-2011")
group by InvoiceDate;


------------------------------------JOINS-------------------------------------------
------------------------TOTAL CUSTOMER SALES PER FINANCIAL PERIOD-------------------
select Y1.[Customer ID],
	sum(CAST(Y1.Total_Price as Decimal(18,2))) as TotalSales_Table1,
    sum(CAST(Y1.Total_Price as Decimal(18,2))) as TotalPrice_Table2
from "Year 2009-2010" Y1
FULL OUTER JOIN "Year 2010-2011" Y2
on Y1.[Customer ID] = Y2.[Customer ID]
group by Y1.[Customer ID], Y2.[Customer ID];

--------------------------TOTAL PRODUCT SALES PER FINANCIAL PERIOD-----------------

select Y1.Description, SUM(CAST(Y1.Total_Price as Decimal(18,2))) AS TotalPrice_Table1, SUM(CAST(Y1.Total_Price as Decimal(18,2))) AS TotalPrice_Table2
from "Year 2009-2010" Y1
JOIN "Year 2010-2011" Y2
on Y1.Description = Y2.Description
group by Y1.Description;

----------------------BEST SELLING PRODUCT BETWEEN FINANCIAL PERIODS---------------

select COALESCE(TRIM(Y1.StockCode), TRIM(Y2.StockCode)) AS StockCode, COALESCE(Y1.Description, Y2.Description) AS Description, SUM(Y1.Quantity) + SUM(Y2.Quantity) AS TotalQuantitySold
from  "Year 2009-2010" Y1
FULL OUTER JOIN 
    "Year 2010-2011" Y2
ON TRIM(Y1.StockCode) = TRIM(Y2.StockCode)
group by COALESCE(TRIM(t1.StockCode), TRIM(t2.StockCode)), COALESCE(t1.Description, t2.Description)
order by TotalQuantitySold DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;

----------------------TOTAL COUNTRY SALES PER FINANCIAL PERIOD----------------------

select COALESCE(Y1.Country, Y2.Country) AS Country, SUM(COALESCE(Y1.Total_Price, 0)) + SUM(COALESCE(Y2.Total_Price, 0)) AS TotalSales
from "Year 2009-2010" Y1
FULL OUTER JOIN "Year 2010-2011" Y2
on Y1.Country = Y2.Country
group by COALESCE(Y1.Country, Y2.Country)
order by TotalSales;

----------------------------------TREND ANALYSIS-----------------------------------
---------------------------MONTHLY SALES OVER TIME---------------------------------
select MONTH(InvoiceDate) AS Month, YEAR(InvoiceDate) AS Year, SUM(CAST(Total_Price as Decimal(18,2))) AS TotalSales
from "Year 2009-2010"
group by MONTH(InvoiceDate), YEAR(InvoiceDate)
ORDER BY Year, Month;

select MONTH(InvoiceDate) AS Month, YEAR(InvoiceDate) AS Year, SUM(CAST(Total_Price as Decimal(18,2))) AS TotalSales
from "Year 2010-2011"
group by MONTH(InvoiceDate), YEAR(InvoiceDate)
ORDER BY Year, Month;

------------------------PRODUCT POPULARITY PER FINANCIAL PERIOD---------------------
select StockCode, Description, MONTH(InvoiceDate) AS Month, YEAR(InvoiceDate) AS Year, SUM(Quantity) AS TotalQuantitySold
from "Year 2009-2010"
group by StockCode, Description, MONTH(InvoiceDate), YEAR(InvoiceDate)
order by Year, Month;

select StockCode, Description, MONTH(InvoiceDate) AS Month, YEAR(InvoiceDate) AS Year, SUM(Quantity) AS TotalQuantitySold
from "Year 2010-2011"
group by StockCode, Description, MONTH(InvoiceDate), YEAR(InvoiceDate)
order by Year, Month;

------------------------------CUSTOMER TRENDS---------------------------------------
------------------------------REPEAT CUSTOMERS--------------------------------------

select [Customer ID], COUNT(DISTINCT Invoice) AS NumberOfOrders
from "Year 2009-2010"
group by [Customer ID]
having COUNT(DISTINCT Invoice) > 1
order by [Customer ID];

select [Customer ID], COUNT(DISTINCT Invoice) AS NumberOfOrders
from "Year 2010-2011"
group by [Customer ID]
having COUNT(DISTINCT Invoice) > 1
order by [Customer ID];

------------------------------TIME SERIES ANALYSIS----------------------------------

select InvoiceDate, SUM(Total_Price) AS TotalSales, AVG(SUM(Total_Price)) over (order by InvoiceDate rows BETWEEN 6 preceding AND 0 following) AS MovingAverage
from "Year 2009-2010"
group by InvoiceDate
order by MovingAverage;


select InvoiceDate, SUM(Total_Price) AS TotalSales, AVG(SUM(Total_Price)) over (order by InvoiceDate rows BETWEEN 6 preceding AND 0 following) AS MovingAverage
from "Year 2010-2011"
group by InvoiceDate
order by MovingAverage;

