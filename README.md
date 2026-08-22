# MySQL Assignment 1

## About the Assignment

This assignment demonstrates the use of MySQL DDL commands and constraints using an Employee Database.

The database contains three tables:

* Departments
* Location
* Employees

## Tools Used

* MySQL
* MySQL Workbench
* GitHub

## What I Did

### Database Creation

Created a database named `employee` and selected it using the `USE` command.

### Table Creation

Created three tables:

* `Departments`
* `Location`
* `Employees`

The Employees table contains employee details including employee ID, employee name, gender, age, hire date, designation, department ID, location ID, and salary.

### ALTER TABLE Operations

Performed the following changes to the Employees table:

* Added an `email` column.
* Modified `designation` from `VARCHAR(100)` to `VARCHAR(200)`.
* Dropped the `age` column.
* Renamed `hire_date` to `date_of_joining`.

### Table Renaming

Renamed:

* `Departments` to `Departments_Info`
* `Location` to `Locations`

### TRUNCATE

Used `TRUNCATE TABLE` on the Employees table to remove all records while keeping the table structure.

### DROP

Dropped:

* Employees table
* employee database

## Constraints

Recreated the employee database and added the required constraints.

### Departments Table

Applied:

* `PRIMARY KEY` on `department_id`
* `NOT NULL` on `department_name`
* `UNIQUE` on `department_name`

### Location Table

Applied:

* `PRIMARY KEY` on `location_id`
* `AUTO_INCREMENT` on `location_id`
* `NOT NULL` on `location`
* `UNIQUE` on `location`

### Employees Table

Applied:

* `PRIMARY KEY` on `employee_id`
* `NOT NULL` on `employee_name`
* `ENUM('M', 'F')` for gender
* `CHECK (age >= 18)` for age
* `DEFAULT (CURRENT_DATE)` for `hire_date`
* Foreign key between `department_id` and `Departments`
* Foreign key between `location_id` and `Location`

## SQL File

The file `MySQL_Assignment_1.sql` contains all SQL commands completed for this assignment.
