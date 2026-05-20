-- ============================================================
--   SEMESTRE 2 — Ingeniería en Computación · FES Aragón UNAM
--   USA SUBCONSULTAS POR NOMBRE — nunca falla por AUTO_INCREMENT
--   Corre DESPUÉS de fix_sem2.sql
-- ============================================================

USE referencias_db;

-- ============================================================
--   MATERIAS  (semestre_id=2)
-- ============================================================
INSERT INTO materias (nombre, creditos, semestre_id, area, modalidad, tipo, caracter, objetivo, asignatura_antecedente, asignatura_subsecuente) VALUES
('Álgebra Lineal',                    9, 2, 'Matemáticas',                           'Curso',  'Teórico',  'Obligatorio',
 'Analizar con un manejo formal matemático, los elementos básicos de los espacios vectoriales y las características principales que se obtienen, al establecer en ellos un producto interno y un operador lineal para aplicarlos en la solución de problemas que requieren de estos conceptos como instrumentos para su resolución.',
 'Álgebra, Geometría Analítica', 'Métodos Numéricos'),
('Cálculo Vectorial',                 9, 2, 'Matemáticas',                           'Curso',  'Teórico',  'Obligatorio',
 'Entender el cálculo vectorial como una extensión natural a funciones de más de una variable independiente.',
 'Cálculo Diferencial e Integral', 'Ecuaciones Diferenciales'),
('Comunicación',                      8, 2, 'Entorno Social',                        'Curso',  'Teórico',  'Obligatorio',
 'Desarrollar estrategias y habilidades de comunicación escrita, oral y no verbal (kinésica), para transmitir de forma clara y eficiente ideas, conocimientos y emociones.',
 'Ninguna', 'Habilidades Directivas'),
('Emprendimiento 1',                  8, 2, 'Entorno Social',                        'Curso',  'Teórico',  'Obligatorio',
 'Conocer los aspectos económicos que determinan y condicionan la creación, crecimiento y consolidación de una empresa y realizar un esfuerzo creativo para desarrollar la parte económica de un plan de negocios.',
 'Introducción a la Ingeniería en Computación', 'Emprendimiento 2'),
('Programación Orientada a Objetos',  8, 2, 'Programación e Ingeniería de Software', 'Curso',  'Teórico',  'Obligatorio',
 'Entender el paradigma y aplicación de la programación orientada a objetos para responder a las exigencias y bondades de los compiladores actuales.',
 'Computadoras y Programación', 'Estructura de Datos'),
('Taller de Creatividad e Innovación',3, 2, 'Entorno Social',                        'Taller', 'Práctico', 'Obligatorio',
 'Conocer los problemas actuales en torno a las necesidades del ser humano y analizar las soluciones existentes a nivel mundial, para desarrollar alternativas propias que sean creativas e innovadoras, aplicando la ingeniería en computación.',
 'Ninguna', 'Emprendimiento 2');

-- ============================================================
--   AUTORES  (solo los nuevos, los ya existentes se reutilizan)
-- ============================================================
INSERT INTO autores (apellidos, inicial) VALUES
('Antón',        'H.'),       -- Álgebra Lineal
('Bretscher',    'O.'),
('Grossman',     'S.'),
('Hitte',        'F.'),
('Howard',       'A.'),
('Larson',       'R.'),
('Falvo',        'C.'),
('Lipschutz',    'S.'),       -- Álgebra Lineal (España, distinto al id=20)
('Petersen',     'P.'),
('Poole',        'D.'),
('Sanz',         'A. P.'),
('Shafarevich',  'I. R.'),
('Blume',        'F.'),       -- Cálculo Vectorial
('George',       'B. T.'),
('Hahn',         'A.'),
('Marsden',      'J.'),
('Fonseca',      'Y. S.'),    -- Comunicación (2016)
('Fonseca',      'Y. S.'),    -- Comunicación (2000)
('González',     'C.'),
('González',     'R. S.'),
('Rangel',       'H. M.'),
('Sanchez',      'O.'),
('Baro',         'T.'),
('Eggert',       'M.'),
('Mc Entee',     'E.'),
('Niño',         'V.'),
('Ocampo',       'N.'),
('Araujo',       'A. D.'),    -- Emprendimiento 1
('Brunet',       'I. I.'),
('Dickey',       'T.'),
('Guajardo',     'G.'),
('Hernández',    'O. M.'),
('Horngren',     'C.'),
('Koontz',       'H.'),
('Ocampo',       'J.'),
('Ocampo',       'S. J.'),
('Salvarredy',   'J.'),
('Welsch',       'G.'),
('Oropeza',      'M. O.'),
('Rico',         'E. L.'),
('Río',          'G. C.'),
('Rodríguez',    'M.'),
('Ceballos',     'S. F.'),    -- POO
('Deitel',       'H.'),       -- POO (Como Programar en Java 2016)
('Horstmann',    'C.'),
('López',        'I.'),
('Vázquez',      'B.'),
('Horton',       'I.'),
('Comorera',     'O. V.'),    -- Taller
('Fingermann',   'G.'),
('Maslow',       'A.'),       -- 1991
('Maslow',       'A.'),       -- 1994
('Osterwalder',  'A.'),       -- 2010 solo
('Osterwalder',  'A.'),       -- 2011 con Pigneur
('Pigneur',      'Y.'),
('Tracy',        'D.'),
('Venegas',      'R.'),
('Vroom',        'V.'),
('Gámez',        'J.'),
('Hilarión',     'J.'),
('Schnarch',     'A.');

