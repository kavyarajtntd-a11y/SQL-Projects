-- MySQL Assignment 1 - DDL Commands & Constraints

-- =========================================
-- PART 1: DDL COMMANDS
-- =========================================

-- 1. Create database
CREATE DATABASE employee;
USE employee;

-- Create Departments table
CREATE TABLE Departments (
    department_id INT,
    department_name VARCHAR(100)
);

-- Create Location table
CREATE TABLE Location (
    location_id INT,
    location VARCHAR(30)
);

-- Create Employees table
CREATE TABLE Employees (
    employee_id INT,
    employee_name VARCHAR(50),
    gender ENUM('M', 'F'),
    age INT,
    hire_date DATE,
    designation VARCHAR(100),
    department_id INT,
    location_id INT,
    salary DECIMAL(10,2)
);

-- 2. ALTER TABLE

-- Add email column
ALTER TABLE Employees
ADD email VARCHAR(100);

-- Modify designation column
ALTER TABLE Employees
MODIFY designation VARCHAR(200);

-- Drop age column
ALTER TABLE Employees
DROP COLUMN age;

-- Rename hire_date column
ALTER TABLE Employees
RENAME COLUMN hire_date TO date_of_joining;

-- 3. Rename tables
RENAME TABLE Departments TO Departments_Info;
RENAME TABLE Location TO Locations;

-- 4. Truncate Employees table
TRUNCATE TABLE Employees;

-- 5. Drop Employees table and employee database
DROP TABLE Employees;
DROP DATABASE employee;


-- =========================================
-- PART 2: CONSTRAINTS
-- =========================================

-- 1. Recreate database
DROP DATABASE IF EXISTS employee;
CREATE DATABASE employee;
USE employee;

-- 2. Departments table with constraints
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Location table with constraints
CREATE TABLE Location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(30) NOT NULL UNIQUE
);

-- 4. Employees table with constraints
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    gender ENUM('M', 'F'),
    age INT CHECK (age >= 18),
    hire_date DATE DEFAULT (CURRENT_DATE),
    designation VARCHAR(100),
    department_id INT,
    location_id INT,
    salary DECIMAL(10,2),

    FOREIGN KEY (department_id)
        REFERENCES Departments(department_id),

    FOREIGN KEY (location_id)
        REFERENCES Location(location_id)
);
