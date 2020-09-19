use assignment

/* to do
19/22

22/22 still need: 50320. Product cannot be deleted as sales exist

*/


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



/* ADD_CUSTOMER ------------------------------- 1/22 COMPLETED */

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

delete from CUSTOMER

go

EXEC ADD_CUSTOMER @pcustID = 1, @pcustname = 'Tom Cruise';
EXEC ADD_CUSTOMER @pcustID = 2, @pcustname = 'Leonardo DiCaprio';


/* DELETE_ALL_CUSTOMERS -------------------------- 2/22 COMPLETED */

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

go
-- works: prints '(2 rows affected) 2 customers deleted' 
exec DELETE_ALL_CUSTOMERS

go

EXEC ADD_CUSTOMER @pcustID = 1, @pcustname = 'Tom Cruise';
EXEC ADD_CUSTOMER @pcustID = 2, @pcustname = 'Leonardo DiCaprio';
EXEC ADD_CUSTOMER @pcustID = 3, @pcustname = 'Bradley Cooper';
EXEC ADD_CUSTOMER @pcustID = 4, @pcustname = 'Amy Adams';
EXEC ADD_CUSTOMER @pcustID = 5, @pcustname = 'Natalie Portman';
EXEC ADD_CUSTOMER @pcustID = 6, @pcustname = 'Emilia Clarke';
EXEC ADD_CUSTOMER @pcustID = 7, @pcustname = 'Matt Damon';
EXEC ADD_CUSTOMER @pcustID = 8, @pcustname = 'Margot Robbie';
EXEC ADD_CUSTOMER @pcustID = 9, @pcustname = 'Will Smith';
EXEC ADD_CUSTOMER @pcustID = 10, @pcustname = 'Antony Starr';
EXEC ADD_CUSTOMER @pcustID = 11, @pcustname = 'Brad Pitt';

/* ADD_PRODUCT ---------------------------- 3/22 COMPLETED */


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

delete from PRODUCT;

go

EXEC ADD_PRODUCT @pprodid = 1001, @pprodname = 'chicken', @pprice = 5.00;
EXEC ADD_PRODUCT @pprodid = 1002, @pprodname = 'snapper', @pprice = 25.00;


/* DELETE_ALL_PRODUCTS ----------------------------- 4/22 COMPLETED */

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

--works: prints '(2 rows affected) 2 products deleted' 
exec DELETE_ALL_PRODUCTS

go

EXEC ADD_PRODUCT @pprodid = 1001, @pprodname = 'Chicken', @pprice = 5.00;
EXEC ADD_PRODUCT @pprodid = 1002, @pprodname = 'Snapper', @pprice = 25.00;
EXEC ADD_PRODUCT @pprodid = 1003, @pprodname = 'Steak', @pprice = 40.00;
EXEC ADD_PRODUCT @pprodid = 1004, @pprodname = 'Tuna', @pprice = 60.00;
EXEC ADD_PRODUCT @pprodid = 1005, @pprodname = 'Salmon', @pprice = 20.00;
EXEC ADD_PRODUCT @pprodid = 1006, @pprodname = 'Mussels', @pprice = 10.00;
EXEC ADD_PRODUCT @pprodid = 1007, @pprodname = 'Pork', @pprice = 10.00;
EXEC ADD_PRODUCT @pprodid = 1008, @pprodname = 'Beef', @pprice = 15.00;
EXEC ADD_PRODUCT @pprodid = 1009, @pprodname = 'Bacon', @pprice = 2.00;


/* GET_CUSTOMER_STRING ---------------------------------- COMPLETED 5/22 */

IF OBJECT_ID('GET_CUSTOMER_STRING') IS NOT NULL
DROP PROCEDURE GET_CUSTOMER_STRING;

go

create procedure GET_CUSTOMER_STRING @pcustid int, @preturnstring nvarchar(100) OUTPUT AS

