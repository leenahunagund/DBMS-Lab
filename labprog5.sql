/*5. Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are specified.
Create tables for the following schema listed below by properly specifying the primary keys and foreign keys.
Enter at least five tuples for each relation.
Company Database:
EMPLOYEE (SSN, Name, Address, Sex, Salary, SuperSSN, DNo)
DEPARTMENT (DNo, DName, MgrSSN, MgrStartDate)
DLOCATION (DNo,DLoc)
PROJECT (PNo, PName, PLocation, DNo)
WORKS_ON (SSN, PNo, Hours)
1.	Make a list of all project numbers for projects that involve an employee whose last name is ‘Scott’, either as a worker or as a manager of the department that controls the project.  
2.	Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise.  
3.	Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the maximum salary, the minimum salary, and the average salary in this department  
4.	Retrieve the name of each employee who works on all the projects controlled by department number 5 (use NOT EXISTS operator). 
5.	For each department that has more than five employees, retrieve the department number and the number of its employees who are making more than Rs. 6,00,000. 
6.	Create a view that shows name, dept name and location of all employees. 
7.	Create a trigger that prevents a project from being deleted if it is currently being worked by any employee.
*/
create database company;
use company;
-- Create EMPLOYEE table
CREATE TABLE EMPLOYEE (
    SSN INT PRIMARY KEY,
    eName VARCHAR(255),
    Address VARCHAR(255),
    Sex CHAR(1),
    Salary DECIMAL(10,2),
    SuperSSN INT,
    DNo INT,
    FOREIGN KEY (SuperSSN) REFERENCES EMPLOYEE(SSN)
    -- 
);
/*ALTER TABLE table_name
ADD FOREIGN KEY (column_name)
REFERENCE table_name(Referencing column_name in table_name);
alter table employee add FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo);*/

-- Create DEPARTMENT table
CREATE TABLE DEPARTMENT (
    DNo INT PRIMARY KEY,
    DName VARCHAR(255),
    MgrSSN INT,
    MgrStartDate DATE,
    FOREIGN KEY (MgrSSN) REFERENCES EMPLOYEE(SSN)
);

-- Create DLOCATION table
CREATE TABLE DLOCATION (
    DNo INT PRIMARY KEY,
    DLoc VARCHAR(255),
    foreign key (DNo) references department(DNo)
);

-- Create PROJECT table
CREATE TABLE PROJECT (
    PNo INT PRIMARY KEY,
    PName VARCHAR(255),
    PLocation VARCHAR(255),
    DNo INT,
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo)
);

-- Create WORKS_ON table
CREATE TABLE WORKS_ON (
    SSN INT,
    PNo INT,
    Hours INT,
    PRIMARY KEY (SSN, PNo),
    FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN),
    FOREIGN KEY (PNo) REFERENCES PROJECT(PNo)
);
select *from employee;

-- Insert data into EMPLOYEE table
INSERT INTO EMPLOYEE VALUES
(1, 'John Smith', '123 Main St', 'M', 60000, NULL, 1),
(2, 'Jane Doe', '456 Oak St', 'F', 55000, 1, 1),
(3, 'Robert Johnson', '789 Pine St', 'M', 70000, NULL, 2),
(4, 'Emily Davis', '101 Maple St', 'F', 50000, 3, 3),
(5, 'Scott Thompson', '202 Cedar St', 'M', 65000, 3, 4);

-- Insert data into DEPARTMENT table
INSERT INTO DEPARTMENT VALUES
(1, 'HR', 2, '2022-01-01'),
(2, 'IT', 3, '2022-02-01'),
(3, 'Accounts', 4, '2022-03-08'),
(4, 'PR', 1, '2022-01-12'),
(5, 'Recruitment', 5, '2022-01-29');

-- Insert data into DLOCATION table
INSERT INTO DLOCATION VALUES
(1, 'New York'),
(2, 'San Francisco'),
(3, 'Chicago'),
(4, 'Tokyo'),
(5, 'Washington');

-- Insert data into PROJECT table
INSERT INTO PROJECT VALUES
(1, 'Employee Database', 'New York', 1),
(2, 'Website Development', 'San Francisco', 2),
(3, 'Financial Analysis', 'Chicago', 3),
(4, 'Public Rlations', 'Chicago', 4),
(5, 'Recruitment', 'San Francisco', 5);

-- Insert data into WORKS_ON table
INSERT INTO WORKS_ON VALUES
(1, 1, 40),
(2, 2, 30),
(3, 3, 35),
(4, 2, 20),
(5, 5, 25);
select *from employee;
select *from department;
select *from dlocation;
select *from project;
select *from works_on;

alter table employee add FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo);

#queries
SELECT DISTINCT P.PNo,P.Pname
FROM PROJECT P
JOIN WORKS_ON W ON P.PNo = W.PNo
JOIN EMPLOYEE E ON W.SSN = E.SSN
WHERE E.eName like '%Scott%' OR E.SuperSSN = (SELECT SSN FROM EMPLOYEE WHERE eName like '%Scott%');

insert into department values(6,"hardware",null,null);
insert into project values(6,"IoT","Berlin",6);
insert into works_on values(3,6,12);
insert into works_on values(4,6,15);
UPDATE EMPLOYEE E
SET E.Salary = E.Salary * 1.1
WHERE SSN IN (SELECT SSN FROM WORKS_ON WHERE PNo = (SELECT PNo FROM PROJECT WHERE PName = 'IoT'));

select *from employee;

insert into employee values (6,"Mindy","4th avenue","F",60000,null,4);
update employee set DNo=3 where eName like "Mindy";
SELECT SUM(Salary) AS TotalSalary, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary, AVG(Salary) AS AvgSalary
FROM EMPLOYEE E
WHERE E.DNo = (SELECT DNo FROM DEPARTMENT WHERE DName = 'Accounts');

SELECT E.eName
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT PNo
    FROM PROJECT P
    WHERE P.DNo = 5
    AND NOT EXISTS (
        SELECT W.PNo
        FROM WORKS_ON W
        WHERE W.SSN = E.SSN AND W.PNo = P.PNo
    )
);

update employee set salary=700000 where SSN=4;
update employee set salary=750000 where SSN=5;
SELECT DNo, COUNT(*) AS NumEmployees
FROM EMPLOYEE
WHERE Salary > 600000
GROUP BY DNo
HAVING COUNT(*) >= 1;

CREATE VIEW EmployeeInfo AS
SELECT E.eName, D.DName AS DeptName, DL.DLoc
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DNo = D.DNo
JOIN DLOCATION DL ON D.DNo = DL.DNo;

select *from EmployeeInfo;

-- Create a trigger to prevent project deletion
DELIMITER //
CREATE TRIGGER PreventProjectDeletion
BEFORE DELETE ON PROJECT
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM WORKS_ON WHERE PNo = OLD.PNo) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete project currently being worked on.';
    END IF;
END;
//
DELIMITER ;
delete from project where PNo=2;