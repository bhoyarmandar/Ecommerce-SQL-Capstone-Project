
create database ecommerce_db;
use ecommerce_db;

--  1) customers table
CREATE TABLE customers (customer_id INT PRIMARY KEY, name VARCHAR(100), email VARCHAR(100), city VARCHAR(50), signup_date DATE ); 
 
 -- 2) products table
create table products (product_id INT PRIMARY KEY, product_name VARCHAR(255),category VARCHAR(50), price DECIMAL(10,2), stock_quantity INT ); 

-- 3) Orders table
CREATE TABLE orders (order_id INT PRIMARY KEY, customer_id INT, order_date DATE,status VARCHAR(20), FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ); 


-- 4) Order_Items table
CREATE TABLE order_items (order_item_id INT PRIMARY KEY, order_id INT, product_id INT,     quantity INT, price DECIMAL(10,2), FOREIGN KEY (order_id) REFERENCES orders(order_id), FOREIGN KEY (product_id) REFERENCES products(product_id) ); 
 

-- 5) Payments table 
CREATE TABLE payments (payment_id INT PRIMARY KEY, order_id INT, payment_method VARCHAR(50),payment_status VARCHAR(20),amount DECIMAL(10,2), FOREIGN KEY (order_id) REFERENCES orders(order_id) ); 


-- 6) Shipping table
CREATE TABLE shipping (shipping_id INT PRIMARY KEY, order_id INT,shipping_status VARCHAR(50), delivery_date DATE, FOREIGN KEY (order_id) REFERENCES orders(order_id) ); 


SET GLOBAL local_infile = 1; 
select * from customers;
select * from products;
select * from orders;
select * from order_items;
select * from payments;
select * from shipping;



-- BUSINESS PROBLEMS 
-- (This project focuses on solving real-world business questions using SQL.) 


-- 1.	Total Customer Base Analysis 
-- Business Problem: 
-- The company wants to understand its overall user base. As a data analyst, you are asked to calculate the total number of registered customers in the system. 

SELECT COUNT(*) FROM customers;    
-- IT IS GIVING THE TOTAL NUMBER OF CUSTOMER WHO ARE REGISTERED.

-- 2.	City-Based Customer Segmentation 
-- Business Problem: 
-- The marketing team wants to run a campaign specifically in Pune. Retrieve all customers who belong to Pune so they can be targeted. 

select customer_id,name,city from customers where city='pune';
-- GIVING THE CUSTOMER LIST WHO BELONGS TO PUNE.


-- 3.	Order Volume Tracking 
-- Business Problem: 
-- Management wants to know how many total orders have been placed on the platform so far to measure platform activity.

select count(*) from orders;
-- COUNTING THE TOTAL NUMBER OF ORDERS PLACED.
 
-- 4.	Recent Customer Activity 
-- Business Problem: 
-- To analyze current trends, the business wants to see all orders placed in the last 30 days.
select * from orders where order_date >= date_sub((select max(order_date) from orders),interval 30 day);
-- GIVES ORDER  OF PAST 30 DAYS

--  5. High-Value Product Identification 
-- Business Problem: 
-- The company wants to identify premium products. Retrieve all products with a price greater than ₹50,000. 

select * from products where price> 50000;
-- GIVING  PREMIUM PRODUCTS HAVING PRICE GREATER THAN 50 K 

-- 6. Product Category Overview 
-- Business Problem: 
-- To understand product diversity, list all unique product categories available on the platform.

select distinct(category) from products;
-- GIVING THE LIST OF UNIQUE PRODUCT CATEGORIES

--  7. Total Revenue Calculation 
-- Business Problem: 
-- Finance team needs to know total revenue generated from all orders using order item data. 

select sum(oi.quantity*oi.price) as total_revenue from orders as o inner join order_items as oi on o.order_id=oi.order_id ;
-- GIVES THE TOTAL REVENUE OF ALL ORDERS  

-- 8. Order Status Distribution 
-- Business Problem: 
-- Operations team wants to understand how orders are distributed across statuses (Delivered, Pending, Cancelled). 

select count(order_id) as ct,status from orders group by status order by ct;
-- GIVES THE COUNT OF ORDER BELONGING TO DELIVERED , PENDING AND CANCELLED

-- 9.	Product Inventory Distribution 
-- Business Problem: 
-- Warehouse team wants to know how many products exist in each category. 