BEGIN

    BEGIN TRY

        DECLARE @custname NVARCHAR(100), @status NVARCHAR(7), @ytd money;

        select @custname = CUSTNAME, @ytd = SALES_YTD, @status = [STATUS] 
        from CUSTOMER 
        where CUSTID = @pcustid

        IF @@rowcount = 0
            THROW 50060, 'GET_CUSTOMER_STRING Customer ID not found', 1

        SET @preturnstring = CONCAT('CustID: ', @pcustID, ' / Name: ', @custname, ' / Status: ', @status, ' / SalesYTD: ', @ytd);

    END TRY

    BEGIN CATCH
    
        IF ERROR_NUMBER() = 50060
            THROW
    
        ELSE 
            BEGIN
                DECLARE @errormessage NVARCHAR(max) = error_message();
                THROW 50000, @errormessage, 1
            END;

    END CATCH

END

GO
-- works: prints 'CustID: 4 / Name: Amy Adams / Status: OK / SalesYTD: 0.00' 
BEGIN

    DECLARE @outputvalue NVARCHAR(100);
    EXEc GET_CUSTOMER_STRING @pcustID = 4, @preturnstring = @outputvalue OUTPUT;
    print (@outputvalue)

END

/* UPD_CUST_SALESYTD --------------------------------- COMPLETED 6/22 */

IF OBJECT_ID('UPD_CUST_SALESYTD') IS NOT NULL
DROP PROCEDURE UPD_CUST_SALESYTD;

go

create procedure UPD_CUST_SALESYTD @pcustid int, @pamt int AS

BEGIN

    BEGIN TRY

        IF @pamt < -999.99 OR @pamt > 999.99
            THROW 50080, 'Amount out of range', 1

        UPDATE customer
        set SALES_YTD = SALES_YTD + @pamt
        WHERE CUSTID = @pcustid
            
        if @@ROWCOUNT = 0
            THROW 50070, 'UPD_CUST_SALESYTD Customer ID not found', 1
    
    END TRY

    BEGIN CATCH

            BEGIN
                DECLARE @errormessage NVARCHAR(max) = error_message();
                THROW 50000, @errormessage, 1
            END

    END CATCH;

END;

GO
 
EXEC UPD_CUST_SALESYTD @pcustid = 1, @pamt = 100;
EXEC UPD_CUST_SALESYTD @pcustid = 2, @pamt = 200;
EXEC UPD_CUST_SALESYTD @pcustid = 3, @pamt = 100;
EXEC UPD_CUST_SALESYTD @pcustid = 4, @pamt = 900;
EXEC UPD_CUST_SALESYTD @pcustid = 5, @pamt = 500;
EXEC UPD_CUST_SALESYTD @pcustid = 6, @pamt = 600;
EXEC UPD_CUST_SALESYTD @pcustid = 7, @pamt = 300;
EXEC UPD_CUST_SALESYTD @pcustid = 8, @pamt = 800;
EXEC UPD_CUST_SALESYTD @pcustid = 9, @pamt = 700;
EXEC UPD_CUST_SALESYTD @pcustid = 10, @pamt = 400;
EXEC UPD_CUST_SALESYTD @pcustid = 11, @pamt = 900;

/* GET_PROD_STRING ---------------------------------------- COMPLETED 7/22 */

IF OBJECT_ID('GET_PROD_STRING') IS NOT NULL
DROP PROCEDURE GET_PROD_STRING;

go

create procedure GET_PROD_STRING @pprodid int, @pReturnString nvarchar(1000) OUTPUT AS 

BEGIN

    BEGIN TRY

        DECLARE @pprodname NVARCHAR(100),  @ytd money, @sellprice MONEY;

        SELECT @pprodname = PRODNAME, @ytd = sales_ytd, @sellprice = selling_price
        from PRODUCT
        WHERE @pprodid = PRODID

        IF @@ROWCOUNT = 0
            THROW 50090, 'Product ID not found', 1
        
        SET @pReturnString = concat('Prodid: ', @pprodid, ' / Name: ', @pprodname, ' / Price: ' , @sellprice ,' / SalesYTD: ',@ytd);

    END TRY

    BEGIN CATCH

        IF ERROR_NUMBER() in (50090)
            THROW
        
        ELSE
            BEGIN
                DECLARE @errormessage NVARCHAR(max) = error_message();
                THROW 50000, @errormessage, 1 
            END
    END CATCH;

END;

GO

GO
-- works: prints 'Prodid: 1001 / Name: Chicken / Price: 5.00 / SalesYTD: 0.00' 
BEGIN
    DECLARE @externalParam NVARCHAR(100)
    EXEC GET_PROD_STRING @pprodid = 1001, @pReturnString = @externalParam OUTPUT
    print @externalParam
