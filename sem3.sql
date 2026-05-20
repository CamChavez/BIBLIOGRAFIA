-- ============================================================
--   SEMESTRE 3 — Ingeniería en Computación · FES Aragón UNAM
--   USA SUBCONSULTAS POR NOMBRE — nunca falla por AUTO_INCREMENT
-- ============================================================

USE referencias_db;

-- ============================================================
--   MATERIAS  (semestre_id=3)
-- ============================================================
INSERT INTO materias (nombre, creditos, semestre_id, area, modalidad, tipo, caracter, objetivo, asignatura_antecedente, asignatura_subsecuente) VALUES
('Ecuaciones Diferenciales', 9, 3, 'Matemáticas', 'Curso', 'Teórico', 'Obligatorio',
 'Analizar los elementos básicos de las ecuaciones diferenciales y emplearlos en la resolución de problemas físicos y geométricos.',
 'Cálculo Vectorial', 'Probabilidad y Estadística'),
('Electricidad y Magnetismo (L)', 11, 3, 'Arquitectura de Computadoras', 'Curso-Laboratorio', 'Teórico-Práctico', 'Obligatorio',
 'Analizar los conceptos, principios y leyes fundamentales del electromagnetismo y desarrollar la capacidad de observación y habilidad en el manejo de instrumentos experimentales y de medición, con el fin de aplicar los conocimientos en la resolución de problemas reales.',
 'Ninguna', 'Dispositivos Electrónicos (L)'),
('Emprendimiento 2', 8, 3, 'Entorno Social', 'Curso', 'Teórico', 'Obligatorio',
 'Conocer las herramientas de la administración, los costos, la contabilidad y el presupuesto, a partir de los cuales se podrá realizar un Plan de Negocios para emprender, generar empleo, bienes o servicios innovadores para un mayor bienestar a la sociedad.',
 'Emprendimiento 1 y Taller de Creatividad e Innovación', 'Emprendimiento 3'),
('Estructura de Datos', 8, 3, 'Programación e Ingeniería de Software', 'Curso', 'Teórico', 'Obligatorio',
 'Entender los algoritmos básicos de ordenación y hacer un análisis del tiempo de ejecución; el concepto de recursión, así como representar y ocupar las estructuras de datos en problemas computacionales.',
 'Programación Orientada a Objetos', 'Bases de Datos 1'),
('Métodos Numéricos', 9, 3, 'Matemáticas', 'Curso', 'Teórico', 'Obligatorio',
 'Analizar los elementos que permitan obtener soluciones aproximadas de modelos matemáticos en la ingeniería mediante métodos numéricos.',
 'Álgebra Lineal', 'Probabilidad y Estadística');

-- ============================================================
--   AUTORES  (solo los nuevos)
-- ============================================================
INSERT INTO autores (apellidos, inicial) VALUES
-- Ecuaciones Diferenciales
('Barrelli',    'R.'),
('Coleman',     'C.'),
('Boyce',       'W.'),
('Constando',   'C.'),
('Debnath',     'L.'),
('Doshi',       'J. B.'),
('Edwards',     'H.'),
('Erwin',       'K.'),
('James',       'G.'),
('Taylor',      'M.'),   -- (distinto al Taylor de Cálculo Vectorial A. Taylor)
('Zill',        'D.'),
-- Electricidad y Magnetismo
('Enriquez',    'G.'),
('Giraldo',     'E.'),
('Hayt',        'W.'),
('Sears',       'F.'),
('Serway',      'R.'),
('Torresi',     'A.'),
('Varela',      'D.'),
('Garzón',      'A.'),
('González',    'J.'),   -- (González J., distinto al González C. y González R.S. de Comunicación)
('Kelly',       'P. F.'),
('Serrano',     'D. V.'),
-- Emprendimiento 2
('Bléjer',      'M.'),
('Cohen',       'B.'),
('Evans',       'M.'),
('Harris',      'N.'),
('Ibáñez',      'J. J.'),
('Pappas',      'J. L.'),
('Motta',       'M.'),
('Piñeiro',     'G. P.'),
-- Estructura de Datos (Welsch ya existe en Emprendimiento 1 sem2; Savitch y Lopez/Ismael nuevos)
('Aho',         'A.'),
('Drozdek',     'A.'),
('Lopez',       'A.'),
('Pantoja',     'L.'),
('Sznajdleder', 'P.'),
('Weiss',       'M.'),
('Cormen',      'T.'),
('Savitch',     'W.'),
-- Métodos Numéricos
('Burden',      'R.'),
('Carrasco',    'V. L.'),
('Ezquerro',    'F. J.'),
('García',      'R.'),
('Luthe',       'R.'),
('Mora',        'W. F.');

