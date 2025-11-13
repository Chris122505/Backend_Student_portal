SET AUTOCOMMIT OFF;
COMMIT;

ALTER TABLE regions
  ADD population DECIMAL(15,0);
  
ALTER TABLE regions
  ADD membership_date DATE DEFAULT'31/Dec/9999';
  
INSERT INTO regions VALUES('5', 'Australia', '15000000', '01/Jan/1900');
INSERT INTO regions VALUES('6', 'Africa', '29000000', '01/Jan/2000');
INSERT INTO regions VALUES('7', 'North America', '30000000', '21/Feb/1995');
INSERT INTO regions VALUES('8', 'Philippines', '5000000', '28/Feb/2000');

UPDATE regions
  SET region_name='South America'
  WHERE region_id = '2';
  
UPDATE regions
  SET population='10000000'
  WHERE population IS NULL;
  
UPDATE regions
  SET membership_date='12/Jan/1973'
  WHERE region_id = '5';
  
UPDATE employees
  SET salary = 3000
     ,commission_pct = 0.1
     ,hire_date = '26/Aug/2925'
  WHERE employee_id IN(100,103,108,109)
    AND commission_pct = 0;

UPDATE employees
  SET hire_date = '12/Jan/2025'
     ,salary = 2000
  WHERE (commission_pct BETWEEN 0.01 AND 0.5)
   OR (hire_date > TO_DATE('01-DEC-2000', 'DD-MON-YYYY'));
 
 
 COMMIT;

DELETE FROM regions
WHERE population BETWEEN 10000000 AND 300000000
  AND membership_date <= TO_DATE('31-DEC-1995', 'DD-MON-YYYY');


DELETE FROM regions
WHERE region_name = 'Philippines';


DELETE FROM regions
WHERE population IS NULL;
 
ROLLBACK;
 
SELECT* 
  FROM regions;
  
SELECT*
  FROM employees;