END 
GO

/* UPD_PROD_SALESYTD ----------------------------------- COMPLETED 8/22 */

IF OBJECT_ID('UPD_PROD_SALESYTD') IS NOT NULL
DROP PROCEDURE UPD_PROD_SALESYTD;

go

create procedure UPD_PROD_SALESYTD @pprodid int, @pamt money AS

BEGIN

    BEGIN TRY

        if @pamt < -999.99 or @pamt > 999.99
            THROW 50110, 'Amount out of range', 1
        
        UPDATE PRODUCT 
        set SALES_YTD = @pamt
        WHERE PRODID = @pprodid;

        if @@ROWCOUNT = 0
            THROW 50070, 'UPD_PROD_SALESYTD Customer ID not found', 1

    END TRY

    BEGIN CATCH

            BEGIN
                DECLARE @errormessage NVARCHAR(max) = error_message();
                THROW 50000, @errormessage, 1
            END
        

    END CATCH;

END;

GO

exec UPD_PROD_SALESYTD @pprodid = 1001, @pamt = 111
exec UPD_PROD_SALESYTD @pprodid = 1003, @pamt = 222
exec UPD_PROD_SALESYTD @pprodid = 1004, @pamt = 333
exec UPD_PROD_SALESYTD @pprodid = 1006, @pamt = 444
exec UPD_PROD_SALESYTD @pprodid = 1007, @pamt = 555

GO

/* UPD_CUSTOMER_STATUS ------------------------------------- COMPLETED 9/22 */

IF OBJECT_ID('UPD_CUSTOMER_STATUS') IS NOT NULL
DROP PROCEDURE UPD_CUSTOMER_STATUS;

go

create procedure UPD_CUSTOMER_STATUS @pcustid int, @pstatus nvarchar(10) AS

BEGIN

    BEGIN TRY

        if @pstatus != 'ok' AND @pstatus != 'suspend'
            THROW 50130, 'Invalid Status value', 1

        UPDATE CUSTOMER
        SET [STATUS] = @pstatus
        WHERE CUSTID = @pcustid;

        IF @@ROWCOUNT = 0
                THROW 50120, 'CustomerID not found', 1 

    END TRY

    BEGIN CATCH
        BEGIN

            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1
                
        END
    END CATCH;

END;

GO

exec UPD_CUSTOMER_STATUS @pcustid = 1, @pstatus = 'suspend';


/* ADD_SIMPLE_SALE ---------------------------------- COMPLETED 10/22 */

IF OBJECT_ID('ADD_SIMPLE_SALE') IS NOT NULL
DROP PROCEDURE ADD_SIMPLE_SALE;

go

create procedure ADD_SIMPLE_SALE @pcustid int, @pprodid int, @pqty int AS

BEGIN

    BEGIN TRY

        declare @sum int, @custstatus NVARCHAR(10), @pstatus nvarchar(100), @price money, 
        @userid int, @userprodid int, @converteddate date;

        select @custstatus = [status] from customer where custid = @pcustid
        select @userid = custid from customer where custid = @pcustid
        select @price = selling_price from product where prodid = @pprodid
        select @userprodid = prodid from product where prodid = @pprodid;
  
        if @pqty < 1 or @pqty > 999
            THROW 50140, 'sale quantity outside valid range', 1
        if @pstatus != 'ok'
            throw 50150, 'customer status is not ok', 1
        if @userid is NULL
            throw 50160, 'customer id not found', 1
        if @userprodid is NULL
            throw 50170, 'product id not found', 1

        set @sum = @pqty * @price

        exec UPD_CUST_SALESYTD @pcustid = @pcustid, @pamt = @sum;
        exec UPD_PROD_SALESYTD @pprodid = @pprodid, @pamt = @sum;
        if @pprodid is NULL
            throw 50170, 'customer status is not ok', 1

    END TRY

    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END;
    END CATCH;

END;

GO


delete from SALE

GO

EXEC ADD_SIMPLE_SALE @pcustid = 2, @pprodid = 1003, @pqty = 5;

go


/* SUM_CUSTOMER_SALESYTD ------------------------------ COMPLETED 11/22 */

