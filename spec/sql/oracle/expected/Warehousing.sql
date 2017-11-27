CREATE TABLE BACK_ORDER_ALLOCATION (
	-- Back Order Allocation involves Purchase Order Item that is part of Purchase Order that has Purchase Order ID
	PURCHASE_ORDER_ITEM_PURCHASE_ORDER_ID   LONGINTEGER NOT NULL,
	-- Back Order Allocation involves Purchase Order Item that is for Product that has Product ID
	PURCHASE_ORDER_ITEM_PRODUCT_ID          LONGINTEGER NOT NULL,
	-- Back Order Allocation involves Sales Order Item that is part of Sales Order that has Sales Order ID
	SALES_ORDER_ITEM_SALES_ORDER_ID         LONGINTEGER NOT NULL,
	-- Back Order Allocation involves Sales Order Item that is for Product that has Product ID
	SALES_ORDER_ITEM_PRODUCT_ID             LONGINTEGER NOT NULL,
	-- Back Order Allocation is for Quantity
	QUANTITY                                INTEGER NOT NULL,
	-- Primary index to Back Order Allocation(Purchase Order Item, Sales Order Item in "Purchase Order Item is allocated to Sales Order Item")
	PRIMARY KEY(PURCHASE_ORDER_ITEM_PURCHASE_ORDER_ID, PURCHASE_ORDER_ITEM_PRODUCT_ID, SALES_ORDER_ITEM_SALES_ORDER_ID, SALES_ORDER_ITEM_PRODUCT_ID)
);


CREATE TABLE BIN (
	-- Bin has Bin ID
	BIN_ID                                  LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Bin contains Quantity
	QUANTITY                                INTEGER NOT NULL,
	-- maybe Bin contains Product that has Product ID
	PRODUCT_ID                              LONGINTEGER NULL,
	-- maybe Warehouse contains Bin and Warehouse has Warehouse ID
	WAREHOUSE_ID                            LONGINTEGER NULL,
	-- Primary index to Bin(Bin ID in "Bin has Bin ID")
	PRIMARY KEY(BIN_ID)
);


CREATE TABLE DISPATCH_ITEM (
	-- Dispatch Item has Dispatch Item ID
	DISPATCH_ITEM_ID                        LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Dispatch Item is Product that has Product ID
	PRODUCT_ID                              LONGINTEGER NOT NULL,
	-- Dispatch Item is in Quantity
	QUANTITY                                INTEGER NOT NULL,
	-- maybe Dispatch Item is for Dispatch that has Dispatch ID
	DISPATCH_ID                             LONGINTEGER NULL,
	-- maybe Dispatch Item is for Sales Order Item that is part of Sales Order that has Sales Order ID
	SALES_ORDER_ITEM_SALES_ORDER_ID         LONGINTEGER NULL,
	-- maybe Dispatch Item is for Sales Order Item that is for Product that has Product ID
	SALES_ORDER_ITEM_PRODUCT_ID             LONGINTEGER NULL,
	-- maybe Dispatch Item is for Transfer Request that has Transfer Request ID
	TRANSFER_REQUEST_ID                     LONGINTEGER NULL,
	-- Primary index to Dispatch Item(Dispatch Item ID in "Dispatch Item has Dispatch Item ID")
	PRIMARY KEY(DISPATCH_ITEM_ID)
);


CREATE TABLE PARTY (
	-- Party has Party ID
	PARTY_ID                                LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Primary index to Party(Party ID in "Party has Party ID")
	PRIMARY KEY(PARTY_ID)
);


CREATE TABLE PRODUCT (
	-- Product has Product ID
	PRODUCT_ID                              LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Primary index to Product(Product ID in "Product has Product ID")
	PRIMARY KEY(PRODUCT_ID)
);


