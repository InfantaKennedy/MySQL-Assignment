-- 1. Database Setup & Data Entry
CREATE DATABASE ElearningDB;
SHOW DATABASES;
USE ElearningDB;
CREATE TABLE Learners(
learner_id INT PRIMARY KEY,
full_name VARCHAR(50),
country VARCHAR(50));
CREATE TABLE Courses(
course_id INT PRIMARY KEY,
course_name VARCHAR(50),
category VARCHAR(50),
unit_price DECIMAL(10,2)
);
CREATE TABLE Purchases(
purchase_id INT PRIMARY KEY,
learner_id INT,
course_id INT,
quantity INT,
purchase_date DATE,
FOREIGN KEY(learner_id)
REFERENCES Learners(learner_id),
FOREIGN KEY(course_id)
REFERENCES Courses(course_id)
);
SHOW TABLES;
INSERT INTO Learners VALUES
(101,'Aarav Mehta','India'),
(102,'Sneha Reddy','India'),
(103,'Michael Johnson','USA'),
(104,'Sophia Wilson','Canada'),
(105,'Fatima Ali','UAE');
INSERT INTO Courses VALUES
(201,'SQL Masterclass','Database',4500),
(202,'Python for Data Analysis','Programming',6500),
(203,'Power BI Dashboard','Visualization',5500),
(204,'Excel Advanced','Productivity',3000),
(205,'Machine Learning Basics','Beginner',7000);
INSERT INTO Purchases VALUES
(1,101,201,2,'2026-01-15'),
(2,101,203,1,'2026-02-10'),
(3,102,202,2,'2026-01-18'),
(4,103,205,1,'2026-03-12'),
(5,104,204,3,'2026-02-25'),
(6,105,202,1,'2026-04-05'),
(7,102,201,1,'2026-04-20'),
(8,103,203,2,'2026-05-10');
DESC Learners;
DESC Courses;
DESC Purchases;
SELECT * FROM Learners;
SELECT * FROM Courses;
SELECT * FROM Purchases;
-- 2. Data Exploration Using Joins
-- INNER JOIN
SELECT
l.full_name AS Learner_Name,
c.course_name AS Course_Name,
c.category AS Category,
p.quantity AS Quantity,
FORMAT(c.unit_price*p.quantity,2) AS Total_Amount,
p.purchase_date AS Purchase_Date
FROM purchases p
INNER JOIN learners l
ON p.learner_id=l.learner_id
INNER JOIN courses c
ON p.course_id=c.course_id
ORDER BY c.unit_price*p.quantity DESC;

-- LEFT JOIN
SELECT
l.full_name,
c.course_name,
c.category,
p.quantity,
FORMAT(c.unit_price*p.quantity,2) AS Total_Amount,
p.purchase_date
FROM learners l
LEFT JOIN purchases p
ON l.learner_id=p.learner_id
LEFT JOIN courses c
ON p.course_id=c.course_id;

-- RIGHT JOIN
SELECT
l.full_name,
c.course_name,
c.category,
p.quantity,
FORMAT(c.unit_price*p.quantity,2) AS Total_Amount,
p.purchase_date
FROM purchases p
RIGHT JOIN courses c
ON p.course_id=c.course_id
LEFT JOIN learners l
ON p.learner_id=l.learner_id;

-- 3. Core Analytical Queries (Q1–Q5)
-- Q1. Display each learner’s total spending with their country.
SELECT
l.full_name,
l.country,
SUM(c.unit_price*p.quantity) AS Total_Spending
FROM learners l
JOIN purchases p
ON l.learner_id=p.learner_id
JOIN courses c
ON p.course_id=c.course_id
GROUP BY l.full_name,l.country;

-- Q2. Find the top 3 most purchased courses by quantity.
SELECT
c.course_name,
SUM(p.quantity) AS Total_Quantity
FROM purchases p
JOIN courses c
ON p.course_id=c.course_id
GROUP BY c.course_name
ORDER BY Total_Quantity DESC
LIMIT 3;

-- Q3. Show each category’s: ● Total revenue ● Number of unique learners
SELECT
c.category,
SUM(c.unit_price*p.quantity) AS Total_Revenue,
COUNT(DISTINCT p.learner_id) AS Unique_Learners
FROM purchases p
JOIN courses c
ON p.course_id=c.course_id
GROUP BY c.category;

