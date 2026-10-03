#Q1
SELECT
    e.EmpName,
    d.DeptName,
    d.Location
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID;

-- --------------------------------------------------

#Q2
SELECT
    e.EmpID,
    e.EmpName,
    e.DeptID,
    d.DeptName
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID;

-- --------------------------------------------------

#Q3
SELECT
    e.EmpID,
    e.EmpName,
    e.DeptID,
    e.Salary,
    e.City,
    d.DeptName
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID
WHERE d.DeptName = 'Pharmacy';

-- --------------------------------------------------

#Q4
SELECT
    e.EmpName,
    d.DeptName,
    e.Salary
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID
WHERE e.Salary > 60000;

-- --------------------------------------------------

#Q5
SELECT
    e.EmpID,
    e.EmpName,
    e.DeptID,
    d.DeptName
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID;

-- --------------------------------------------------

#Q6
SELECT
    e.EmpName,
    e.City,
    d.DeptName,
    d.Location
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID;

-- --------------------------------------------------

#Q7
SELECT
    e.EmpName,
    d.DeptName
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID
WHERE d.DeptName = 'Computer Science';

-- --------------------------------------------------

#Q8
SELECT
    e.EmpName,
    e.Salary,
    sg.Grade,
    sg.MinSalary
FROM Employees e
INNER JOIN SalaryGrades sg
    ON e.Salary > sg.MinSalary;

-- --------------------------------------------------

#Q9
SELECT
    e.EmpName,
    e.Salary,
    sg.Grade
FROM Employees e
INNER JOIN SalaryGrades sg
    ON e.Salary >= sg.MinSalary
   AND e.Salary <= sg.MaxSalary;

-- --------------------------------------------------

#Q10
SELECT
    e.EmpName,
    e.Salary,
    sg.Grade,
    sg.MaxSalary
FROM Employees e
INNER JOIN SalaryGrades sg
    ON e.Salary < sg.MaxSalary;

-- --------------------------------------------------

#Q11
SELECT
    e.EmpName,
    e.Salary,
    sg.Grade
FROM Employees e
INNER JOIN SalaryGrades sg
    ON e.Salary >= sg.MinSalary;

-- --------------------------------------------------

#Q12
SELECT
    EmpName,
    DeptID,
    DeptName
FROM Employees
NATURAL JOIN Departments;

-- --------------------------------------------------

#Q13
SELECT
    EmpName,
    DeptID,
    DeptName,
    Location
FROM Employees
NATURAL JOIN Departments
WHERE Location = 'Block B';

-- --------------------------------------------------

#Q14
SELECT
    EmpName,
    DeptName,
    Salary
FROM Employees
NATURAL JOIN Departments
WHERE Salary >= 70000;

-- --------------------------------------------------

#Q15
SELECT
    e.EmpName,
    d.DeptName,
    e.Salary
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID
ORDER BY e.Salary DESC;

-- --------------------------------------------------

#Q16
SELECT DISTINCT
    d.DeptName
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID;

-- --------------------------------------------------

#Q17
SELECT
    d.DeptName,
    COUNT(e.EmpID) AS employee_count
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID
GROUP BY d.DeptName;

-- --------------------------------------------------

#Q18
SELECT
    d.DeptName,
    AVG(e.Salary) AS average_salary
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID
GROUP BY d.DeptName;

-- --------------------------------------------------

#Q19
SELECT
    d.DeptName,
    AVG(e.Salary) AS average_salary
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID
GROUP BY d.DeptName
HAVING AVG(e.Salary) > 60000;

-- --------------------------------------------------

#Q20
SELECT
    e.EmpName,
    d.DeptName,
    e.Salary
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID
WHERE e.Salary = (
    SELECT MAX(e2.Salary)
    FROM Employees e2
    INNER JOIN Departments d2
        ON e2.DeptID = d2.DeptID
);

-- --------------------------------------------------

#Q21
SELECT
    e.EmpName,
    d.DeptName
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID
WHERE d.DeptName IN ('Computer Science', 'Pharmacy');

-- --------------------------------------------------

#Q22
SELECT
    e.EmpName,
    e.City,
    e.Salary,
    d.DeptName
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID
WHERE e.City IN ('Delhi', 'Pune')
  AND e.Salary >= 50000;

-- --------------------------------------------------

#Q23
SELECT
    e.EmpID,
    e.EmpName,
    e.DeptID,
    e.Salary,
    e.City,
    d.DeptName
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID;

-- Employee Neha (EmpID 106) is excluded because
-- her DeptID is 50, and there is no Department with DeptID 50.

-- --------------------------------------------------

#Q24
SELECT
    DeptID,
    DeptName,
    COUNT(EmpID) AS employee_count
FROM Employees
NATURAL JOIN Departments
GROUP BY DeptID, DeptName;

-- --------------------------------------------------

#Q25
SELECT
    d.DeptName,
    SUM(e.Salary) AS total_salary
FROM Employees e
INNER JOIN Departments d
    ON e.DeptID = d.DeptID
GROUP BY d.DeptName
HAVING SUM(e.Salary) > 100000;

-- --------------------------------------------------