-- ============================================================
--   BIBLIOGRAFÍAS — semestre 3
-- ============================================================

-- ── ECUACIONES DIFERENCIALES ─────────────────────────────────
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'basica', 'libro', 'Ecuaciones diferenciales',                                          2002, 'AlfaOmega',                       'México', NULL,    '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'basica', 'libro', 'Ecuaciones diferenciales',                                          2010, 'Limusa Wiley',                    'México', NULL,    '1,2,3,4'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'basica', 'libro', 'Solution techniques for elementary partial differential equations', 2010, 'CRC Press Taylor Francis',        NULL,     'USA',   '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'basica', 'libro', 'Nonlinear partial differential equations',                          2013, 'Birlchauser',                     NULL,     'USA',   '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'basica', 'libro', 'Differential equations for scientists and enginners',               2010, 'Alpha Science International Ltd', NULL,     'USA',   '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'basica', 'libro', 'Ecuaciones diferenciales y problemas con valores en la frontera',   2009, 'Pearson',                         'México', NULL,    '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'basica', 'libro', 'Matemáticas avanzadas para ingeniería I y II',                      2013, 'Limusa Wiley',                    'México', NULL,    '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'basica', 'libro', 'Matemáticas avanzadas para ingeniería',                             2002, 'Pearson Education',               'México', NULL,    '2,3,4'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'basica', 'libro', 'Partial differential equations',                                    2010, 'Springer',                        NULL,     'USA',   '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'basica', 'libro', 'Ecuaciones diferenciales con aplicaciones de modelado',             2006, 'Thompson',                        'México', NULL,    '1,2,3,4'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'complementaria', 'libro', 'Writing the History of Mathematics: Its Historical Development', 2002, 'Birkhäuser',              NULL,     'Germany','1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'complementaria', 'libro', 'Imagine Math. Between Culture and Mathematics',              2012, 'Springer',                        NULL,     'Italia', '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3), 'complementaria', 'libro', 'Tales of Mathematicians and Physicists',                     2007, 'Springer',                        'New York',NULL,   '1,2,3,4,5');

-- ── ELECTRICIDAD Y MAGNETISMO ────────────────────────────────
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
((SELECT id FROM materias WHERE nombre='Electricidad y Magnetismo (L)' AND semestre_id=3), 'basica', 'libro', 'Fundamentos de electricidad: teoría y problemas', 2015, 'Limusa',             'México',   NULL,       '1,2,3'),
((SELECT id FROM materias WHERE nombre='Electricidad y Magnetismo (L)' AND semestre_id=3), 'basica', 'libro', 'Fundamentos de electricidad y magnetismo',        2015, 'Fondo Editorial EIA', 'Colombia', NULL,       '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Electricidad y Magnetismo (L)' AND semestre_id=3), 'basica', 'libro', 'Engineering Electromagnetics',                    2001, 'McGraw Hill',         NULL,       'USA',      '1,2,3,4'),
((SELECT id FROM materias WHERE nombre='Electricidad y Magnetismo (L)' AND semestre_id=3), 'basica', 'libro', 'Física Universitaria',                            2008, 'Addison-Wesley',      'México',   NULL,       '4,5,6'),
((SELECT id FROM materias WHERE nombre='Electricidad y Magnetismo (L)' AND semestre_id=3), 'basica', 'libro', 'Física: electricidad y magnetismo',               2016, 'Cengage Learning',    NULL,       'Australia','3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Electricidad y Magnetismo (L)' AND semestre_id=3), 'basica', 'libro', 'Ensayo de materiales y componentes electrotécnicos', 2017, 'Universitas',      'Cordoba',  NULL,       '1,2,3,4,6'),
((SELECT id FROM materias WHERE nombre='Electricidad y Magnetismo (L)' AND semestre_id=3), 'basica', 'libro', 'Guía para prácticas experimentales de física: electricidad y magnetismo', 2016, 'Universidad de la Salle', 'Colombia', NULL, '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Electricidad y Magnetismo (L)' AND semestre_id=3), 'complementaria', 'libro', 'Conceptos básicos de electricidad y magnetismo', 2012, 'Universidad Distrital Francisco José de Caldas', 'Colombia', NULL, '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Electricidad y Magnetismo (L)' AND semestre_id=3), 'complementaria', 'libro', 'Conceptos básicos de electricidad y magnetismo', 2012, 'Universidad Nacional de Colombia', 'Colombia', NULL, '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Electricidad y Magnetismo (L)' AND semestre_id=3), 'complementaria', 'libro', 'Electricity and magnetism',               2015, 'CRC Press',           'Boca Ratón', NULL,     '1,2,3,4,5,6'),
((SELECT id FROM materias WHERE nombre='Electricidad y Magnetismo (L)' AND semestre_id=3), 'complementaria', 'libro', 'Electricidad y magnetismo',               2001, 'Prentice Hall',       'México',   NULL,       '1,2,3,4,5,6');

