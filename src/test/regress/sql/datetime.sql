-- *** testing new built-in time types: datetime, timespan ***

-- Shorthand values
-- Not directly usable for regression testing since these are not constants.
-- So, just try to test parser and hope for the best - tgl 97/04/26

SELECT ('today'::datetime = ('yesterday'::datetime + '1 day'::timespan)) as "True";
SELECT ('today'::datetime = ('tomorrow'::datetime - '1 day'::timespan)) as "True";
SELECT ('tomorrow'::datetime = ('yesterday'::datetime + '2 days'::timespan)) as "True";
SELECT ('current'::datetime = 'now'::datetime) as "True";
SELECT ('now'::datetime - 'current'::datetime) AS "ZeroSecs";

CREATE TABLE DATETIME_TBL( d1 datetime);

INSERT INTO DATETIME_TBL VALUES ('current');
INSERT INTO DATETIME_TBL VALUES ('today');
INSERT INTO DATETIME_TBL VALUES ('yesterday');
INSERT INTO DATETIME_TBL VALUES ('tomorrow');
INSERT INTO DATETIME_TBL VALUES ('tomorrow EST');
INSERT INTO DATETIME_TBL VALUES ('tomorrow zulu');

SELECT count(*) AS one FROM DATETIME_TBL WHERE d1 = 'today'::datetime;
SELECT count(*) AS one FROM DATETIME_TBL WHERE d1 = 'tomorrow'::datetime;
SELECT count(*) AS one FROM DATETIME_TBL WHERE d1 = 'yesterday'::datetime;
SELECT count(*) AS one FROM DATETIME_TBL WHERE d1 = 'today'::datetime + '1 day'::timespan;
SELECT count(*) AS one FROM DATETIME_TBL WHERE d1 = 'today'::datetime - '1 day'::timespan;

SELECT count(*) AS one FROM DATETIME_TBL WHERE d1 = 'now'::datetime;

DELETE FROM DATETIME_TBL;

-- verify uniform transaction time within transaction block
INSERT INTO DATETIME_TBL VALUES ('current');
BEGIN;
INSERT INTO DATETIME_TBL VALUES ('now');
SELECT count(*) AS two FROM DATETIME_TBL WHERE d1 = 'now'::datetime;
END;
DELETE FROM DATETIME_TBL;

-- Special values
INSERT INTO DATETIME_TBL VALUES ('invalid');
INSERT INTO DATETIME_TBL VALUES ('-infinity');
INSERT INTO DATETIME_TBL VALUES ('infinity');
INSERT INTO DATETIME_TBL VALUES ('epoch');

-- Postgres v6.0 standard output format
INSERT INTO DATETIME_TBL VALUES ('Mon Feb 10 17:32:01 1997 PST');
INSERT INTO DATETIME_TBL VALUES ('Invalid Abstime');
INSERT INTO DATETIME_TBL VALUES ('Undefined Abstime');

-- Variations on Postgres v6.1 standard output format
INSERT INTO DATETIME_TBL VALUES ('Mon Feb 10 17:32:01.000001 1997 PST');
INSERT INTO DATETIME_TBL VALUES ('Mon Feb 10 17:32:01.999999 1997 PST');
INSERT INTO DATETIME_TBL VALUES ('Mon Feb 10 17:32:01.4 1997 PST');
INSERT INTO DATETIME_TBL VALUES ('Mon Feb 10 17:32:01.5 1997 PST');
INSERT INTO DATETIME_TBL VALUES ('Mon Feb 10 17:32:01.6 1997 PST');

-- ISO 8601 format
INSERT INTO DATETIME_TBL VALUES ('1997-01-02');
INSERT INTO DATETIME_TBL VALUES ('1997-01-02 03:04:05');
INSERT INTO DATETIME_TBL VALUES ('1997-02-10 17:32:01-08');
INSERT INTO DATETIME_TBL VALUES ('1997-02-10 17:32:01-0800');
INSERT INTO DATETIME_TBL VALUES ('1997-02-10 17:32:01 -08:00');
INSERT INTO DATETIME_TBL VALUES ('19970210 173201 -0800');
INSERT INTO DATETIME_TBL VALUES ('1997-06-10 17:32:01 -07:00');

-- Variations for acceptable input formats
INSERT INTO DATETIME_TBL VALUES ('Feb 10 17:32:01 1997 -0800');
INSERT INTO DATETIME_TBL VALUES ('Feb 10 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Feb 10 5:32PM 1997');
INSERT INTO DATETIME_TBL VALUES ('1997/02/10 17:32:01-0800');
INSERT INTO DATETIME_TBL VALUES ('1997-02-10 17:32:01 PST');
INSERT INTO DATETIME_TBL VALUES ('Feb-10-1997 17:32:01 PST');
INSERT INTO DATETIME_TBL VALUES ('02-10-1997 17:32:01 PST');
INSERT INTO DATETIME_TBL VALUES ('19970210 173201 PST');
INSERT INTO DATETIME_TBL VALUES ('97FEB10 5:32:01PM UTC');
INSERT INTO DATETIME_TBL VALUES ('97/02/10 17:32:01 UTC');
INSERT INTO DATETIME_TBL VALUES ('97.041 17:32:01 UTC');

