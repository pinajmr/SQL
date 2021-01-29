CREATE DATABASE bloging;
CREATE TABLE people(
    person_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(25),
    first_name VARCHAR(25),
    `address` VARCHAR(120),
    city VARCHAR(20)
);

ALTER TABLE people
ADD COLUMN `date_of_birth` DATETIME NULL AFTER city;

ALTER TABLE people
CHANGE COLUMN `date_of_birth`
`date_of_birth` VARCHAR(30) NULL DEFAULT NULL;


ALTER TABLE people
DROP COLUMN `date_of_bith`;

CREATE OR REPLACE VIEW `Peoplegin` AS 
SELECT * FROM bloging.people;

INSERT INTO `bloging`.`people` (`person_id`, `last_name`, `first_name`, `address`, `city`) 
VALUES ('1', 'Vásquez', 'Israel', 'Calle Famosa Num 1', 'México'),
	       ('2', 'Hernández', 'Mónica', 'Reforma 222', 'México'),
	       ('3', 'Alanis', 'Edgar', 'Central 1', 'Monterrey');  
           


-------------------------------------------------------------------------\
--Creando tablas

CREATE TABLE categorias(
categoria_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
categoria VARCHAR(30) NOT NULL
);

CREATE TABLE usuarios(
usuario_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
`login` VARCHAR(30) NOT NULL,
`password` VARCHAR(32) NOT NULL,
nickname VARCHAR(40) NOT NULL UNIQUE,
email VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE posts(
post_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
titulo VARCHAR(150),
fecha_publicacion TIMESTAMP,
contenido TEXT ,
estatus CHAR(8) DEFAULT 'activo',
usuario_id INTEGER UNSIGNED,
categoria_id INTEGER UNSIGNED
);

-- FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id) 
--     ON UPDATE CASCADE
--     ON DELETE NO ACTION,
-- FOREIGN KEY (categoria_id) REFERENCES categoria(categoria_id)
-- );

CREATE TABLE comentarios(
comentario_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
comentario TEXT ,
usuario_id INTEGER ,
post_id INTEGER 
);

CREATE TABLE etiquetas(
etiquetas_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
nombre_etiqueta VARCHAR(30) NOT NULL
);

--Llaves Foraneas 


    




ALTER TABLE posts 
ADD CONSTRAINT posts_categoria_fk
    FOREIGN KEY(categoria_id)
    REFERENCES categorias(categoria_id)
    ON DELETE NO ACTION 
    ON UPDATE CASCADE;


-- Recordar tener los campos compatibles INTEGER UNSIGNED
ALTER TABLE comentarios
ADD CONSTRAINT comentario_usuario
    FOREIGN KEY (usuario_id) 
    REFERENCES usuarios(usuario_id)
    ON DELETE NO ACTION 
    ON UPDATE CASCADE;

ALTER TABLE comentarios 
ADD CONSTRAINT post_comentario
    FOREIGN KEY (post_id)
    REFERENCES posts(post_id)
    ON DELETE NO ACTION 
    ON UPDATE CASCADE;

-- tabla transitiva 
CREATE TABLE posts_etiquetas
(post_etiqueta_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
post_id INTEGER UNSIGNED NOT NULL, 
etiquetas_id INTEGER UNSIGNED);

ALTER TABLE posts_etiquetas
ADD CONSTRAINT postetiquetas_post
    FOREIGN KEY (post_id) 
    REFERENCES posts(post_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE;

ALTER TABLE posts_etiquetas
ADD CONSTRAINT postetiquetas_etiquetas
    FOREIGN KEY (etiquetas_id) 
    REFERENCES etiquetas(etiquetas_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE;