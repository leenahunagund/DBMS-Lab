/*1. Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are specified.
Create tables for the following schema listed below by properly specifying the primary keys and foreign keys.
Enter at least five tuples for each relation.
Sailors database
SAILORS (sid, sname, rating, age)
BOAT(bid, bname, color)
RSERVERS (sid, bid, date)
Queries, View and Trigger
1.	Find the colours of boats reserved by Albert 
2.	Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103
3.	 Find the names of sailors who have not reserved a boat whose name contains the string “storm”. Order the names in ascending order. 
4.	Find the names of sailors who have reserved all boats. 
5.	Find the name and age of the oldest sailor. 
6.	For each boat which was reserved by at least 5 sailors with age >= 40, find the boat id and the average age of such sailors.
7.	Create a view that shows the names and colours of all the boats that have been reserved by a sailor with a specific rating.
8.	A trigger that prevents boats from being deleted If they have active reservations. 
*/
create database sailors;
use sailors;
create table SAILORS
(
sid INT PRIMARY KEY, 
sname VARCHAR(50), 
rating INT, 
age INT
);
create table BOAT
(bid INT PRIMARY KEY, 
bname VARCHAR(50), 
color VARCHAR(20)
);
create table RESERVES
(
sid INT, 
bid INT,
date date, 
PRIMARY KEY (sid, bid), 
FOREIGN KEY (sid) REFERENCES SAILORS(sid),
FOREIGN KEY (bid) REFERENCES BOAT(bid)
);
insert into SAILORS values
(101,"Alice",9,25),(102,"Bob",8,28),(103,"Carol",7,22),(104,"David",8,30),(105,"Emily",6,35);
select *from SAILORS;
insert into BOAT values 
(201, "Boat1", "Blue"),( 202,"Boat2","Red"),(203,"Boat3","Green"),(204,"Boat4","Yellow"),(205,"Boat5","Black");
select *from BOAT;
insert into RESERVES values 
(101,201,20230101),(102,202,20230201),(103,203,20230301),(104,204,20230401),(105,205,20230501);
select *from RESERVES;
#Values specified as numbers should be 6, 8, 12, or 14 digits long. If a number is 8 or 14 digits long, it is assumed to be in
# YYYYMMDD or YYYYMMDDhhmmss format and that the year is given by the first 4 digits. 
update sailors set sname="Albert" where sid=101;

update reserves set sid=101 where bid>=201;

update sailors set age=40 where sid=101;
update sailors set age=41 where sid=102;
update sailors set age=40 where sid=103;
update sailors set age=42 where sid=104;
update sailors set age=47 where sid=105;

update reserves set bid=203 where sid>=102;


update reserves set sid=102 where bid=202;
update reserves set sid=103 where bid=203;
update reserves set sid=104 where bid=204;
update reserves set sid=105 where bid=205;

update reserves set bid=201 where sid>=101;

update reserves set bid=202 where sid=102;
update reserves set bid=203 where sid=103;
update reserves set bid=204 where sid=104;
update reserves set bid=205 where sid=105;

#queries
SELECT b.color
FROM SAILORS s
JOIN RESERVES r ON s.sid = r.sid
JOIN BOAT b ON r.bid = b.bid
WHERE s.sname = 'Albert';

SELECT DISTINCT s.sid
FROM SAILORS s
LEFT JOIN RESERVES r ON s.sid = r.sid
WHERE s.rating >= 8 OR r.bid = 103;

SELECT s.sname
FROM SAILORS s
LEFT JOIN RESERVES r ON s.sid = r.sid
LEFT JOIN BOAT b ON r.bid = b.bid
WHERE b.bname NOT LIKE '%storm%' OR b.bid IS NULL
ORDER BY s.sname ASC;

SELECT s.sname
FROM SAILORS s
WHERE NOT EXISTS (
  SELECT b.bid
  FROM BOAT b
  WHERE NOT EXISTS (
    SELECT r.bid
    FROM RESERVES r
    WHERE r.sid = s.sid AND r.bid = b.bid
  )
);

SELECT sname, age
FROM SAILORS
ORDER BY age DESC
LIMIT 1;

SELECT r.bid, AVG(s.age) AS avg_age
FROM RESERVES r
JOIN SAILORS s ON r.sid = s.sid
WHERE s.age >= 40
GROUP BY r.bid
HAVING COUNT(DISTINCT r.sid) >= 5;

CREATE VIEW SailorBoatColors AS
SELECT s.sname, b.color
FROM SAILORS s
JOIN RESERVES r ON s.sid = r.sid
JOIN BOAT b ON r.bid = b.bid;

DELIMITER //
CREATE TRIGGER prevent_delete
BEFORE DELETE ON BOAT
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM RESERVES WHERE bid = OLD.bid) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot delete boat with active reservations';
  END IF;
END;
//
DELIMITER ;
delete from BOAT where bid=205;
select *from BOAT;





