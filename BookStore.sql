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


-- Create Admin User with Full access
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'adminspass123!';
GRANT ALL PRIVILEGES ON bookstore_db.* TO 'admin_user'@'localhost';

-- Create Read-Only User: Can only view data
CREATE USER 'readonly_user'@'localhost' IDENTIFIED BY 'ReadOnlyusers123!';
GRANT SELECT ON bookstore_db.* TO 'readonly_user'@'localhost';

-- Create Data Entry User who Can insert and update, but not delete
CREATE USER 'entry_user'@'localhost' IDENTIFIED BY 'EntryPassword123!';
GRANT SELECT, INSERT, UPDATE ON bookstore_db.* TO 'entry_user'@'localhost';

-- Create Shipping Staff who Can view and update shipping/order tables
CREATE USER 'shipping_user'@'localhost' IDENTIFIED BY 'ShipstaffPass123!';
GRANT SELECT, UPDATE ON bookstore_db.cust_order TO 'shipping_user'@'localhost';
GRANT SELECT, UPDATE ON bookstore_db.order_status TO 'shipping_user'@'localhost';
GRANT SELECT, INSERT ON bookstore_db.order_history TO 'shipping_user'@'localhost';


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
INSERT INTO address_status (status_name) VALUES ('Current'), ('Old');

-- Insert Addresses
INSERT INTO address (street, city, state, postal_code, country_id)
VALUES ('123 Jogoo Rd', 'Nairobi', 'Nairobi', '00200', 1),
       ('316 Lake St', 'New York', 'NY', '10001', 2);

-- Insert a Customer
INSERT INTO customer (first_name, last_name, email, phone)
VALUES ('Rabby', 'Boreh', 'rabby@gmail.com', '0735272722');

-- Link Customer to Address
INSERT INTO customer_address (customer_id, address_id, status_id) VALUES (1, 1, 1);

-- Insert Shipping Methods
INSERT INTO shipping_method (method_name, cost) VALUES ('Standard', 10.00), ('Express', 12.00);

-- Insert Order Statuses
INSERT INTO order_status (status_name) VALUES ('Pending'), ('Shipped'), ('Delivered');

-- Insert a Customer Order
INSERT INTO cust_order (customer_id, shipping_method_id, order_status_id)
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