CREATE TABLE PURCHASE_ORDER (
	-- Purchase Order has Purchase Order ID
	PURCHASE_ORDER_ID                       LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Purchase Order is to Supplier that is a kind of Party that has Party ID
	SUPPLIER_ID                             LONGINTEGER NOT NULL,
	-- Purchase Order is to Warehouse that has Warehouse ID
	WAREHOUSE_ID                            LONGINTEGER NOT NULL,
	-- Primary index to Purchase Order(Purchase Order ID in "Purchase Order has Purchase Order ID")
	PRIMARY KEY(PURCHASE_ORDER_ID),
	FOREIGN KEY (SUPPLIER_ID) REFERENCES PARTY (PARTY_ID)
);


CREATE TABLE PURCHASE_ORDER_ITEM (
	-- Purchase Order Item is part of Purchase Order that has Purchase Order ID
	PURCHASE_ORDER_ID                       LONGINTEGER NOT NULL,
	-- Purchase Order Item is for Product that has Product ID
	PRODUCT_ID                              LONGINTEGER NOT NULL,
	-- Purchase Order Item is in Quantity
	QUANTITY                                INTEGER NOT NULL,
	-- Primary index to Purchase Order Item(Purchase Order, Product in "Purchase Order includes Purchase Order Item", "Purchase Order Item is for Product")
	PRIMARY KEY(PURCHASE_ORDER_ID, PRODUCT_ID),
	FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (PRODUCT_ID),
	FOREIGN KEY (PURCHASE_ORDER_ID) REFERENCES PURCHASE_ORDER (PURCHASE_ORDER_ID)
);


CREATE TABLE RECEIVED_ITEM (
	-- Received Item has Received Item ID
	RECEIVED_ITEM_ID                        LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Received Item is Product that has Product ID
	PRODUCT_ID                              LONGINTEGER NOT NULL,
	-- Received Item is in Quantity
	QUANTITY                                INTEGER NOT NULL,
	-- maybe Received Item is for Purchase Order Item that is part of Purchase Order that has Purchase Order ID
	PURCHASE_ORDER_ITEM_PURCHASE_ORDER_ID   LONGINTEGER NULL,
	-- maybe Received Item is for Purchase Order Item that is for Product that has Product ID
	PURCHASE_ORDER_ITEM_PRODUCT_ID          LONGINTEGER NULL,
	-- maybe Received Item has Receipt that has Receipt ID
	RECEIPT_ID                              LONGINTEGER NULL,
	-- maybe Received Item is for Transfer Request that has Transfer Request ID
	TRANSFER_REQUEST_ID                     LONGINTEGER NULL,
	-- Primary index to Received Item(Received Item ID in "Received Item has Received Item ID")
	PRIMARY KEY(RECEIVED_ITEM_ID),
	FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (PRODUCT_ID),
	FOREIGN KEY (PURCHASE_ORDER_ITEM_PURCHASE_ORDER_ID, PURCHASE_ORDER_ITEM_PRODUCT_ID) REFERENCES PURCHASE_ORDER_ITEM (PURCHASE_ORDER_ID, PRODUCT_ID)
);


CREATE TABLE SALES_ORDER (
	-- Sales Order has Sales Order ID
	SALES_ORDER_ID                          LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Sales Order was made by Customer that is a kind of Party that has Party ID
	CUSTOMER_ID                             LONGINTEGER NOT NULL,
	-- Sales Order is from Warehouse that has Warehouse ID
	WAREHOUSE_ID                            LONGINTEGER NOT NULL,
	-- Primary index to Sales Order(Sales Order ID in "Sales Order has Sales Order ID")
	PRIMARY KEY(SALES_ORDER_ID),
	FOREIGN KEY (CUSTOMER_ID) REFERENCES PARTY (PARTY_ID)
);


CREATE TABLE SALES_ORDER_ITEM (
	-- Sales Order Item is part of Sales Order that has Sales Order ID
	SALES_ORDER_ID                          LONGINTEGER NOT NULL,
	-- Sales Order Item is for Product that has Product ID
	PRODUCT_ID                              LONGINTEGER NOT NULL,
	-- Sales Order Item is in Quantity
	QUANTITY                                INTEGER NOT NULL,
	-- Primary index to Sales Order Item(Sales Order, Product in "Sales Order includes Sales Order Item", "Sales Order Item is for Product")
	PRIMARY KEY(SALES_ORDER_ID, PRODUCT_ID),
	FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (PRODUCT_ID),
	FOREIGN KEY (SALES_ORDER_ID) REFERENCES SALES_ORDER (SALES_ORDER_ID)
);


