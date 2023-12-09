/*3. Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are specified.
Create tables for the following schema listed below by properly specifying the primary keys and foreign keys.
Enter at least five tuples for each relation.
Order processing database
Customer (Cust#:int, cname: string, city: string)
Order (order#:int, odate: date, cust#: int, order-amt: int)
Order-item (order#:int, Item#: int, qty: int)
Item (item#:int, unitprice: int)
Shipment (order#:int, warehouse#: int, ship-date: date)
Warehouse (warehouse#:int, city: string)
1.	List the Order# and Ship_date for all orders shipped from Warehouse# "W2". 
2.	List the Warehouse information from which the Customer named "Kumar" was supplied his orders. Produce a listing of Order#, Warehouse#. 
3.	Produce a listing: Cname, #ofOrders, Avg_Order_Amt, where the middle column is the total number of orders by the customer and the last column is the average order amount for that customer. (Use aggregate functions) 
4.	Delete all orders for customer named "Kumar". 
5.	Find the item with the maximum unit price. 
6.	A trigger that updates order_amout based on quantity and unitprice of order_item
7.	Create a view to display orderID and shipment date of all orders shipped from a warehouse 
*/
create database orderp;
use orderp;

CREATE TABLE Customer (
    cid INT PRIMARY KEY,
    cname VARCHAR(25),
    city VARCHAR(25)
);

CREATE TABLE OrderTable (
    orders INT PRIMARY KEY,
    odate DATE,
    cid INT,
    order_amt INT,
    FOREIGN KEY (cid) REFERENCES Customer(cid)
);

CREATE TABLE Item (
    item INT PRIMARY KEY,
    unitprice INT
);
CREATE TABLE OrderItem (
    orders INT,
    item INT,
    qty INT,
    PRIMARY KEY (orders, item),
    FOREIGN KEY (orders) REFERENCES OrderTable(orders),
    FOREIGN KEY (item) REFERENCES Item(item)
);

CREATE TABLE Warehouse (
    warehouse INT PRIMARY KEY,
    city VARCHAR(255)
);

CREATE TABLE Shipment (
    orders INT,
    warehouse INT,
    ship_date DATE,
    PRIMARY KEY (orders,warehouse),
    FOREIGN KEY (orders) REFERENCES OrderTable(orders),
    FOREIGN KEY (warehouse) REFERENCES Warehouse(warehouse)
);

-- Insert into Customer
INSERT INTO Customer VALUES (1, 'Kumar', 'City1');
INSERT INTO Customer VALUES (2, 'John', 'City2');
INSERT INTO Customer VALUES (3, 'mary', 'City3');
INSERT INTO Customer VALUES (4, 'cindy', 'City4');
INSERT INTO Customer VALUES (5, 'andy', 'City5');
-- Add more tuples as needed


-- Insert into Item
INSERT INTO Item VALUES (1, 50);
INSERT INTO Item VALUES (2, 30);
INSERT INTO Item VALUES (3, 10);
INSERT INTO Item VALUES (4, 20);
INSERT INTO Item VALUES (5, 40);
-- Add more tuples as needed

-- Insert into OrderTable
INSERT INTO OrderTable VALUES (101, '2023-01-01', 1, 500);
INSERT INTO OrderTable VALUES (102, '2023-02-01', 2, 700);
INSERT INTO OrderTable VALUES (103, '2023-03-01', 3, 200);
INSERT INTO OrderTable VALUES (104, '2023-04-01', 4, 800);
INSERT INTO OrderTable VALUES (105, '2023-05-01', 5, 400);
-- Add more tuples as needed

-- Insert into Warehouse
INSERT INTO Warehouse VALUES (1, 'City1');
INSERT INTO Warehouse VALUES (2, 'City2');
INSERT INTO Warehouse VALUES (3, 'City3');
INSERT INTO Warehouse VALUES (4, 'City4');
INSERT INTO Warehouse VALUES (5, 'City5');
-- Add more tuples as needed

-- Insert into OrderItem
INSERT INTO OrderItem VALUES (101, 1, 2);
INSERT INTO OrderItem VALUES (101, 2, 1);
INSERT INTO OrderItem VALUES (102, 3, 4);
INSERT INTO OrderItem VALUES (103, 1, 6);
INSERT INTO OrderItem VALUES (104, 2, 1);
-- Add more tuples as needed

-- Insert into Shipment
INSERT INTO Shipment VALUES (101, 1, '2023-01-10');
INSERT INTO Shipment VALUES (102, 2, '2023-02-10');
INSERT INTO Shipment VALUES (103, 3, '2023-03-10');
INSERT INTO Shipment VALUES (104, 4, '2023-04-10');
INSERT INTO Shipment VALUES (105, 5, '2023-05-10');
-- Add more tuples as needed

select *from customer;
select *from item;
select *from orderitem;
select *from ordertable;
select *from shipment;
select *from warehouse;

#queries
SELECT S.orders, S.ship_date
FROM Shipment S
WHERE S.warehouse = (SELECT W.warehouse FROM Warehouse W WHERE W.city = 'City2');

SELECT O.orders, S.warehouse
FROM OrderTable O
JOIN Shipment S ON O.orders = S.orders
JOIN Warehouse W ON S.warehouse = W.warehouse
WHERE O.cid = (SELECT C.cid FROM Customer C WHERE C.cname = 'Kumar');

update ordertable set cid=3 where orders=103;
update ordertable set cid=4 where orders=104;
update ordertable set cid=5 where orders=105;

SELECT C.cname, COUNT(O.orders) AS ofOrders, AVG(O.order_amt) AS Avg_Order_Amt
FROM Customer C
LEFT JOIN OrderTable O ON C.cid = O.cid
GROUP BY C.cname;

SELECT C.cid FROM Customer C WHERE C.cname = 'Kumar';

-- Delete records from Shipment associated with the orders for the customer named "Kumar"
DELETE FROM Shipment
WHERE orders IN (SELECT orders FROM OrderTable WHERE cid = (SELECT cid FROM Customer WHERE cname = 'Kumar'));

-- Delete records from OrderItem associated with the customer named "Kumar"
DELETE FROM OrderItem
WHERE orders IN (SELECT orders FROM OrderTable WHERE cid = (SELECT cid FROM Customer WHERE cname = 'Kumar'));

-- Delete orders for the customer named "Kumar" along with associated records in OrderItem
DELETE FROM OrderTable
WHERE cid= (SELECT cid FROM Customer WHERE cname = 'Kumar');

select *from OrderTable;
select *from customer;
select *from orderitem;
select *from shipment;

SELECT * FROM Item
WHERE unitprice = (SELECT MAX(unitprice) FROM Item);


DELIMITER //
CREATE TRIGGER update_order_amount
AFTER INSERT ON OrderItem
FOR EACH ROW
BEGIN
    UPDATE OrderTable
    SET order_amt = order_amt + NEW.qty * (SELECT unitprice FROM Item WHERE item = NEW.item)
    WHERE orders = NEW.orders;
END;

//DELIMITER ;
INSERT INTO OrderTable VALUES (106, '2023-06-01', 1, 500);
INSERT INTO OrderItem VALUES (106, 1, 5);
select *from item;
select *from ordertable;

CREATE VIEW ShippedOrdersView AS
SELECT S.orders, S.ship_date
FROM Shipment S;
select *from shippedordersview;