IF OBJECT_ID('SUM_CUSTOMER_SALESYTD') IS NOT NULL
DROP PROCEDURE SUM_CUSTOMER_SALESYTD;

go

create procedure SUM_CUSTOMER_SALESYTD AS

BEGIN

    BEGIN TRY

        return (select sum(sales_YTD) from customer)

    END TRY

    BEGIN CATCH

        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END;

    END CATCH;

END;

GO
-- works: prints sum of sales_ytd in customer table: 5700 
BEGIN
    declare @Cust_SalesYTD_Sum INT
    exec @Cust_SalesYTD_Sum = SUM_CUSTOMER_SALESYTD;
    print @Cust_SalesYTd_Sum
END

/* SUM_PRODUCT_SALESYTD ---------------------------- COMPLETED 12/22 */

IF OBJECT_ID('SUM_PRODUCT_SALESYTD') IS NOT NULL
DROP PROCEDURE SUM_PRODUCT_SALESYTD;

go

create procedure SUM_PRODUCT_SALESYTD AS

BEGIN

    BEGIN TRY

        return (select sum(sales_ytd) from product)

    END TRY

    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

go
-- works: prints sum of sales_ytd in product table: 1643 
BEGIN
    declare @prod_SalesYTD_Sum INT
    exec @prod_SalesYTD_Sum = SUM_product_SALESYTD;
    print @prod_SalesYTd_Sum
END

/* GET_ALL_CUSTOMERS ----------------------------------- COMPLETED 13/22 */

IF OBJECT_ID('GET_ALL_CUSTOMERS') IS NOT NULL
DROP PROCEDURE GET_ALL_CUSTOMERS;

go

create procedure GET_ALL_CUSTOMERS @poutcur CURSOR varying output AS

BEGIN
    set @poutcur = cursor for
    select * from customer;
    open @poutcur;
END;

go

BEGIN
declare @outcustcur as cursor;
declare @custname nvarchar(100), @custytd money, @custstatus NVARCHAR(10), @custid INT

exec GET_ALL_CUSTOMERS @poutcur = @outcustcur output;

fetch next from @outcustcur into @custid, @custname, @custytd, @custstatus;
while @@FETCH_STATUS = 0

BEGIN
    BEGIN TRY
        print concat('ID: ', @custid, ' / Name: ', @custname, ' / YTD: ', @custytd, ' / Status: ', @custstatus)
        fetch next from @outcustcur into @custid, @custname, @custytd, @custstatus;
    END TRY
    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH
END
-- works: prints 'ID: 1 / Name: Tom Cruise / YTD: 100.00 / Status: suspend'
close @outcustcur;
DEALLOCATE @outcustcur;

end

/* GET_ALL_PRODUCTS --------------------------------- COMPLETED 14/22 */

IF OBJECT_ID('GET_ALL_PRODUCTS') IS NOT NULL
DROP PROCEDURE GET_ALL_PRODUCTS;

go

create procedure GET_ALL_PRODUCTS @poutcur CURSOR varying output AS

BEGIN
    set @poutcur = cursor for
    select * from product;
    open @poutcur;
END;

go

BEGIN
declare @outprodcur as cursor;
declare @prodid INT, @prodname nvarchar(100), @prodprice money, @prodytd money; 

exec GET_ALL_PRODUCTS @poutcur = @outprodcur output;

fetch next from @outprodcur into @prodid, @prodname, @prodprice, @prodytd;
while @@FETCH_STATUS = 0

BEGIN
    BEGIN TRY
        print concat('ID: ', @prodid, ' / Name: ', @prodname, ' / Price: ', @prodprice, ' / YTD: ', @prodytd)
        fetch next from @outprodcur into @prodid, @prodname, @prodprice, @prodytd;
    END TRY
    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH
END

close @outprodcur;
DEALLOCATE @outprodcur;

end

/* ADD_LOCATION ---------------------------------- 15/22 */

IF OBJECT_ID('ADD_LOCATION') IS NOT NULL
DROP PROCEDURE ADD_LOCATION;

go

create procedure ADD_LOCATION @ploccode nvarchar(5), @pminqty int, @pmaxqty int AS

