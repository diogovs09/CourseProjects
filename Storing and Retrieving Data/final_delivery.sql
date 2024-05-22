DROP DATABASE IF EXISTS book_db;
CREATE DATABASE book_db;
USE book_db;

/*==============================================================*/
/* Table: ADDRESSES                                             */
/*==============================================================*/
CREATE TABLE ADDRESSES
(
   ADDRESS_ID           INTEGER        AUTO_INCREMENT  NOT NULL,
   STREET               LONG VARCHAR                   NOT NULL,
   CITY                 VARCHAR(100)                   NOT NULL,
   STATE                VARCHAR(100)                   NOT NULL,
   COUNTRY              VARCHAR(100)                   NOT NULL,
   ZIP_CODE             VARCHAR(20)                    NOT NULL,
   PRIMARY KEY (ADDRESS_ID)
);

/*==============================================================*/
/* Table: AUTHORS                                               */
/*==============================================================*/
CREATE TABLE AUTHORS
(
   AUTHOR_ID             INTEGER     AUTO_INCREMENT  NOT NULL,
   AuthorName            VARCHAR(80)     UNIQUE         NOT NULL,
   BirthDate             DATE,
   PRIMARY KEY (AUTHOR_ID)
);

/*==============================================================*/
/* Table: PUBLISHERS                                            */
/*==============================================================*/
CREATE TABLE PUBLISHERS
(
   PUBLISHER_ID          INTEGER   AUTO_INCREMENT NOT NULL,
   PublisherName         VARCHAR(40)                    NOT NULL,
   Country               VARCHAR(40),
   PRIMARY KEY (PUBLISHER_ID)
);


/*==============================================================*/
/* Table: BOOKS                                                 */
/*==============================================================*/
CREATE TABLE BOOKS
(
   ISBN                 VARCHAR(20)                    NOT NULL,
   PUBLISHER_ID         INTEGER                       NOT NULL,
   TITLE                VARCHAR(100)                   NOT NULL,
   PRICE                NUMERIC(8,2)                   NOT NULL,
   YEAR                 VARCHAR(4),
   PRIMARY KEY (ISBN),
   FOREIGN KEY (PUBLISHER_ID) REFERENCES PUBLISHERS(PUBLISHER_ID) ON DELETE CASCADE ON UPDATE CASCADE
);


