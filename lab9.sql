USE INSURANCE;
SELECT *FROM PERSON;
+-----------+-------------+--------------+
| DRIVER_ID | DRIVER_NAME | ADDRESS      |
+-----------+-------------+--------------+
| D111      | D1          | KUVEMPUNAGAR |
| D222      | D2          | JP NAGR      |
| D333      | D3          | BOGADI       |
| D444      | D4          | RAJIVNAGR    |
| D555      | D5          | LAKSHMIPURAM |
+-----------+-------------+--------------+

SELECT *FROM CAR;
+------------+--------+--------+
| REG_NO     | MODEL  | C_YEAR |
+------------+--------+--------+
| KA20AB4223 | SWIFT  |   2020 |
| KA20BC5674 | WAGONR |   2017 |
| KA21AC5473 | ALTO   |   2015 |
| KA21AC5478 | TRIBER |   2019 |
| KA21CA6374 | TIAGO  |   2018 |
+------------+--------+--------+

 SELECT *FROM ACCIDENT;
+-----------+--------------+-------------+
| REPORT_NO | ACCIDEN_DATE | LOCATION    |
+-----------+--------------+-------------+
|     43627 | 2020-04-05   | NAZARABAD   |
|     56345 | 2019-12-16   | GOKULAM     |
|     63744 | 2020-05-14   | VIJAYANAGAR |
|     54634 | 2019-08-30   | KUVEMPUNAGR |
|     65738 | 2021-01-21   | JSS LAYOUT  |
+-----------+--------------+-------------+

SELECT *FROM OWNS;
+-----------+------------+
| DRIVER_ID | REG_NO     |
+-----------+------------+
| D111      | KA20AB4223 |
| D222      | KA20BC5674 |
| D333      | KA20AC5473 |
+-----------+------------+

SELECT *FROM PARTICIPATED;
+-----------+------------+-----------+---------------+
| DRIVER_ID | REG_NO     | REPORT_NO | DAMAGE_AMOUNT |
+-----------+------------+-----------+---------------+
| D444      | KA20AB4728 |     54634 |          5000 |
| D333      | KA20AC5473 |     65438 |         25000 |
| D111      | KA20AB4223 |     75389 |          NULL |
+-----------+------------+-----------+---------------+

lina H <patilbhagya437@gmail.com>
Mon, 27 Nov, 12:21 (2 days ago)
to me

SELECT PERSON.DRIVER_NAME,CAR.MODEL FROM PERSON
    -> INNER JOIN OWNS ON PERSON.DRIVER_ID=OWNS.DRIVER_ID
    -> INNER JOIN CAR ON OWNS.REG_NO=CAR.REG_NO;
+-------------+--------+
| DRIVER_NAME | MODEL  |
+-------------+--------+
| D1          | SWIFT  |
| D2          | WAGONR |
+-------------+--------+

SELECT ACCIDENT.REPORT_NO,ACCIDENT.ACCIDEN_DATE,ACCIDENT.LOCATION,PERSON.DRIVER_NAME,CAR.MODEL,PARTICIPATED.DAMAGE_AMOUNT
    -> FROM PARTICIPATED
    -> INNER JOIN PERSON ON PARTICIPATED.DRIVER_ID=PERSON.DRIVER_ID
    -> INNER JOIN CAR ON PARTICIPATED.REG_NO=CAR.REG_NO
    -> INNER JOIN ACCIDENT ON PARTICIPATED.REPORT_NO=ACCIDENT.REPORT_NO;
Empty set (0.00 sec)

SELECT ACCIDENT.REPORT_NO,ACCIDENT.ACCIDEN_DATE,ACCIDENT.LOCATION,PERSON.DRIVER_NAME,CAR.MODEL,PARTICIPATED.DAMAGE_AMOUNT FROM PARTICIPATED
    -> INNER JOIN PERSON ON PARTICIPATED.DRIVER_ID=PERSON.DRIVER_ID
    -> INNER JOIN CAR ON PARTICIPATED.REG_NO=CAR.REG_NO
    -> INNER JOIN ACCIDENT ON PARTICIPATED.REPORT_NO=ACCIDENT.REPORT_NO
    -> WHERE ACCIDENT.ACCIDEN_DATE BETWEEN "2020-01-01" AND "2021-12-12"
    -> ORDER BY PARTICIPATED.DAMAGE_AMOUNT;
Empty set (0.00 sec)
