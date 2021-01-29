--Other Queries
INSERT INTO `clients`(`name`,email,birthdate,gender,active)
VALUES('Jose Hidalgo','Jose.05903641R@random.names','1973-08-13','M',0)
ON DUPLICATE KEY UPDATE active= VALUES(active);

SELECT * FROM clients WHERE client_id = 100\G;
SHOW TABLES LIKE '%i%'

-- Querys Anidados

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
SELECT nationality, COUNT(book_id) AS Books,
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
