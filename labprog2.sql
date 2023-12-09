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
create database insurance;
use insurance;
CREATE TABLE PERSON (
    driver_id VARCHAR(255) PRIMARY KEY,
    dname VARCHAR(255),
    address VARCHAR(255)
);

CREATE TABLE CAR (
    regno VARCHAR(255) PRIMARY KEY,
    model VARCHAR(255),
    year INT
);

CREATE TABLE ACCIDENT (
    report_number INT PRIMARY KEY,
    acc_date DATE,
    location VARCHAR(255)
);

CREATE TABLE OWNS (
    driver_id VARCHAR(255),
    regno VARCHAR(255),
    PRIMARY KEY (driver_id, regno),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (regno) REFERENCES CAR(regno)
);

CREATE TABLE PARTICIPATED (
    driver_id VARCHAR(255),
    regno VARCHAR(255),
    report_number INT,
    damage_amount INT,
    PRIMARY KEY (driver_id, regno, report_number),
    FOREIGN KEY (driver_id, regno) REFERENCES OWNS(driver_id, regno),
    FOREIGN KEY (report_number) REFERENCES ACCIDENT(report_number)
);
-- Inserting into PERSON table
INSERT INTO PERSON VALUES
('D1', 'John Doe', '123 Main St'),
('D2', 'Alice Smith', '456 Oak St'),
('D3', 'Bob Johnson', '789 Pine St'),
('D4', 'Emma Brown', '101 Elm St'),
('D5', 'Charlie White', '202 Cedar St');

-- Inserting into CAR table
INSERT INTO CAR VALUES
('ABC123', 'Toyota', 2020),
('XYZ456', 'Honda', 2019),
('DEF789', 'Ford', 2022),
('GHI012', 'Chevrolet', 2021),
('JKL345', 'Mazda', 2018);

-- Inserting into ACCIDENT table
INSERT INTO ACCIDENT VALUES
(1, '2021-05-10', 'Intersection A'),
(2, '2021-08-15', 'Highway B'),
(3, '2021-11-20', 'Street C'),
(4, '2022-02-05', 'Avenue D'),
(5, '2022-07-30', 'Road E');

-- Inserting into OWNS table
INSERT INTO OWNS VALUES
('D1', 'ABC123'),
('D2', 'XYZ456'),
('D3', 'DEF789'),
('D4', 'GHI012'),
('D5', 'JKL345');

-- Inserting into PARTICIPATED table
INSERT INTO PARTICIPATED VALUES
('D1', 'ABC123', 1, 2000),
('D2', 'XYZ456', 2, 1500),
('D3', 'DEF789', 3, 3000),
('D4', 'GHI012', 4, 2500),
('D5', 'JKL345', 5, 1800);
select *from accident;
select *from car;
select *from owns;
select *from participated;
select *from person;

-- queries
SELECT COUNT(DISTINCT P.driver_id) AS total_people
FROM PERSON P
JOIN OWNS O ON P.driver_id = O.driver_id
JOIN PARTICIPATED PA ON O.driver_id = PA.driver_id
JOIN ACCIDENT A ON PA.report_number = A.report_number
WHERE YEAR(A.acc_date) = 2021;

update PERSON set dname="smith" where driver_id='D1';
SELECT COUNT(*) AS accidents_involving_smith
FROM PARTICIPATED PA
JOIN OWNS O ON PA.driver_id = O.driver_id AND PA.regno = O.regno
JOIN PERSON P ON O.driver_id = P.driver_id
WHERE P.dname = 'Smith';

INSERT INTO ACCIDENT VALUES
(6, '2023-03-01', 'New Location');
select *from accident;


DELETE FROM OWNS
WHERE regno = 'JKL345'
AND driver_id IN (SELECT driver_id FROM PERSON WHERE dname = 'Smith');
select *from owns;

UPDATE PARTICIPATED
SET damage_amount = 2500
WHERE regno = 'ABC123' AND report_number = 1;
select *from participated;

CREATE VIEW AccidentCarsView AS
SELECT DISTINCT C.model, C.year
FROM CAR C
JOIN OWNS O ON C.regno = O.regno
JOIN PARTICIPATED PA ON O.driver_id = PA.driver_id AND O.regno = PA.regno;
select *from accidentcarsview;

INSERT INTO ACCIDENT VALUES("7",'2020-01-02',"AAAA");
INSERT INTO ACCIDENT VALUES("8",'2020-01-03',"AAAA");
INSERT INTO ACCIDENT VALUES("9",'2020-01-04',"AAAA");
INSERT INTO ACCIDENT VALUES("10",'2020-01-05',"AAAA");


DELIMITER //

CREATE TRIGGER check_accidents_limit
BEFORE INSERT ON PARTICIPATED
FOR EACH ROW
BEGIN
    DECLARE accidents_count INT;
    
    -- Get the year of the new accident
    DECLARE new_accident_year INT;
    SELECT YEAR(acc_date) INTO new_accident_year
    FROM ACCIDENT
    WHERE report_number = NEW.report_number;
    
    -- Count the number of accidents for the driver in the given year
    SELECT COUNT(*) INTO accidents_count
    FROM PARTICIPATED
    JOIN ACCIDENT ON PARTICIPATED.report_number = ACCIDENT.report_number
    WHERE PARTICIPATED.driver_id# = NEW.driver_id#
    AND YEAR(ACCIDENT.acc_date) = new_accident_year;
    
    -- Check if the driver has reached the maximum limit of accidents for the year
    IF accidents_count >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Driver has reached the maximum limit of accidents for the year.';
    END IF;
END;

//

DELIMITER ;


SELECT *FROM PARTICIPATED;
SELECT *FROM ACCIDENT;
SELECT *FROM OWNS;
SELECT *FROM CAR;
SELECT *FROM PERSON;

INSERT INTO PARTICIPATED VALUES ('D1', 'ABC123', 7, 2000);
INSERT INTO PARTICIPATED VALUES ('D5', 'JKL345', 8, 1800);
INSERT INTO PARTICIPATED VALUES ('D5', 'JKL345', 9, 1800);
INSERT INTO PARTICIPATED VALUES ('D5', 'JKL345', 10, 1800);

INSERT INTO ACCIDENT VALUES (11, '2021-01-10', 'Intersection A');
INSERT INTO PARTICIPATED VALUES('D5','JKL345',11,1800);

INSERT INTO ACCIDENT VALUES (13, '2021-01-12', 'Intersection A');
INSERT INTO PARTICIPATED VALUES('D5','JKL345',13,1800);