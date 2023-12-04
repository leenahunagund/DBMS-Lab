select *from customer;
+-----+----------+-----------+
| cid | name     | city      |
+-----+----------+-----------+
| 101 | customer | mysuru    |
| 102 | LUFFY    | bangalore |
| 103 | zuru     | mumbai    |
| 104 | nami     | delhi     |
| 105 | sanji    | chennai   |
+-----+----------+-----------+

select *from orderitem;
+----------+---------+------+
| order_id | item_id | qty  |
+----------+---------+------+
|        1 |     501 |   10 |
|        2 |     502 |   20 |
|        3 |     503 |   30 |
|        4 |     504 |   40 |
|        5 |     505 |   50 |
+----------+---------+------+

select *from item;
+---------+-----------+
| item_id | unitprice |
+---------+-----------+
|     501 |       200 |
|     502 |       400 |
|     503 |       600 |
|     504 |       800 |
|     505 |      1000 |
+---------+-----------+


select *from warehouse;
+--------------+-----------+
| warehouse_id | city      |
+--------------+-----------+
|          701 | mysuru    |
|          702 | bangalore |
|          703 | mumbai    |
|          705 | delhi     |
+--------------+-----------+


select *from orders;
+----------+------+-----------+------------+
| order_id | cid  | order_amt | order_date |
+----------+------+-----------+------------+
|        1 |  101 |      1000 | 2000-01-01 |
|        2 |  102 |      2000 | 2000-02-02 |
|        3 |  103 |      3000 | 2000-03-03 |
|        4 |  104 |      4000 | 2000-04-04 |
|        5 |  105 |      5000 | 2000-05-05 |
+----------+------+-----------+------------+

select *from shipment;
+----------+--------------+------------+
| order_id | warehouse_id | ship_date  |
+----------+--------------+------------+
|        1 |          701 | 2000-01-01 |
|        2 |          702 | 2000-02-02 |
|        3 |          703 | 2000-03-03 |
|        5 |          705 | 2000-05-05 |
+----------+--------------+------------+


1. select orders.order_id,SUM(orderitem.qty) AS TOTAL_QTY from orders  inner join orderitem on orders.order_id=orderitem.order_id inner join shipment on orders.order_id=shipment.order_id group by orders.order_id;
+----------+-----------+
| order_id | TOTAL_QTY |
+----------+-----------+
|        1 |        10 |
|        2 |        20 |
|        5 |        50 |
+----------+-----------+
3 rows in set (0.00 sec)

2. select *from customer;
+-----+----------+-------------+
| cid | name     | city        |
+-----+----------+-------------+
| 101 | customer | mysuru      |
| 102 | LUFFY    | bangalore   |
| 103 | zuru     | mumbai      |
| 104 | nami     | delhi       |
| 105 | sanji    | chennai     |
| 106 | person6  | mumbai city |
+-----+----------+-------------+
6 rows in set (0.00 sec)

mysql> select *from customer where city like "%city%";
+-----+---------+-------------+
| cid | name    | city        |
+-----+---------+-------------+
| 106 | person6 | mumbai city |
+-----+---------+-------------+
1 row in set (0.00 sec)


3. select order_id from orders where order_amt>2500
    -> intersect
    -> select order_id from orderitem where qty>=12;
+----------+
| order_id |
+----------+
|        3 |
|        4 |
|        5 |
+----------+

select order_id from orders where order_amt>2500;
+----------+
| order_id |
+----------+
|        3 |
|        4 |
|        5 |
+----------+

select order_id from orderitem where qty>=12;
+----------+
| order_id |
+----------+
|        2 |
|        3 |
|        4 |
|        5 |
+----------+


4. select city from customer UNION select city from warehouse;
+-------------+
| city        |
+-------------+
| mysuru      |
| bangalore   |
| mumbai      |
| delhi       |
| chennai     |
| mumbai city |
+-------------+

 select city from customer;
+-------------+
| city        |
+-------------+
| mysuru      |
| bangalore   |
| mumbai      |
| delhi       |
| chennai     |
| mumbai city |
+-------------+

select city from warehouse;
+-----------+
| city      |
+-----------+
| mysuru    |
| bangalore |
| mumbai    |
| delhi     |
+-----------+

5. delete from orders where order_id=3;
Query OK, 1 row affected (0.01 sec)

mysql> select *from orders;
+----------+------+-----------+------------+
| order_id | cid  | order_amt | order_date |
+----------+------+-----------+------------+
|        1 |  101 |      1000 | 2000-01-01 |
|        2 |  102 |      2000 | 2000-02-02 |
|        4 |  104 |      4000 | 2000-04-04 |
|        5 |  105 |      5000 | 2000-05-05 |
+----------+------+-----------+------------+

