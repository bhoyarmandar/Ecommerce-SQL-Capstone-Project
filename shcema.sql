
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
