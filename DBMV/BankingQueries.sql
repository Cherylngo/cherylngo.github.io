/* Cheryl Ngo, Module 3 Assignment: Banking
March 24, 2019 */

USE banking;

-- Query 1: Employees who are tellers
SELECT FIRST_NAME TellerFirst, LAST_NAME TellerLast
FROM employee
WHERE TITLE='teller'
ORDER BY START_DATE;

-- Query 2: Product with account
SELECT NAME ProductName
FROM product
WHERE NAME LIKE '%account%';

-- Query 3: Product avg, min, max available balance
SELECT NAME Name, avg(AVAIL_BALANCE) AvgBalance, min(AVAIL_BALANCE) MinBalance, max(AVAIL_BALANCE) MaxBalance
FROM product, account
GROUP BY NAME;

-- Query 4: CustID, number of accounts, avg balance
SELECT CUST_ID Customer, count(ACCOUNT_ID) NoOfAccounts, avg(AVAIL_BALANCE) AverageAvailBalance
FROM account
WHERE CUST_ID IN (SELECT CUST_ID
		FROM account
        GROUP BY CUST_ID
        HAVING sum(AVAIL_BALANCE)>1000)
GROUP BY CUST_ID;

-- Query 5: Max pending balance
SELECT max(PENDING_BALANCE) PendingBal, OPEN_BRANCH_ID BranchID, PRODUCT_CD ProductCD
FROM account
GROUP BY OPEN_BRANCH_ID, PRODUCT_CD
HAVING max(PENDING_BALANCE)>2000;

-- Query 6: Accounts below avg available balance
SELECT ACCOUNT_ID Account, CUST_ID Customer, PRODUCT_CD Product, OPEN_BRANCH_ID Branch
FROM account
WHERE AVAIL_BALANCE < (SELECT avg(AVAIL_BALANCE)
						FROM account);
 
-- Query 7: Accounts below avg availabe balance ordered
SELECT ACCOUNT_ID, LAST_NAME, FIRST_NAME, p.NAME PRODUCT_NAME, b.NAME BRANCH
FROM account a, individual i, product p, branch b
WHERE a.CUST_ID=i.CUST_ID 
	AND a.OPEN_BRANCH_ID=b.BRANCH_ID
	AND p.PRODUCT_CD=a.PRODUCT_CD
	AND AVAIL_BALANCE < (SELECT avg(AVAIL_BALANCE)
						FROM account)
ORDER BY LAST_NAME;
        
-- Query 8: Customers with more than 2 accounts
SELECT FIRST_NAME, LAST_NAME
FROM individual 
WHERE CUST_ID IN (SELECT CUST_ID
					FROM account
                    GROUP BY CUST_ID
                    HAVING count(CUST_ID)>2);
                    
-- Query 9: Employee info
SELECT e.LAST_NAME EELast, e.FIRST_NAME EEFirst, TIMESTAMPDIFF(YEAR, e.START_DATE, CURDATE()) 'Years with Company', m.LAST_NAME MgrLast
FROM employee e, employee m
WHERE e.SUPERIOR_EMP_ID=m.EMP_ID
ORDER BY m.LAST_NAME;

-- Query 10: Supervisors
SELECT m.LAST_NAME 'Supervisor Last Name', count(e.EMP_ID) 'Number of employees'
FROM employee e, employee m
WHERE m.EMP_ID = e.SUPERIOR_EMP_ID
GROUP BY e.SUPERIOR_EMP_ID;