-- ── EMPRENDIMIENTO 2 ─────────────────────────────────────────
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
((SELECT id FROM materias WHERE nombre='Emprendimiento 2' AND semestre_id=3), 'basica', 'libro', 'Ensayos sobre el enfoque monetario de la balanza de pagos', 1982, 'Centro de Estudios Monetarios Latinoamericanos', 'México', NULL, '5'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 2' AND semestre_id=3), 'basica', 'libro', 'Política de balanza de pagos',                              1969, 'Alianza',      NULL,    'España', '5'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 2' AND semestre_id=3), 'basica', 'libro', 'Macroeconomics for managers',                               2004, 'Wiley-Blackwell', NULL, 'USA',    '2'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 2' AND semestre_id=3), 'basica', 'libro', 'Business economics',                                        2001, 'Butterworth Heinemann', NULL, 'Great Britain', '1,2'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 2' AND semestre_id=3), 'basica', 'libro', 'Responsabilidad social de la empresa y finanzas sociales',  2004, 'Akal',         NULL,    'España', '4'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 2' AND semestre_id=3), 'basica', 'libro', 'Fundamentos de economía y administración',                  1993, 'McGraw-Hill',  'México', NULL,    '3'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 2' AND semestre_id=3), 'complementaria', 'libro', 'Política de competencia: teoría y práctica',        2018, 'Fondo de Cultura Económica', 'Ciudad de México', NULL, '2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 2' AND semestre_id=3), 'complementaria', 'libro', 'Introducción a la economía de la empresa',          2012, 'Delta',        NULL,    'España', '3'),
((SELECT id FROM materias WHERE nombre='Emprendimiento 2' AND semestre_id=3), 'complementaria', 'libro', 'Presupuestos, planificación y control de las utilidades', 2005, 'Prentice Hall', 'México', NULL, '4');

-- ── ESTRUCTURA DE DATOS ──────────────────────────────────────
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
((SELECT id FROM materias WHERE nombre='Estructura de Datos' AND semestre_id=3), 'basica', 'libro', 'Compiladores: principios, técnicas y herramientas',         2008, 'Addison Wesley',   'México',      NULL, '1,5'),
((SELECT id FROM materias WHERE nombre='Estructura de Datos' AND semestre_id=3), 'basica', 'libro', 'The theory of parsing, translation, and compiling',          1972, 'Prentice Hall',    'New Jersey',  NULL, '1,3,4,5'),
((SELECT id FROM materias WHERE nombre='Estructura de Datos' AND semestre_id=3), 'basica', 'libro', 'Estructura de datos y algoritmos en Java',                   2007, 'Thomson',          'México',      NULL, '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Estructura de Datos' AND semestre_id=3), 'basica', 'libro', 'Estructura de datos con JAVA: un enfoque práctico',          2011, 'UNAM. Facultad de Ciencias', 'México', NULL, '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Estructura de Datos' AND semestre_id=3), 'basica', 'libro', 'Estructuras de datos dinámicas',                             2017, 'Ra-Ma',            'Madrid',      NULL, '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Estructura de Datos' AND semestre_id=3), 'basica', 'libro', 'Programación orientada a objetos y estructura de datos a fondo: implementación de algoritmos en Java', 2017, 'Alfaomega', 'Buenos Aires', NULL, '1,2,3,4,5'),
((SELECT id FROM materias WHERE nombre='Estructura de Datos' AND semestre_id=3), 'basica', 'libro', 'Estructura de datos en Java',                                2000, 'Addison Wesley',   'Madrid',      NULL, '1,3,4,5'),
((SELECT id FROM materias WHERE nombre='Estructura de Datos' AND semestre_id=3), 'complementaria', 'libro', 'Introduction to Algorithms',                         2009, 'The MIT Press',     NULL,          'USA','1,3,4,5'),
((SELECT id FROM materias WHERE nombre='Estructura de Datos' AND semestre_id=3), 'complementaria', 'libro', 'Curso avanzado de Java: manual Práctico',             2017, 'Alfaomega',        'Ciudad de México', NULL, '1,2,3,4'),
((SELECT id FROM materias WHERE nombre='Estructura de Datos' AND semestre_id=3), 'complementaria', 'libro', 'Absolute Java',                                      2010, 'Addison-Wesley',   'México',      NULL, '1,2,3,4');

