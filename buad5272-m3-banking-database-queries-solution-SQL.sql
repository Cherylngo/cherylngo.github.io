
-- Query 1
SELECT FIRST_NAME ,LAST_NAME 
FROM employee
WHERE TITLE = 'Teller'
ORDER BY START_DATE;

-- Query 2
SELECT NAME
FROM product
WHERE Name LIKE '%account%';

-- Query 3
select p.name, avg(AVAIL_BALANCE), min(AVAIL_BALANCE), max(AVAIL_BALANCE)
from ACCOUNT a, product p, PRODUCT_TYPE pt
where a.PRODUCT_CD=p.PRODUCT_CD and
p.PRODUCT_TYPE_CD=pt.PRODUCT_TYPE_CD
group by name;

-- Query 4
SELECT CUST_ID, COUNT(*)
FROM ACCOUNT a
WHERE  
a.AVAIL_BALANCE > '1000'
group by CUST_ID;

-- Query 5
select OPEN_BRANCH_ID,PRODUCT_CD,max(PENDING_BALANCE)
from ACCOUNT
group by OPEN_BRANCH_ID,PRODUCT_CD
having max(PENDING_BALANCE)>2000;

-- Query 6
select  ACCOUNT_ID, CUST_ID,PRODUCT_CD,OPEN_BRANCH_ID
from  ACCOUNT
where 
AVAIL_BALANCE<(
SELECT avg(AVAIL_BALANCE)
FROM  ACCOUNT);

-- Query 7
select  ACCOUNT_ID,LAST_NAME, FIRST_NAME, p.NAME as 'product name',b.NAME as 'branch name'
from  ACCOUNT a,  PRODUCT p, BRANCH b, INDIVIDUAL i
where a.PRODUCT_CD=p.PRODUCT_CD and
a.OPEN_BRANCH_ID=b.BRANCH_ID and
a.CUST_ID=i.CUST_ID and
AVAIL_BALANCE<(
SELECT avg(AVAIL_BALANCE)
FROM  ACCOUNT)
order by LAST_NAME;

-- Query 8
select  LAST_NAME,  FIRST_NAME
from   INDIVIDUAL
where CUST_ID in
(select CUST_ID
from  ACCOUNT
group by CUST_ID
having count(*)>2);

-- Query 9
SELECT 
    e.LAST_NAME,
    e.FIRST_NAME,
    year(CURDATE()) - year(e.START_DATE) as 'Years with Company',
    s.last_name as 'Supervisor Last Name'
FROM
    EMPLOYEE E,
    EMPLOYEE S
WHERE
    e.SUPERIOR_EMP_ID = s.EMP_ID
ORDER BY s.last_name;


-- Query 10
SELECT 
    s.last_name as 'Supervisor Last Name', count(*) as 'Number of employees'
FROM
    EMPLOYEE E,
    EMPLOYEE S
WHERE
    e.SUPERIOR_EMP_ID = s.EMP_ID
group by s.last_name
ORDER BY s.last_name;