BEGIN

    BEGIN TRY

        insert into [LOCATION] (locid, minqty, maxqty) VALUES
        (@ploccode, @pminqty, @pmaxqty);


    END TRY

    BEGIN CATCH
        BEGIN
            if ERROR_NUMBER() = 2627
                throw

            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

GO

delete from [LOCATION]

exec add_location @ploccode = "Loc01", @pminqty = 1, @pmaxqty = 500
exec add_location @ploccode = "Loc02", @pminqty = 600, @pmaxqty = 999
exec add_location @ploccode = "Loc03", @pminqty = 100, @pmaxqty = 300
exec add_location @ploccode = "Loc04", @pminqty = 100, @pmaxqty = 700
exec add_location @ploccode = "Loc05", @pminqty = 300, @pmaxqty = 400
exec add_location @ploccode = "Loc06", @pminqty = 200, @pmaxqty = 800
exec add_location @ploccode = "Loc07", @pminqty = 1, @pmaxqty = 999

/* ADD_COMPLEX_SALE -------------------------------------- COMPLETED 16/22 */

IF OBJECT_ID('ADD_COMPLEX_SALE') IS NOT NULL
DROP PROCEDURE ADD_COMPLEX_SALE;

go

create procedure ADD_COMPLEX_SALE @pcustid int, @pprodid int, @pqty int, @pdate nvarchar(8) AS

BEGIN

    BEGIN TRY

        declare @sum int, @custstatus NVARCHAR(10), @price money, @userid int, 
        @userprodid int, @converteddate date;

        select @custstatus = [status] from customer where custid = @pcustid
        select @userid = custid from customer where custid = @pcustid
        select @price = selling_price from product where prodid = @pprodid
        select @userprodid = prodid from product where prodid = @pprodid;
        select @converteddate = convert(nvarchar, @pdate)
        
        if @pqty < 1 or @pqty > 999
            throw 50230, 'sale quantity outside valid range', 1
        if @custstatus != 'ok'
            throw 50240, 'customer status is not ok', 1
        if (select count(*) from customer where custid = @pcustid) = 0
            throw 50260, 'customer id not found', 1
        if (select count(*) from product where prodid = @pprodid) = 0
            throw 50270, 'product id not found', 1

        declare @seq bigINT
        set @seq = next value for SALE_SEQ
        set @sum = @pqty * @price

        exec UPD_CUST_SALESYTD @pcustid = @pcustid, @pamt = @sum;

        insert into sale (saleid, custid, prodid, qty, price, saledate)
        values (@seq, @pcustid, @pprodid, @pqty, @price, @converteddate)

    END TRY

    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

GO

exec ADD_COMPLEX_SALE @pcustid = 7, @pprodid = 1001, @pqty = 15, @pdate = 20200511;
exec ADD_COMPLEX_SALE @pcustid = 2, @pprodid = 1002, @pqty = 10, @pdate = 20190705;
exec ADD_COMPLEX_SALE @pcustid = 3, @pprodid = 1003, @pqty = 20, @pdate = 20180920;
exec ADD_COMPLEX_SALE @pcustid = 5, @pprodid = 1004, @pqty = 5, @pdate = 20170115;
exec ADD_COMPLEX_SALE @pcustid = 6, @pprodid = 1005, @pqty = 10, @pdate = 20190310;
exec ADD_COMPLEX_SALE @pcustid = 2, @pprodid = 1006, @pqty = 30, @pdate = 20200205;

go 

/* GET_ALLSALES -------------------------------------- COMPLETED 17/22 */

IF OBJECT_ID('GET_ALLSALES') IS NOT NULL
DROP PROCEDURE GET_ALLSALES;

go

create procedure GET_ALLSALES @poutcur cursor varying output AS

BEGIN
    set @poutcur = cursor for
    select * from sale
    open @poutcur;
END

go

BEGIN

declare @oSales as cursor;
declare @oSaleid bigint, @oCustid int, @oProdid int, @oQty int, @oPrice money, @oSalesDate DATE

exec get_allsales @poutcur = @oSales output;

fetch next from @oSales into @oSaleid, @oCustID, @oProdid, @oQty, @oPrice, @oSalesDate;
while @@FETCH_STATUS= 0

