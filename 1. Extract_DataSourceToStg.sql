 -- 1. слой временного хранения копии данных от источника в неизменном виде;

CREATE DATABASE stg;


USE [stg] -- создаем в слое хранения таблицу [SalesOrderDetail]
GO

CREATE TABLE [SalesOrderDetail](
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderDetailID] [int] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[OrderQty] [smallint] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SpecialOfferID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[UnitPriceDiscount] [money] NOT NULL,
	[LineTotal]  AS (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))),
	[ModifiedDate] [datetime] NOT NULL,
)

CREATE TABLE [SalesOrderHeader](
	[SalesOrderID] [int] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[OnlineOrderFlag] [bit] NOT NULL,
	[SalesOrderNumber]  AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID]),N'*** ERROR ***')),
	[PurchaseOrderNumber] [varchar](25) NULL,
	[AccountNumber] [varchar](15) NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NOT NULL,
	[ShipToAddressID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[TotalDue]  AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
	[Comment] [nvarchar](128) NULL,
	[ModifiedDate] [datetime] NOT NULL
 )

CREATE TABLE [Product](
	[ProductID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[MakeFlag] [bit] NOT NULL,
	[FinishedGoodsFlag] [bit] NOT NULL,
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ReorderPoint] [smallint] NOT NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] NOT NULL,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NOT NULL
	)

	-- переносим исходные данные в слой храннения.

	-- заполняем таблицу [SalesOrderDetail] данными за один день
INSERT INTO [stg].[dbo].[SalesOrderDetail](
			[SalesOrderID],
			[SalesOrderDetailID],
			[CarrierTrackingNumber],
			[OrderQty],
		    [ProductID],
		    [SpecialOfferID],
		    [UnitPrice],
		    [UnitPriceDiscount],
		    [ModifiedDate]
		   )
SELECT     [SalesOrderID],
		   [SalesOrderDetailID],
		   [CarrierTrackingNumber],
		   [OrderQty],
		   [ProductID],
		   [SpecialOfferID],
		   [UnitPrice],
		   [UnitPriceDiscount],
		   [ModifiedDate] from [AdventureWorks2019].[Sales].[SalesOrderDetail]
WHERE	ModifiedDate = (SELECT MAX(ModifiedDate) from [AdventureWorks2019].[Sales].[SalesOrderDetail])

-- заполняем таблицу [Product] данными за один день
INSERT INTO [stg].[dbo].[Product]
           ([ProductID]
           ,[Name]
           ,[ProductNumber]
           ,[MakeFlag]
           ,[FinishedGoodsFlag]
           ,[Color]
           ,[SafetyStockLevel]
           ,[ReorderPoint]
           ,[StandardCost]
           ,[ListPrice]
           ,[Size]
           ,[SizeUnitMeasureCode]
           ,[WeightUnitMeasureCode]
           ,[Weight]
           ,[DaysToManufacture]
           ,[ProductLine]
           ,[Class]
           ,[Style]
           ,[ProductSubcategoryID]
           ,[ProductModelID]
           ,[SellStartDate]
           ,[SellEndDate]
           ,[DiscontinuedDate]
           ,[ModifiedDate])

SELECT		[ProductID]
           ,[Name]
           ,[ProductNumber]
           ,[MakeFlag]
           ,[FinishedGoodsFlag]
           ,[Color]
           ,[SafetyStockLevel]
           ,[ReorderPoint]
           ,[StandardCost]
           ,[ListPrice]
           ,[Size]
           ,[SizeUnitMeasureCode]
           ,[WeightUnitMeasureCode]
           ,[Weight]
           ,[DaysToManufacture]
           ,[ProductLine]
           ,[Class]
           ,[Style]
           ,[ProductSubcategoryID]
           ,[ProductModelID]
           ,[SellStartDate]
           ,[SellEndDate]
           ,[DiscontinuedDate]
           ,[ModifiedDate]
FROM		[AdventureWorks2019].[Production].[Product]
WHERE		ModifiedDate = (SELECT MAX(ModifiedDate) FROM [AdventureWorks2019].[Production].[Product])

-- заполняем таблицу [SalesOrderHeader] данными за один день
INSERT INTO [stg].[dbo].[SalesOrderHeader]
           ([SalesOrderID]
           ,[RevisionNumber]
           ,[OrderDate]
           ,[DueDate]
           ,[ShipDate]
           ,[Status]
           ,[OnlineOrderFlag]
           ,[PurchaseOrderNumber]
           ,[AccountNumber]
           ,[CustomerID]
           ,[SalesPersonID]
           ,[TerritoryID]
           ,[BillToAddressID]
           ,[ShipToAddressID]
           ,[ShipMethodID]
           ,[CreditCardID]
           ,[CreditCardApprovalCode]
           ,[CurrencyRateID]
           ,[SubTotal]
           ,[TaxAmt]
           ,[Freight]
           ,[Comment]
           ,[ModifiedDate])
SELECT		[SalesOrderID]
           ,[RevisionNumber]
           ,[OrderDate]
           ,[DueDate]
           ,[ShipDate]
           ,[Status]
           ,[OnlineOrderFlag]
           ,[PurchaseOrderNumber]
           ,[AccountNumber]
           ,[CustomerID]
           ,[SalesPersonID]
           ,[TerritoryID]
           ,[BillToAddressID]
           ,[ShipToAddressID]
           ,[ShipMethodID]
           ,[CreditCardID]
           ,[CreditCardApprovalCode]
           ,[CurrencyRateID]
           ,[SubTotal]
           ,[TaxAmt]
           ,[Freight]
           ,[Comment]
           ,[ModifiedDate]
FROM		[AdventureWorks2019].[Sales].[SalesOrderHeader]
WHERE		ModifiedDate = (SELECT MAX(ModifiedDate) FROM [AdventureWorks2019].[Sales].[SalesOrderHeader])