-- Q4. List learners who purchased from more than one category
SELECT
l.full_name,
COUNT(DISTINCT c.category) AS Categories
FROM learners l
JOIN purchases p
ON l.learner_id=p.learner_id
JOIN courses c
ON p.course_id=c.course_id
GROUP BY l.full_name
HAVING COUNT(DISTINCT c.category)>1;

-- Q5. Identify courses never purchased
SELECT
c.course_name
FROM courses c
LEFT JOIN purchases p
ON c.course_id=p.course_id
WHERE p.course_id IS NULL;

-- 4. Subqueries & Correlated Subqueries
-- Q6. Find learners whose total spending is above the average learner spending
SELECT *
FROM
(
SELECT
l.learner_id,
l.full_name,
SUM(c.unit_price*p.quantity) AS Spending
FROM learners l
JOIN purchases p
ON l.learner_id=p.learner_id
JOIN courses c
ON p.course_id=c.course_id
GROUP BY l.learner_id,l.full_name
) t
WHERE Spending>
(
SELECT AVG(Spending)
FROM
(
SELECT
SUM(c.unit_price*p.quantity) AS Spending
FROM purchases p
JOIN courses c
ON p.course_id=c.course_id
GROUP BY learner_id
) x
);

-- Q7. Display courses whose price is higher than any course in the ‘Beginner’ category
SELECT *
FROM courses
WHERE unit_price>
ANY
(
SELECT unit_price
FROM courses
WHERE category='Beginner'
);

-- Q8 . Find learners who spent more than the average spending in their country
SELECT
l.full_name,
l.country,
(
SELECT SUM(c.unit_price * p.quantity)
FROM purchases p
JOIN courses c ON p.course_id = c.course_id
WHERE p.learner_id = l.learner_id
) AS total_spending
FROM learners l
WHERE
(
SELECT SUM(c.unit_price * p.quantity)
FROM purchases p
JOIN courses c ON p.course_id = c.course_id
WHERE p.learner_id = l.learner_id
)
>
(
SELECT AVG(country_total)
FROM
(
SELECT
l2.learner_id,
SUM(c2.unit_price * p2.quantity) AS country_total
FROM learners l2
JOIN purchases p2 ON l2.learner_id = p2.learner_id
JOIN courses c2 ON p2.course_id = c2.course_id
WHERE l2.country = l.country
GROUP BY l2.learner_id
) t
);

-- 5. CTE, CASE, View, and NULL Handling
-- Q9. Use a CTE to calculate total spending per learner, then: Display learners with spending above 10,000
WITH Spending AS
(
SELECT
l.full_name,
SUM(c.unit_price*p.quantity) AS Total_Spending
FROM learners l
JOIN purchases p
ON l.learner_id=p.learner_id
JOIN courses c
ON p.course_id=c.course_id
GROUP BY l.full_name
)
SELECT *
FROM Spending
WHERE Total_Spending>10000;

-- Q10. CASE Expression
-- Classify learners based on spending:● Above 15,000 → “High Value”,● 8,000–15,000 → “Medium Value”,● Below 8,000 → “Low Value”
SELECT
l.full_name,
SUM(c.unit_price*p.quantity) AS Total_Spending,
CASE
WHEN SUM(c.unit_price*p.quantity)>15000
THEN 'High Value'
WHEN SUM(c.unit_price*p.quantity)
BETWEEN 8000 AND 15000
THEN 'Medium Value'
ELSE 'Low Value'
END AS Customer_Type
FROM learners l
JOIN purchases p
ON l.learner_id=p.learner_id
JOIN courses c
ON p.course_id=c.course_id
GROUP BY l.full_name;

-- Q11 . NULL Handling ● Display all courses and replace NULL purchase counts with 0 using: IFNULL() or COALESCE()
SELECT
c.course_name,
COALESCE(SUM(p.quantity),0) AS Purchase_Count
FROM courses c
LEFT JOIN purchases p
ON c.course_id=p.course_id
GROUP BY c.course_name;

-- Q12 . View● Create a view: category_performance_view Showing: Category, Total revenue, Number of purchases, Average revenue per purchase
CREATE VIEW category_performance_view AS
SELECT
    c.category,
    SUM(c.unit_price * p.quantity) AS Total_Revenue,
    COUNT(p.purchase_id) AS Number_of_Purchases,
    AVG(c.unit_price * p.quantity) AS Average_Revenue_Per_Purchase
FROM purchases p
JOIN courses c
ON p.course_id = c.course_id
GROUP BY c.category;
SELECT * FROM category_performance_view;

