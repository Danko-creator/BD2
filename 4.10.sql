CREATE DATABASE IF NOT EXISTS warehouse_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
USE warehouse_db;

CREATE TABLE warehouse (
    id_warehouse INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    area DECIMAL(10,2),
    warehouse_type VARCHAR(50),
    working_hours VARCHAR(100)
);

CREATE TABLE category (
    id_category INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    status VARCHAR(30),
    created_date DATE
);

CREATE TABLE supplier (
    id_supplier INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    contact_person VARCHAR(100),
    bank_details VARCHAR(255)
);

CREATE TABLE product (
    id_product INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    article VARCHAR(50),
    id_category INT,
    id_supplier INT,
    price DECIMAL(10,2),
    unit VARCHAR(30),
    description VARCHAR(255),
    expiration_date DATE,
    FOREIGN KEY (id_category) REFERENCES category(id_category),
    FOREIGN KEY (id_supplier) REFERENCES supplier(id_supplier)
);

CREATE TABLE warehouse_product (
    id_warehouse_product INT PRIMARY KEY AUTO_INCREMENT,
    id_warehouse INT NOT NULL,
    id_product INT NOT NULL,
    quantity INT,
    storage_date DATE,
    storage_location VARCHAR(100),
    status VARCHAR(30),
    FOREIGN KEY (id_warehouse) REFERENCES warehouse(id_warehouse),
    FOREIGN KEY (id_product) REFERENCES product(id_product)
);
