/*2. Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are specified.
Create tables for the following schema listed below by properly specifying the primary keys and foreign keys.
Enter at least five tuples for each relation.
Insurance database
PERSON (driver id#: string, name: string, address: string)
CAR (regno: string, model: string, year: int)
ACCIDENT (report_ number: int, acc_date: date, location: string)
OWNS (driver id#: string, regno: string)
PARTICIPATED(driver id#:string, regno:string, report_ number: int,damage_amount: int)
1.	Find the total number of people who owned cars that were involved in accidents in 2021. 
2.	Find the number of accidents in which the cars belonging to “Smith” were involved.  
3.	Add a new accident to the database; assume any values for required attributes.  
4.	Delete the Mazda belonging to “Smith”.  
5.	Update the damage amount for the car with license number “KA09MA1234” in the accident with report. 
6.	A view that shows models and year of cars that are involved in accident. 
7.	A trigger that prevents a driver from participating in more than 3 accidents in a given year.
*/
drop database if exists insurance;
create database insurance;
use insurance;
CREATE TABLE IF NOT EXISTS person (
driver_id VARCHAR(255) NOT NULL,
driver_name TEXT NOT NULL,
address TEXT NOT NULL,
PRIMARY KEY (driver_id)
);
CREATE TABLE IF NOT EXISTS car (
reg_no VARCHAR(255) NOT NULL,
model TEXT NOT NULL,
c_year INTEGER,
PRIMARY KEY (reg_no)
);
CREATE TABLE IF NOT EXISTS accident (
report_no INTEGER NOT NULL,
accident_date DATE,
location TEXT,
PRIMARY KEY (report_no)
);
CREATE TABLE IF NOT EXISTS owns (
driver_id VARCHAR(255) NOT NULL,
reg_no VARCHAR(255) NOT NULL,
FOREIGN KEY (driver_id) REFERENCES person(driver_id) ON DELETE CASCADE,
FOREIGN KEY (reg_no) REFERENCES car(reg_no) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS participated (
driver_id VARCHAR(255) NOT NULL,
reg_no VARCHAR(255) NOT NULL,
report_no INTEGER NOT NULL,
damage_amount FLOAT NOT NULL,
FOREIGN KEY (driver_id) REFERENCES person(driver_id) ON DELETE CASCADE,
FOREIGN KEY (reg_no) REFERENCES car(reg_no) ON DELETE CASCADE,
FOREIGN KEY (report_no) REFERENCES accident(report_no)
);
show tables;
INSERT INTO person VALUES
("D111", "Driver_1", "Kuvempunagar, Mysuru"),
("D222", "Smith", "JP Nagar, Mysuru"),
("D333", "Driver_3", "Udaygiri, Mysuru"),
("D444", "Driver_4", "Rajivnagar, Mysuru"),
("D555", "Driver_5", "Vijayanagar, Mysore");
INSERT INTO car VALUES
("KA-20-AB-4223", "Swift", 2020),
("KA-20-BC-5674", "Mazda", 2017),
("KA-21-AC-5473", "Alto", 2015),
("KA-21-BD-4728", "Triber", 2019),
("KA-09-MA-1234", "Tiago", 2018);
INSERT INTO accident VALUES
(43627, "2020-04-05", "Nazarbad, Mysuru"),
(56345, "2019-12-16", "Gokulam, Mysuru"),
(63744, "2020-05-14", "Vijaynagar, Mysuru"),
(54634, "2019-08-30", "Kuvempunagar, Mysuru"),
(65738, "2021-01-21", "JSS Layout, Mysuru"),
(66666, "2021-01-21", "JSS Layout, Mysuru");
INSERT INTO owns VALUES
("D111", "KA-20-AB-4223"),
("D222", "KA-20-BC-5674"),
("D333", "KA-21-AC-5473"),
("D444", "KA-21-BD-4728"),
("D222", "KA-09-MA-1234");
INSERT INTO participated VALUES
("D111", "KA-20-AB-4223", 43627, 20000),
("D222", "KA-20-BC-5674", 56345, 49500),
("D333", "KA-21-AC-5473", 63744, 15000),
("D444", "KA-21-BD-4728", 54634, 5000),
("D222", "KA-09-MA-1234", 65738, 25000);

select *from person;
select *from car;
select *from accident;
select *from owns;
select *from participated;

#q1
select COUNT(driver_id)
from participated p, accident a
where p.report_no=a.report_no and a.accident_date like "2021%";

#q2
select count(distinct a.report_no) as cnt
from accident a
where exists 
(select *from participated ptd, person p where p.driver_id=ptd.driver_id and p.driver_name like "%smith" and a.report_no=ptd.report_no);

#q3 
insert into accident values 
(45662,"2022-03-17","jp nagar mysuru");
insert into participated values
("D222","KA-21-BD-4728",45662,50000);
select *from accident;

#q4
delete from car where model="mazda" and reg_no in (select reg_no from person p , owns o where p.driver_id=o.driver_id and p.driver_name like "%smith%");

#q5 
update participated set damage_amount=17000 where report_no=65738 and reg_no="KA-09-MA-1234";

#q6
create view carmodelaccident as
select distinct model , c_year 
from car c,participated p
where c.reg_no=p.reg_no;

#q7
DELIMITER //
create trigger caraccident 
before insert on participated
for each row
begin
if 2<=(select count(*) from participated where driver_id=new.driver_id) then
signal sqlstate '45000' set message_text="driver has already participated in 2 accidents in a year";
end if;
end;//
DELIMITER ;
insert into  participated values
("D222","KA-20-AB-4223",66667,20000);
/*  worked!*/
