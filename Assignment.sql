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

/* ADD_CUSTOMER ----------------------------------------------------------------------------- 1/22 COMPLETED */


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


EXEC ADD_CUSTOMER @pcustID = 2, @pcustname = 'testdude3';
EXEC ADD_CUSTOMER @pcustID = 3, @pcustname = 'testdude3';

select * from customer
*/


/* DELETE_ALL_CUSTOMERS --------------------------------------------------------------------------------- 2/22 COMPLETED */

/*

IF OBJECT_ID('DELETE_ALL_CUSTOMERS') IS NOT NULL
DROP PROCEDURE DELETE_ALL_CUSTOMERS;

GO

create procedure DELETE_ALL_CUSTOMERS AS

BEGIN

    BEGIN TRY

        DELETE FROM customer;
        PRINT (CONCAT(@@rowcount, ' customers deleted'));

    END TRY

    BEGIN CATCH
        
        BEGIN
            DECLARE @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END;

    END CATCH;
END;

GO

exec DELETE_ALL_CUSTOMERS;

GO

select * from customer;

*/

/* ADD_PRODUCT --------------------------------------------------------------------------------- 3/22 COMPLETED */

/*
IF OBJECT_ID('ADD_PRODUCT') IS NOT NULL
DROP PROCEDURE ADD_PRODUCT;

GO

create procedure ADD_PRODUCT @pprodid INT, @pprodname NVARCHAR(100), @pprice MONEY AS

BEGIN

    BEGIN TRY

        IF @pprodid < 1000 OR @pprodid > 2500
            THROW 50040, 'Product ID out of range', 1
        
        ELSE IF @pprice < 0 OR @pprice > 999.99
            THROW 50050, 'Price out of range', 1
        
        INSERT INTO PRODUCT (PRODID, PRODNAME, SELLING_PRICE, SALES_YTD)
        VALUES (@pprodid, @pprodname, @pprice, 0);

    END TRY

    BEGIN CATCH

        IF error_number() = 2627
            THROW 50030, 'Duplicate Product ID', 1
        ELSE IF error_number() = 50040
            THROW
        ELSE IF error_number() = 50050
            THROW
        ELSE
            BEGIN
                DECLARE @errormessage NVARCHAR(max) = error_message();
                THROW 50000, @errormessage, 1
            END

    END CATCH;

END;

GO


added to ADD_PRODUCT successfully 
EXEC ADD_PRODUCT @pprodid = 1001, @pprodname = 'chicken', @pprice = 50.00;

Select *
From Product;
*/

/* DELETE_ALL_PRODUCTS --------------------------------------------------------------------------------- 4/22 COMPLETED */

/*

IF OBJECT_ID('DELETE_ALL_PRODUCTS') IS NOT NULL
DROP PROCEDURE DELETE_ALL_PRODUCTS;

GO

create procedure DELETE_ALL_PRODUCTS AS

BEGIN

    BEGIN TRY

        DELETE FROM product
        print (concat(@@rowcount, ' products deleted'))

    END TRY

    BEGIN CATCH

        BEGIN
            DECLARE @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END

    END CATCH;

END

go

exec add_product @pprodid = 1002, @pprodname = 'chicken', @pprice = 50.00;
exec add_product @pprodid = 1003, @pprodname = 'chicken', @pprice = 50.00;
exec add_product @pprodid = 1004, @pprodname = 'chicken', @pprice = 50.00;

exec DELETE_ALL_PRODUCTS;

select * from product;

*/

/* GET_CUSTOMER_STRING --------------------------------------------------------------------------------- 5/22 */

/*
IF OBJECT_ID('GET_CUSTOMER_STRING') IS NOT NULL
DROP PROCEDURE GET_CUSTOMER_STRING;

go

create procedure GET_CUSTOMER_STRING @pcustid int, @preturnstring nvarchar(100) AS

BEGIN

    BEGIN TRY



    END TRY

    BEGIN CATCH
        BEGIN
        END
    END CATCH;

END;
*/

/* UPD_CUST_SALESYTD --------------------------------------------------------------------------------- 6/22 */



/* GET_PROD_STRING --------------------------------------------------------------------------------- 7/22 */



/* UPD_PROD_SALESYTD --------------------------------------------------------------------------------- 8/22 */



/* UPD_CUSTOMER_STATUS --------------------------------------------------------------------------------- 9/22 */



/* ADD_SIMPLE_SALE --------------------------------------------------------------------------------- 10/22 */



/* SUM_CUSTOMER_SALESYTD --------------------------------------------------------------------------------- 11/22 */



/* SUM_PRODUCT_SALESYTD --------------------------------------------------------------------------------- 12/22 */



/* GET_ALL_CUSTOMERS --------------------------------------------------------------------------------- 13/22 */



/* GET_ALL_PRODUCTS --------------------------------------------------------------------------------- 14/22 */



/* ADD_LOCATION --------------------------------------------------------------------------------- 15/22 */



/* ADD_COMPLEX_SALE --------------------------------------------------------------------------------- 16/22 */



/* GET_ALLSALES --------------------------------------------------------------------------------- 17/22 */


/* COUNT_PRODUCT_SALES --------------------------------------------------------------------------------- 18/22 */



/* DELETE_SALE --------------------------------------------------------------------------------- 19/22 */



/* DELETE_ALL_SALES --------------------------------------------------------------------------------- 20/22 */



/* DELETE_CUSTOMER --------------------------------------------------------------------------------- 21/22 */



/* DELETE_PRODUCT --------------------------------------------------------------------------------- 22/22 */