select category,count(distinct(product_id)) as ct from products group by category order by ct desc;
-- IT GIVES COUNT OF OF EACH PRODUCT CATEGORY

-- 10.	Customer Order Mapping 
-- Business Problem: 
-- To understand customer engagement, display each customer along with the orders they have placed. 

select c.customer_id,c.name,o.order_id,o.status from customers as c inner join orders as o on o.customer_id=c.customer_id order by customer_id ;
-- LISTS EACH CUSTOMER ALONG WITH EVERY INDIVIDUAL ORDER THEY PLACED AND ITS STATUS (PENDING, DELIVERED, OR CANCELLED)

-- 11. Low Inventory Alert 
-- Business Problem: 
-- Identify products where stock is below 20 units so that restocking can be planned. 

select * from products where stock_quantity< 20;
-- IT GIVES LIST WHICH HAS STOCK QUANTITY LESS THAN 20

-- 12.	Successful Payment Transactions 
-- Business Problem: 
-- Finance team wants to analyze only successful payments. 

select * from payments where payment_status='Success';
-- GIVING LIST WHICH HAS ONLY SUCESSFUL PAYMENTS

-- 13.	Completed Orders Analysis 
-- Business Problem: 
-- Find all orders that have been successfully delivered to customers.


select C.CUSTOMER_ID,C.NAME,O.ORDER_ID,O.STATUS from customers as c inner join orders as o on o.customer_id=c.customer_id where o.status ='DELIVERED';
--  GIVES LIST OF ONLY SUCESSFULLY DELIVERED ORDERS JTO CUSTOMERS

 
-- 14.	Customer Order Frequency 
-- Business Problem: 
-- Calculate how many orders each customer has placed. 

SELECT C.CUSTOMER_ID,C.NAME ,COUNT(ORDER_ID) FROM CUSTOMERS AS C INNER JOIN ORDERS AS O ON C.CUSTOMER_ID=O.CUSTOMER_ID GROUP BY C.CUSTOMER_ID,C.NAME;
-- GIVES COUNT OF ORDERS THAT EACH CUSTOMER HAS PLACED


-- 15.	Order Product Details 
-- Business Problem: 
-- Display all products included in each order to understand order composition. 

SELECT * FROM ORDER_ITEMS AS OI INNER JOIN PRODUCTS AS P ON OI.PRODUCT_ID=P.PRODUCT_ID INNER JOIN ORDERS AS O ON O.ORDER_ID=OI.ORDER_ID;
-- DISPLAYS ALL PRODUCTS INCLUDED IN EACH ORDER ALONG WITH ORDER DETAILS


-- 16.	Top Customers by Revenue Contribution 
-- Business Problem: 
-- Identify top 10 customers who have contributed the highest revenue to the business. 

SELECT C.CUSTOMER_ID,C.NAME,SUM(OI.QUANTITY*OI.PRICE) AS CT FROM CUSTOMERS AS C INNER JOIN ORDERS AS O ON O.CUSTOMER_ID=C.CUSTOMER_ID INNER JOIN  ORDER_ITEMS AS OI  ON OI.ORDER_ID=O.ORDER_ID INNER JOIN PRODUCTS AS P ON P.PRODUCT_ID=OI.PRODUCT_ID GROUP BY C.CUSTOMER_ID,C.NAME ORDER BY CT DESC LIMIT 10;

-- GIVES TOP 10 CUSTOMERS WITH HIGHEST SPENDING

-- 17.	Monthly Sales Trend Analysis 
-- Business Problem: 
-- Analyze how revenue changes month by month to detect trends and seasonality. 

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,SUM(oi.quantity * oi.price) AS monthly_revenue FROM orders AS o INNER JOIN order_items AS oi ON o.order_id = oi.order_id
GROUP BY order_month ORDER BY order_month ASC;
-- CALCULATES AND TRACKS TOTAL REVENUE MONTH-BY-MONTH TO DETECT SALES TRENDS AND SEASONALITY



-- 18.	High-Value Orders Identification 
-- Business Problem: 
-- Find orders where total value exceeds ₹50,000. These are considered premium orders. 

SELECT o.order_id, o.customer_id, o.order_date, o.status, SUM(oi.quantity * oi.price) AS total_SUM FROM orders AS o INNER JOIN order_items AS oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.customer_id, o.order_date, o.status HAVING total_SUM> 50000;
-- GIVES ORDER HAVING TOTAL VALUE(QUANTITY* SUM) GREATER THAH 50 K