select *from orders;
+----------+------+-----------+------------+
| order_id | cid  | order_amt | order_date |
+----------+------+-----------+------------+
|        1 |  101 |      1000 | 2000-01-01 |
|        2 |  102 |      2000 | 2000-02-02 |
|        3 |  103 |      3000 | 2000-03-03 |
|        4 |  104 |      4000 | 2000-04-04 |
|        5 |  105 |      5000 | 2000-05-05 |
+----------+------+-----------+------------+

6.  insert into orders values (6,106,1000,'2023-04-20');
Query OK, 1 row affected (0.01 sec)

mysql> select *from orders;
+----------+------+-----------+------------+
| order_id | cid  | order_amt | order_date |
+----------+------+-----------+------------+
|        1 |  101 |      1000 | 2000-01-01 |
|        2 |  102 |      2000 | 2000-02-02 |
|        4 |  104 |      4000 | 2000-04-04 |
|        5 |  105 |      5000 | 2000-05-05 |
|        6 |  106 |      1000 | 2023-04-20 |
+----------+------+-----------+------------+

select *from orders;
+----------+------+-----------+------------+
| order_id | cid  | order_amt | order_date |
+----------+------+-----------+------------+
|        1 |  101 |      1000 | 2000-01-01 |
|        2 |  102 |      2000 | 2000-02-02 |
|        4 |  104 |      4000 | 2000-04-04 |
|        5 |  105 |      5000 | 2000-05-05 |
+----------+------+-----------+------------+

7. select customer.cid,orders.order_id,orders.order_date FROM customer
    -> LEFT JOIN orders on customer.cid=orders.cid;
+-----+----------+------------+
| cid | order_id | order_date |
+-----+----------+------------+
| 101 |        1 | 2000-01-01 |
| 102 |        2 | 2000-02-02 |
| 103 |     NULL | NULL       |
| 104 |        4 | 2000-04-04 |
| 105 |        5 | 2000-05-05 |
| 106 |        6 | 2023-04-20 |
+-----+----------+------------+
6 rows in set (0.00 sec)

mysql> select *from customer;
+-----+----------+-------------+
| cid | name     | city        |
+-----+----------+-------------+
| 101 | customer | mysuru      |
| 102 | LUFFY    | bangalore   |
| 103 | zuru     | mumbai      |
| 104 | nami     | delhi       |
| 105 | sanji    | chennai     |
| 106 | person6  | mumbai city |
+-----+----------+-------------+
6 rows in set (0.01 sec)

mysql> select *from orders;
+----------+------+-----------+------------+
| order_id | cid  | order_amt | order_date |
+----------+------+-----------+------------+
|        1 |  101 |      1000 | 2000-01-01 |
|        2 |  102 |      2000 | 2000-02-02 |
|        4 |  104 |      4000 | 2000-04-04 |
|        5 |  105 |      5000 | 2000-05-05 |
|        6 |  106 |      1000 | 2023-04-20 |
+----------+------+-----------+------------+
5 rows in set (0.00 sec)

9. select order_id ,order_date,order_amt
    -> from orders
    -> where order_amt>(select avg(order_amt) from orders);
+----------+------------+-----------+
| order_id | order_date | order_amt |
+----------+------------+-----------+
|        4 | 2000-04-04 |      4000 |
|        5 | 2000-05-05 |      5000 |
+----------+------------+-----------+
2 rows in set (0.00 sec)

mysql> select *from orders;
+----------+------+-----------+------------+
| order_id | cid  | order_amt | order_date |
+----------+------+-----------+------------+
|        1 |  101 |      1000 | 2000-01-01 |
|        2 |  102 |      2000 | 2000-02-02 |
|        4 |  104 |      4000 | 2000-04-04 |
|        5 |  105 |      5000 | 2000-05-05 |
|        6 |  106 |      1000 | 2023-04-20 |
+----------+------+-----------+------------+
5 rows in set (0.00 sec)

10. create view customerorder as select c.cid,c.name,o.order_id,o.order_amt
    -> from customer c
    -> left join orders o on c.cid=o.cid;
Query OK, 0 rows affected (0.00 sec)

mysql> select *from customerorder;
+-----+----------+----------+-----------+
| cid | name     | order_id | order_amt |
+-----+----------+----------+-----------+
| 101 | customer |        1 |      1000 |
| 102 | LUFFY    |        2 |      2000 |
| 103 | zuru     |     NULL |      NULL |
| 104 | nami     |        4 |      4000 |
| 105 | sanji    |        5 |      5000 |
| 106 | person6  |        6 |      1000 |
+-----+----------+----------+-----------+
6 rows in set (0.00 sec)

11. grant select,insert,update,delete on orders to "nami";
ERROR 1142 (42000): GRANT command denied to user 'sem5a1'@'localhost' for table 'orders'

12. REVOKE ALL PRIVILEGES ON orders FROM "nami";
ERROR 1142 (42000): GRANT command denied to user 'sem5a1'@'localhost' for table 'orders'
