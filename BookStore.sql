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




