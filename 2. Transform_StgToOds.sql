-- 2. ���� �������� ����������� ������;

CREATE DATABASE ods; 

USE [ods]
GO

-- �������� ������� ������ [FactSales] �  ��������� � ods

SELECT d.ProductID, 
		d.SalesOrderID, 
		d.OrderQty, 
		d.UnitPrice, 
		d.ModifiedDate 
		INTO ods.[dbo].[FactSales]
FROM [stg].[dbo].[SalesOrderDetail] d

-- ��� ����������� ���������� ������ � ������� ������ ��������� � job
INSERT INTO ods.[dbo].[FactSales]
           ([ProductID]
           ,[SalesOrderID]
           ,[OrderQty]
           ,[UnitPrice]
           ,[ModifiedDate])
SELECT d.ProductID, 
		d.SalesOrderID, 
		d.OrderQty, 
		d.UnitPrice, 
		d.ModifiedDate 
FROM [stg].[dbo].[SalesOrderDetail] d

-- �������� ������� ��������� [DimProduct]

CREATE TABLE ods.[dbo].[DimProduct]
           ([ProductID] [int] not null
           ,[Name] [nvarchar] (50) not null
           ,[ProductNumber] [nvarchar] (50) not null
           ,[ModifiedDate] [datetime] not null
		   )
-- ��������� ������
INSERT INTO [ods].[dbo].[DimProduct]
           ([ProductID]
           ,[Name]
           ,[ProductNumber]
           ,[ModifiedDate])

select		[ProductID]
           ,[Name]
           ,[ProductNumber]
           ,[ModifiedDate]
from [stg].[dbo].[Product]

-- -- �������� ������� ��������� [DimOrder]
CREATE TABLE ods.[dbo].[DimOrder]
           ([SalesOrderID] [int] not null
           ,[SalesOrderNumber] [nvarchar] (25) not null
           ,[AccountNumber] [nvarchar] (15) null
		   ,[CreditCardID] [int] null
		   ,[OrderDate] [datetime] not null
           ,[ModifiedDate] [datetime] not null
		   )

-- ��������� ������
INSERT INTO [ods].[dbo].[DimOrder]
           ([SalesOrderID]
           ,[SalesOrderNumber]
           ,[AccountNumber]
		   ,[CreditCardID]
		   ,[OrderDate]
           ,[ModifiedDate]
		   )

select		[SalesOrderID]
           ,[SalesOrderNumber]
           ,[AccountNumber]
		   ,[CreditCardID]
		   ,[OrderDate]
           ,[ModifiedDate]
from [stg].[dbo].SalesOrderHeader