begin 
    BEGIN TRY
        print concat('Sale ID: ', @oSaleid, ', Customer: ', @ocustid, ' Product: ', @oprodid, ', Quantity: ', @oqty, ', Price: ', @oprice, ', Sale Date: ', @osalesdate)
        fetch next from @osales into @osaleid, @ocustid, @oprodid, @oqty, @oprice, @oSalesDate;
    END TRY
    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH
END

close @osales;
DEALLOCATE @osales;

END

GO

/* COUNT_PRODUCT_SALES ----------------------------------------------------------- 18/22 */

IF OBJECT_ID('COUNT_PRODUCT_SALES') IS NOT NULL
DROP PROCEDURE COUNT_PRODUCT_SALES;

go

create procedure COUNT_PRODUCT_SALES @pdays int AS

BEGIN

    BEGIN TRY

        declare @nndate DATE
        set @nndate = dateadd(DD, @pdays, SYSDATETIME());

        return (select count(*)
        from SALE where SALEDATE >= @nndate);

    END TRY

    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

GO

declare @salescount INT
-- works: returns 2 and only 2 sales have been logged in the last 365 days
exec @salescount = COUNT_PRODUCT_SALES @pdays = -365
print concat('Total sales: ', @salescount)

/* DELETE_SALE ------------------------------------------- 19/22 */

IF OBJECT_ID('DELETE_SALE') IS NOT NULL
DROP PROCEDURE DELETE_SALE;

go

create procedure DELETE_SALE AS

BEGIN

    BEGIN TRY

        declare @minsale int, @prodid int, @custid int, @saleprice money
        select @minsale = min(saleid) from sale;
        delete from sale where saleid = @minsale;

        if @minsale = null
            throw 50280, 'no sale rows found', 1

        else
        declare @sum money, @saleqty INT
        select @saleprice = price, @custid = custid, @saleqty = qty, @prodid = prodid
        from sale where saleid = @minsale
            set @sum = @saleqty * @saleprice
        
        exec UPD_CUST_SALESYTD @pcustid = @custid, @pamt = @sum;
        exec UPD_PROD_SALESYTD @pprodid = @prodid, @pamt = @sum;

    END TRY

    BEGIN CATCH
        if ERROR_NUMBER() = 50280
            throw
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

GO

exec DELETE_SALE

go

select*
from SALE
select *
from CUSTOMER
select *
from product
select *
from [Location]


/* DELETE_ALL_SALES ----------------------------------- COMPLETED 20/22 */

IF OBJECT_ID('DELETE_ALL_SALES') IS NOT NULL
DROP PROCEDURE DELETE_ALL_SALES;

go

create procedure DELETE_ALL_SALES AS

BEGIN

    BEGIN TRY

        DELETE from sale;
        update CUSTOMER set sales_ytd = 0;
        update product set sales_ytd = 0;


    END TRY

    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

GO

-- works 
-- exec DELETE_ALL_SALES


/* DELETE_CUSTOMER ------------------------------------------------------------------ COMPLETED 21/22 */

IF OBJECT_ID('DELETE_CUSTOMER') IS NOT NULL
DROP PROCEDURE DELETE_CUSTOMER;

go

create procedure DELETE_CUSTOMER @pcustid int AS

BEGIN

    BEGIN TRY

        delete from customer where @pcustid = custid
        if @@rowcount = 0
            THROW 50290, 'customer id not found', 1

    END TRY

    BEGIN CATCH
        
        if ERROR_NUMBER() = 547
            THROW 50300, 'Customer cannot be deleted as sales exist', 1

        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

GO

-- works: custid: 8 had no sales and id's on Customer table now go 6, 7, 9 (no 8)
EXEC DELETE_CUSTOMER @pcustid = 8

/* DELETE_PRODUCT ------------------------------------------------------------------ 22/22 */

IF OBJECT_ID('DELETE_PRODUCT') IS NOT NULL
DROP PROCEDURE DELETE_PRODUCT;

go

create procedure DELETE_PRODUCT @pprodid int AS

BEGIN

    BEGIN TRY
        delete from product where prodid = @pprodid
        if @@rowcount = 0
            THROW 50310, 'product id not found', 1
    END TRY

    BEGIN CATCH
        if ERROR_NUMBER() = 50310
            throw
        if ERROR_NUMBER() = 547
            throw 50320, 'product cannot delete product as sales exist', 1

        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

exec DELETE_PRODUCT @pprodid = 1002
