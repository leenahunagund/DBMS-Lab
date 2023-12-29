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
drop database if exists order_processing;
create database order_processing;
use order_processing;
create table if not exists Customers (
cust_id int primary key,
cname varchar(35) not null,
city varchar(35) not null
);
create table if not exists Orders (
order_id int primary key,
odate date not null,
cust_id int,
order_amt int not null,
foreign key (cust_id) references Customers(cust_id) on delete cascade
);
create table if not exists Items (
item_id int primary key,
unitprice int not null
);
create table if not exists OrderItems (
order_id int not null,
item_id int not null,
qty int not null,
foreign key (order_id) references Orders(order_id) on delete cascade,
foreign key (item_id) references Items(item_id) on delete cascade
);
create table if not exists Warehouses (
warehouse_id int primary key,
city varchar(35) not null
);
create table if not exists Shipments (
order_id int not null,
warehouse_id int not null,
ship_date date not null,
foreign key (order_id) references Orders(order_id) on delete cascade,
foreign key (warehouse_id) references Warehouses(warehouse_id) on delete cascade
);

INSERT INTO Customers VALUES
(0001, "Customer_1", "Mysuru"),
(0002, "Customer_2", "Bengaluru"),
(0003, "Kumar", "Mumbai"),
(0004, "Customer_4", "Dehli"),
(0005, "Customer_5", "Bengaluru");
INSERT INTO Orders VALUES
(001, "2020-01-14", 0001, 2000),
(002, "2021-04-13", 0002, 500),
(003, "2019-10-02", 0003, 2500),
(004, "2019-05-12", 0005, 1000),
(005, "2020-12-23", 0004, 1200);
INSERT INTO Items VALUES
(0001, 400),
(0002, 200),
(0003, 1000),
(0004, 100),
(0005, 500);
INSERT INTO Warehouses VALUES
(0001, "Mysuru"),
(0002, "Bengaluru"),
(0003, "Mumbai"),
(0004, "Dehli"),
(0005, "Chennai");
INSERT INTO OrderItems VALUES
(001, 0001, 5),
(002, 0005, 1),
(003, 0005, 5),
(004, 0003, 1),
(005, 0004, 12);
INSERT INTO Shipments VALUES
(001, 0002, "2020-01-16"),
(002, 0001, "2021-04-14"),
(003, 0004, "2019-10-07"),
(004, 0003, "2019-05-16"),
(005, 0005, "2020-12-23");
select *from customers;
select *from orders;
select *from orderitems;
select *from items;
select *from shipments;
select *from warehouses;

#q1 
select order_id , ship_date from shipments where warehouse_id like "%1%";

#q2 
select s.order_id, s.warehouse_id from orders o ,shipments s , customers c where s.order_id=o.order_id and o.cust_id=c.cust_id and c.cname like "%kumar%";
#select order_id,warehouse_id from Warehouses natural join Shipments where order_id in (select order_id from Orders where cust_id in (Select cust_id from Customers where cname like "%Kumar%"));

#q3 
select c.cname, count(*) as number_of_orders, avg(order_amt) as avg_order_amt
from customers c ,orders o
where c.cust_id=o.cust_id 
group by cname;

#q4 
select max(unitprice) from items;

#q5
create view ordershipment as
select order_id, ship_date from shipments where warehouse_id like "%2";

#q6
DELIMITER //
create trigger updateamt
after insert on orderitems
for each row
begin
update orders set order_amt=(new.qty*(select distinct unitprice from items natural join orderitems where item_id=new.item_id)) 
where orders.order_id=new.order_id;
end; // 
DELIMITER ;
INSERT INTO Orders VALUES
(006, "2020-12-23", 0004, 1200);
INSERT INTO OrderItems VALUES
(006, 0001, 5);
select *from orders;
select *from orderitems;

