-- 3. ������� ������ �� Ods � �������������� ���� (��� ���������� �������� �������� ������) � ���������.
CREATE DATABASE dwh; -- ��������� ������;
use [dwh]


-- ������� ������� ������ FactSales
select ProductID, f.SalesOrderID, h.OrderDate, sum(f.OrderQty * f.UnitPrice) as Sum
into dwh.dbo.FactSales
 from [ods].[dbo].[FactSales] f
 inner join [ods].[dbo].DimOrder h on h.SalesOrderID = f.SalesOrderID
where 1=2 -- ��� ���������� ������ ��� �������� �������
 group by ProductID, f.SalesOrderID, OrderDate 

 -- � ������� ������� MERGE ��������� ����� ������ � ��������� 
 -- ��������� ������ � ������� ������ FactSales
 MERGE dwh.dbo.FactSales AS TARGET
USING (
select ProductID, f.SalesOrderID, h.OrderDate, sum(f.OrderQty * f.UnitPrice) as Sum
from [ods].[dbo].[FactSales] f
inner join [ods].[dbo].DimOrder h on h.SalesOrderID = f.SalesOrderID 
group by ProductID, f.SalesOrderID, OrderDate) AS SOURCE
ON (
	TARGET.ProductId = SOURCE.ProductId and
	TARGET.SalesOrderID = SOURCE.SalesOrderID and
	TARGET.OrderDate = SOURCE.OrderDate)
WHEN MATCHED THEN
	UPDATE SET TARGET.Sum = SOURCE.Sum
WHEN NOT MATCHED THEN
	INSERT (ProductID, SalesOrderID, OrderDate, Sum)
	VALUES (SOURCE.ProductID, SOURCE.SalesOrderID, SOURCE.OrderDate, SOURCE.Sum);

-- ������� ������� ��������� DimOrder
select		[SalesOrderID]
           ,[SalesOrderNumber]
           ,[AccountNumber]
		   ,[CreditCardID]
into dwh.dbo.DimOrder
from ods.dbo.DimOrder
where 1=2

-- ��������� ������ � ������� ��������� DimOrder
MERGE dwh.dbo.DimOrder AS TARGET
USING (
select SalesOrderID, 
	   SalesOrderNumber, 
	   AccountNumber, 
	   CreditCardID
from ods.dbo.DimOrder) AS SOURCE
ON (TARGET.SalesOrderID = SOURCE.SalesOrderID)
WHEN MATCHED THEN
	UPDATE SET TARGET.SalesOrderNumber = SOURCE.SalesOrderNumber,
			   TARGET.AccountNumber = SOURCE.AccountNumber,
			   TARGET.CreditCardID = SOURCE.CreditCardID

WHEN NOT MATCHED THEN
	INSERT (SalesOrderID, SalesOrderNumber, AccountNumber, CreditCardID)
	VALUES (SOURCE.SalesOrderID, SOURCE.SalesOrderNumber, SOURCE.AccountNumber, SOURCE.CreditCardID);

-- ������� ������� ��������� Product

select		[ProductID]
           ,[Name]
           ,[ProductNumber]
into dwh.dbo.DimProduct
from [ods].[dbo].[DimProduct]
where 1=2

-- ��������� ������ � ������� ��������� DimProduct
MERGE dwh.dbo.DimProduct AS TARGET
USING (
select ProductID, Name, ProductNumber
from ods.dbo.DimProduct) AS SOURCE
ON (TARGET.ProductID = SOURCE.ProductID)
WHEN MATCHED THEN
	UPDATE SET TARGET.Name = SOURCE.Name,
			   TARGET.ProductNumber = SOURCE.ProductNumber

WHEN NOT MATCHED THEN
	INSERT (ProductID, Name, ProductNumber)
	VALUES (SOURCE.ProductID, SOURCE.Name, SOURCE.ProductNumber);

-- ������� ������� ��������� Date �������� ����
select	DISTINCT OrderDate,
		YEAR(OrderDate) AS Year,
		MONTH(OrderDate) AS Month,
		DATENAME(month, OrderDate) AS MonthName,
		DAY(OrderDate) AS Day
into dwh.dbo.DimDate
from [ods].[dbo].[DimOrder]
where 1=2

-- ��������� ������ � ������� ������ DimProduct
MERGE dwh.dbo.DimDate AS TARGET 
USING (
select DISTINCT OrderDate,
		YEAR(OrderDate) AS Year,
		MONTH(OrderDate) AS Month,
		DATENAME(month, OrderDate) AS MonthName,
		DAY(OrderDate) AS Day
from ods.dbo.DimOrder) AS SOURCE
ON (TARGET.OrderDate = SOURCE.OrderDate)
WHEN MATCHED THEN
	UPDATE SET TARGET.YEAR = SOURCE.YEAR,
			   TARGET.MONTH = SOURCE.MONTH,
			   TARGET.MonthName = SOURCE.MonthName,
			   TARGET.Day = SOURCE.Day

WHEN NOT MATCHED THEN
	INSERT (OrderDate, YEAR, MONTH, MonthName, Day)
	VALUES (SOURCE.OrderDate, SOURCE.YEAR, SOURCE.MONTH, SOURCE.MonthName, SOURCE.Day);