-- Guardar los IDs que necesitamos como variables
-- (Los nuevos autores arrancaron en el siguiente disponible tras id=64)
-- Usamos subconsultas por apellido+inicial donde sea único,
-- o SET @var para los que se repiten.

-- IDs de autores reutilizados del semestre 1:
-- Kaufmann=4, Sullivan=7, Taylor=9, Mann=10, Dauben=11, Scriba=12,
-- Emmer=13, Gindikin=14, Hall=18, Colley=27, Mena=30

-- Para los autores nuevos usamos subconsultas MAX(id) por apellido+inicial
-- agrupando donde hay duplicados por año.

-- ============================================================
--   BIBLIOGRAFÍAS — usando subconsulta para materia_id
-- ============================================================

-- ── ÁLGEBRA LINEAL ──────────────────────────────────────────
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Introducción al Álgebra Lineal',              2003, 'Limusa',                    'México',     NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Linear algebra with applications',            2009, 'Pearson',                   'New Jersey', NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Algebra lineal',                              2012, 'Mc Graw Hill',              'México',     NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Álgebra Lineal',                              2002, 'Pearson',                   'México',     NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Introducción al algebra lineal',              2003, 'Limusa Wiley',              'México',     NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Álgebra Intermedia',                          2000, 'Thomson',                   'México',     NULL,     '1'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Introducción al álgebra lineal',              2008, 'Limusa',                    'México',     NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Fundamentos de álgebra lineal',               2016, 'Cengage Learning Editores', NULL,         'USA',    '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Álgebra Lineal',                              1993, 'McGraw-Hill',               NULL,         'España', '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Linear Algebra',                              2012, 'Springer',                  NULL,         'USA',    '2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Álgebra lineal una introducción moderna',     2016, 'Cengage Learning Editores', NULL,         'EUA',    '1,2,3'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Álgebra lineal',                              2013, 'Garceta',                   'Madrid',     NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Linear Algebra and Geometry',                 2012, 'Springer',                  NULL,         'USA',    '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'basica', 'libro', 'Algebra and trigonometry',                    2012, 'Pearson',                   'New Jersey', NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'complementaria', 'libro', 'Writing the History of Mathematics: Its Historical Development', 2002, 'Birkhäuser', NULL, 'Germany', '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'complementaria', 'libro', 'Imagine Math. Between Culture and Mathematics',   2012, 'Springer', NULL, 'USA',     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2), 'complementaria', 'libro', 'Tales of Mathematicians and Physicists',          2007, 'Springer', 'New York', NULL,  '1,2,3,4,5,6');

