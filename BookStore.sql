-- Creating database
CREATE DATABASE  bookstore_db;
USE bookstore_db;

-- book_language table
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL
);

-- publisher table
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(255) NOT NULL
);

-- book table
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    language_id INT,
    publisher_year YEAR,
    price DECIMAL(10,2),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

-- author table
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

-- book_author table
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- address_status table
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_description VARCHAR(50) NOT NULL
);

-- address table
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    postal_code VARCHAR(20),
    country_id INT,
    town VARCHAR(100),
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- customer table
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE
    
    );

-- customer_address table
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- shipping_method table
CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100)    
);

-- order_status table
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50)
);

-- cust_order table
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    shipping_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
    FOREIGN KEY (order_status_id) REFERENCES order_status(status_id)
);

-- order_line table
CREATE TABLE order_line (
    order_line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- order_history table
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    changed_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Create Admin with Full access
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'adminpass123!';
GRANT ALL PRIVILEGES ON bookstore_db.* TO 'admin'@'localhost';

-- Create user: Can only view data
CREATE USER 'user'@'localhost' IDENTIFIED BY 'user123!';
GRANT SELECT ON bookstore_db.* TO 'user'@'localhost';

-- Create Data Entry staff who Can insert and update, but not delete
CREATE USER 'entry_staff'@'localhost' IDENTIFIED BY 'EntryPassword123!';
GRANT SELECT, INSERT, UPDATE ON bookstore_db.* TO 'entry_staff'@'localhost';

-- Create Shipping Staff who Can view and update shipping/order tables
CREATE USER 'shipping_staff'@'localhost' IDENTIFIED BY 'ShipstaffPass123!';
GRANT SELECT, UPDATE ON bookstore_db.cust_order TO 'shipping_staff'@'localhost';
GRANT SELECT, UPDATE ON bookstore_db.order_status TO 'shipping_staff'@'localhost';
GRANT SELECT, INSERT ON bookstore_db.order_history TO 'shipping_staff'@'localhost';


-- Inserting the  Languages
INSERT INTO book_language (language_name) VALUES ('English'), ('British'),
('Kiswahili');

-- Insert Sample Publishers
INSERT INTO publisher (publisher_name) VALUES ('Evaah'), ('Jymo'),('Rency');

-- Insert Sample Authors
INSERT INTO author (first_name, last_name) VALUES ('Mercy', 'Nduta'), ('Resly', 'Boreh');

-- Insert Sample Books
INSERT INTO book (title, publisher_id, language_id, price)
VALUES ('Introduction To SQL', 1, 1, 59.66), ('Advanced SQL', 2, 2, 100.00);

-- Link Books to Authors
INSERT INTO book_author (book_id, author_id) VALUES (1, 1), (2, 2);

-- Insert Countries
INSERT INTO country (country_name) VALUES ('Kenya'), ('Canada');

-- Insert Address Statuses
INSERT INTO address_status (status_description) VALUES ('Current'), ('Old');

-- Insert Addresses
INSERT INTO address (city, state, postal_code, country_id)
VALUES ('Nairobi', 'Nairobi', '00200', 1),
       ('New York', 'NY', '10001', 2);

-- Insert a Customer
INSERT INTO customer (first_name, last_name, email)
VALUES ('Rabby', 'Boreh', 'rabby@gmail.com');

-- Link Customer to Address
INSERT INTO customer_address (customer_id, address_id, status_id) VALUES (1, 1, 1);

-- Insert Shipping Methods
INSERT INTO shipping_method (method_name) VALUES ('Standard'), ('Express';

-- Insert Order Statuses
INSERT INTO order_status (status_name) VALUES ('Pending'), ('Shipped'), ('Delivered');

-- Insert a Customer Order
INSERT INTO cust_order (customer_id, shipping_id, order_id)
VALUES (1, 1, 1);

-- Add Books to Order
INSERT INTO order_line (order_id, book_id, quantity, price)
VALUES (1, 1, 2, 59.99);

-- Add Order History
INSERT INTO order_history (order_id, status_id)
VALUES (1, 1);


-- Test Queries


--  Get All Books and Their Authors
SELECT b.title, CONCAT(a.first_name, ' ', a.last_name) AS author
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;

--  Show All Orders With Customer Info
SELECT co.order_id, c.first_name, c.last_name, os.status_name, co.order_date
FROM cust_order co
JOIN customer c ON co.customer_id = c.customer_id
JOIN order_status os ON co.order_status_id = os.status_id;

--  Get Current Address of a Customer
SELECT c.first_name, c.last_name, a.street, a.city
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN address a ON ca.address_id = a.address_id
JOIN address_status ast ON ca.status_id = ast.status_id
WHERE ast.status_name = 'Current'; 


