CREATE TABLE logistic.City (
 CityID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL
);

CREATE TABLE logistic.Warehouse(
  CityID INT NOT NULL,
  WarehouseID INT NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY,
  Name VARCHAR(500) NOT NULL,
  IsStore BOOLEAN NOT NULL DEFAULT false, 
  Address VARCHAR(1000), 
  Phone VARCHAR(50), 
  PRIMARY KEY (WarehouseID),
  CONSTRAINT fk_Warehouse_City FOREIGN KEY (CityID) REFERENCES logistic.City (CityID)
);

-- I-й вариант
create table logistic.ProductBin(
  CityID INT NOT NULL,
  WarehouseID INT NOT NULL,
  Bin VARCHAR(16) NOT NULL,
  ProductID  INT NOT NULL,
  VendorID INT NOT NULL,
  Count INT,
  PRIMARY KEY (CityID, WarehouseID, VendorID, ProductID, Bin),
  CONSTRAINT fk_WarehouseBin_Warehouse FOREIGN KEY (WarehouseID) REFERENCES logistic.Warehouse (WarehouseID),
  CONSTRAINT fk_WarehouseBin_Vendor FOREIGN KEY (VendorID) REFERENCES logistic.Vendor (VendorID),
  CONSTRAINT fk_WarehouseBin_Product FOREIGN KEY (ProductID) REFERENCES logistic.Product (ProductID)
);


--- II вариант

CREATE TABLE logistic.WarehouseBin(
  BinID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  WarehouseID INT NOT NULL,
  BIN VARCHAR(16) NOT NULL,
  CONSTRAINT fk_WarehouseBin_Warehouse FOREIGN KEY (WarehouseID) REFERENCES logistic.Warehouse (WarehouseID)
);

CREATE INDEX idx_warehousebin_warehouse on logistic.WarehouseBin (WarehouseID);

create table logistic.ProductBin(
  ProductID INT NOT NULL,
  VendorID INT NOT NULL,
  BinID INT NOT NULL,
  Count INT,
  PRIMARY KEY (ProductID, VendorID, BinID),
  CONSTRAINT fk_ProductBin_WarehouseBin FOREIGN KEY (BinID) REFERENCES logistic.WarehouseBin (BinID),
  CONSTRAINT fk_ProductBin_Vendor FOREIGN KEY (VendorID) REFERENCES logistic.Vendor (VendorID),
  CONSTRAINT fk_ProductBin_Product FOREIGN KEY (ProductID) REFERENCES logistic.Product (ProductID)
);