-- ── CÁLCULO VECTORIAL ────────────────────────────────────────
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
((SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2), 'basica', 'libro', 'Applied calculus for scientist and engineers', 2005, 'Jones and Barlett',                 NULL,      'USA',    '2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2), 'basica', 'libro', 'Cálculo vectorial',                            2013, 'Pearson',                           'México',  NULL,     '1,2,3,4,5,6,7,8'),
((SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2), 'basica', 'libro', 'Cálculo varias variables',                     2015, 'Pearson Education',                 'México',  NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2), 'basica', 'libro', 'Basic Calculus',                               2017, 'Johns Hopkins University Press',     'New York',NULL,     '2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2), 'basica', 'libro', 'Álgebra superior',                             1991, 'Hispanoamérica',                    'México',  NULL,     '1'),
((SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2), 'basica', 'libro', 'Cálculo Vectorial',                            2005, 'Pearson Education (Prentice Hall)', 'México',  NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2), 'basica', 'libro', 'Introducción al cálculo vectorial',            2003, 'Thomson',                           'México',  NULL,     '1,2,3,4,5,6,7,8'),
((SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2), 'basica', 'libro', 'Fundamentos de cálculo avanzado',              1989, 'Limusa',                            'México',  NULL,     '1,2,3,4,5,6,7,8'),
((SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2), 'complementaria', 'libro', 'Writing the History of Mathematics: Its Historical Development', 2002, 'Birkhäuser', NULL, 'Germany', '1,2,3,4,5,6,7,8'),
((SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2), 'complementaria', 'libro', 'Imagine Math. Between Culture and Mathematics',   2012, 'Springer', NULL, 'Italia',  '1,2,3,4,5,6,7,8'),
((SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2), 'complementaria', 'libro', 'Tales of Mathematicians and Physicists',          2007, 'Springer', 'New York', NULL, '1,2,3,4,5,6,7,8');

-- ── COMUNICACIÓN ─────────────────────────────────────────────
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
((SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2), 'basica', 'libro', 'Comunicación oral y escrita',                       2016, 'Pearson',                    'México', NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2), 'basica', 'libro', 'Comunicación oral (fundamentos y práctica estratégica)', 2000, 'Pearson',               'México', NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2), 'basica', 'libro', 'Principios básicos de comunicación',                 2008, 'Trillas',                    'México', NULL,     '1'),
((SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2), 'basica', 'libro', 'Manual de redacción e investigación documental',     2005, 'Trillas',                    'México', NULL,     '1,2,3,4,5,6,7'),
((SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2), 'basica', 'libro', 'Comunicación Oral México',                           2010, 'Trillas',                    'México', NULL,     '5,7'),
((SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2), 'basica', 'libro', 'Comunicación oral y escrita en la empresa',          2013, 'Paraninfo',                  NULL,     'España', '1,2,7'),
((SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2), 'complementaria', 'libro', 'Manual de la comunicación personal de éxito: saber ser, saber actuar, saber comunicarse', 2016, 'Ediciones Culturales Paidós', 'México', NULL, '1,2,3,4,5,6,7'),
((SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2), 'complementaria', 'libro', 'Tips efectivos para mejorar su lenguaje corporal',  2013, 'Editorial Trillas',  'México', NULL,     '1,4,5,6,7'),
((SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2), 'complementaria', 'libro', 'Comunicación Oral I: Fundamentos de la Comunicación Oral', 2015, 'Eileen McEntee','México', NULL,   '1,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2), 'complementaria', 'libro', 'Competencias en la comunicación: hacia las prácticas del discurso', 2012, 'Ecoe Ediciones', 'Bogota', NULL, '1,2,3,4,5,6,7'),
((SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2), 'complementaria', 'libro', 'Método de comunicación asertiva: el método que acerca a las personas', 2010, 'Editorial Trillas', 'México', NULL, '1,2,3,4,5,6,7');

-- ── EMPRENDIMIENTO 1 ─────────────────────────────────────────
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'basica', 'libro', 'Presupuestos empresariales. Eje de la planeación financiera', 2012, 'Trillas',       'México',    NULL,     '5'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'basica', 'libro', 'Creación de empresas. Emprendimiento e innovación',           2014, 'Ra-Ma',         'México',    NULL,     '2'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'basica', 'libro', 'Cómo elaborar un presupuesto',                               1994, 'Iberoamericana','México',    NULL,     '5'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'basica', 'libro', 'Contabilidad Financiera',                                    2008, 'McGraw Hill',   'México',    NULL,     '3'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'basica', 'libro', 'Administración de empresas',                                 2014, 'Pirámide',      NULL,        'España', '1'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'basica', 'libro', 'Costos accounting',                                          2012, 'Prentice Hall', NULL,        'USA',    '4'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'basica', 'libro', 'Administración. Una perspectiva global y empresarial',       2008, 'McGraw Hill',   'México',    NULL,     '1,2'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'basica', 'libro', 'Costos y evaluación de proyectos',                           2003, 'CECSA',         'México',    NULL,     '4'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'basica', 'libro', 'Administración Contabilidad y Costos',                       2009, 'Continentales', 'México',    NULL,     '2,3,4'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'basica', 'libro', 'Gestión económica y financiera de proyectos',                2003, 'Omicron',       'Argentina', NULL,     '5'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'basica', 'libro', 'Presupuestos, planificación y control de las utilidades',    2005, 'Prentice Hall', 'México',    NULL,     '4'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'complementaria', 'libro', 'Costos Curso básico',                                2003, 'Trillas',       'México',    NULL,     '4'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'complementaria', 'libro', 'Cuánto vale mi empresa',                              2006, 'CESA y Mayol',  'Colombia',  NULL,     '1,2,3,4'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'complementaria', 'libro', 'Costos 1',                                            2011, 'CENGAGE Learning','México',  NULL,     '4'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'complementaria', 'libro', 'Presupuestos con Excel',                              2003, 'Omicron',       'Argentina', NULL,     '5'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2), 'complementaria', 'libro', 'Comunicación oral y escrita en la empresa',           2013, 'Paraninfo',     NULL,        'España', '1,2');