CREATE TABLE TRANSFER_REQUEST (
	-- Transfer Request has Transfer Request ID
	TRANSFER_REQUEST_ID                     LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Transfer Request is from From Warehouse and Warehouse has Warehouse ID
	FROM_WAREHOUSE_ID                       LONGINTEGER NOT NULL,
	-- Transfer Request is for Product that has Product ID
	PRODUCT_ID                              LONGINTEGER NOT NULL,
	-- Transfer Request is for Quantity
	QUANTITY                                INTEGER NOT NULL,
	-- Transfer Request is to To Warehouse and Warehouse has Warehouse ID
	TO_WAREHOUSE_ID                         LONGINTEGER NOT NULL,
	-- Primary index to Transfer Request(Transfer Request ID in "Transfer Request has Transfer Request ID")
	PRIMARY KEY(TRANSFER_REQUEST_ID),
	FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (PRODUCT_ID)
);


CREATE TABLE WAREHOUSE (
	-- Warehouse has Warehouse ID
	WAREHOUSE_ID                            LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Primary index to Warehouse(Warehouse ID in "Warehouse has Warehouse ID")
	PRIMARY KEY(WAREHOUSE_ID)
);


ALTER TABLE BACK_ORDER_ALLOCATION
	ADD FOREIGN KEY (PURCHASE_ORDER_ITEM_PURCHASE_ORDER_ID, PURCHASE_ORDER_ITEM_PRODUCT_ID) REFERENCES PURCHASE_ORDER_ITEM (PURCHASE_ORDER_ID, PRODUCT_ID);


ALTER TABLE BACK_ORDER_ALLOCATION
	ADD FOREIGN KEY (SALES_ORDER_ITEM_SALES_ORDER_ID, SALES_ORDER_ITEM_PRODUCT_ID) REFERENCES SALES_ORDER_ITEM (SALES_ORDER_ID, PRODUCT_ID);


ALTER TABLE BIN
	ADD FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (PRODUCT_ID);


ALTER TABLE BIN
	ADD FOREIGN KEY (WAREHOUSE_ID) REFERENCES WAREHOUSE (WAREHOUSE_ID);


ALTER TABLE DISPATCH_ITEM
	ADD FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (PRODUCT_ID);


ALTER TABLE DISPATCH_ITEM
	ADD FOREIGN KEY (SALES_ORDER_ITEM_SALES_ORDER_ID, SALES_ORDER_ITEM_PRODUCT_ID) REFERENCES SALES_ORDER_ITEM (SALES_ORDER_ID, PRODUCT_ID);


ALTER TABLE DISPATCH_ITEM
	ADD FOREIGN KEY (TRANSFER_REQUEST_ID) REFERENCES TRANSFER_REQUEST (TRANSFER_REQUEST_ID);


ALTER TABLE PURCHASE_ORDER
	ADD FOREIGN KEY (WAREHOUSE_ID) REFERENCES WAREHOUSE (WAREHOUSE_ID);


ALTER TABLE RECEIVED_ITEM
	ADD FOREIGN KEY (TRANSFER_REQUEST_ID) REFERENCES TRANSFER_REQUEST (TRANSFER_REQUEST_ID);


ALTER TABLE SALES_ORDER
	ADD FOREIGN KEY (WAREHOUSE_ID) REFERENCES WAREHOUSE (WAREHOUSE_ID);


ALTER TABLE TRANSFER_REQUEST
	ADD FOREIGN KEY (FROM_WAREHOUSE_ID) REFERENCES WAREHOUSE (WAREHOUSE_ID);


ALTER TABLE TRANSFER_REQUEST
	ADD FOREIGN KEY (TO_WAREHOUSE_ID) REFERENCES WAREHOUSE (WAREHOUSE_ID);

