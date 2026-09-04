-- SQL schema for the synthetic e-commerce BI case
CREATE TABLE DimCustomer (
    CustomerID VARCHAR(20) PRIMARY KEY,
    Country VARCHAR(50),
    AcquisitionChannel VARCHAR(50),
    SignupDate DATE
);

CREATE TABLE DimProduct (
    ProductID VARCHAR(20) PRIMARY KEY,
    ProductName VARCHAR(150),
    Category VARCHAR(50),
    UnitCost DECIMAL(12,2),
    ListPrice DECIMAL(12,2)
);

CREATE TABLE FactSales (
    OrderID VARCHAR(20) PRIMARY KEY,
    OrderDate DATE,
    CustomerID VARCHAR(20),
    ProductID VARCHAR(20),
    Quantity INT,
    DiscountRate DECIMAL(8,4),
    GrossSales DECIMAL(12,2),
    DiscountValue DECIMAL(12,2),
    NetSales DECIMAL(12,2),
    COGS DECIMAL(12,2),
    ShippingCost DECIMAL(12,2),
    PaymentCost DECIMAL(12,2)
);

CREATE TABLE FactReturns (
    OrderID VARCHAR(20),
    ReturnDate DATE,
    ProductID VARCHAR(20),
    ReturnQuantity INT,
    ReturnReason VARCHAR(50),
    RefundValue DECIMAL(12,2),
    ReturnCost DECIMAL(12,2)
);

CREATE TABLE FactMarketing (
    Month DATE,
    AcquisitionChannel VARCHAR(50),
    Spend DECIMAL(12,2)
);
