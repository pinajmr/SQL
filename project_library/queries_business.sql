-- 1.What nationalities are the authors?

SELECT DISTINCT nationality FROM authors 
WHERE nationality IS NOT NULL
ORDER BY nationality;

-- 2. How many writing are there each nationality?
SELECT nationality , COUNT(author_id) AS c_authors
FROM authors 
WHERE nationality IS NOT NULL
-- AND nationality NOT IN('RUS','AUS')
GROUP BY nationality
ORDER BY c_authors DESC, nationality ASC;


-- 3. How many books are there each nationality?
SELECT a.nationality, COUNT(book_id) AS c_books
FROM books AS b 
JOIN  authors AS a 
	ON a.author_id = b.author_id
WHERE nationality IS NOT NULL
GROUP BY a.nationality
ORDER BY c_books DESC, nationality;


-- 4.Which is average price/ standard deviation  of the books ?
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


-- 5. What is price max/min of the books?
SELECT MAX(price), MIN(price)
FROM books;


-- 6. What is price max/min of the books each nationality?
SELECT nationality, MAX(price) AS precio_max, MIN(price)AS precio_min
FROM books as b 
JOIN authors as a
	ON a.author_id = b.author_id
GROUP BY nationality
ORDER BY precio_max DESC;


-- 7.How would the loan  report look?

SELECT c.name, t.type, b.title, CONCAT(a.name, " (",a.nationality, ")") AS author,
TO_DAYS(NOW()) -TO_DAYS(t.created_at) AS ago
FROM transactions AS t 
LEFT JOIN clients AS c 
	ON c.client_id = t.client_id
LEFT JOIN books AS b 
	ON t.book_id = b.book_id
LEFT JOIN authors AS a 
	ON a.author_id = b.author_id;

