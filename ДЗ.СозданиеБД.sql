--база
create database myshop;
-- \c myshop

--poли
create role customeruser; 
create role manageruser;  
create user adminuser with SUPERUSER PASSWORD 'StudyDb';

--схемы
CREATE SCHEMA IF NOT EXISTS logistic;
CREATE SCHEMA IF NOT EXISTS orders; 

--таблицы
CREATE TABLE logistic.Product (
 ProductID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 Name VARCHAR(500) NOT NULL,
 Description VARCHAR(1000), 
 Age SMALLINT,
 Size VARCHAR(8)
);

CREATE TABLE logistic.Vendor(
  VendorID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  Name VARCHAR(500) NOT NULL,
  Description VARCHAR(1000), 
  Address VARCHAR(1000), 
  EMail VARCHAR(500) NOT NULL, 
  Phone VARCHAR(50) 
);

create table logistic.ProductVendor(
  VendorID  INT NOT NULL,
  ProductID INT NOT NULL,
  UnitCost  NUMERIC(18,2),
  PRIMARY KEY (VendorID, ProductID ),
  CONSTRAINT fk_ProductVendor_Vendor FOREIGN KEY (VendorID) REFERENCES logistic.Vendor (VendorID),
  CONSTRAINT fk_ProductVendor_Product FOREIGN KEY (ProductID) REFERENCES logistic.Product (ProductID)
);

create table orders.Customer(
  CustomerID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  Name VARCHAR(500) NOT NULL,
  Address VARCHAR(1000),
  EMail VARCHAR(500) NOT NULL,
  Phone VARCHAR(50) NOT NULL
);

create table orders.Order(
  OrderID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  Number VARCHAR(16) NOT NULL,
  CustomerID INT NOT NULL,
  NeedDelivery BOOLEAN,
  DeliveryDate DATE,  
  DeliveryTimeInterval VARCHAR(100),
  DeliveryCost NUMERIC(18,2),
  Price NUMERIC(18,2),
  Promocode VARCHAR(8),
  CONSTRAINT fk_Order_Customer FOREIGN KEY (CustomerID) REFERENCES orders.Customer (CustomerID)
);

create table orders.OrderDtl(
  OrderID   INT NOT NULL,
  OrderLine INT NOT NULL,
  ProductID INT NOT NULL,
  VendorID  INT NOT NULL,
  UnitCost  NUMERIC(18,2),
  Discount  NUMERIC(5,2), 
  Price     NUMERIC(18,2),
  CONSTRAINT pk_OrderDtl PRIMARY KEY (OrderID, OrderLine), 
  CONSTRAINT fk_OrderDtl_Order FOREIGN KEY (OrderID) REFERENCES orders.Order (OrderID) ON DELETE CASCADE,
  CONSTRAINT fk_OrderDtl_Product FOREIGN KEY (ProductID) REFERENCES logistic.Product (ProductID),
  CONSTRAINT fk_OrderDtl_ProductVendor FOREIGN KEY (VendorID, ProductID) REFERENCES logistic.ProductVendor (VendorID, ProductID)
);

-- создать табличные пространства
-- mkdir -p /var/run/archive-dir 
-- cd /var/run
-- chown postgres:postgres archive-dir

CREATE TABLESPACE archivespace LOCATION '/var/run/archive-dir';
CREATE SCHEMA IF NOT EXISTS archive; 

CREATE TABLE archive.ShippedOrder(
  OrderID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  Number VARCHAR(16) NOT NULL,
  CustomerID INT NOT NULL,
  NeedDelivery BOOLEAN,
  DeliveryDate DATE,  
  DeliveryTimeInterval VARCHAR(100),
  DeliveryCost NUMERIC(18,2),
  Price NUMERIC(18,2),
  Promocode VARCHAR(8),
  CONSTRAINT fk_ShippedOrder_Customer FOREIGN KEY (CustomerID) REFERENCES orders.Customer (CustomerID)
) TABLESPACE archivespace;

create table archive.ShippedOrderDtl(
  OrderID   INT NOT NULL,
  OrderLine INT NOT NULL,
  ProductID INT NOT NULL,
  VendorID  INT NOT NULL,
  UnitCost  NUMERIC(18,2),
  Discount  NUMERIC(5,2), 
  Price     NUMERIC(18,2),
  CONSTRAINT pk_ShippedOrderDtl PRIMARY KEY (OrderID, OrderLine), 
  CONSTRAINT fk_ShippedOrderDtl_Order FOREIGN KEY (OrderID) REFERENCES orders.Order (OrderID) ON DELETE CASCADE,
  CONSTRAINT fk_ShippedOrderDtl_Product FOREIGN KEY (ProductID) REFERENCES logistic.Product (ProductID)
) TABLESPACE archivespace;

--безопасность
grant all privileges on database myshop to adminuser;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA logistic TO manageruser;
GRANT SELECT ON ALL TABLES IN SCHEMA orders TO manageruser;
GRANT SELECT ON ALL TABLES IN SCHEMA archive TO manageruser;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA orders TO customeruser;
GRANT SELECT ON ALL TABLES IN SCHEMA logistic TO customeruser;
GRANT SELECT ON ALL TABLES IN SCHEMA archive TO customeruser;


