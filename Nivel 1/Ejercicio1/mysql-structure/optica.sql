CREATE DATABASE cul_dampolla;
USE cul_dampolla;

CREATE TABLE Address (
	id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(100),
    number VARCHAR(100),
    floor VARCHAR(100),
    door VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE Customer (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60),
    postal_address VARCHAR(100),
    telephone VARCHAR(40),
    email VARCHAR(70),
    registration_date DATE,
    recommended_by INT,
    FOREIGN KEY (recommended_by) REFERENCES Customer(id)
);

CREATE TABLE Employee (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60),
    telephone VARCHAR(20),
    email VARCHAR(100),
    role VARCHAR(40)
);

CREATE TABLE Supplier (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60),
    telephone VARCHAR(20),
    fax VARCHAR(20),
    NIF VARCHAR(20),
    address_id INT,
	FOREIGN KEY (address_id) REFERENCES Address(id)
);

CREATE TABLE Glasses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand  VARCHAR(40),
    prescription_L  VARCHAR(20),
    prescription_R VARCHAR(20),
    type_frame ENUM("floating", "paste", "metal"),
    color_frame  VARCHAR(20),
    color_lens VARCHAR(20),
    price DECIMAL(10, 2),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(id)
);

CREATE TABLE Sale (
	id INT AUTO_INCREMENT PRIMARY KEY,
    date DATETIME,
    employee_id INT,
	customer_id INT,
	FOREIGN KEY (employee_id) REFERENCES Employee(id),
    FOREIGN KEY (customer_id) REFERENCES Customer(id)
);

CREATE TABLE Sale_Item (
	id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT,
    glasses_id INT,
    price DECIMAL(10, 2),
    num_of_items INT,
    FOREIGN KEY (sale_id) REFERENCES Sale(id),
	FOREIGN KEY (glasses_id) REFERENCES Glasses(id)
);

-- DATA INPUT --
INSERT INTO Address (street, number, city, postal_code, country)
VALUES ('Carrer Valencia', '11', 'Barcelona', '08015', 'Spain'),
       ('Boninha', '16', 'Oporto', '08090', 'Portugal');

INSERT INTO Supplier (name, telephone, fax, NIF, address_id)
VALUES ('Ojazos', '931234567', '931234568', 'Z12345678', 1),
       ('Raymonds', '973564560', '973564560', 'Z12347654', 2);

INSERT INTO Glasses (brand, prescription_L, prescription_R, type_frame, color_frame, color_lens, price, supplier_id)
VALUES ('RayBan', '0', '0', 'metal', 'black', 'brown', 120.00, 1),
       ('Oakley', '0', '0', 'paste', 'blue', 'gray', 150.00, 2);

INSERT INTO Customer (name, postal_address, telephone, email, registration_date)
VALUES ('Lola Drones', 'C/ Lala 33', '600165423', 'lola@mail.com', '2024-01-10');

INSERT INTO Customer (name, postal_address, telephone, email, registration_date, recommended_by)
VALUES ('Emil Weiss', 'C/ Balmes 21', '600456456', 'emil@mail.com', '2025-02-01', 1);

INSERT INTO Employee (name, telephone, email, role)
VALUES ('Andy Genc', '699888777', 'Andy@optica.com', 'salesman');

INSERT INTO Sale (date, employee_id, customer_id)
VALUES ('2024-06-15 10:30:00', 1, 2);

INSERT INTO Sale_Item (sale_id, glasses_id, price, num_of_items)
VALUES (1, 1, 120.00, 1),
       (1, 2, 150.00, 2);

-- VERIFICATIONS
SELECT 
    Customer.name AS customer_name,
    Sale.id AS sale_id,
    Sale.date AS sale_date,
    Glasses.brand AS glasses_brand,
    Glasses.type_frame AS frame_type,
    Sale_Item.price AS unit_price,
    Sale_Item.num_of_items AS quantity,
    (Sale_Item.price * Sale_Item.num_of_items) AS total_item
FROM Customer
JOIN Sale ON Customer.id = Sale.customer_id
JOIN Sale_Item ON Sale.id = Sale_Item.sale_id
JOIN Glasses ON Sale_Item.glasses_id = Glasses.id
WHERE Customer.name = "Emil Weiss"
ORDER BY Sale.date;

SELECT DISTINCT
	Employee.name AS employee,
    Glasses.brand AS glasses_brand,      
    Glasses.type_frame AS frame_type,     
    Glasses.color_frame AS frame_color,    
    Glasses.color_lens AS lens_color      
FROM Employee
JOIN Sale ON Employee.id = Sale.employee_id     
JOIN Sale_Item ON Sale.id = Sale_Item.sale_id   
JOIN Glasses ON Sale_Item.glasses_id = Glasses.id 
WHERE Employee.name = 'Andy Genc'  
  AND YEAR(Sale.date) = 2024        
ORDER BY Glasses.brand;             

SELECT DISTINCT
    Supplier.name AS supplier_name,
    Supplier.telephone,
    Supplier.NIF,
	Sale.id AS sale_id
FROM Supplier
JOIN Glasses ON Supplier.id = Glasses.supplier_id
JOIN Sale_Item ON Glasses.id = Sale_Item.glasses_id
JOIN Sale ON Sale_Item.sale_id = Sale.id
ORDER BY Supplier.name, Sale.id;

