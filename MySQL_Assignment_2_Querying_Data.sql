-- MySQL Assignment 2 - Querying Data
-- Based on the tables created in MySQL Assignment 1

USE employee;

-- =========================================
-- PART 1: QUERYING DATA
-- =========================================

-- 1. DISTINCT VALUES
-- Retrieve distinct salaries from the Employees table
SELECT DISTINCT salary
FROM Employees;


-- 2. ALIAS (AS)
-- Provide aliases for age and salary
SELECT age AS Employee_Age,
       salary AS Employee_Salary
FROM Employees;


-- 3. WHERE CLAUSE & OPERATORS

-- Retrieve employees with salary greater than 50000
-- and hired before 2016-01-01
SELECT *
FROM Employees
WHERE salary > 50000
  AND hire_date < '2016-01-01';


-- Find the employee whose designation is missing
SELECT *
FROM Employees
WHERE designation IS NULL;

-- Fill the missing designation with 'Data Scientist'
UPDATE Employees
SET designation = 'Data Scientist'
WHERE designation IS NULL;


-- =========================================
-- PART 2: SORTING AND GROUPING DATA
-- =========================================

-- 1. ORDER BY
-- Sort by department ID ascending and salary descending
SELECT *
FROM Employees
ORDER BY department_id ASC, salary DESC;


-- 2. LIMIT
-- Display the first 5 employees hired in 2018
SELECT *
FROM Employees
WHERE YEAR(hire_date) = 2018
ORDER BY hire_date ASC
LIMIT 5;


-- 3. AGGREGATE FUNCTIONS

-- Calculate the sum of all salaries in the Finance department
SELECT SUM(e.salary) AS Total_Finance_Salary
FROM Employees e
INNER JOIN Departments d
    ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';


-- Find the minimum age among all employees
SELECT MIN(age) AS Minimum_Age
FROM Employees;


-- 4. GROUP BY

-- List the maximum salary for each location
SELECT l.location,
       MAX(e.salary) AS Maximum_Salary
FROM Employees e
INNER JOIN Location l
    ON e.location_id = l.location_id
GROUP BY l.location_id, l.location;


-- Calculate the average salary for each designation
-- containing the word 'Analyst'
SELECT designation,
       AVG(salary) AS Average_Salary
FROM Employees
WHERE designation LIKE '%Analyst%'
GROUP BY designation;


-- 5. HAVING

-- Find departments with less than 3 employees
-- LEFT JOIN includes departments with 0 employees
SELECT d.department_name,
       COUNT(e.employee_id) AS Employee_Count
FROM Departments d
LEFT JOIN Employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) < 3;


-- Find locations with female employees whose average age is below 30
SELECT l.location,
       AVG(e.age) AS Average_Age
FROM Employees e
INNER JOIN Location l
    ON e.location_id = l.location_id
WHERE e.gender = 'F'
GROUP BY l.location_id, l.location
HAVING AVG(e.age) < 30;


-- =========================================
-- PART 3: JOINS
-- =========================================

-- 1. INNER JOIN
-- List employee names, designations, and department names
-- where employees are assigned to a department
SELECT e.employee_name,
       e.designation,
       d.department_name
FROM Employees e
INNER JOIN Departments d
    ON e.department_id = d.department_id;


-- 2. LEFT JOIN
-- List all departments with the total number of employees,
-- including departments with no employees
SELECT d.department_name,
       COUNT(e.employee_id) AS Total_Employees
FROM Departments d
LEFT JOIN Employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;


-- 3. RIGHT JOIN
-- Display all locations with employee names.
-- Locations with no employees will show NULL for employee_name.
SELECT l.location,
       e.employee_name
FROM Employees e
RIGHT JOIN Location l
    ON e.location_id = l.location_id;
