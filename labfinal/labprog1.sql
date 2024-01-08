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
drop database if exists sailors;

create database sailors;
use sailors;

create table if not exists Sailors(
sid int primary key,
sname varchar(35) not null,
rating float not null,
age int not null);

create table if not exists Boat(
bid int primary key,
bname varchar(35) not null,
color varchar(25) not null
);

create table if not exists reserves(
sid int not null,
bid int not null,
sdate date not null,
foreign key (sid) references Sailors(sid) on delete cascade,
foreign key (bid) references Boat(bid) on delete cascade
);

show tables;

insert into sailors values
(1,"Albert", 5.0, 40),
(2, "Nakul", 5.0, 49),
(3, "Darshan", 9, 18),
(4, "Astorm Gowda", 2, 68),
(5, "Armstormin", 7, 19);

insert into boat values
(1,"Boat_1", "Green"),
(2,"Boat_2", "Red"),
(103,"Boat_3", "Blue");

insert into reserves values
(1,103,"2023-01-01"),
(1,2,"2023-02-01"),
(2,1,"2023-02-05"),
(3,2,"2023-03-06"),
(5,103,"2023-03-06"),
(1,1,"2023-03-06");

select *from sailors;
select *from boat;
select *from reserves;

#q1
select boat.color from boat,sailors,reserves where reserves.sid=sailors.sid and reserves.bid=boat.bid and sailors.sname like "albert"  ;

#q2 
(select sid
from Sailors
where Sailors.rating>=8)
UNION
(select sid 
from reserves
where reserves.bid=103);

#q3
select sailors.sname from sailors
where sailors.sid not in 
(select sailors.sid from sailors,reserves where reserves.sid=sailors.sid and sailors.sname like "%storm%") 
and  sailors.sname like "%storm%" 
order by sailors.sname ASC;


#q4 
select s.sname from sailors s where not exists(select *from boat b where not exists (select *from reserves r where r.sid=s.sid and r.bid=b.bid));

#q5 
select s.sname, s.age from sailors s where age in (select max(age) from sailors);

#q6
select b.bid, avg(s.age) as avg_age from boat b ,sailors s ,reserves r
where r.sid=s.sid and r.bid=b.bid and age>=40
group by bid having 5<=count(distinct r.sid);

#q7
create view namewcolors as
select b.bname,b.color,s.rating from boat b , sailors s
where s.rating=5;
select *from namewcolors;

#q8
DELIMITER //
CREATE TRIGGER CheckAndDelete
before delete on Boat
for each row
BEGIN
IF EXISTS (select * from reserves where reserves.bid=old.bid)
THEN
SIGNAL SQLSTATE '45000' SET message_text='Boat is reserved and hence cannot be deleted';
END IF;
END;//
DELIMITER ;
delete from boat where bid=103;








