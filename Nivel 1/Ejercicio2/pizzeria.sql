CREATE DATABASE pizzeria;
USE pizzeria;

CREATE TABLE Client (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    surname VARCHAR(50),
    address VARCHAR(50),
    postal_code VARCHAR(20),
    town VARCHAR(50),
    province VARCHAR(50),
    telephone VARCHAR(30)
);

CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Store (
	store_id INT AUTO_INCREMENT PRIMARY KEY,
	address VARCHAR(50),
    postal_code VARCHAR(20),
    city VARCHAR(50),
    province VARCHAR(50)
);

CREATE TABLE Employee (
	employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    surname VARCHAR(50),
    nif VARCHAR(50),
    telephone VARCHAR(50),
    role ENUM("delivery", "cook"),
    store_id INT,
    FOREIGN KEY (store_id) REFERENCES Store(store_id)
);

CREATE TABLE Product (
    name VARCHAR(20) PRIMARY KEY,
    description VARCHAR(200),
    image VARCHAR(200),
    price DECIMAL(10,2),
    type ENUM("pizza","hamburger","drink"),
    category_id INT NULL,
	FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Order_food (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    order_datetime DATETIME,
    delivery_type ENUM("delivery","to_go"),
    total_price DECIMAL(10,2),
    store_id INT,
    delivery_employee_id INT,
    delivery_datetime DATETIME,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE,
    FOREIGN KEY (store_id) REFERENCES Store(store_id) ON DELETE CASCADE,
    FOREIGN KEY (delivery_employee_id) REFERENCES Employee(employee_id) ON DELETE CASCADE
);

CREATE TABLE Product_item (
    product_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Order_food(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_name) REFERENCES Product(name)
);

INSERT INTO Category (name) 
VALUES ('Muzzarella'),
('Napoletana'),
('Capricciosa');

INSERT INTO Store (address, postal_code, city, province) 
VALUES ('Av. Corrientes 1234', '1043', 'Buenos Aires', 'Buenos Aires'),
('Calle San Martín 456', '5000', 'Córdoba', 'Córdoba');

INSERT INTO Employee (name, surname, nif, telephone, role, store_id) 
VALUES ('Gustavo', 'Cerati', '20123456A', '600111222', 'delivery', 1),
('Charly', 'Garcia', '20987654B', '600333444', 'cook', 1),
('Luis', 'Spinetta', '20334455C', '600555666', 'delivery', 2);

INSERT INTO Client (name, surname, address, postal_code, town, province, telephone) 
VALUES ('Fito', 'Paez', 'Av. Rivadavia 742', '1406', 'Buenos Aires', 'Buenos Aires', '611222333'),
('Andres', 'Calamaro', 'Calle Belgrano 980', '5000', 'Córdoba', 'Córdoba', '622333444');

INSERT INTO Product (name, description, image, price, type, category_id) 
VALUES ('Cola', 'Cold cola drink', 'cola.jpg', 2.50, 'drink', NULL),
('Muzzarella Pizza', 'Classic', 'muzzarella.jpg', 9.00, 'pizza', 1),
('Napoletana Pizza', 'with tomato and garlic', 'napoletana.jpg', 10.00, 'pizza', 2),
('Burger', 'Beef hamburger', 'burger.jpg', 8.50, 'hamburger', NULL);

INSERT INTO Order_food (client_id, order_datetime, delivery_type, total_price, store_id, delivery_employee_id, delivery_datetime) 
VALUES (1, '2025-02-01 13:00:00', 'delivery', 14.00, 1, 1, '2025-02-01 13:45:00'),
(1, '2025-02-03 20:00:00', 'to_go', 11.50, 1, NULL, NULL),
(2, '2025-02-02 21:00:00', 'delivery', 12.50, 2, 3, '2025-02-02 21:40:00');

INSERT INTO Product_item (order_id, product_name, quantity, price) 
VALUES (1, 'Cola', 2, 2.50),
(1, 'Muzzarella Pizza', 1, 9.00),
(2, 'Water', 1, 1.50),
(2, 'Burger', 1, 8.50),
(3, 'Napoletana Pizza', 1, 10.00);

SELECT Store.city AS city, SUM(Product_item.quantity) AS total_drinks
FROM Product_item
JOIN Product ON Product_item.product_name = Product.name
JOIN Order_food ON Product_item.order_id = Order_food.order_id
JOIN Store ON Order_food.store_id = Store.store_id
WHERE Product.type = 'drink'
GROUP BY Store.city;

SELECT Employee.name, Employee.surname, COUNT(Order_food.order_id) AS total_orders
FROM Employee
JOIN Order_food ON Employee.employee_id = Order_food.delivery_employee_id
WHERE Employee.surname = 'Spinetta';


