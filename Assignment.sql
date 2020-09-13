use assignment

/* to do
finish 15/22
18/22 not sure if working
21/22 still need: 50320. Product cannot be deleted as sales exist
22/22 still need: 50320. Product cannot be deleted as sales exist

*/

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

/* ADD_CUSTOMER ------------------------------------------------------------------ 1/22 COMPLETED */


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


/* DELETE_ALL_CUSTOMERS --------------------------------------------------------------- 2/22 COMPLETED */

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

EXEC ADD_CUSTOMER @pcustID = 2, @pcustname = 'testdude3';
EXEC ADD_CUSTOMER @pcustID = 3, @pcustname = 'testdude3';

exec DELETE_ALL_CUSTOMERS;

GO

select * from customer;

*/

/* ADD_PRODUCT ---------------------------------------------------------------- 3/22 COMPLETED */

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

/* DELETE_ALL_PRODUCTS ----------------------------------------------------------------- 4/22 COMPLETED */

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

/* GET_CUSTOMER_STRING -------------------------------------------------------------------- COMPLETED 5/22 */

/*
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
            THROW 50060, 'Customer ID not found', 1

        SET @preturnstring = CONCAT('CustID: ', @pcustID, ' Name: ', @custname, ' Status', @status, ' SalesYTD: ', @ytd);

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

BEGIN

    DECLARE @outputvalue NVARCHAR(100);
    EXEc GET_CUSTOMER_STRING @pcustID = 1, @preturnstring = @outputvalue OUTPUT;
    print (@outputvalue)

END

*/

/* UPD_CUST_SALESYTD ---------------------------------------------------------------------- COMPLETED 6/22 */

/*

IF OBJECT_ID('UPD_CUST_SALESYTD') IS NOT NULL
DROP PROCEDURE UPD_CUST_SALESYTD;

go

create procedure UPD_CUST_SALESYTD @pcustid int, @pamt int AS

BEGIN

    BEGIN TRY

        DECLARE @ytd money;
        SELECT @ytd = sales_ytd from CUSTOMER where custid = @pcustid;

        IF @pamt < -999.99 OR @pamt > 999.99
            THROW 50080, 'Amount out of range', 1

        ELSE 
            BEGIN
                UPDATE customer
                set SALES_YTD = @ytd + @pamt
                WHERE CUSTID = @pcustid
            END

    END TRY

    BEGIN CATCH

        if @@ROWCOUNT = 0
            THROW 50070, 'Customer ID not found', 1

        ELSE
            BEGIN
                DECLARE @errormessage NVARCHAR(max) = error_message();
                THROW 50000, @errormessage, 1
            END

    END CATCH;

END;

GO
 
EXEC UPD_CUST_SALESYTD @pcustid = 2, @pamt = 700.00;
EXEC UPD_CUST_SALESYTD @pcustid = 3, @pamt = 100.00;
EXEC UPD_CUST_SALESYTD @pcustid = 1, @pamt = 50.00;

Select *
From customer;

*/


/* GET_PROD_STRING ----------------------------------------------------------------- COMPLETED 7/22 */

/*

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
        
        SET @pReturnString = concat('Prodid: ', @pprodid, ' ','Name: ', @pprodname, ' ',  'Price: ' , @sellprice ,' ','SalesYTD: ',@ytd);

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
BEGIN
    DECLARE @externalParam NVARCHAR(100)
    EXEC GET_PROD_STRING @pprodid = 1, @pReturnString = @externalParam OUTPUT
    print @externalParam
END 
GO

*/

/* UPD_PROD_SALESYTD ---------------------------------------------------------------------- COMPLETED 8/22 */

/*

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

    END TRY

    BEGIN CATCH

        BEGIN

            if @@ROWCOUNT = 0
            THROW 50070, 'Customer ID not found', 1

        ELSE
            BEGIN
                DECLARE @errormessage NVARCHAR(max) = error_message();
                THROW 50000, @errormessage, 1
            END
        END

    END CATCH;

END;

GO


exec UPD_PROD_SALESYTD @pprodid = 1, @pamt = 696
exec UPD_PROD_SALESYTD @pprodid = 4, @pamt = 727

select *
from product

GO

*/


/* UPD_CUSTOMER_STATUS ---------------------------------------------------------------- COMPLETED 9/22 */

/*

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

exec UPD_CUSTOMER_STATUS @pcustid = 2, @pstatus = 'suspend';

select *
from customer

*/

/* ADD_SIMPLE_SALE --------------------------------------------------------------------- COMPLETED 10/22 */

/*

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

BEGIN
EXEC ADD_SIMPLE_SALE @pcustid = 1, @pprodid = 2, @pqty = 30;
end

go

select *
from CUSTOMER

select *
from product

*/

/* SUM_CUSTOMER_SALESYTD -------------------------------------------------------------- COMPLETED 11/22 */

/*

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

insert into customer values
(5, 'Freddy', 1000, 'ok');

GO

-- works: the extra 1000 from Freddy is added to the return total
declare @Cust_SalesYTD_Sum INT
exec @Cust_SalesYTD_Sum = SUM_CUSTOMER_SALESYTD;
print @Cust_SalesYTd_Sum

go

*/