/*==============================================================*/
/* Table: AUTHOR_BOOKS                                          */
/*==============================================================*/
CREATE TABLE AUTHOR_BOOKS
(
   ISBN                 VARCHAR(20)                    NOT NULL,
   AUTHOR_ID            INTEGER                        NOT NULL,
   PRIMARY KEY (ISBN, AUTHOR_ID),
   FOREIGN KEY (ISBN) REFERENCES BOOKS(ISBN) ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (AUTHOR_ID) REFERENCES AUTHORS(AUTHOR_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

/*==============================================================*/
/* Table: CUSTOMERS                                             */
/*==============================================================*/
CREATE TABLE CUSTOMERS
(
   USER_ID              INTEGER        AUTO_INCREMENT  NOT NULL,
   ADDRESS_ID           INTEGER                        NOT NULL,
   FIRST_NAME           VARCHAR(50)                    NOT NULL,
   LAST_NAME            VARCHAR(50)                    NOT NULL,
   EMAIL                VARCHAR(100)    UNIQUE         NOT NULL,
   PHONE_NR             VARCHAR(100)    UNIQUE,
   TIN                  CHAR(10)        UNIQUE,
   PRIMARY KEY (USER_ID),
   FOREIGN KEY (ADDRESS_ID) REFERENCES ADDRESSES(ADDRESS_ID) ON DELETE CASCADE ON UPDATE CASCADE
);


/*==============================================================*/
/* Table: WAREHOUSES                                            */
/*==============================================================*/
CREATE TABLE WAREHOUSES
(
   WAREHOUSE_ID         INTEGER   AUTO_INCREMENT       NOT NULL,
   CAPACITY             INTEGER                        NOT NULL,
   REGION               VARCHAR(50)                    NOT NULL,
   PRIMARY KEY (WAREHOUSE_ID)
);


/*==============================================================*/
/* Table: WAREHOUSE_BOOKS                                       */
/*==============================================================*/
CREATE TABLE WAREHOUSE_BOOKS
(
   ISBN                 VARCHAR(20)                    NOT NULL,
   WAREHOUSE_ID         INTEGER                        NOT NULL,
   STOCK                INTEGER                        NOT NULL,
   PRIMARY KEY (ISBN, WAREHOUSE_ID),
   FOREIGN KEY (ISBN) REFERENCES BOOKS(ISBN) ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (WAREHOUSE_ID) REFERENCES WAREHOUSES(WAREHOUSE_ID) ON DELETE CASCADE ON UPDATE CASCADE
);


/*==============================================================*/
/* Table: LOGS                                                  */
/*==============================================================*/
CREATE TABLE LOGS_
(
   LOG_ID               INTEGER        AUTO_INCREMENT  NOT NULL,
   DATE                 DATE 	DEFAULT (CURRENT_DATE) NOT NULL,
   CART_ID              INTEGER                        NOT NULL,
   STATUS               VARCHAR(20)                    NOT NULL,
   CONSTRAINT CKC_STATUS_LOGS CHECK (STATUS IN ('Waiting', 'Sold', 'Expired')),
   PRIMARY KEY (LOG_ID)
);

/*==============================================================*/
/* Table: CARTS                                                 */
/*==============================================================*/
CREATE TABLE CARTS
(
   CART_ID              INTEGER        AUTO_INCREMENT  NOT NULL,
   USER_ID              INTEGER                        NOT NULL,
   SUBTOTAL             NUMERIC(8,2)                   NOT NULL,
   DISCOUNT             FLOAT,
   TAX_RATE             FLOAT                          NOT NULL,
   -- TOTAL_COST           NUMERIC(8,2)                   NOT NULL,
   PRIMARY KEY (CART_ID),
   FOREIGN KEY (USER_ID) REFERENCES CUSTOMERS(USER_ID) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Add FOREIGN KEY constraint to LOGS table
ALTER TABLE LOGS_
ADD CONSTRAINT FK_LOGS_CART_ID
FOREIGN KEY (CART_ID) REFERENCES CARTS(CART_ID)
ON DELETE CASCADE ON UPDATE CASCADE;


/*==============================================================*/
/* Table: CART_ITEMS                                            */
/*==============================================================*/
CREATE TABLE CART_ITEMS
(
   ISBN                 VARCHAR(20)                    NOT NULL,
   CART_ID              INTEGER                        NOT NULL,
   QUANTITY             INTEGER                        NOT NULL,
   PRIMARY KEY (ISBN, CART_ID),
   FOREIGN KEY (ISBN) REFERENCES BOOKS(ISBN) ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (CART_ID) REFERENCES CARTS(CART_ID) ON DELETE CASCADE ON UPDATE CASCADE
);


/*==============================================================*/
/* Table: RATING                                           */
/*==============================================================*/
CREATE TABLE RATING
(
    USER_ID    INTEGER                        NOT NULL,
    BOOK_ID    VARCHAR(20)                    NOT NULL,
    RATING     INTEGER CHECK (RATING >= 0 AND RATING <= 5),
    COMMENT    TEXT,
    PRIMARY KEY (USER_ID, BOOK_ID),
    FOREIGN KEY (USER_ID) REFERENCES CUSTOMERS(USER_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BOOK_ID) REFERENCES BOOKS(ISBN) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Insert data into the ADDRESSES table
INSERT INTO ADDRESSES (STREET, CITY, STATE, COUNTRY, ZIP_CODE)
VALUES
('123 Main St', 'New York', 'NY', 'USA', '10001'),
('456 Broadway', 'Los Angeles', 'CA', 'USA', '90012'),
('789 Market St', 'San Francisco', 'CA', 'USA', '94105');

-- Insert data into the AUTHORS table
INSERT INTO AUTHORS (AuthorName, BirthDate)
VALUES
('Adam Sandler', '1990-01-01'),
('Kevin Hart', '1995-01-01'),
('Nicholas Sparks', '2000-01-01');

-- Insert data into the PUBLISHERS table
INSERT INTO PUBLISHERS (PublisherName, Country)
VALUES
('Chubby New York Times', 'USA'),
('Moose Books', 'Canada'),
('Fish & Chips Publishing', 'UK');

-- Insert data into the BOOKS table
INSERT INTO BOOKS (ISBN, PUBLISHER_ID, TITLE, PRICE, YEAR)
VALUES
('1234567890', 1, 'Snuggle Puppy', 10.00, '2020'),
('2345678901', 2, 'How to tell if your cat is plotting to kill you', 20.00, '2021'),
('3456789012', 3, 'The notebook', 30.00, '2022');

-- Insert data into the AUTHOR_BOOKS table
INSERT INTO AUTHOR_BOOKS (ISBN, AUTHOR_ID)
VALUES
('1234567890', 1),
('2345678901', 2),
('3456789012', 3);

-- Insert data into the CUSTOMERS table
INSERT INTO CUSTOMERS (USER_ID, ADDRESS_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NR, TIN)
VALUES
(1, 1, 'Mike', 'Tyson', 'dynamite@gmail.com', '123-456-7890', '1234567890'),
(2, 2, 'Dwayne', 'Johnson', 'therock123@gmail.com', '234-567-8901', '2345678901'),
(3, 3, 'John', 'Cena', 'chaingang765@example.com', '345-678-9012', '3456789012'),
(4, 3, 'Meryl', 'Streep', 'merylstrp@example.com', '345-457-7846', '4732572658');

-- Insert data into the WAREHOUSES table
INSERT INTO WAREHOUSES (CAPACITY, REGION)
VALUES
(1000, 'East'),
(2000, 'West'),
(3000, 'South');

-- Insert data into the WAREHOUSE_BOOKS table
INSERT INTO WAREHOUSE_BOOKS (ISBN, WAREHOUSE_ID, STOCK)
VALUES
('1234567890', 1, 100),
('2345678901', 2, 200),
('3456789012', 3, 300);

-- Insert data into the CARTS table
INSERT INTO CARTS (USER_ID, SUBTOTAL, DISCOUNT, TAX_RATE)
VALUES
(1, 50.00, 10.00, 5),
(2, 20.00, 20.00, 7),
(3, 30.00, 30.00, 5),
(4, 60.00, 0.00, 5);

-- Insert data into the LOGS table
INSERT INTO LOGS_ (DATE, CART_ID, STATUS)
VALUES
('2020-01-01', 1, 'Waiting'),
('2020-01-02', 1, 'Sold'),
('2021-10-01', 2, 'Waiting'),
('2021-10-02', 2, 'Sold'),
('2021-12-31', 3, 'Waiting'),
('2022-01-02', 3, 'Expired'),
('2023-04-02', 4, 'Waiting'),
('2023-04-03', 4, 'Sold');

-- Insert data into the CART_ITEMS table
INSERT INTO CART_ITEMS (ISBN, CART_ID, QUANTITY)
VALUES
('1234567890', 1, 3),
('2345678901', 1, 1),
('2345678901', 2, 1),
('3456789012', 3, 2),
('1234567890', 4, 4);

-- Insert data into the RATING table
INSERT INTO RATING (USER_ID, BOOK_ID, RATING, COMMENT)
VALUES
(1, '1234567890', 4, 'Enjoyed the plot and characters.'),
(2, '2345678901', 5, 'Excellent book! Highly recommend.'),
(3, '3456789012', 3, 'Average read, nothing special.');

-- TRIGGERS
-- use book_db;
DELIMITER //
-- trigger 1 which updates stock on new cart_item added
	CREATE TRIGGER tr_stock_update AFTER INSERT ON CART_ITEMS
	FOR EACH ROW
	BEGIN
		UPDATE WAREHOUSE_BOOKS
		SET STOCK = STOCK - NEW.QUANTITY
		WHERE ISBN = NEW.ISBN;
	END//

-- trigger 2 which inserts new log row when new cart is created
	CREATE TRIGGER tr_new_log AFTER INSERT ON CARTS
	FOR EACH ROW
	BEGIN
		INSERT INTO LOGS_ (DATE, CART_ID, STATUS)
		VALUES (CURDATE(), NEW.CART_ID, 'Waiting');
	END//
    
-- trigger 3 that updates subtotal every time new item is added
	CREATE TRIGGER tr_update_subtotal
	BEFORE INSERT ON CART_ITEMS
	FOR EACH ROW
	BEGIN
		DECLARE item_price DECIMAL(4,2);
		-- Calculate the item price
		SELECT PRICE INTO item_price FROM BOOKS WHERE ISBN = NEW.ISBN;

		-- Update CARTS['Subtotal'] if needed
		UPDATE CARTS
		SET SUBTOTAL = SUBTOTAL + (item_price * NEW.QUANTITY)
		WHERE CART_ID = NEW.CART_ID
		AND SUBTOTAL != SUBTOTAL + (item_price * NEW.QUANTITY);
	END //
DELIMITER ;

-- Create Event to run every X time that checks any expired carts and does the following:
	-- (1)insert new logs record 'Expired'
	-- (2)update back warehouse stock 
	-- (3)delete cart_items 
    -- (4)update subtotals to 0
	-- NOTE: Expired is defined as 2 days old or more
	DELIMITER //
		SET GLOBAL event_scheduler = ON;
		CREATE EVENT check_expired_carts
		-- (for testing we do 5 sec)
		ON SCHEDULE EVERY 5 SECOND
		DO
		BEGIN
			DECLARE expired_cart_id INT;
			DECLARE cart_cursor CURSOR FOR
				SELECT CART_ID FROM LOGS_
				WHERE STATUS = 'Waiting'
				AND DATE < DATE_SUB(CURDATE(), INTERVAL 2 DAY)
				AND CART_ID NOT IN (
					SELECT DISTINCT CART_ID FROM LOGS_
					WHERE STATUS = 'Expired' OR STATUS = 'Sold'
				);

			OPEN cart_cursor;
			cart_loop: LOOP
				FETCH cart_cursor INTO expired_cart_id;
				IF expired_cart_id IS NULL THEN
					LEAVE cart_loop;
				END IF;

				-- Create new log row with status 'Expired' for the same cart_id
				INSERT INTO LOGS_ (DATE, CART_ID, STATUS)
				VALUES (CURDATE(), expired_cart_id, 'Expired');

				-- Update warehouse stock (adding it back from cart_items)
				UPDATE WAREHOUSE_BOOKS WB
				INNER JOIN CART_ITEMS CI ON WB.ISBN = CI.ISBN
				SET WB.STOCK = WB.STOCK + CI.QUANTITY
				WHERE CI.CART_ID = expired_cart_id;
                
                -- Delete cart_items rows associated with that cart_id
				DELETE FROM CART_ITEMS
				WHERE CART_ID = expired_cart_id;
                
                -- Update subtotal values to 0
                UPDATE CARTS CA
                SET SUBTOTAL = 0
                WHERE CART_ID = expired_cart_id;
                
			END LOOP;

			CLOSE cart_cursor;
		END //
	DELIMITER ;
    
-- VIEWS
    
USE book_db;

-- 1)
CREATE VIEW invoice_head_totals AS
SELECT c.FIRST_NAME, c.LAST_NAME, 
		a.STREET, a.CITY, a.STATE, a.COUNTRY, a.ZIP_CODE,
        ca.CART_ID as Invoice_Number,
        l.DATE as Date_of_Issue, DATE_ADD(l.DATE, INTERVAL 2 DAY) as Payment_Limit_Date,
        ca.SUBTOTAL, ca.DISCOUNT, ca.TAX_RATE, 
        ca.SUBTOTAL * (1-(ca.DISCOUNT/100)) * (ca.TAX_RATE/100) as TAX,
        ca.SUBTOTAL * (1-(ca.DISCOUNT/100)) * (1 + ca.TAX_RATE/100) as TOTAL
FROM CUSTOMERS c, ADDRESSES a, CARTS ca, LOGS_ l
WHERE c.ADDRESS_ID = a.ADDRESS_ID 
	AND ca.USER_ID = c.USER_ID 
    AND l.CART_ID = ca.CART_ID
    AND l.STATUS = 'Waiting';
    
SELECT * FROM invoice_head_totals;
    
-- 2)
CREATE VIEW invoice_details AS
SELECT b.TITLE AS DESCRIPTION, b.ISBN as REFERENCE, b.Price AS UNIT_COST, 
		ci.QUANTITY, ci.QUANTITY * b.PRICE AS AMOUNT
FROM CARTS c, CART_ITEMS ci, BOOKS b
WHERE c.CART_ID = ci.CART_ID
	AND b.ISBN = ci.ISBN;

SELECT * FROM invoice_details;