-- ── MÉTODOS NUMÉRICOS ────────────────────────────────────────
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
((SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3), 'basica', 'libro', 'Análisis numérico',                            2002, 'Thompson Learning',                              'México',       NULL, '4,5,7,8'),
((SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3), 'basica', 'libro', 'Métodos numéricos',                            2011, 'Macro',                                          'Lima, Perú',   NULL, '1,2,4,5,6,7,8,9,10'),
((SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3), 'basica', 'libro', 'Iniciación a los Métodos Numéricos',           2012, 'Iberus',                                         NULL,           'España', '1,2,4,5,6,7,8,9,10'),
((SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3), 'basica', 'libro', 'Métodos Numéricos Con Mathematica',            2005, 'Alfaomega, Universidad Politécnica de Valencia',  'México',       NULL, '1,2,4,5,6,7,8,10'),
((SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3), 'basica', 'libro', 'Métodos numéricos',                            1996, 'Limusa',                                         'Mexico',       NULL, '1,2,3,4,5,6,7,8,9'),
((SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3), 'complementaria', 'libro', 'Writing the History of Mathematics: Its Historical Development', 2002, 'Birkhäuser',       NULL,           'Germany', '1,2,4,5,6,7,8,9,10'),
((SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3), 'complementaria', 'libro', 'Imagine Math. Between Culture and Mathematics',               2012, 'Springer',               NULL,           'Italia', '1,2,4,5,6,7,8,9,10'),
((SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3), 'complementaria', 'libro', 'Tales of Mathematicians and Physicists',                       2007, 'Springer',               'New York',     NULL, '1,2,4,5,6,7,8,9,10'),
((SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3), 'complementaria', 'libro', 'Introducción a los Métodos Numéricos',                         2016, 'Escuela de Matemáticas', NULL,           'Costa Rica', '1,2,4,5,6,7,8,9,10');

-- ============================================================
--   RELACIÓN AUTORES ↔ BIBLIOGRAFÍAS
-- ============================================================

