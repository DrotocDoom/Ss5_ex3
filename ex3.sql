-- =========================
-- Tạo Database
-- =========================
CREATE DATABASE "IOC-03-session5";

-- Kết nối vào database
\c "IOC-03-session5"

-- =========================
-- Tạo Schema
-- =========================
CREATE SCHEMA schema3;

-- =========================
-- Tạo bảng customers
-- =========================
CREATE TABLE schema3.customers (
                                   customer_id SERIAL PRIMARY KEY,
                                   customer_name VARCHAR(100),
                                   city VARCHAR(100)
);

-- =========================
-- Tạo bảng orders
-- =========================
CREATE TABLE schema3.orders (
                                order_id SERIAL PRIMARY KEY,
                                customer_id INT,
                                order_date DATE,
                                total_price NUMERIC(10,2),

                                CONSTRAINT fk_customer
                                    FOREIGN KEY (customer_id)
                                        REFERENCES schema3.customers(customer_id)
);

-- =========================
-- Tạo bảng order_items
-- =========================
CREATE TABLE schema3.order_items (
                                     item_id INT PRIMARY KEY,
                                     order_id INT,
                                     product_id INT,
                                     quantity INT,
                                     price NUMERIC(10,2),

                                     CONSTRAINT fk_order
                                         FOREIGN KEY (order_id)
                                             REFERENCES schema3.orders(order_id)
);

-- =========================
-- Insert dữ liệu customers
-- =========================
INSERT INTO schema3.customers (
    customer_id,
    customer_name,
    city
)
VALUES
    (1, 'Nguyễn Văn A', 'Hà Nội'),
    (2, 'Trần Thị B', 'Đà Nẵng'),
    (3, 'Lê Văn C', 'Hồ Chí Minh'),
    (4, 'Phạm Thị D', 'Hà Nội');

-- =========================
-- Insert dữ liệu orders
-- =========================
INSERT INTO schema3.orders (
    order_id,
    customer_id,
    order_date,
    total_price
)
VALUES
    (101, 1, '2024-12-20', 3000),
    (102, 2, '2025-01-05', 1500),
    (103, 1, '2025-02-10', 2500),
    (104, 3, '2025-02-15', 4000),
    (105, 4, '2025-03-01', 800);

-- =========================
-- Insert dữ liệu order_items
-- =========================
INSERT INTO schema3.order_items (
    item_id,
    order_id,
    product_id,
    quantity,
    price
)
VALUES
    (1, 101, 1, 2, 1500),
    (2, 102, 2, 1, 1500),
    (3, 103, 3, 5, 500),
    (4, 104, 2, 4, 1000);

-- =========================
-- Kiểm tra dữ liệu
-- =========================
SELECT * FROM schema3.customers;

SELECT * FROM schema3.orders;

SELECT * FROM schema3.order_items;

SELECT c.customer_id,sum(o.total_price) total_revenue, count(o.customer_id) order_count FROM schema3.customers c
INNER JOIN schema3.orders o on c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING sum(o.total_price) > 2000;


SELECT c.customer_id,sum(o.total_price) total_revenue, count(o.customer_id) order_count FROM schema3.customers c
INNER JOIN schema3.orders o on c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING sum(o.total_price) > (SELECT avg(total_revenue) FROM (
                            SELECT sum(o.total_price) total_revenue from schema3.orders o
                            GROUP BY o.customer_id)
                            as otr);

SELECT c.city,sum(o.total_price) total_revenue FROM schema3.customers c
INNER JOIN schema3.orders o on c.customer_id = o.customer_id
GROUP BY c.city
HAVING sum(o.total_price) = (SELECT max(total_revenue) FROM (SELECT sum(o.total_price) total_revenue FROM schema3.customers c
    INNER JOIN schema3.orders o on c.customer_id = o.customer_id
    GROUP BY c.city) as otr);

SELECT c.customer_name, c.city, sum(oi.quantity) total_quantity, sum(o.total_price) FROM schema3.customers c
INNER JOIN schema3.orders o on c.customer_id = o.customer_id
INNER JOIN schema3.order_items oi on o.order_id = oi.order_id
GROUP BY c.customer_id