-- ── PROGRAMACIÓN ORIENTADA A OBJETOS ────────────────────────
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
((SELECT id FROM materias WHERE nombre='Programación Orientada a Objetos' AND semestre_id=2), 'basica', 'libro', 'Java 2 Curso de Programación',         2000, 'Alfaomega Ra-Ma', 'México',          NULL, '1,2,3,4'),
((SELECT id FROM materias WHERE nombre='Programación Orientada a Objetos' AND semestre_id=2), 'basica', 'libro', 'Como Programar en Java',               2016, 'Prentice Hall',   'México',          NULL, '1,2,3,4'),
((SELECT id FROM materias WHERE nombre='Programación Orientada a Objetos' AND semestre_id=2), 'basica', 'libro', 'Core Java',                            2008, 'Prentice Hall',   'México',          NULL, '1,2,3'),
((SELECT id FROM materias WHERE nombre='Programación Orientada a Objetos' AND semestre_id=2), 'basica', 'libro', 'Curso avanzado de Java: manual práctico', 2017, 'Alfaomega',    'Ciudad de México', NULL, '1,2,3,4'),
((SELECT id FROM materias WHERE nombre='Programación Orientada a Objetos' AND semestre_id=2), 'basica', 'libro', 'Java y C++: paso a paso',              2017, 'Ra-Ma',           'Madrid',          NULL, '1,2,3,4'),
((SELECT id FROM materias WHERE nombre='Programación Orientada a Objetos' AND semestre_id=2), 'complementaria', 'libro', 'Beginning Java',               2011, 'John Wiley',      NULL,              'USA','1,2,3,4');

-- ── TALLER DE CREATIVIDAD E INNOVACIÓN ──────────────────────
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'basica', 'libro', 'Creación de empresas, emprendimiento e innovación',          2014, 'Ra-Ma',                 'México',      NULL,     '1'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'basica', 'libro', 'Desarrollo del factor humano',                               2005, 'UOC',                   'Barcelona',   NULL,     '1'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'basica', 'libro', 'Relaciones humanas, fundamentos psicológicos y sociales',    1992, 'Editorial el ateneo',   'México',      NULL,     '2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'basica', 'libro', 'Motivación y personalidad',                                  1991, 'Diaz de Santos',        'Madrid',      NULL,     '2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'basica', 'libro', 'La teoría de las necesidades',                               1994, 'Salvat',                NULL,          'España', '2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'basica', 'libro', 'Generación de modelos de negocios',                          2010, 'Wiley',                 'New Jersey',  NULL,     '1'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'basica', 'libro', 'Generación de modelos de negocio',                           2011, 'Deusto',                NULL,          'España', '1'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'basica', 'libro', 'La pirámide del poder',                                      1991, 'Javier Vergara Editor', 'Buenos Aires',NULL,     '2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'basica', 'libro', 'Guía para el docente y solucionarios, creación y gestión de microempresas', 2014, 'IC editorial', NULL, 'España', '1'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'basica', 'libro', 'Motivación y alta dirección',                                1979, 'Trillas',               'México',      NULL,     '2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'complementaria', 'libro', 'Emprendimiento, creatividad e innovación',            2015, 'Universidad de la Salle FCAC', 'Bogota', NULL, '2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'complementaria', 'libro', 'Emprendimiento e innovación: diseña y planea tu negocio', 2014, 'Cengage Learning', 'México',    NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Taller de Creatividad e Innovación' AND semestre_id=2), 'complementaria', 'libro', 'Creatividad e Innovación',                           2018, 'Alfaomega',             'México',      NULL,     '1,2,3,4,5,6');

