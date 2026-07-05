CREATE DATABASE EmployeeDB;
SHOW DATABASES;
USE EmployeeDB;
CREATE TABLE Departments(
department_id INT PRIMARY KEY,
department_name VARCHAR(50)
);
CREATE TABLE Location(
location_id INT PRIMARY KEY,
location_name VARCHAR(50)
);
CREATE TABLE Employees(
employee_id INT PRIMARY kEY,
Employee_name VARCHAR(100),
Gender ENUM('M','F'),
Age INT,
Hire_date DATE,
Designation VARCHAR(100),
Salary DECIMAL(10,2),
department_id INT,
location_id INT,
FOREIGN KEY (department_id)
REFERENCES Departments(department_id),
FOREIGN KEY (location_id)
REFERENCES Location(location_id)
);
ALTER TABLE Employees
ADD email VARCHAR(50);
ALTER TABLE Employees
MODIFY Designation VARCHAR(200);
/* Checking the above */
DESCRIBE Employees;
ALTER TABLE Employees
DROP COLUMN age;
DESCRIBE Employees;      /* checking age drop query */
ALTER TABLE Employees
RENAME COLUMN Hire_date TO date_of_joining;
DESCRIBE Employees;      /* checking rename query */
RENAME TABLE Departments TO Departments_Info;  /* Renaming Department table name */
RENAME TABLE Location TO Locations;  /* Renaming Location table name */
TRUNCATE Table Employees;
SELECT * FROM Employees;
DROP TABLE Employees;
DROP DATABASE EmployeeDB;
SHOW DATABASES;
DROP DATABASE IF EXISTS EmployeeDB;
CREATE DATABASE EmployeeDB;
USE EmployeeDB;
SHOW DATABASES;
CREATE TABLE Departments(
department_id INT PRIMARY KEY,
department_name VARCHAR(50) NOT NULL UNIQUE
);
DESCRIBE Departments;
CREATE TABLE Locations(
location_id INT PRIMARY KEY auto_increment,
location_name VARCHAR(50) NOT NULL UNIQUE
);
DESCRIBE Locations;
CREATE TABLE Employees(
employee_id INT PRIMARY KEY,
Employee_name VARCHAR(100) NOT NULL,
Gender ENUM('M','F') NOT NULL,
Age INT CHECK(Age >= 18),
Hire_date DATE DEFAULT(CURRENT_DATE),
Designation VARCHAR(100),
Salary DECIMAL(10,2),
department_id INT,
location_id INT,
FOREIGN KEY (department_id)
REFERENCES Departments(department_id),
FOREIGN KEY (location_id)
REFERENCES Locations(location_id)
);
DESCRIBE Employees;
SHOW TABLES;
