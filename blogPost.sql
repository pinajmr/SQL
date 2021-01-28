CREATE TABLE IF NOT EXISTS books(
	book_id INTEGER  UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	author_id INTEGER,
	title VARCHAR(100) NOT NULL,
	`year` INTEGER UNSIGNED NOT NULL DEFAULT 1900,
	language VARCHAR(2) NOT NULL DEFAULT 'es' COMMENT 'ISO 639-1 Language',
	cover_url VARCHAR(500),
	price DOUBLE(6,2) NOT NULL DEFAULT 10.0, 
	sellable TINYINT(1) DEFAULT 1, 
	copies INTEGER NOT NULL DEFAULT 1,
	description TEXT
	); 
	
CREATE TABLE IF NOT EXISTS authors (
	author_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
	name VARCHAR(100) NOT NULL,
	nationality VARCHAR(3)
	);

CREATE TABLE clients (
	client_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	`name`  VARCHAR(50) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	birthdate DATETIME,
	gender ENUM('M','F','ND') NOT NULL,
	active TINYINT(1) NOT NULL DEFAULT 1, 
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
		ON UPDATE CURRENT_TIMESTAMP
	);
	
CREATE TABLE IF NOT EXISTS operations(
	operation_id [klajsdklajs],
	book_id [ajsdkasjd],
	client_id [jaksldjlkads],
	type prestado,devuelto, vendido,
	created_at,
	update_at,
	finshed TINYINT(1) NOT NULL
);


INSERT INTO `clients`(`name`,email,birthdate,gender,active)
VALUES('Jose Hidalgo','Jose.05903641R@random.names','1973-08-13','M',0)
ON DUPLICATE KEY UPDATE active= VALUES(active);

SELECT * FROM clients WHERE client_id = 100\G


-- Querys Anidados

INSERT INTO books(title, author_id,`year`)
VALUES('El Laberinto de la Soledad',6, 1952);

INSERT INTO books(title, author_id,`year`)
VALUES('Never Stop Learning',
	(SELECT author_id FROM authors 
	WHERE `name` = 'Freddy Vega'
	LIMIT 1
	), 1960
);


--Querys 

SELECT `name` FROM clients;

SELECT `name`, email, gender FROM clients;

SELECT `name`, email, gender FROM clients LIMIT 10;

SELECT `name`, email, gender FROM clients WHERE gender = 'F';

SELECT `name`, email, YEAR(NOW()-YEAR(birthdate)) AS edad, gender 
FROM clients
WHERE gender = 'F'
	AND `name` LIKE '%Lop%';

-- JOIN 
SELECT book_id, author_id, title FROM books WHERE author_id BETWEEN 1 AND 5;

SELECT b.book_id, a.name, b.title
FROM books AS b 
JOIN authors AS a
	ON a.author_id = b.author_id
	WHERE a.author_id BETWEEN 1 AND 5;

SELECT c.name, b.title, a.name, t.type
FROM  transactions AS t
INNER JOIN books AS b
	ON t.book_id =  b.book_id
INNER JOIN clients AS  c 
	ON t.client_id = c.client_id
INNER JOIN authors AS  a 
	ON b.author_id = a.author_id
WHERE c.gender = 'M'
AND t.type IN ('sell','lend');

SELECT a.name, b.title
FROM books as b 
INNER JOIN authors as a 
	ON b.author_id = a.author_id;


-- LEFT JOIN 
SELECT a.author_id, a.name, a.nationality, b.title
FROM authors AS a 
LEFT JOIN  books AS b 
	ON b.author_id = a.author_id
WHERE a.author_id BETWEEN 1 AND 5
ORDER BY a.author_id DESC;

SELECT a.author_id, a.name, a.nationality, COUNT(b.book_id) AS Cantidad_de_Libros
FROM authors AS a 
LEFT JOIN  books AS b 
	ON b.author_id = a.author_id
WHERE a.author_id BETWEEN 1 AND 5
GROUP BY  a.author_id
ORDER BY a.author_id;

-- 1.¿Qué nacionalidades hay?

SELECT DISTINCT nationality FROM authors 
ORDER BY nationality;

-- 2.¿Cuántos escritores hay de cada nacionalidad?
SELECT nationality , COUNT(author_id) AS c_authors
FROM authors 
WHERE nationality IS NOT NULL
-- AND nationality NOT IN('RUS','AUS')
GROUP BY nationality
ORDER BY c_authors DESC, nationality ASC;


-- 3.¿Cuántos libros hay de cada nacionalidad?
SELECT a.nationality, COUNT(book_id) AS c_books
FROM books AS b 
JOIN  authors AS a 
	ON a.author_id = b.author_id
WHERE nationality IS NOT NULL
GROUP BY a.nationality
ORDER BY c_books DESC, nationality;


-- 4.¿Cuál es el promedio/desviación standar del precio de libros?
SELECT nationality, COUNT(book_id) as Libros, 
	AVG(price) AS Promedio, STDDEV(price) AS Desviacion
FROM books as b
JOIN authors as a
	ON b.author_id = a.author_id
GROUP BY nationality
ORDER BY libros DESC;
--
SELECT AVG(price) AS Promedio, STDDEV(price) AS Desviacion
FROM books;

-- 5.Idem, pero por nacionalidad 
-- 6.¿Cuál es el precio máximo/mínimo de un libros
SELECT MAX(price), MIN(price)
FROM books;

SELECT nationality, MAX(price) AS 'Precio Maximo', MIN(price)AS 'Precio Minimo'
FROM books as b 
JOIN authors as a
	ON a.author_id = b.author_id
GROUP BY nationality
ORDER BY 'Precio Maximo' DESC;


-- 7.¿Cómo quedaría el reporte de préstamos?

SELECT c.name, t.type, b.title, CONCAT(a.name, " (",a.nationality, ")") AS author,
TO_DAYS(NOW()) -TO_DAYS(t.created_at) AS ago
FROM transactions AS t 
LEFT JOIN clients AS c 
	ON c.client_id = t.client_id
LEFT JOIN books AS b 
	ON t.book_id = b.book_id
LEFT JOIN authors AS a 
	ON a.author_id = b.author_id

--UPDATE 
SELECT client_id, `name`, active
FROM clients
WHERE 
	client_id IN (1,6,8,27,90)
	OR `name` LIKE '%Lopez%'
----
UPDATE clients
SET 
	active = 0
WHERE
	client_id IN (1,6,8,27,90)
	OR `name` LIKE '%Lopez%';

UPDATE authors 
SET 
	nationality = 'GBR'
WHERE 
	nationality = 'ENG';



--SUPER QUERYS
SELECT nationality, COUNT(book_id) AS `Libros por Pais`,
	SUM(IF(YEAR < 1950, 1, 0)) AS `<1950`,
	SUM(IF(YEAR >= 1950 AND YEAR < 1990, 1, 0)) AS `<1990`,
	SUM(IF(YEAR >= 1990 AND YEAR < 2000, 1, 0)) AS `<2000`,
	SUM(IF(YEAR >= 2000, 1,0)) AS `<hoy`
FROM books as b
JOIN authors as a 
	ON a.author_id = b.author_id
WHERE 
	a.nationality IS NOT NULL 
GROUP BY nationality;


--Alter
ALTER TABLE authors ADD COLUMN birthyear INTEGER DEFAULT 1930 AFTER name;
ALTER TABLE authors MODIFY COLUMN birthyear YEAR DEFAULT 1920;
ALTER TABLE authors DROP COLUMN birthyear;

SHOW TABLES LIKE '%i%'