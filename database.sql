-- ============================================================
--   Proyecto: CRUD de Referencias Bibliográficas
--   Carrera : Ingeniería en Computación - FES Aragón UNAM
--   Autora  : Camila Chávez Ramírez
-- ============================================================
--   Este script:
--     1. Crea la base de datos `referencias_db`.
--     2. Crea 5 tablas relacionadas.
--     3. Inserta datos de ejemplo (Geometría Analítica).
--
--   Para importarlo, en la terminal corre:
--     mysql -u root -p < database.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS referencias_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE referencias_db;

-- Borrar tablas si ya existen (orden inverso por las FKs)
DROP TABLE IF EXISTS bibliografia_autores;
DROP TABLE IF EXISTS bibliografias;
DROP TABLE IF EXISTS autores;
DROP TABLE IF EXISTS materias;
DROP TABLE IF EXISTS semestres;

-- ============================================================
--   TABLA: semestres
--   Catálogo de semestres (1-9) más la categoría "Optativa".
-- ============================================================
CREATE TABLE semestres (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    numero      INT NULL,                         -- NULL = Optativa
    nombre      VARCHAR(50) NOT NULL UNIQUE,
    creado_en   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
--   TABLA: materias
--   Datos generales de cada asignatura.
-- ============================================================
CREATE TABLE materias (
    id                       INT AUTO_INCREMENT PRIMARY KEY,
    nombre                   VARCHAR(200) NOT NULL,
    clave                    VARCHAR(20)  NULL,
    creditos                 INT          NULL,
    semestre_id              INT          NOT NULL,
    area                     VARCHAR(100) NULL,    -- Matemáticas, Programación, etc.
    modalidad                VARCHAR(50)  NULL,    -- Curso, Taller, Seminario...
    tipo                     VARCHAR(50)  NULL,    -- Teórico, Práctico, T/P
    caracter                 VARCHAR(20)  NULL,    -- Obligatorio / Optativo
    objetivo                 TEXT         NULL,
    asignatura_antecedente   VARCHAR(200) NULL,
    asignatura_subsecuente   VARCHAR(200) NULL,
    creado_en                TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en           TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_materia_semestre
        FOREIGN KEY (semestre_id) REFERENCES semestres(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_materia_nombre (nombre)
) ENGINE=InnoDB;

-- ============================================================
--   TABLA: autores
--   Se separan para poder buscar "Shannon" y traer TODAS sus obras.
-- ============================================================
CREATE TABLE autores (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(100) NULL,         -- Nombre completo si se conoce
    apellidos   VARCHAR(150) NOT NULL,
    inicial     VARCHAR(20)  NOT NULL,     -- "P." o "A. V." para las citas
    creado_en   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_autor_apellidos (apellidos)
) ENGINE=InnoDB;

-- ============================================================
--   TABLA: bibliografias
--   Una bibliografía pertenece a UNA materia y se clasifica
--   como básica o complementaria. Tiene todos los campos
--   necesarios para generar APA, IEEE, BibTeX y MLA.
-- ============================================================
CREATE TABLE bibliografias (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    materia_id          INT NOT NULL,
    tipo                ENUM('basica','complementaria') NOT NULL DEFAULT 'basica',
    tipo_recurso        ENUM('libro','articulo','capitulo','tesis','web','otro')
                        NOT NULL DEFAULT 'libro',
    titulo              VARCHAR(500) NOT NULL,
    subtitulo           VARCHAR(500) NULL,
    anio                INT          NULL,
    editorial           VARCHAR(200) NULL,
    ciudad              VARCHAR(100) NULL,
    pais                VARCHAR(100) NULL,
    edicion             VARCHAR(50)  NULL,
    -- Solo aplica para artículos:
    revista             VARCHAR(200) NULL,
    volumen             VARCHAR(20)  NULL,
    numero_revista      VARCHAR(20)  NULL,
    paginas             VARCHAR(50)  NULL,
    -- Identificadores:
    doi                 VARCHAR(200) NULL,
    isbn                VARCHAR(50)  NULL,
    issn                VARCHAR(20)  NULL,
    url                 VARCHAR(500) NULL,
    fecha_consulta      DATE         NULL,
    -- Datos del programa:
    temas_recomendados  VARCHAR(100) NULL,   -- ej: "1,2,3,4,5"
    notas               TEXT         NULL,
    creado_en           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_biblio_materia
        FOREIGN KEY (materia_id) REFERENCES materias(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_biblio_titulo (titulo),
    INDEX idx_biblio_anio   (anio)
) ENGINE=InnoDB;

-- ============================================================
--   TABLA: bibliografia_autores
--   N:M entre bibliografías y autores, con orden (1er autor,
--   2do autor, etc.) para construir bien la cita.
-- ============================================================
CREATE TABLE bibliografia_autores (
    bibliografia_id INT NOT NULL,
    autor_id        INT NOT NULL,
    orden           INT NOT NULL DEFAULT 1,
    PRIMARY KEY (bibliografia_id, autor_id),
    CONSTRAINT fk_ba_biblio
        FOREIGN KEY (bibliografia_id) REFERENCES bibliografias(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ba_autor
        FOREIGN KEY (autor_id) REFERENCES autores(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
--   DATOS DE EJEMPLO
-- ============================================================

-- Semestres (1 al 9 + Optativa)
INSERT INTO semestres (numero, nombre) VALUES
(1,    'Primer Semestre'),
(2,    'Segundo Semestre'),
(3,    'Tercer Semestre'),
(4,    'Cuarto Semestre'),
(5,    'Quinto Semestre'),
(6,    'Sexto Semestre'),
(7,    'Séptimo Semestre'),
(8,    'Octavo Semestre'),
(9,    'Noveno Semestre'),
(NULL, 'Optativa');

-- Materia: Geometría Analítica (semestre 1)
INSERT INTO materias
    (nombre, creditos, semestre_id, area, modalidad, tipo, caracter,
     objetivo, asignatura_antecedente, asignatura_subsecuente)
VALUES (
    'Geometría Analítica',
    9,
    1,
    'Matemáticas',
    'Curso',
    'Teórico',
    'Obligatorio',
    'Reafirmar los conocimientos de la trigonometría básica y de la geometría analítica plana con el fin de adquirir los conceptos fundamentales del álgebra vectorial y aplicarlos al estudio de la geometría analítica del espacio tridimensional.',
    'Ninguna',
    'Álgebra Lineal'
);

-- Autores (solo apellidos + inicial como aparecen en el PDF)
INSERT INTO autores (apellidos, inicial) VALUES
('Barry',     'P.'),       -- 1
('Gigena',    'S.'),       -- 2
('Granville', 'W.'),       -- 3
('Kaufmann',  'J.'),       -- 4
('Kindle',    'J.'),       -- 5
('Pogorélov', 'A. V.'),    -- 6
('Sullivan',  'M.'),       -- 7
('Swokowski', 'E.'),       -- 8
('Taylor',    'A.'),       -- 9
('Mann',      'R. W.'),    -- 10
('Dauben',    'J.'),       -- 11
('Scriba',    'C. J.'),    -- 12
('Emmer',     'M.'),       -- 13
('Gindikin',  'S.');       -- 14

-- Bibliografía básica para Geometría Analítica (materia_id = 1)
INSERT INTO bibliografias
    (materia_id, tipo, tipo_recurso, titulo, anio, editorial, pais, temas_recomendados)
VALUES
(1, 'basica',         'libro', 'Geometry and trigonometry',                        2001, 'Woodhead Publishing',                          'Irlanda',     '1,2,3,4,5'),
(1, 'basica',         'libro', 'Álgebra y geometría: teoría, práctica y aplicaciones', 2018, 'Universitas Editorial Científica Universitaria', 'Argentina', '1,2,3,4,5'),
(1, 'basica',         'libro', 'Trigonometría plana y esférica',                   1980, 'Hispanoamérica',                                'México',     '3,4,5'),
(1, 'basica',         'libro', 'Álgebra intermedia',                               2000, 'Thomson',                                       'México',     '1'),
(1, 'basica',         'libro', 'Geometría analítica',                              2007, 'Mc Grawhill',                                   'México',     '1,2,3,4,5'),
(1, 'basica',         'libro', 'Geometría elemental',                              2001, 'Editorial Pueblo y Educación',                  'México',     '1,2,3,4,5'),
(1, 'basica',         'libro', 'Algebra and trigonometry',                         2011, 'Pearson',                                       'New Jersey', '1,2,4'),
(1, 'basica',         'libro', 'Álgebra y trigonometría con geometría analítica',  2002, 'International Thompson',                        'México',     '1,2,3,4'),
(1, 'basica',         'libro', 'Fundamentos de cálculo avanzado',                  1989, 'Limusa',                                        'México',     '1,2,5'),
(1, 'complementaria', 'libro', 'Writing the History of Mathematics: Its Historical Development', 2002, 'Birkhäuser', 'Germany',           '1,2,3,4,5'),
(1, 'complementaria', 'libro', 'Imagine Math. Between Culture and Mathematics',    2012, 'Springer',                                      'Italia',     '1,2,3,4,5'),
(1, 'complementaria', 'libro', 'Tales of Mathematicians and Physicists',           2007, 'Springer',                                      'New York',   '1,2,3,4,5');

-- Relacionar autores con sus bibliografías (preservando orden)
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
( 1,  1, 1),   -- Barry      → Geometry and trigonometry
( 2,  2, 1),   -- Gigena     → Álgebra y geometría
( 3,  3, 1),   -- Granville  → Trigonometría plana y esférica
( 4,  4, 1),   -- Kaufmann   → Álgebra intermedia
( 5,  5, 1),   -- Kindle     → Geometría analítica
( 6,  6, 1),   -- Pogorélov  → Geometría elemental
( 7,  7, 1),   -- Sullivan   → Algebra and trigonometry
( 8,  8, 1),   -- Swokowski  → Álgebra y trigonometría
( 9,  9, 1),   -- Taylor     → Fundamentos de cálculo avanzado
( 9, 10, 2),   -- Mann       (2do autor del mismo libro)
(10, 11, 1),   -- Dauben     → Writing the History
(10, 12, 2),   -- Scriba     (2do autor del mismo libro)
(11, 13, 1),   -- Emmer      → Imagine Math
(12, 14, 1);   -- Gindikin   → Tales of Mathematicians

-- ============================================================
--   VERIFICACIÓN: cuántos registros quedaron en cada tabla
-- ============================================================
SELECT 'semestres'           AS tabla, COUNT(*) AS total FROM semestres
UNION ALL SELECT 'materias',           COUNT(*) FROM materias
UNION ALL SELECT 'autores',            COUNT(*) FROM autores
UNION ALL SELECT 'bibliografias',      COUNT(*) FROM bibliografias
UNION ALL SELECT 'bibliografia_autores', COUNT(*) FROM bibliografia_autores;