SELECT *FROM BOAT WHERE BNAME LIKE "%BOAT%";
+-----+-------+--------+-------+
| BID | BNAME | COLOR  | MODEL |
+-----+-------+--------+-------+
| 701 | BOAT1 | GREEN  |  1995 |
| 702 | BOAT2 | RED    |  1995 |
| 703 | BOAT3 | GREEN  |  1995 |
| 704 | BOAT4 | YELLOW |  1995 |
| 705 | BOAT5 | WHITE  |  1995 |
+-----+-------+--------+-------+

SELECT COLOR,COUNT(BID) FROM BOAT GROUP BY COLOR HAVING COUNT(BID)>=1 ORDER BY COUNT(BID) DESC;
+--------+------------+
| COLOR  | COUNT(BID) |
+--------+------------+
| GREEN  |          2 |
| RED    |          1 |
| YELLOW |          1 |
| WHITE  |          1 |
+--------+------------+

(SELECT SID FROM SAILORS WHERE SAILORS.RATING>=4) UNION (SELECT SID FROM RESERVES WHERE RESERVES.BID=703);
+-----+
| SID |
+-----+
| 601 |
| 602 |
| 604 |
+-----+

SELECT SNAME,AGE FROM SAILORS WHERE AGE IN (SELECT MAX(AGE) FROM SAILORS);
+-------+------+
| SNAME | AGE  |
+-------+------+
| JAMES |   31 |
+-------+------+

SELECT AVG(AGE) AS AVG_AGE,MAX(RATING) AS MAX_RATING FROM SAILORS;
+---------+------------+
| AVG_AGE | MAX_RATING |
+---------+------------+
| 28.7500 |        4.9 |
+---------+------------+