-- 19.	Repeat Customer Identification 
-- Business Problem: 
-- Identify customers who have placed more than 5 orders. These are loyal customers. 


SELECT C.CUSTOMER_ID,C.NAME ,COUNT(O.ORDER_ID)AS CT FROM CUSTOMERS AS C INNER JOIN ORDERS AS O ON C.CUSTOMER_ID =O.CUSTOMER_ID  GROUP BY C.CUSTOMER_ID,C.NAME HAVING CT>5;
-- GIVES CUSTOMER WHICH HAS PLACED MORE THAN 5 ORDERS TERMED AS LOYOL CUSTOMER


-- 20.	Product-Level Revenue Analysis 
-- Business Problem: 
-- Calculate how much revenue each product generates. 


SELECT DISTINCT(P.PRODUCT_ID),P.PRODUCT_NAME,SUM(OI.QUANTITY*OI.PRICE) AS CT FROM PRODUCTS AS P INNER JOIN ORDER_ITEMS AS OI ON OI.PRODUCT_ID=P.PRODUCT_ID GROUP BY P.PRODUCT_ID,P.PRODUCT_NAME;
-- CALCULATES REVENUE OF EACH PRODUCT

-- 21.	Payment Method Popularity 
-- Business Problem: 
-- Find which payment method is used most frequently by customers. 

SELECT P.PAYMENT_METHOD,COUNT(O.ORDER_ID) AS CT FROM ORDERS AS O INNER JOIN PAYMENTS AS P ON P.ORDER_ID=O.ORDER_ID  GROUP BY P.PAYMENT_METHOD ORDER BY CT DESC LIMIT 1;
-- GIVES WHICH PAYMENT METHOD IS USED MOST BY CUSTOMERS (NETBANKING)


-- 22.	Failed Payment Impact 
-- Business Problem: 
-- Identify orders that had at least one failed payment attempt. 

SELECT DISTINCT order_id, payment_method, payment_status, amount FROM payments
WHERE payment_status = 'Failed';

-- IDENTIFIES ORDERS THAT EXPERIENCED AT LEAST ONE FAILED PAYMENT ATTEMPT

-- 23.	City-wise Order Distribution 
-- Business Problem: 
-- Determine how many orders come from each city.

SELECT * FROM ORDERS;
SELECT C.CITY,COUNT(O.ORDER_ID) AS CT  FROM CUSTOMERS AS C INNER JOIN ORDERS AS O ON O.CUSTOMER_ID=C.CUSTOMER_ID GROUP BY C.CITY ORDER BY CT DESC;
-- GIVES COUNT OF ORDERS FROM EACH CITY


-- 24.	Most Sold Product Category 
-- Business Problem: 
-- Identify which category has the highest number of items sold.

SELECT P.CATEGORY,SUM(OI.QUANTITY ) AS CT FROM PRODUCTS AS P INNER JOIN ORDER_ITEMS AS OI ON OI.PRODUCT_ID=P.PRODUCT_ID GROUP BY P.CATEGORY ORDER BY CT DESC;
-- -- IDENTIFIES WHICH PRODUCT CATEGORY HAS THE HIGHEST TOTAL NUMBER OF ITEMS SOLD
 
-- 25.	Delivery Performance Analysis 
-- Business Problem: 
-- Calculate the average delivery time for delivered orders. 


select avg(datediff(s.delivery_date,o.order_date)) as avg_days from orders as o inner join shipping as s on o.order_id=s.order_id where s.shipping_status='delivered' ;
-- GIVES AVGERAGE DELIVERY TIME FOR DELIVERED ORDERS

-- 26.	Customer Ranking Based on Spending 
-- Business Problem: 
-- Rank all customers based on total money spent to identify VIP customers. 

select c.customer_id,c.name,sum(oi.price*oi.quantity) as ct from customers as c inner join orders as o on  o.customer_id=c.customer_id inner join order_items as oi on o.order_id=oi.order_id group by c.customer_id,c.name order by ct desc;

-- RANKS ALL CUSTOMERS BASED ON TOTAL MONEY SPENT FROM HIGHEST TO LOWEST TO IDENTIFY VIP CUSTOMERS

