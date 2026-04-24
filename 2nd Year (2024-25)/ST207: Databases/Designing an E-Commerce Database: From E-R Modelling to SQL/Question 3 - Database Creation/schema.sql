CREATE TABLE CUSTOMER
(
  Customer_ID INT NOT NULL,
  Email_Address VARCHAR NOT NULL,
  Date_of_Birth DATE NOT NULL,
  Building_NameNumber VARCHAR,
  Street VARCHAR NOT NULL,
  City VARCHAR NOT NULL,
  Country VARCHAR NOT NULL,
  Postcode VARCHAR NOT NULL,
  Phone_Number VARCHAR NOT NULL,
  Password VARCHAR NOT NULL,
  Name VARCHAR NOT NULL,
  PRIMARY KEY (Customer_ID),
  UNIQUE (Email_Address)
);

CREATE TABLE PAYMENT_METHOD
(
  SerialCard_Number INT(12) NOT NULL,
  Expiry_Date DATE NOT NULL,
  Customer_ID VARCHAR NOT NULL,
  PRIMARY KEY (SerialCard_Number),
  FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID)
);

CREATE TABLE CREDIT_DEBIT
(
  Name VARCHAR NOT NULL,
  Verification_Code INT(4) NOT NULL,
  Is_Default CHAR(1) NOT NULL,
  SerialCard_Number INT(12) NOT NULL,
  PRIMARY KEY (SerialCard_Number),
  FOREIGN KEY (SerialCard_Number) REFERENCES PAYMENT_METHOD(SerialCard_Number)
);

CREATE TABLE VOUCHER_GIFTCARD
(
  Total_Amount FLOAT NOT NULL,
  Current_Balance FLOAT NOT NULL,
  SerialCard_Number INT(12) NOT NULL,
  PRIMARY KEY (SerialCard_Number),
  FOREIGN KEY (SerialCard_Number) REFERENCES PAYMENT_METHOD(SerialCard_Number)
);

CREATE TABLE PRODUCT
(
  Product_Number INT NOT NULL,
  Product_Name VARCHAR NOT NULL,
  Description VARCHAR NOT NULL,
  Brand VARCHAR NOT NULL,
  Colour VARCHAR NOT NULL,
  Depth INT NOT NULL,
  Width INT NOT NULL,
  Height INT NOT NULL,
  Weight FLOAT NOT NULL,
  Price FLOAT NOT NULL,
  Warranty INT NOT NULL, 
  Category VARCHAR NOT NULL,
  Stock_Quantity INT NOT NULL,
  Is_Available CHAR(1) NOT NULL,
  PRIMARY KEY (Product_Number)
);

CREATE TABLE BASKET
(
  Basket_ID VARCHAR NOT NULL,
  Customer_ID VARCHAR NOT NULL,
  PRIMARY KEY (Basket_ID),
  FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID)
);

CREATE TABLE ADDED_TO
(
  Desired_Quantity INT NOT NULL,
  Product_Number INT NOT NULL,
  Basket_ID VARCHAR NOT NULL,
  PRIMARY KEY (Product_Number, Basket_ID),
  FOREIGN KEY (Product_Number) REFERENCES PRODUCT(Product_Number),
  FOREIGN KEY (Basket_ID) REFERENCES BASKET(Basket_ID)
);

CREATE TABLE ORDERED_PRODUCT
(
  Product_Number INT NOT NULL,
  Product_Subtotal FLOAT NOT NULL,
  Num_Ordered INT NOT NULL,
  Order_Number INT NOT NULL,
  PRIMARY KEY (Order_Number, Product_Number),
  FOREIGN KEY (Product_Number) REFERENCES PRODUCT(Product_Number),
  FOREIGN KEY (Order_Number) REFERENCES CUSTOMER_ORDER(Order_Number)
);

CREATE TABLE CUSTOMER_ORDER
(
  Order_Number INT NOT NULL,
  Date DATE NOT NULL,
  Deduction_Promotion FLOAT NOT NULL,
  Total FLOAT NOT NULL,
  Grand_Total FLOAT NOT NULL,
  Customer_ID VARCHAR NOT NULL,
  PRIMARY KEY (Order_Number),
  FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID)
);

CREATE TABLE DELIVERY
(
  Tracking_Number INT NOT NULL,
  Date_of_Delivery DATE NOT NULL,
  Status VARCHAR NOT NULL,
  Delivery_Address VARCHAR NOT NULL,
  Order_Number INT NOT NULL,
  PRIMARY KEY (Tracking_Number),
  FOREIGN KEY (Order_Number) REFERENCES CUSTOMER_ORDER(Order_Number)
);

CREATE TABLE RETURN
(
  Ticket_Number INT NOT NULL,
  Order_Number INT NOT NULL,
  Start_Date DATE NOT NULL,
  Due_Date DATE NOT NULL,
  Refund_Total FLOAT NOT NULL,
  Status VARCHAR NOT NULL,
  PRIMARY KEY (Ticket_Number),
  FOREIGN KEY (Order_Number) REFERENCES CUSTOMER_ORDER(Order_Number)
);

CREATE TABLE REVIEW
(
  Review_Number INT NOT NULL,
  Date DATE NOT NULL,
  Text VARCHAR NOT NULL,
  Ranking INT NOT NULL,
  Product_Number INT NOT NULL,
  Customer_ID VARCHAR NOT NULL,
  PRIMARY KEY (Review_Number),
  FOREIGN KEY (Product_Number) REFERENCES PRODUCT(Product_Number),
  FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID)
);