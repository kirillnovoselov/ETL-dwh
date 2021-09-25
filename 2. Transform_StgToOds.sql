-- 2. слой хранения оперативных данных;

CREATE DATABASE ods; 

USE [ods]
GO

-- создадим таблицу фактов [FactSales] и  измерений в ods

SELECT d.ProductID, 
		d.SalesOrderID, 
		d.OrderQty, 
		d.UnitPrice, 
		d.ModifiedDate 
		INTO ods.[dbo].[FactSales]
FROM [stg].[dbo].[SalesOrderDetail] d

-- для ежедневного добавления данных в таблицу фактов вставляем в job
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

-- создадим таблицу измерений [DimProduct]

CREATE TABLE ods.[dbo].[DimProduct]
           ([ProductID] [int] not null
           ,[Name] [nvarchar] (50) not null
           ,[ProductNumber] [nvarchar] (50) not null
           ,[ModifiedDate] [datetime] not null
		   )
-- вставляем данные
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

-- -- создадим таблицу измерений [DimOrder]
CREATE TABLE ods.[dbo].[DimOrder]
           ([SalesOrderID] [int] not null
           ,[SalesOrderNumber] [nvarchar] (25) not null
           ,[AccountNumber] [nvarchar] (15) null
		   ,[CreditCardID] [int] null
		   ,[OrderDate] [datetime] not null
           ,[ModifiedDate] [datetime] not null
		   )

-- вставляем данные
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