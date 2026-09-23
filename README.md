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





Yes. Here are matching README sections for your Assignment 2 and Final Module Assignment.

# MySQL Assignment 2

## About the Assignment

This assignment demonstrates querying, sorting, grouping, aggregate functions, and joins using the Employee Database created in MySQL Assignment 1.

The database contains three tables:

* Departments
* Location
* Employees

## Tools Used

* MySQL
* MySQL Workbench
* GitHub

## What I Did

### DISTINCT

Retrieved unique salary values from the `Employees` table.

### Column Aliases

Used `AS` to rename:

* `age` as `Employee_Age`
* `salary` as `Employee_Salary`

### WHERE Clause and Operators

Retrieved employees:

* With salary greater than 50000.
* Hired before `2016-01-01`.

Also identified employees with a missing designation and updated the missing value to `Data Scientist`. 

### ORDER BY

Sorted employees by:

* `department_id` in ascending order.
* `salary` in descending order.

### LIMIT

Displayed the first 5 employees hired in 2018. 

### Aggregate Functions

Used aggregate functions to:

* Calculate the total salary of employees in the Finance department.
* Find the minimum age among all employees.

### GROUP BY

Used `GROUP BY` to:

* Find the maximum salary for each location.
* Calculate the average salary for each designation containing the word `Analyst`.

### HAVING

Used `HAVING` to:

* Find departments with fewer than 3 employees.
* Find locations where female employees have an average age below 30. 

### Joins

Performed different types of joins.

#### INNER JOIN

Displayed:

* Employee name.
* Designation.
* Department name.

#### LEFT JOIN

Displayed all departments with the total number of employees, including departments with no employees.

#### RIGHT JOIN

Displayed all locations with employee names, including locations where no employee is assigned. 

## SQL File

The file `MySQL_Assignment_2_Querying_Data.sql` contains all SQL queries completed for this assignment.

# Module End Assignment 2

## E-Commerce Customer Churn Analysis

## About the Assignment

This project analyses customer churn in an e-commerce business using MySQL.

The objective is to clean and transform customer data, analyse customer behaviour, identify churn patterns, and extract useful business insights.

The analysis considers factors such as:

* Customer tenure.
* Payment mode.
* Preferred order category.
* Satisfaction score.
* Complaints.
* Order behaviour.
* Cashback amount.
* Distance from warehouse.
* Customer churn status. 

## Tools Used

* MySQL
* MySQL Workbench
* GitHub

## Database

Created and used the database:

`ecomm`

The main table used for analysis is:

`customer_churn`

The dataset contains customer information including CustomerID, churn status, tenure, preferred login device, city tier, warehouse distance, payment mode, gender, order category, satisfaction score, complaints, order count, and cashback amount. 

## What I Did

### Data Cleaning

Handled missing values using mean and mode imputation.

Used mean values for:

* `WarehouseToHome`
* `HourSpendOnApp`
* `OrderAmountHikeFromlastYear`
* `DaySinceLastOrder`

Used mode values for:

* `Tenure`
* `CouponUsed`
* `OrderCount`

Removed outliers where `WarehouseToHome` was greater than 100. 

### Data Standardisation

Corrected inconsistent values in the dataset.

Updated:

* `Phone` to `Mobile Phone` in `PreferredLoginDevice`.
* `Mobile` to `Mobile Phone` in the preferred order category.
* `COD` to `Cash on Delivery`.
* `CC` to `Credit Card`. 

### Column Renaming

Renamed:

* `PreferedOrderCat` to `PreferredOrderCat`.
* `HourSpendOnApp` to `HoursSpentOnApp`.

### Creating New Columns

Created:

* `ComplaintReceived`
* `ChurnStatus`

`ComplaintReceived` contains:

* `Yes` when a complaint was received.
* `No` otherwise.

`ChurnStatus` contains:

* `Churned` when the customer churned.
* `Active` otherwise.

### Column Dropping

Removed the original:

* `Churn`
* `Complain`

columns after creating the new readable columns. 

## Data Exploration and Analysis

Performed SQL analysis to:

* Count active and churned customers.
* Calculate average tenure and total cashback for churned customers.
* Calculate the percentage of churned customers who complained.
* Identify the city tier with the most churned Laptop & Accessory customers.
* Find the most preferred payment mode among active customers.
* Calculate order amount hike for single customers who prefer mobile phones.
* Find the average number of registered devices for UPI customers.
* Identify the city tier with the highest number of customers.
* Identify which gender used the highest number of coupons.
* Find customer count and maximum app usage for each order category.
* Calculate total orders for Credit Card customers with the highest satisfaction score.
* Calculate average satisfaction score for customers who complained.
* Find preferred categories for customers who used more than 5 coupons.
* Find the top 3 order categories based on average cashback.
* Analyse payment modes based on average tenure and total order count. 

### Distance Analysis

Categorised customers based on the distance between warehouse and home:

* Very Close Distance, less than or equal to 5 km.
* Close Distance, less than or equal to 10 km.
* Moderate Distance, less than or equal to 15 km.
* Far Distance, greater than 15 km.

Analysed Active and Churned customers within each distance group. 

### Customer Order Analysis

Identified married customers who:

* Live in City Tier 1.
* Have order counts higher than the overall average order count. 

## Customer Returns Table

Created a new table named:

`customer_returns`

The table contains:

* ReturnID.
* CustomerID.
* ReturnDate.
* RefundAmount.

Inserted the 8 return records provided in the assignment. 

### JOIN Analysis

Joined `customer_returns` with `customer_churn` using `CustomerID`.

Displayed return and customer details for customers who:

* Churned.
* Made a complaint. 

## SQL File

The file `Module_End_Assignment_2_Ecommerce_Customer_Churn_Analysis.sql` contains all SQL commands used for data cleaning, transformation, analysis, and customer return analysis.

