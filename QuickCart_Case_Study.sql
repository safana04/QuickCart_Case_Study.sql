CREATE DATABASE QuickCartDB;
USE QuickCartDB;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    email VARCHAR(100),
    registration_date DATE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    stock_quantity INT
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    selling_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Customers VALUES
(1, 'Rahul', 'Trivandrum', 'rahul@gmail.com', '2025-01-10'),
(2, 'Anu', 'Kochi', 'anu@gmail.com', '2025-02-15'),
(3, 'Arun', 'Kollam', 'arun@gmail.com', '2025-03-20'),
(4, 'Meera', 'Trivandrum', 'meera@gmail.com', '2025-04-05'),
(5, 'Priya', 'Kozhikode', 'priya@gmail.com', '2025-05-12'),
(6, 'Kiran', 'Kochi', 'kiran@gmail.com', '2025-06-18');


INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 55000, 8),
(102, 'Headphones', 'Electronics', 2500, 25),
(103, 'Smartphone', 'Electronics', 22000, 5),
(104, 'T-Shirt', 'Fashion', 800, 40),
(105, 'Shoes', 'Fashion', 2500, 12),
(106, 'Mixer Grinder', 'Home Appliances', 3500, 6),
(107, 'Office Chair', 'Furniture', 7500, 4);

INSERT INTO Orders VALUES
(1001, 1, '2026-10-01', 'Delivered'),
(1002, 2, '2026-10-02', 'Delivered'),
(1003, 1, '2026-10-05', 'Delivered'),
(1004, 3, '2026-10-07', 'Cancelled'),
(1005, 4, '2026-10-10', 'Delivered'),
(1006, 5, '2026-10-12', 'Pending'),
(1007, 2, '2026-10-15', 'Delivered'),
(1008, 3, '2026-10-18', 'Delivered');

INSERT INTO Order_Items VALUES
(1, 1001, 101, 1, 54000),
(2, 1001, 102, 2, 2300),
(3, 1002, 104, 3, 750),
(4, 1002, 105, 1, 2400),
(5, 1003, 103, 1, 21500),
(6, 1004, 106, 1, 3400),
(7, 1005, 107, 1, 7200),
(8, 1006, 102, 1, 2300),
(9, 1007, 104, 2, 750),
(10, 1008, 106, 2, 3300),
(11, 1008, 105, 1, 2400);

INSERT INTO Payments VALUES
(1, 1001, 'UPI', 'Paid', 58600),
(2, 1002, 'Credit Card', 'Paid', 4650),
(3, 1003, 'UPI', 'Paid', 21500),
(4, 1004, 'Debit Card', 'Refunded', 3400),
(5, 1005, 'UPI', 'Paid', 7200),
(6, 1006, 'Cash on Delivery', 'Pending', 2300),
(7, 1007, 'Credit Card', 'Paid', 1500),
(8, 1008, 'UPI', 'Paid', 9000);

 -- MISSION 1: DATA EXPLORATION 
-- Q1 
SELECT * FROM Customers;
-- Q2
SELECT * FROM Products;
-- Q3
SELECT * FROM  Orders;
-- Q4
SELECT COUNT(*) AS Total_Customers FROM Customers;
-- Q5
SELECT COUNT(*) AS Total_Products FROM Products;
-- Q6
SELECT COUNT(*) AS Total_Orders FROM Orders;
-- Q7
SELECT DISTINCT category
FROM Products;
-- Q8
SELECT *FROM Products
WHERE stock_quantity < 10;
-- Q9
SELECT * FROM orders
WHERE Order_status='cancelled';
-- Q10
SELECT *FROM Customers
WHERE city = 'Trivandrum';

-- MISSION 2: SALES ANALYSIS 
-- Q1
SELECT * FROM products
ORDER BY unit_price DESC
LIMIT 1;

-- Q2
SELECT * FROM products
ORDER BY unit_price ASC
LIMIT 1;

-- Q3
SELECT SUM(quantity) AS Total_Quantity_Sold
FROM Order_Items;

-- Q4
SELECT SUM(quantity*selling_price) AS Total_sales
FROM Order_Items;

-- Q5
SELECT AVG(selling_price) AS Average_Selling_Price
FROM Order_Items;

-- Q6
SELECT order_status, COUNT(*) AS Total_Orders
FROM Orders
GROUP BY order_status;

-- MISSION 3: CUSTOMER ANALYSIS 

-- Q1
SELECT Orders.order_id,
       Customers.customer_name,
       Orders.order_date,
       Orders.order_status
FROM Orders
INNER JOIN Customers
ON Orders.customer_id = Customers.customer_id;

-- Q2
SELECT Customers.customer_name,
       COUNT(Orders.order_id) AS Total_Orders
FROM Customers
LEFT JOIN Orders
ON Customers.customer_id = Orders.customer_id
GROUP BY Customers.customer_id, Customers.customer_name;