/* SUM_PRODUCT_SALESYTD --------------------------------------------------------------- COMPLETED 12/22 */

/*

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


GO

-- insert into product values
-- (5, 'super beef', 30, 1000);

go

-- first try: 1953 (adding a product with 1000 sales_ytd next)
-- second try: 2953, works
declare @prod_SalesYTD_Sum INT
exec @prod_SalesYTD_Sum = SUM_product_SALESYTD;
print @prod_SalesYTd_Sum

*/

/* GET_ALL_CUSTOMERS ----------------------------------------------------------------------- COMPLETED 13/22 */

/*

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
        print concat('ID: ', @custid, ', Name: ', @custname, ', YTD: ', @custytd, ', Status: ', @custstatus)
        fetch next from @outcustcur into @custid, @custname, @custytd, @custstatus;
    END TRY
    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH
END

close @outcustcur;
DEALLOCATE @outcustcur;

end

*/

/* GET_ALL_PRODUCTS ---------------------------------------------------------------- COMPLETED 14/22 */

/*

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
        print concat('ID: ', @prodid, ', Name: ', @prodname, ', Price: ', @prodprice, ', YTD: ', @prodytd)
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

*/

/* ADD_LOCATION -------------------------------------------------------------------- 15/22 */

/*
IF OBJECT_ID('ADD_LOCATION') IS NOT NULL
DROP PROCEDURE ADD_LOCATION;

go

create procedure ADD_LOCATION @ploccode nvarchar(5), @pminqty int, @pmaxqty int AS

BEGIN

    BEGIN TRY

        insert into [LOCATION] (locid, minqty, maxqty) VALUES
        (@ploccode, @pminqty, @pmaxqty);

        if 

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
insert into [LOCATION] (locid, minqty, maxqty)
VALUES ('loc69', 10, 100),
('loc69', 10, 100)

go

select *
from LOCATION
*/

/* ADD_COMPLEX_SALE ------------------------------------------------------------------- COMPLETED 16/22 */

/*
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

        -- saleid comes out negative, not sure if supposed to

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

exec ADD_COMPLEX_SALE @pcustid = 1, @pprodid = 3, @pqty = 10, @pdate = 20200505;

select * from SALE;
select * from product;

*/


/* GET_ALLSALES ---------------------------------------------------------------- COMPLETED 17/22 */

/*

IF OBJECT_ID('GET_ALLSALES') IS NOT NULL
DROP PROCEDURE GET_ALLSALES;

go

create procedure GET_ALLSALES @poutcur cursor varying output AS

BEGIN
    set @poutcur = cursor for
    select * from sale
    open @poutcur;
END

BEGIN

    BEGIN TRY

        declare @oSales as cursor;
        declare @oSaleid bigint, @oCustid int, @oProdid int, @oQty int, @oPrice money, @oSalesDate DATE

        exec get_allsales @poutcur = @oSales output;

        fetch next from @oSales into @oSaleid, @oCustID, @oProdid, @oQty, @oPrice, @oSalesDate;

        begin 
            print concat('sale id: ', @oSaleid, ', customer: ', @ocustid, ' product: ', @oprodid, ', quantity: ', @oqty, ', price: ', @oprice, ', sale date: ', @osalesdate)
            fetch next from @osales into @osaleid, @ocustid, @oprodid, @oqty, @oprice, @oSalesDate;
        END

        close @osales;
        DEALLOCATE @osales;

    END TRY

    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END;
    END CATCH

END;

GO

*/

/* COUNT_PRODUCT_SALES ----------------------------------------------------------- 18/22 */

/*
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
exec @salescount = COUNT_PRODUCT_SALES @pdays = -10
print concat()
*/

/* DELETE_SALE ------------------------------------------------------------------- 19/22 */

/*
IF OBJECT_ID('') IS NOT NULL
DROP PROCEDURE _;

go

create procedure _ AS

BEGIN

    BEGIN TRY



    END TRY

    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

GO
*/

/* DELETE_ALL_SALES ------------------------------------------------------------------ COMPLETED 20/22 */

/*

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

exec DELETE_ALL_SALES

go

select * from PRODUCT
select * from customer
select * from sale

*/

/* DELETE_CUSTOMER ------------------------------------------------------------------ COMPLETED 21/22 */

/*

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

-- still need to add THROW 50300, 'Customer cannot be deleted as sales exist', 1

    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

GO

EXEC DELETE_CUSTOMER @pcustid = 2

select * from CUSTOMER

*/

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
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

GO

exec DELETE_PRODUCT @pprodid = 1



select *
from product

/* quick tsql setup 

IF OBJECT_ID('') IS NOT NULL
DROP PROCEDURE _;

go

create procedure _ AS

BEGIN

    BEGIN TRY



    END TRY

    BEGIN CATCH
        BEGIN
            declare @errormessage nvarchar(max) = error_message();
            throw 50000, @errormessage, 1
        END
    END CATCH;

END;

GO

*/