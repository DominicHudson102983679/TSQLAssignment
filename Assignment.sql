use assignment

/*
IF OBJECT_ID('Sale') IS NOT NULL
DROP TABLE SALE;
IF OBJECT_ID('Product') IS NOT NULL
DROP TABLE PRODUCT;
IF OBJECT_ID('Customer') IS NOT NULL
DROP TABLE CUSTOMER;
IF OBJECT_ID('Location') IS NOT NULL
DROP TABLE LOCATION;

GO

CREATE TABLE CUSTOMER (
  CUSTID          INT
, CUSTNAME        NVARCHAR(100)
, SALES_YTD       MONEY
, STATUS          NVARCHAR(7)
, PRIMARY KEY     (CUSTID) 
);

CREATE TABLE PRODUCT (
  PRODID            INT
, PRODNAME          NVARCHAR(100)
, SELLING_PRICE     MONEY
, SALES_YTD         MONEY
, PRIMARY KEY       (PRODID)
);

CREATE TABLE SALE (
  SALEID          BIGINT
, CUSTID          INT
, PRODID          INT
, QTY             INT
, PRICE           MONEY
, SALEDATE        DATE
, PRIMARY KEY     (SALEID)
, FOREIGN KEY     (CUSTID) REFERENCES CUSTOMER
, FOREIGN KEY     (PRODID) REFERENCES PRODUCT
);

CREATE TABLE LOCATION (  
  LOCID           NVARCHAR(5)
, MINQTY          INTEGER
, MAXQTY          INTEGER
, PRIMARY KEY     (LOCID)
, CONSTRAINT CHECK_LOCID_LENGTH CHECK (LEN(LOCID) = 5)
, CONSTRAINT CHECK_MINQTY_RANGE CHECK (MINQTY BETWEEN 0 AND 999)
, CONSTRAINT CHECK_MAXQTY_RANGE CHECK (MAXQTY BETWEEN 0 AND 999)
, CONSTRAINT CHECK_MAXQTY_GREATER_MIXQTY CHECK (MAXQTY >= MINQTY)
);



IF OBJECT_ID('SALE_SEQ') IS NOT NULL
DROP SEQUENCE SALE_SEQ;
CREATE SEQUENCE SALE_SEQ;

GO

*/

/* ----------------------------------------------------------------------------- COMPLETED */

/*

IF OBJECT_ID('ADD_CUSTOMER') IS NOT NULL
DROP PROCEDURE ADD_CUSTOMER;

GO

CREATE PROCEDURE ADD_CUSTOMER @PCUSTID INT, @PCUSTNAME NVARCHAR(100) AS

BEGIN

    BEGIN TRY

        IF @PCUSTID < 1 OR @PCUSTID > 499
            THROW 50020, 'Customer ID out of range', 1

        INSERT INTO CUSTOMER (CUSTID, CUSTNAME, SALES_YTD, STATUS)
        VALUES (@PCUSTID, @PCUSTNAME, 0, 'OK');

    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 2627
            THROW 50010, 'Duplicate Customer ID', 1
        ELSE IF ERROR_NUMBER() = 50020
            THROW  
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END;
    END CATCH;
END;

GO 

DELETE from customer;

GO

EXEC ADD_CUSTOMER @pcustID = 1, @pcustname = 'testdude2';
EXEC ADD_CUSTOMER @pcustID = 500, @pcustname = 'testdude3';

*/

/* --------------------------------------------------------------------------------- */

/*
IF OBJECT_ID('DELETE_ALL_CUSTOMERS') IS NOT NULL
DROP PROCEDURE DELETE_ALL_CUSTOMERS;

GO

create procedure DELETE_ALL_CUSTOMERS AS

BEGIN

    BEGIN TRY

        DELETE * FROM CUSTOMER;

*/

/* --------------------------------------------------------------------------------- */

IF OBJECT_ID('ADD_PRODUCT') IS NOT NULL
DROP PROCEDURE ADD_PRODUCT;

GO

create procedure ADD_PRODUCT @pprodid INT, @pprodname NVARCHAR(100), @pprice MONEY AS

BEGIN

    BEGIN TRY

        IF @pprodid < 1000 OR @pprodid > 2500
            THROW 50040, 'Product ID out of range', 1
        
        IF @pprice < 0 OR @pprice > 999.99
            THROW 50050, 'Price out of range', 1
        
        INSERT INTO PRODUCT (PRODID, PRODNAME, SELLING_PRICE, SALES_YTD)
        VALUES (@pprodid, @pprodname, @pprice, 0);

    END TRY

    BEGIN CATCH

    END CATCH;

END;

GO


/* not inserting into PRODUCT */
EXEC ADD_PRODUCT @pprodid = 1, @pprodname = 'chicken', @pprice = 50.00;

Select *
From Product;