-- Q3
SELECT Customers.customer_name,
       SUM(Order_Items.quantity * Order_Items.selling_price) AS Total_Spent
FROM Customers
INNER JOIN Orders
ON Customers.customer_id = Orders.customer_id
INNER JOIN Order_Items
ON Orders.order_id = Order_Items.order_id
GROUP BY Customers.customer_id, Customers.customer_name;

-- Q4
SELECT Customers.customer_name,
       SUM(Order_Items.quantity * Order_Items.selling_price) AS Total_Spent
FROM Customers
INNER JOIN Orders
ON Customers.customer_id = Orders.customer_id
INNER JOIN Order_Items
ON Orders.order_id = Order_Items.order_id
GROUP BY Customers.customer_id, Customers.customer_name
ORDER BY Total_Spent DESC
LIMIT 1;

-- Q5
SELECT Customers.*
FROM Customers
LEFT JOIN Orders
ON Customers.customer_id = Orders.customer_id
WHERE Orders.order_id IS NULL;

-- Q6
SELECT Customers.customer_name,
       COUNT(Orders.order_id) AS Total_Orders
FROM Customers
INNER JOIN Orders
ON Customers.customer_id = Orders.customer_id
GROUP BY Customers.customer_id, Customers.customer_name
HAVING COUNT(Orders.order_id) > 2;

-- Q7
SELECT AVG(Order_Total) AS Average_Order_Value
FROM (
    SELECT order_id,
           SUM(quantity * selling_price) AS Order_Total
    FROM Order_Items
    GROUP BY order_id
) AS Order_Summary;

-- Q8
SELECT city,
       COUNT(*) AS Total_Customers
FROM Customers
GROUP BY city
ORDER BY Total_Customers DESC
LIMIT 1;

-- Q9
SELECT *
FROM Customers
WHERE registration_date < '2025-04-01';

-- Q10
SELECT Customers.customer_name,
       COUNT(Orders.order_id) AS Total_Orders
FROM Customers
INNER JOIN Orders
ON Customers.customer_id = Orders.customer_id
GROUP BY Customers.customer_id, Customers.customer_name
HAVING COUNT(Orders.order_id) > 1;

-- MISSION 4: PAYMENT ANALYSIS 

-- Q1
SELECT Orders.order_id,
       Orders.order_status,
       Payments.payment_method,
       Payments.payment_status,
       Payments.amount
FROM Orders
INNER JOIN Payments
ON Orders.order_id = Payments.order_id;

-- Q2
SELECT Orders.order_id,
       Payments.payment_status,
       Payments.amount
FROM Orders
INNER JOIN Payments
ON Orders.order_id = Payments.order_id
WHERE Payments.payment_status = 'Pending';

-- Q3
SELECT *
FROM Orders
WHERE order_status = 'Cancelled';

-- Q4
SELECT payment_method,
       SUM(amount) AS Total_Received
FROM Payments
WHERE payment_status = 'Paid'
GROUP BY payment_method;

-- Q5
SELECT
    SUM(CASE WHEN payment_status = 'Paid' THEN 1 ELSE 0 END) AS Successful_Payments,
    SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS Failed_Payments
FROM Payments;

-- Q6
SELECT Orders.order_id,
       Orders.order_status,
       Payments.payment_status
FROM Orders
INNER JOIN Payments
ON Orders.order_id = Payments.order_id
WHERE Orders.order_status = 'Delivered'
AND Payments.payment_status <> 'Paid';

-- Q7
SELECT payment_method,
       COUNT(*) AS Total_Uses
FROM Payments
GROUP BY payment_method
ORDER BY Total_Uses DESC
LIMIT 1;

-- MISSION 5: MANAGEMENT CHALLENGE 

-- Q1
SELECT Products.category,
       SUM(Order_Items.quantity) AS Total_Quantity_Sold,
       SUM(Order_Items.quantity * Order_Items.selling_price) AS Total_Sales
FROM Products
INNER JOIN Order_Items
ON Products.product_id = Order_Items.product_id
GROUP BY Products.category
ORDER BY Total_Sales ASC;

-- Q2
SELECT product_id,
       product_name,
       stock_quantity
FROM Products
WHERE stock_quantity < 10;

-- Q3
SELECT payment_method,
       COUNT(*) AS Total_Uses
FROM Payments
GROUP BY payment_method
ORDER BY Total_Uses DESC
LIMIT 1;

-- Q4
SELECT *
FROM Products
ORDER BY unit_price DESC
LIMIT 1 OFFSET 1;

-- Q5
SELECT *
FROM Products
WHERE product_id NOT IN (
    SELECT product_id
    FROM Order_Items
);

-- Q6
SELECT order_id,
       COUNT(item_id) AS Total_Product_Lines
FROM Order_Items
GROUP BY order_id
HAVING COUNT(item_id) > 1;



SELECT * FROM Customers; 
SELECT * FROM Products; 
SELECT * FROM Orders; 
SELECT * FROM Order_Items; 
SELECT * FROM Payments; 