-- ── ECUACIONES DIFERENCIALES ─────────────────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
((SELECT id FROM bibliografias WHERE titulo='Ecuaciones diferenciales' AND anio=2002 AND materia_id=(SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Barrelli' AND inicial='R.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Ecuaciones diferenciales' AND anio=2002 AND materia_id=(SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Coleman' AND inicial='C.'), 2),
((SELECT id FROM bibliografias WHERE titulo='Ecuaciones diferenciales' AND anio=2010 AND materia_id=(SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Boyce' AND inicial='W.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Solution techniques for elementary partial differential equations'),
 (SELECT id FROM autores WHERE apellidos='Constando' AND inicial='C.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Nonlinear partial differential equations'),
 (SELECT id FROM autores WHERE apellidos='Debnath' AND inicial='L.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Differential equations for scientists and enginners'),
 (SELECT id FROM autores WHERE apellidos='Doshi' AND inicial='J. B.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Ecuaciones diferenciales y problemas con valores en la frontera'),
 (SELECT id FROM autores WHERE apellidos='Edwards' AND inicial='H.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Matemáticas avanzadas para ingeniería I y II'),
 (SELECT id FROM autores WHERE apellidos='Erwin' AND inicial='K.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Matemáticas avanzadas para ingeniería' AND anio=2002),
 (SELECT id FROM autores WHERE apellidos='James' AND inicial='G.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Partial differential equations' AND anio=2010),
 (SELECT id FROM autores WHERE apellidos='Taylor' AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Ecuaciones diferenciales con aplicaciones de modelado'),
 (SELECT id FROM autores WHERE apellidos='Zill' AND inicial='D.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Writing the History of Mathematics: Its Historical Development' AND materia_id=(SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Dauben' AND inicial='J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Writing the History of Mathematics: Its Historical Development' AND materia_id=(SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Scriba' AND inicial='C. J.'), 2),
((SELECT id FROM bibliografias WHERE titulo='Imagine Math. Between Culture and Mathematics' AND materia_id=(SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Emmer' AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Tales of Mathematicians and Physicists' AND materia_id=(SELECT id FROM materias WHERE nombre='Ecuaciones Diferenciales' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Gindikin' AND inicial='S.'), 1);

-- ── ELECTRICIDAD Y MAGNETISMO ────────────────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
((SELECT id FROM bibliografias WHERE titulo='Fundamentos de electricidad: teoría y problemas'),
 (SELECT id FROM autores WHERE apellidos='Enriquez' AND inicial='G.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Fundamentos de electricidad y magnetismo'),
 (SELECT id FROM autores WHERE apellidos='Giraldo' AND inicial='E.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Engineering Electromagnetics'),
 (SELECT id FROM autores WHERE apellidos='Hayt' AND inicial='W.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Física Universitaria'),
 (SELECT id FROM autores WHERE apellidos='Sears' AND inicial='F.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Física: electricidad y magnetismo'),
 (SELECT id FROM autores WHERE apellidos='Serway' AND inicial='R.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Ensayo de materiales y componentes electrotécnicos'),
 (SELECT id FROM autores WHERE apellidos='Torresi' AND inicial='A.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Guía para prácticas experimentales de física: electricidad y magnetismo'),
 (SELECT id FROM autores WHERE apellidos='Varela' AND inicial='D.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Conceptos básicos de electricidad y magnetismo' AND editorial='Universidad Distrital Francisco José de Caldas'),
 (SELECT id FROM autores WHERE apellidos='Garzón' AND inicial='A.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Conceptos básicos de electricidad y magnetismo' AND editorial='Universidad Nacional de Colombia'),
 (SELECT id FROM autores WHERE apellidos='González' AND inicial='J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Electricity and magnetism'),
 (SELECT id FROM autores WHERE apellidos='Kelly' AND inicial='P. F.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Electricidad y magnetismo' AND anio=2001),
 (SELECT id FROM autores WHERE apellidos='Serrano' AND inicial='D. V.'), 1);

-- ── EMPRENDIMIENTO 2 ─────────────────────────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
((SELECT id FROM bibliografias WHERE titulo='Ensayos sobre el enfoque monetario de la balanza de pagos'),
 (SELECT id FROM autores WHERE apellidos='Bléjer' AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Política de balanza de pagos'),
 (SELECT id FROM autores WHERE apellidos='Cohen' AND inicial='B.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Macroeconomics for managers'),
 (SELECT id FROM autores WHERE apellidos='Evans' AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Business economics'),
 (SELECT id FROM autores WHERE apellidos='Harris' AND inicial='N.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Responsabilidad social de la empresa y finanzas sociales'),
 (SELECT id FROM autores WHERE apellidos='Ibáñez' AND inicial='J. J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Fundamentos de economía y administración'),
 (SELECT id FROM autores WHERE apellidos='Pappas' AND inicial='J. L.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Política de competencia: teoría y práctica'),
 (SELECT id FROM autores WHERE apellidos='Motta' AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Introducción a la economía de la empresa'),
 (SELECT id FROM autores WHERE apellidos='Piñeiro' AND inicial='G. P.'), 1),
-- Welsch ya existe en sem2 Emprendimiento 1; referenciamos por subconsulta
((SELECT id FROM bibliografias WHERE titulo='Presupuestos, planificación y control de las utilidades' AND materia_id=(SELECT id FROM materias WHERE nombre='Emprendimiento 2' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Welsch' AND inicial='G.'), 1);

-- ── ESTRUCTURA DE DATOS ──────────────────────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
((SELECT id FROM bibliografias WHERE titulo='Compiladores: principios, técnicas y herramientas' AND anio=2008),
 (SELECT id FROM autores WHERE apellidos='Aho' AND inicial='A.' AND id=(SELECT MIN(id) FROM autores WHERE apellidos='Aho' AND inicial='A.')), 1),
((SELECT id FROM bibliografias WHERE titulo='The theory of parsing, translation, and compiling'),
 (SELECT id FROM autores WHERE apellidos='Aho' AND inicial='A.' AND id=(SELECT MIN(id) FROM autores WHERE apellidos='Aho' AND inicial='A.')), 1),
((SELECT id FROM bibliografias WHERE titulo='Estructura de datos y algoritmos en Java'),
 (SELECT id FROM autores WHERE apellidos='Drozdek' AND inicial='A.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Estructura de datos con JAVA: un enfoque práctico'),
 (SELECT id FROM autores WHERE apellidos='Lopez' AND inicial='A.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Estructuras de datos dinámicas'),
 (SELECT id FROM autores WHERE apellidos='Pantoja' AND inicial='L.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Programación orientada a objetos y estructura de datos a fondo: implementación de algoritmos en Java'),
 (SELECT id FROM autores WHERE apellidos='Sznajdleder' AND inicial='P.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Estructura de datos en Java'),
 (SELECT id FROM autores WHERE apellidos='Weiss' AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Introduction to Algorithms'),
 (SELECT id FROM autores WHERE apellidos='Cormen' AND inicial='T.'), 1),
-- "Curso avanzado de Java: manual Práctico" — López I. ya existe (sem2 POO), referenciamos
((SELECT id FROM bibliografias WHERE titulo='Curso avanzado de Java: manual Práctico' AND materia_id=(SELECT id FROM materias WHERE nombre='Estructura de Datos' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='López' AND inicial='I.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Absolute Java'),
 (SELECT id FROM autores WHERE apellidos='Savitch' AND inicial='W.'), 1);

-- ── MÉTODOS NUMÉRICOS ────────────────────────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
((SELECT id FROM bibliografias WHERE titulo='Análisis numérico' AND anio=2002),
 (SELECT id FROM autores WHERE apellidos='Burden' AND inicial='R.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Métodos numéricos' AND anio=2011),
 (SELECT id FROM autores WHERE apellidos='Carrasco' AND inicial='V. L.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Iniciación a los Métodos Numéricos'),
 (SELECT id FROM autores WHERE apellidos='Ezquerro' AND inicial='F. J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Métodos Numéricos Con Mathematica'),
 (SELECT id FROM autores WHERE apellidos='García' AND inicial='R.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Métodos numéricos' AND anio=1996),
 (SELECT id FROM autores WHERE apellidos='Luthe' AND inicial='R.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Writing the History of Mathematics: Its Historical Development' AND materia_id=(SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Dauben' AND inicial='J.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Writing the History of Mathematics: Its Historical Development' AND materia_id=(SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Scriba' AND inicial='C. J.'), 2),
((SELECT id FROM bibliografias WHERE titulo='Imagine Math. Between Culture and Mathematics' AND materia_id=(SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Emmer' AND inicial='M.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Tales of Mathematicians and Physicists' AND materia_id=(SELECT id FROM materias WHERE nombre='Métodos Numéricos' AND semestre_id=3)),
 (SELECT id FROM autores WHERE apellidos='Gindikin' AND inicial='S.'), 1),
((SELECT id FROM bibliografias WHERE titulo='Introducción a los Métodos Numéricos'),
 (SELECT id FROM autores WHERE apellidos='Mora' AND inicial='W. F.'), 1);

-- ============================================================
--   VERIFICACIÓN FINAL
-- ============================================================
SELECT m.nombre,
       COUNT(b.id)                    AS total_refs,
       SUM(b.tipo = 'basica')         AS basicas,
       SUM(b.tipo = 'complementaria') AS complementarias
FROM   materias m
LEFT JOIN bibliografias b ON b.materia_id = m.id
WHERE  m.semestre_id = 3
GROUP  BY m.id, m.nombre
ORDER  BY m.nombre;