-- ============================================================
--   RELACIÓN AUTORES ↔ BIBLIOGRAFÍAS
--   Usamos subconsultas por título+año para evitar hardcodear IDs
-- ============================================================

-- ── ÁLGEBRA LINEAL ──────────────────────────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
((SELECT id FROM bibliografias WHERE titulo='Introducción al Álgebra Lineal'          AND anio=2003), (SELECT id FROM autores WHERE apellidos='Antón'       AND inicial='H.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Linear algebra with applications'         AND anio=2009), (SELECT id FROM autores WHERE apellidos='Bretscher'   AND inicial='O.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Algebra lineal'                           AND anio=2012), (SELECT id FROM autores WHERE apellidos='Grossman'    AND inicial='S.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Álgebra Lineal'                           AND anio=2002), (SELECT id FROM autores WHERE apellidos='Hitte'       AND inicial='F.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Introducción al algebra lineal'           AND anio=2003), (SELECT id FROM autores WHERE apellidos='Howard'      AND inicial='A.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Álgebra Intermedia'                       AND anio=2000), (SELECT id FROM autores WHERE apellidos='Kaufmann'    AND inicial='J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Introducción al álgebra lineal'           AND anio=2008), (SELECT id FROM autores WHERE apellidos='Larson'      AND inicial='R.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Fundamentos de álgebra lineal'            AND anio=2016), (SELECT id FROM autores WHERE apellidos='Larson'      AND inicial='R.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Fundamentos de álgebra lineal'            AND anio=2016), (SELECT id FROM autores WHERE apellidos='Falvo'       AND inicial='C.'), 2),
((SELECT id FROM bibliografias WHERE titulo='Álgebra Lineal'                           AND anio=1993), (SELECT id FROM autores WHERE apellidos='Lipschutz'   AND inicial='S.' AND id=(SELECT MAX(id) FROM autores WHERE apellidos='Lipschutz' AND inicial='S.')), 1),
((SELECT id FROM bibliografias WHERE titulo='Linear Algebra'                           AND anio=2012), (SELECT id FROM autores WHERE apellidos='Petersen'    AND inicial='P.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Álgebra lineal una introducción moderna'  AND anio=2016), (SELECT id FROM autores WHERE apellidos='Poole'       AND inicial='D.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Álgebra lineal'                           AND anio=2013), (SELECT id FROM autores WHERE apellidos='Sanz'        AND inicial='A. P.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Linear Algebra and Geometry'              AND anio=2012), (SELECT id FROM autores WHERE apellidos='Shafarevich' AND inicial='I. R.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Algebra and trigonometry'                 AND anio=2012 AND materia_id=(SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Sullivan' AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Writing the History of Mathematics: Its Historical Development' AND materia_id=(SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Dauben' AND inicial='J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Writing the History of Mathematics: Its Historical Development' AND materia_id=(SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Scriba' AND inicial='C. J.'), 2),
((SELECT id FROM bibliografias WHERE titulo='Imagine Math. Between Culture and Mathematics' AND materia_id=(SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Emmer' AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Tales of Mathematicians and Physicists'   AND materia_id=(SELECT id FROM materias WHERE nombre='Álgebra Lineal' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Gindikin' AND inicial='S.'), 1);

-- ── CÁLCULO VECTORIAL ────────────────────────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
((SELECT id FROM bibliografias WHERE titulo='Applied calculus for scientist and engineers'), (SELECT id FROM autores WHERE apellidos='Blume'   AND inicial='F.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Cálculo vectorial'   AND anio=2013 AND materia_id=(SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Colley'  AND inicial='S.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Cálculo varias variables'),                    (SELECT id FROM autores WHERE apellidos='George'  AND inicial='B. T.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Basic Calculus'),                              (SELECT id FROM autores WHERE apellidos='Hahn'    AND inicial='A.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Álgebra superior' AND materia_id=(SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Hall' AND inicial='H.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Cálculo Vectorial' AND anio=2005),             (SELECT id FROM autores WHERE apellidos='Marsden' AND inicial='J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Introducción al cálculo vectorial' AND materia_id=(SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Mena' AND inicial='B.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Fundamentos de cálculo avanzado' AND materia_id=(SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Taylor' AND inicial='A.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Fundamentos de cálculo avanzado' AND materia_id=(SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Mann'   AND inicial='R. W.'), 2),
((SELECT id FROM bibliografias WHERE titulo='Writing the History of Mathematics: Its Historical Development' AND materia_id=(SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Dauben' AND inicial='J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Writing the History of Mathematics: Its Historical Development' AND materia_id=(SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Scriba' AND inicial='C. J.'), 2),
((SELECT id FROM bibliografias WHERE titulo='Imagine Math. Between Culture and Mathematics' AND materia_id=(SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Emmer'   AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Tales of Mathematicians and Physicists'        AND materia_id=(SELECT id FROM materias WHERE nombre='Cálculo Vectorial' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Gindikin' AND inicial='S.'), 1);

-- ── COMUNICACIÓN ─────────────────────────────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
((SELECT id FROM bibliografias WHERE titulo='Comunicación oral y escrita'                   AND anio=2016), (SELECT MAX(id) FROM autores WHERE apellidos='Fonseca' AND inicial='Y. S.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Comunicación oral (fundamentos y práctica estratégica)'),      (SELECT MIN(id) FROM autores WHERE apellidos='Fonseca' AND inicial='Y. S.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Principios básicos de comunicación'),          (SELECT id FROM autores WHERE apellidos='González'  AND inicial='C.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Manual de redacción e investigación documental'),(SELECT id FROM autores WHERE apellidos='González'  AND inicial='R. S.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Comunicación Oral México'),                     (SELECT id FROM autores WHERE apellidos='Rangel'    AND inicial='H. M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Comunicación oral y escrita en la empresa' AND materia_id=(SELECT id FROM materias WHERE nombre='Comunicación' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Sanchez' AND inicial='O.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Manual de la comunicación personal de éxito: saber ser, saber actuar, saber comunicarse'), (SELECT id FROM autores WHERE apellidos='Baro'     AND inicial='T.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Tips efectivos para mejorar su lenguaje corporal'),            (SELECT id FROM autores WHERE apellidos='Eggert'   AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Comunicación Oral I: Fundamentos de la Comunicación Oral'),    (SELECT id FROM autores WHERE apellidos='Mc Entee' AND inicial='E.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Competencias en la comunicación: hacia las prácticas del discurso'), (SELECT id FROM autores WHERE apellidos='Niño'  AND inicial='V.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Método de comunicación asertiva: el método que acerca a las personas'), (SELECT id FROM autores WHERE apellidos='Ocampo' AND inicial='N.'), 1);

-- ── EMPRENDIMIENTO 1 ─────────────────────────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
((SELECT id FROM bibliografias WHERE titulo='Presupuestos empresariales. Eje de la planeación financiera'), (SELECT id FROM autores WHERE apellidos='Araujo'     AND inicial='A. D.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Creación de empresas. Emprendimiento e innovación'),           (SELECT id FROM autores WHERE apellidos='Brunet'     AND inicial='I. I.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Cómo elaborar un presupuesto'),                               (SELECT id FROM autores WHERE apellidos='Dickey'     AND inicial='T.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Contabilidad Financiera'),                                    (SELECT id FROM autores WHERE apellidos='Guajardo'   AND inicial='G.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Administración de empresas'),                                  (SELECT id FROM autores WHERE apellidos='Hernández'  AND inicial='O. M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Costos accounting'),                                           (SELECT id FROM autores WHERE apellidos='Horngren'   AND inicial='C.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Administración. Una perspectiva global y empresarial'),        (SELECT id FROM autores WHERE apellidos='Koontz'     AND inicial='H.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Costos y evaluación de proyectos'),                           (SELECT id FROM autores WHERE apellidos='Ocampo'     AND inicial='J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Administración Contabilidad y Costos'),                       (SELECT id FROM autores WHERE apellidos='Ocampo'     AND inicial='S. J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Gestión económica y financiera de proyectos'),                (SELECT id FROM autores WHERE apellidos='Salvarredy' AND inicial='J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Presupuestos, planificación y control de las utilidades'),    (SELECT id FROM autores WHERE apellidos='Welsch'     AND inicial='G.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Costos Curso básico'),                                        (SELECT id FROM autores WHERE apellidos='Oropeza'    AND inicial='M. O.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Cuánto vale mi empresa'),                                     (SELECT id FROM autores WHERE apellidos='Rico'       AND inicial='E. L.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Costos 1'),                                                   (SELECT id FROM autores WHERE apellidos='Río'        AND inicial='G. C.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Presupuestos con Excel'),                                     (SELECT id FROM autores WHERE apellidos='Rodríguez'  AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Comunicación oral y escrita en la empresa' AND materia_id=(SELECT id FROM materias WHERE nombre='Emprendimiento 1' AND semestre_id=2)), (SELECT id FROM autores WHERE apellidos='Sanchez' AND inicial='O.'), 1);

-- ── PROGRAMACIÓN ORIENTADA A OBJETOS ────────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
((SELECT id FROM bibliografias WHERE titulo='Java 2 Curso de Programación'),        (SELECT id FROM autores WHERE apellidos='Ceballos'   AND inicial='S. F.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Como Programar en Java'),              (SELECT id FROM autores WHERE apellidos='Deitel'     AND inicial='H.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Core Java'),                           (SELECT id FROM autores WHERE apellidos='Horstmann'  AND inicial='C.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Curso avanzado de Java: manual práctico'),(SELECT id FROM autores WHERE apellidos='López'   AND inicial='I.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Java y C++: paso a paso'),             (SELECT id FROM autores WHERE apellidos='Vázquez'   AND inicial='B.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Beginning Java'),                      (SELECT id FROM autores WHERE apellidos='Horton'    AND inicial='I.'), 1);

-- ── TALLER DE CREATIVIDAD E INNOVACIÓN ──────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
((SELECT id FROM bibliografias WHERE titulo='Creación de empresas, emprendimiento e innovación'),           (SELECT id FROM autores WHERE apellidos='Brunet'      AND inicial='I. I.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Desarrollo del factor humano'),                                (SELECT id FROM autores WHERE apellidos='Comorera'    AND inicial='O. V.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Relaciones humanas, fundamentos psicológicos y sociales'),     (SELECT id FROM autores WHERE apellidos='Fingermann'  AND inicial='G.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Motivación y personalidad'),                                   (SELECT MIN(id) FROM autores WHERE apellidos='Maslow' AND inicial='A.'), 1),
((SELECT id FROM bibliografias WHERE titulo='La teoría de las necesidades'),                                (SELECT MAX(id) FROM autores WHERE apellidos='Maslow' AND inicial='A.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Generación de modelos de negocios'),                          (SELECT MIN(id) FROM autores WHERE apellidos='Osterwalder' AND inicial='A.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Generación de modelos de negocio'),                           (SELECT MAX(id) FROM autores WHERE apellidos='Osterwalder' AND inicial='A.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Generación de modelos de negocio'),                           (SELECT id FROM autores WHERE apellidos='Pigneur'     AND inicial='Y.'), 2),
((SELECT id FROM bibliografias WHERE titulo='La pirámide del poder'),                                      (SELECT id FROM autores WHERE apellidos='Tracy'       AND inicial='D.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Guía para el docente y solucionarios, creación y gestión de microempresas'), (SELECT id FROM autores WHERE apellidos='Venegas' AND inicial='R.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Motivación y alta dirección'),                                (SELECT id FROM autores WHERE apellidos='Vroom'       AND inicial='V.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Emprendimiento, creatividad e innovación'),                   (SELECT id FROM autores WHERE apellidos='Gámez'       AND inicial='J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Emprendimiento e innovación: diseña y planea tu negocio'),    (SELECT id FROM autores WHERE apellidos='Hilarión'    AND inicial='J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Creatividad e Innovación'),                                   (SELECT id FROM autores WHERE apellidos='Schnarch'    AND inicial='A.'), 1);

-- ============================================================
--   VERIFICACIÓN FINAL
-- ============================================================
SELECT m.nombre,
       COUNT(b.id)                    AS total_refs,
       SUM(b.tipo = 'basica')         AS basicas,
       SUM(b.tipo = 'complementaria') AS complementarias
FROM   materias m
LEFT JOIN bibliografias b ON b.materia_id = m.id
WHERE  m.semestre_id = 2
GROUP  BY m.id, m.nombre
ORDER  BY m.nombre;