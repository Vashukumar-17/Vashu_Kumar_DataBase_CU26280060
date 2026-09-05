#Q1
GRANT SELECT ON company_db.* TO 'john'@'localhost';


#Q2
GRANT SELECT, INSERT ON company_db.employees TO 'alice'@'localhost';


#Q3
REVOKE INSERT ON company_db.employees FROM 'alice'@'localhost';


#Q4
START TRANSACTION;


#Q5
COMMIT;


#Q6
ROLLBACK;


#Q7
SAVEPOINT sp_before_update;


#Q8
GRANT ALL PRIVILEGES ON *.* TO 'admin_user'@'%' WITH GRANT OPTION;


#Q9
FLUSH PRIVILEGES;


#Q10
REVOKE ALL PRIVILEGES, GRANT OPTION ON company_db.* FROM 'intern_user'@'localhost';


#Q11
GRANT DELETE ON company_db.orders TO 'dev_user'@'localhost';


#Q12
START TRANSACTION;
UPDATE company_db.employees SET salary = 80000.00 WHERE emp_id = 101;
SAVEPOINT sp_first;
UPDATE company_db.employees SET salary = 95000.00 WHERE emp_id = 102;
ROLLBACK TO SAVEPOINT sp_first;
COMMIT;


#Q13
REVOKE UPDATE ON company_db.employees FROM 'hr_assistant'@'localhost';


#Q14
SET TRANSACTION READ ONLY;
START TRANSACTION;
SELECT * FROM company_db.employees;
COMMIT;


#Q15
START TRANSACTION;
UPDATE company_db.employees SET salary = 85000.00 WHERE emp_id = 101;
ALTER TABLE company_db.employees ADD COLUMN transaction_demo INT NULL;


#Q16
START TRANSACTION;
UPDATE company_db.departments SET budget = budget - 10000.00 WHERE dept_id = 10;
UPDATE company_db.departments SET budget = budget + 10000.00 WHERE dept_id = 20;
COMMIT;


#Q17
SHOW GRANTS FOR 'team_lead'@'localhost';


#Q18
REVOKE GRANT OPTION ON company_db.* FROM 'team_lead'@'localhost';


#Q19
START TRANSACTION;
UPDATE company_db.orders SET status = 'Shipped' WHERE order_id = 5002 AND status = 'Pending';
ROLLBACK;


#Q20
CREATE ROLE 'reporter_role';
GRANT SELECT ON company_db.* TO 'reporter_role';
GRANT 'reporter_role' TO 'analyst'@'localhost';
SET DEFAULT ROLE 'reporter_role' TO 'analyst'@'localhost';


#Q21
START TRANSACTION;
UPDATE company_db.employees SET salary = salary * 1.15 WHERE dept_id = 10;
SAVEPOINT sp_salary_done;
UPDATE company_db.departments SET budget = budget + 50000.00 WHERE dept_id = 10;
ROLLBACK TO SAVEPOINT sp_salary_done;
COMMIT;


#Q22
START TRANSACTION;
SELECT * FROM company_db.employees WHERE emp_id = 101 FOR UPDATE;
UPDATE company_db.employees SET salary = 88000.00 WHERE emp_id = 101;
COMMIT;


#Q23
START TRANSACTION;
SELECT * FROM company_db.departments WHERE dept_id = 10 FOR SHARE;
SELECT * FROM company_db.departments WHERE dept_id = 10;
COMMIT;


#Q24
ALTER USER 'auditor'@'localhost' WITH MAX_QUERIES_PER_HOUR 100 MAX_USER_CONNECTIONS 2;


#Q25
START TRANSACTION;
UPDATE company_db.orders SET status = 'Cancelled' WHERE order_id = 5002 AND status = 'Pending' AND total_amount = 450.00;
UPDATE company_db.departments SET budget = budget + 450.00 WHERE dept_id = 20;
COMMIT;


#Q26
CREATE ROLE 'read_role';
CREATE ROLE 'write_role';
CREATE ROLE 'admin_role';
GRANT SELECT ON company_db.* TO 'read_role';
GRANT INSERT, UPDATE, DELETE ON company_db.* TO 'write_role';
GRANT 'read_role' TO 'write_role';
GRANT 'write_role' TO 'admin_role';
CREATE USER 'super_dev'@'localhost' IDENTIFIED BY 'SuperDevPass2026!';
GRANT 'admin_role' TO 'super_dev'@'localhost';
SET DEFAULT ROLE 'admin_role' TO 'super_dev'@'localhost';


#Q27
-- SESSION 1
START TRANSACTION;
SELECT * FROM company_db.employees WHERE emp_id = 101 FOR UPDATE;
UPDATE company_db.employees SET salary = salary + 1000 WHERE emp_id = 102;
-- SESSION 2
START TRANSACTION;
SELECT * FROM company_db.employees WHERE emp_id = 102 FOR UPDATE;
UPDATE company_db.employees SET salary = salary + 1000 WHERE emp_id = 101;


#Q28
CREATE USER 'cloud_user'@'%' IDENTIFIED BY 'CloudPass2026!' REQUIRE SSL;
GRANT SELECT, INSERT ON company_db.* TO 'cloud_user'@'%';


#Q29
START TRANSACTION;
INSERT INTO company_db.orders (order_id, customer_name, order_date, total_amount, status)
VALUES (5008, 'New Customer 5008', '2024-02-01', 1000.00, 'Pending');
SAVEPOINT sp_5008;
INSERT INTO company_db.orders (order_id, customer_name, order_date, total_amount, status)
VALUES (5009, 'New Customer 5009', '2024-02-02', 50.00, 'Pending');
SAVEPOINT sp_5009;
ROLLBACK TO SAVEPOINT sp_5008;
COMMIT;


#Q30
CREATE USER 'test_maint'@'localhost' IDENTIFIED BY 'TestMaintPass2026!';
GRANT SELECT, INSERT, UPDATE ON company_db.* TO 'test_maint'@'localhost';
START TRANSACTION;
UPDATE company_db.employees SET is_active = TRUE WHERE emp_id = 104;
ROLLBACK;
SHOW GRANTS FOR 'test_maint'@'localhost';
REVOKE SELECT, INSERT, UPDATE ON company_db.* FROM 'test_maint'@'localhost';
ALTER USER 'test_maint'@'localhost' ACCOUNT LOCK;