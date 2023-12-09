/*4. Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are specified.
Create tables for the following schema listed below by properly specifying the primary keys and foreign keys.
Enter at least five tuples for each relation.
Student enrollment in courses and books adopted for each course
STUDENT (regno: string, name: string, major: string, bdate: date)
COURSE (course#:int, cname: string, dept: string)
ENROLL(regno:string, course#: int,sem: int,marks: int)
BOOK-ADOPTION (course#:int, sem: int, book-ISBN: int)
TEXT (book-ISBN: int, book-title: string, publisher: string,author: string)
1.	Demonstrate how you add a new text book to the database and make this book be adopted by some department.  
2.	Produce a list of text books (include Course #, Book-ISBN, Book-title) in the alphabetical order for courses offered by the ‘CS’ department that use more than two books.  
3.	List any department that has all its adopted books published by a specific publisher. 
4.	List the students who have scored maximum marks in ‘DBMS’ course. 
5.	Create a view to display all the courses opted by a student along with marks obtained.
6.	Create a trigger that prevents a student from enrolling in a course if the marks prerequisite is less than  40.
*/
create database student;
use student;

CREATE TABLE STUDENT (
    regno VARCHAR(255) PRIMARY KEY,
    Sname VARCHAR(255),
    major VARCHAR(255),
    bdate DATE
);

CREATE TABLE COURSE (
    course INT PRIMARY KEY,
    cname VARCHAR(255),
    dept VARCHAR(255)
);

CREATE TABLE TEXTBOOK (
    book_ISBN INT PRIMARY KEY,
    book_title VARCHAR(255),
    publisher VARCHAR(255),
    author VARCHAR(255)
);

CREATE TABLE ENROLL (
    regno VARCHAR(255),
    course INT,
    sem INT,
    marks INT,
    PRIMARY KEY (regno, course, sem),
    INDEX idx_course_sem (course, sem), -- Add an index for the composite key
    FOREIGN KEY (regno) REFERENCES STUDENT(regno),
    FOREIGN KEY (course) REFERENCES COURSE(course)
);

CREATE TABLE BOOK_ADOPTION (
    course INT,
    sem INT,
    book_ISBN INT,
    PRIMARY KEY (course, sem, book_ISBN),
    FOREIGN KEY (course,sem) REFERENCES ENROLL(course,sem),
    FOREIGN KEY (book_ISBN) REFERENCES TEXTBOOK(book_ISBN)
);

-- Insert into STUDENT
INSERT INTO STUDENT VALUES ('S001', 'John Doe', 'CSE', '2000-01-01');
INSERT INTO STUDENT VALUES ('S002', 'Jane Smith', 'EEE', '2001-02-15');
INSERT INTO STUDENT VALUES ('S003', 'Jack', 'CSE', '2000-01-01');
INSERT INTO STUDENT VALUES ('S004', 'hillary', 'EC', '2000-01-01');
INSERT INTO STUDENT VALUES ('S005', 'Joe', 'CTM', '2000-01-01');
-- Add more tuples as needed

-- Insert into COURSE
INSERT INTO COURSE VALUES (101, 'Introduction to CS', 'CS');
INSERT INTO COURSE VALUES (102, 'Database Management Systems', 'CS');
INSERT INTO COURSE VALUES (103, 'OS', 'CS');
INSERT INTO COURSE VALUES (104, 'CALCULUS', 'MATHS');
INSERT INTO COURSE VALUES (105, 'OOPS', 'CS');
-- Add more tuples as needed

-- Insert into ENROLL
INSERT INTO ENROLL VALUES ('S001', 101, 1, 80);
INSERT INTO ENROLL VALUES ('S002', 102, 1, 75);
INSERT INTO ENROLL VALUES ('S003', 103, 3, 75);
INSERT INTO ENROLL VALUES ('S004', 104, 3, 75);
INSERT INTO ENROLL VALUES ('S005', 105, 5, 75);
-- Add more tuples as needed

-- Insert into BOOK_ADOPTION
INSERT INTO BOOK_ADOPTION VALUES (101, 1, 1001);
INSERT INTO BOOK_ADOPTION VALUES (102, 1, 1002);
INSERT INTO BOOK_ADOPTION VALUES (103, 3, 1003);
INSERT INTO BOOK_ADOPTION VALUES (104, 3, 1003);
INSERT INTO BOOK_ADOPTION VALUES (105, 5, 1005);
-- Add more tuples as needed

-- Insert into TEXT
INSERT INTO TEXTBOOK VALUES (1001, 'Computer Science Book', 'Tech Publishers', 'Alice Author');
INSERT INTO TEXTBOOK VALUES (1002, 'maths Book', 'rd sharma', 'rd sharma');
INSERT INTO TEXTBOOK VALUES (1003, 'OS ', 'Tech Publishers', 'pearson');
INSERT INTO TEXTBOOK VALUES (1004, 'DSA', 'Tech Publishers', 'pearson');
INSERT INTO TEXTBOOK VALUES (1005, 'DBMS', 'Tech Publishers', 'kyrdy');
-- Add more tuples as needed
select *from student;
select *from course;
select *from enroll;
select *from textbook;
select *from book_adoption;

#QUERIES
INSERT INTO TEXTBOOK (book_ISBN, book_title, publisher, author)
VALUES (1006, 'New Textbook', 'NewPub', 'New Author');

INSERT INTO COURSE VALUES (201,"NEW","MECH");
INSERT INTO ENROLL VALUES('S006',201,1,50);
INSERT INTO STUDENT VALUES ('S006',"MAY","CSE","2000-03-01");
INSERT INTO BOOK_ADOPTION (course, sem, book_ISBN)
VALUES (201, 1, 1006);

SELECT B.course, T.book_ISBN, T.book_title
FROM BOOK_ADOPTION B
JOIN TEXTBOOK T ON B.book_ISBN = T.book_ISBN
WHERE B.course IN (SELECT course FROM COURSE WHERE dept = 'CSE')
GROUP BY B.course, T.book_ISBN, T.book_title
HAVING COUNT(B.book_ISBN) >=1
ORDER BY T.book_title;

SELECT DISTINCT C.dept
FROM COURSE C
WHERE 'Tech Publishers' = ALL (
    SELECT T.publisher
    FROM BOOK_ADOPTION B
    JOIN TEXTBOOK T ON B.book_ISBN = T.book_ISBN
    WHERE B.course = C.course
);

SELECT E.regno, E.marks
FROM ENROLL E
WHERE E.course = (SELECT course FROM COURSE WHERE cname = 'Database Management Systems')
ORDER BY E.marks DESC
LIMIT 1;
select *from student;
select *from enroll;
select *from course;

insert into enroll values('S001',102,1,88);

CREATE VIEW StudentCourses AS
SELECT S.regno, S.sname, E.course, E.marks
FROM STUDENT S
JOIN ENROLL E ON S.regno = E.regno;
select *from StudentCourses;

DELIMITER //
CREATE TRIGGER BeforeEnroll
BEFORE INSERT ON ENROLL
FOR EACH ROW
BEGIN
    IF NEW.marks < 40 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Marks prerequisite not met';
    END IF;
END;
// DELIMITER ;

insert into enroll values('S003',103,4,28);