-- Check date conversion and date arithmetic
INSERT INTO DATETIME_TBL VALUES ('1997-06-10 18:32:01 PDT');

INSERT INTO DATETIME_TBL VALUES ('Feb 10 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Feb 11 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Feb 12 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Feb 13 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Feb 14 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Feb 15 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 1997');

INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 0097 BC');
INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 0097');
INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 0597');
INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 1097');
INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 1697');
INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 1797');
INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 1897');
INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 2097');

INSERT INTO DATETIME_TBL VALUES ('Feb 28 17:32:01 1996');
INSERT INTO DATETIME_TBL VALUES ('Feb 29 17:32:01 1996');
INSERT INTO DATETIME_TBL VALUES ('Mar 01 17:32:01 1996');
INSERT INTO DATETIME_TBL VALUES ('Dec 30 17:32:01 1996');
INSERT INTO DATETIME_TBL VALUES ('Dec 31 17:32:01 1996');
INSERT INTO DATETIME_TBL VALUES ('Jan 01 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Feb 28 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Feb 29 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Mar 01 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Dec 30 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Dec 31 17:32:01 1997');
INSERT INTO DATETIME_TBL VALUES ('Dec 31 17:32:01 1999');
INSERT INTO DATETIME_TBL VALUES ('Jan 01 17:32:01 2000');
INSERT INTO DATETIME_TBL VALUES ('Dec 31 17:32:01 2000');
INSERT INTO DATETIME_TBL VALUES ('Jan 01 17:32:01 2001');

-- Currently unsupported syntax and ranges
INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 -0097');
INSERT INTO DATETIME_TBL VALUES ('Feb 16 17:32:01 5097 BC');

SELECT '' AS sixtythree, d1 FROM DATETIME_TBL; 

-- Demonstrate functions and operators
SELECT '' AS fortythree, d1 FROM DATETIME_TBL
   WHERE d1 > '1997-01-02'::datetime and d1 != 'current'::datetime;

SELECT '' AS fifteen, d1 FROM DATETIME_TBL
   WHERE d1 < '1997-01-02'::datetime and d1 != 'current'::datetime;

SELECT '' AS one, d1 FROM DATETIME_TBL
   WHERE d1 = '1997-01-02'::datetime and d1 != 'current'::datetime;

SELECT '' AS fiftyeight, d1 FROM DATETIME_TBL
   WHERE d1 != '1997-01-02'::datetime and d1 != 'current'::datetime;

SELECT '' AS sixteen, d1 FROM DATETIME_TBL
   WHERE d1 <= '1997-01-02'::datetime and d1 != 'current'::datetime;

SELECT '' AS fortyfour, d1 FROM DATETIME_TBL
   WHERE d1 >= '1997-01-02'::datetime and d1 != 'current'::datetime;

SELECT '' AS sixtythree, d1 + '1 year'::timespan AS one_year FROM DATETIME_TBL;

SELECT '' AS sixtythree, d1 - '1 year'::timespan AS one_year FROM DATETIME_TBL;

-- Casting within a BETWEEN qualifier should probably be allowed by the parser. - tgl 97/04/26
--SELECT '' AS fifty, d1 - '1997-01-02'::datetime AS diff
--   FROM DATETIME_TBL WHERE d1 BETWEEN '1902-01-01'::datetime AND '2038-01-01'::datetime;
SELECT '' AS fifty, d1 - '1997-01-02'::datetime AS diff
   FROM DATETIME_TBL WHERE d1 BETWEEN '1902-01-01' AND '2038-01-01';

SELECT '' AS fortynine, date_part( 'year', d1) AS year, date_part( 'month', d1) AS month,
   date_part( 'day', d1) AS day, date_part( 'hour', d1) AS hour,
   date_part( 'minute', d1) AS minute, date_part( 'second', d1) AS second
   FROM DATETIME_TBL WHERE d1 BETWEEN '1902-01-01' AND '2038-01-01';

SELECT '' AS fortynine, date_part( 'quarter', d1) AS quarter, date_part( 'msec', d1) AS msec,
   date_part( 'usec', d1) AS usec
   FROM DATETIME_TBL WHERE d1 BETWEEN '1902-01-01' AND '2038-01-01';

