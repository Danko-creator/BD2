USE warehouse_db;
SET SQL_SAFE_UPDATES = 0;

-- 3.1 INSERT
-- a. Без указания списка полей
INSERT INTO category VALUES (NULL, 'Продукты питания', 'Скоропортящиеся товары', 'active', '2024-05-20');

SELECT 1 FROM category WHERE name = 'Продукты питания' AND status = 'active' LIMIT 1;

-- b. С указанием списка полей
INSERT INTO warehouse (name, address, phone, area, warehouse_type, working_hours)
VALUES ('Главный склад', 'ул. Промышленная, д. 10', '8-800-555-35-35', 5000.00, 'Распределительный', 'Круглосуточно');

SELECT 1 FROM warehouse WHERE name = 'Главный склад' AND area = 5000.00 LIMIT 1;

-- c. С чтением значения из другой таблицы
CREATE TABLE IF NOT EXISTS category_archive LIKE category;

INSERT INTO category_archive (name, description, status, created_date)
SELECT name, description, status, created_date
FROM category
WHERE status = 'inactive';

SELECT 1 FROM category_archive LIMIT 1;

-- 3.2 DELETE
-- a. Всех записей
DELETE FROM category_archive;
SELECT 1 FROM category_archive LIMIT 1;

-- b. По условию
DELETE FROM product
WHERE expiration_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

SELECT 1 FROM product
WHERE expiration_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR) LIMIT 1;

-- 3.3 UPDATE
-- a. Всех записей
UPDATE supplier SET email = LOWER(email);

SELECT 1 FROM supplier WHERE email = LOWER(email) LIMIT 1;

-- b. По условию обновляя один атрибут
UPDATE warehouse SET area = 5500.00 WHERE name = 'Главный склад';

SELECT 1 FROM warehouse WHERE name = 'Главный склад' AND area = 5500.00 LIMIT 1;

-- c. По условию обновляя несколько атрибутов
UPDATE supplier
SET phone = '+7-999-111-22-33', email = 'updated@mail.ru'
WHERE id_supplier = 1;

SELECT 1 FROM supplier WHERE id_supplier = 1 AND phone = '+7-999-111-22-33' AND email = 'updated@mail.ru' LIMIT 1;

-- 3.4 SELECT
-- a. С набором извлекаемых атрибутов
SELECT name, price, unit FROM product;

-- b. Со всеми атрибутами
SELECT * FROM warehouse;

-- c. С условием по атрибуту
SELECT * FROM category WHERE status = 'active';

-- 3.5 SELECT ORDER BY + LIMIT
-- a. С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT name, price FROM product ORDER BY price ASC LIMIT 5;

-- b. С сортировкой по убыванию DESC
SELECT * FROM warehouse ORDER BY area DESC;

-- c. С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT * FROM product
ORDER BY id_category ASC, price DESC
LIMIT 10;

-- d. С сортировкой по первому атрибуту из списка извлекаемых
SELECT price, name, article FROM product ORDER BY 1;

-- 3.6 Работа с датами
-- a. WHERE по дате
SELECT * FROM category
WHERE created_date >= DATE_SUB(NOW(), INTERVAL 1 MONTH);

-- b. WHERE дата в диапазоне
SELECT * FROM warehouse_product
WHERE storage_date BETWEEN '2024-01-01' AND '2024-12-31';

-- c. Извлечь только год
SELECT id_category, name, YEAR(created_date) as creation_year
FROM category;

-- 3.7 Функции агрегации
-- a. Посчитать количество записей в таблице
SELECT COUNT(*) as total_products FROM product;

-- b. Посчитать количество уникальных записей в таблице
SELECT COUNT(DISTINCT id_supplier) as unique_suppliers FROM product;

-- c. Вывести уникальные значения столбца
SELECT DISTINCT warehouse_type FROM warehouse;

-- d. Найти максимальное значение столбца
SELECT MAX(area) as max_area FROM warehouse;

-- e. Найти минимальное значение столбца
SELECT MIN(price) as min_price FROM product;

-- f. Написать запрос COUNT() + GROUP BY
SELECT id_category, COUNT(*) as product_count
FROM product
GROUP BY id_category;

-- 3.8 SELECT GROUP BY + HAVING
-- a.1. Категории с большим ассортиментом
-- находит ID категорий, в которых насчитывается более 5 товаров
SELECT product.id_category, COUNT(product.id_product) as product_count
FROM product
GROUP BY product.id_category
HAVING COUNT(product.id_product) > 5;

-- a.2. Склады с большим количеством позиций
-- находит склады, на которых хранится более 10 различных товаров
SELECT warehouse_product.id_warehouse, COUNT(warehouse_product.id_warehouse_product) as product_count
FROM warehouse_product
GROUP BY warehouse_product.id_warehouse
HAVING COUNT(warehouse_product.id_warehouse_product) > 10;

-- a.3. Товары с высокой средней ценой по категориям
-- находит категории товаров, у которых средняя цена превышает 500 рублей
SELECT product.id_category, AVG(product.price) as avg_price, COUNT(product.id_product) as product_count
FROM product
GROUP BY product.id_category
HAVING AVG(product.price) > 500;

-- 3.9 SELECT JOIN
-- a. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT warehouse.name, warehouse_product.quantity
FROM warehouse
LEFT JOIN warehouse_product ON warehouse.id_warehouse = warehouse_product.id_warehouse
WHERE warehouse.warehouse_type = 'Распределительный';

-- b. RIGHT JOIN
SELECT warehouse.name, warehouse_product.quantity
FROM warehouse_product
RIGHT JOIN warehouse ON warehouse_product.id_warehouse = warehouse.id_warehouse
WHERE warehouse.warehouse_type = 'Распределительный';

-- c. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT warehouse.name, product.name, warehouse_product.storage_location
FROM warehouse
LEFT JOIN warehouse_product ON warehouse.id_warehouse = warehouse_product.id_warehouse
LEFT JOIN product ON warehouse_product.id_product = product.id_product
WHERE warehouse.area > 1000 AND warehouse_product.status = 'на хранении' AND product.price < 150.00;

-- d. INNER JOIN двух таблиц
SELECT product.name, category.name
FROM product
INNER JOIN category ON product.id_category = category.id_category;

-- 3.10 Подзапросы
-- a. WHERE IN (подзапрос)
SELECT * FROM product
WHERE id_category IN (
    SELECT id_category FROM category WHERE status = 'active'
);

-- b. SELECT с подзапросом в списке атрибутов
SELECT
warehouse.name,
warehouse.address,
(SELECT COUNT(*) FROM warehouse_product WHERE warehouse_product.id_warehouse = warehouse.id_warehouse) as product_count
FROM warehouse;

-- c. SELECT * FROM (подзапрос)
SELECT * FROM (
    SELECT id_category, COUNT(*) as total_products, SUM(price) as total_price
    FROM product
    GROUP BY id_category
) as category_stats
WHERE total_products > 1;

-- d. SELECT * FROM table JOIN (подзапрос)
SELECT *
FROM warehouse
JOIN (
    SELECT id_warehouse, SUM(quantity) as total_qty, COUNT(*) as products_count
    FROM warehouse_product
    GROUP BY id_warehouse
) as stats ON warehouse.id_warehouse = stats.id_warehouse;

DROP TABLE IF EXISTS category_archive;
SET SQL_SAFE_UPDATES = 1;