-- 27.	Running Revenue Analysis 
-- Business Problem: 
-- Track cumulative revenue over time to understand business growth. 

SELECT order_date,daily_revenue,SUM(daily_revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM (SELECT o.order_date,SUM(oi.quantity * oi.price) AS daily_revenue FROM orders AS o
INNER JOIN order_items AS oi ON o.order_id = oi.order_id GROUP BY o.order_date) AS subquery
ORDER BY order_date ASC;

-- TRACKS CUMULATIVE RUNNING REVENUE CHRONOLOGICALLY OVER TIME TO MONITOR BUSINESS GROWTH


-- 28.	Top Customers per City 
-- Business Problem: 
-- Identify top 3 customers in each city based on spending. 

select customer_id,name,city,total_spent from (
select c.customer_id,c.name, c.city,sum(oi.price*oi.quantity) as total_spent, dense_rank() over(partition by c.city order by sum(oi.price*oi.quantity) desc) as city_rnk from customers as c inner join orders as o on c.customer_id=o.customer_id inner join order_items as oi on oi.order_id=o.order_id group by c.customer_id,c.name,c.city ) as ranked_customer where city_rnk<=3 ;

--  GIVES TOP 3 CUSTOMER FROM EACH CITY

-- 29.	Product Revenue Contribution Percentage 
-- Business Problem: 
-- Calculate how much each product contributes to total revenue in percentage terms.

SELECT product_id,product_name,product_revenue,(product_revenue * 100.0 / SUM(product_revenue) OVER ()) AS revenue_percentage FROM (SELECT p.product_id,p.product_name,SUM(oi.quantity * oi.price) AS product_revenue FROM products AS p INNER JOIN order_items AS oi ON p.product_id = oi.product_id GROUP BY p.product_id, p.product_name) AS subquery ORDER BY revenue_percentage DESC;
-- CALCULATES EACH PRODUCT'S REVENUE CONTRIBUTION AS A PERCENTAGE OF TOTAL REVENUE TO IDENTIFY TOP-SELLING ITEMS


-- 30.	Customer Behavior Pattern Analysis 
-- Business Problem: 
-- Find customers who have both delivered and cancelled orders, indicating mixed behavior. 

SELECT c.customer_id, c.name 
FROM customers AS c 
INNER JOIN orders AS o ON c.customer_id = o.customer_id 
INNER JOIN shipping AS s ON s.order_id = o.order_id 
WHERE s.shipping_status = 'Delivered' INTERSECT
SELECT c.customer_id, c.name 
FROM customers AS c 
INNER JOIN orders AS o ON c.customer_id = o.customer_id 
INNER JOIN shipping AS s ON s.order_id = o.order_id 
WHERE s.shipping_status = 'Cancelled';

--  FINDS CUSTOMERS WHO HAVE BOTH SUCCESSFULLY DELIVERED AND CANCELLED ORDERS TO SPOT MIXED BEHAVIOR PATTERNS


--  "E-Commerce Business Performance & Analytics Insights"

-- 1. "User Base Scale:" The platform has a registered user base of "650 customers" distributed across major cities.

-- 2. "Order Volume:" A total of "2,500 orders" have been processed, indicating healthy platform activity.

-- 3. "Revenue Generation:" The business has generated a cumulative lifetime revenue of "₹93,02,59,948.43".

-- 4. "Top Customer (VIP):" "Deepak Mishra" is the highest-contributing customer, with total spending of "₹46,63,040.34".

-- 5. "Sales Seasonality & Trends:" "May 2024" recorded peak monthly revenue ("₹17.1 Cr"), while "February 2024" experienced the lowest seasonal dip ("₹14.03 Cr").

-- 6. "Cumulative Growth:"Running revenue analysis demonstrates steady, uninterrupted business expansion since launch.

-- 7. "Payment Preferences:" "Net Banking" is the most frequently utilized payment method by customers.

-- 8. "Logistics & Delivery:" The average delivery time for successfully fulfilled orders stands efficiently at "5.6 days".

-- 9. "Top-Selling Category:" The "Sports" category leads platform sales with the highest physical unit volume ("3,811 items sold").

-- 10. "Top Revenue Product:" The "Decathlon Yoga Mat" holds the highest individual revenue share across the entire product catalog.

-- 11. "Geographic Distribution:" "Hyderabad" represents the city with the highest order concentration.



















