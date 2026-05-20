-- ============================================================
--   SEMESTRE 1 — Ingeniería en Computación · FES Aragón UNAM
--   Corre DESPUÉS de database.sql
--   IDs asumidos al arrancar este script:
--     materias     último id = 1  (Geometría Analítica)
--     autores      último id = 14
--     bibliografias último id = 12
-- ============================================================

USE referencias_db;

-- ============================================================
--   MATERIAS  (ids resultantes: 2-5)
-- ============================================================
INSERT INTO materias (nombre, creditos, semestre_id, area, modalidad, tipo, caracter, objetivo, asignatura_antecedente, asignatura_subsecuente) VALUES
('Álgebra',                                9, 1, 'Matemáticas',                          'Curso', 'Teórico', 'Obligatorio',
 'Manejar los conceptos de lógica, teoría de conjuntos y sistemas algebraicos para la solución de problemas de análisis combinatorio, y como fundamento para todos los cursos posteriores de matemáticas en su aplicación al área del cómputo.',
 'Ninguna', 'Álgebra Lineal'),

('Cálculo Diferencial e Integral',         9, 1, 'Matemáticas',                          'Curso', 'Teórico', 'Obligatorio',
 'Analizar los conceptos fundamentales del cálculo diferencial e integral de funciones reales de variable real, a fin de aplicarlos a la formulación y manejo de modelos matemáticos de problemas físicos y geométricos.',
 'Ninguna', 'Cálculo Vectorial'),

('Computadoras y Programación',            9, 1, 'Programación e Ingeniería de Software', 'Curso', 'Teórico', 'Obligatorio',
 'Conocer los conceptos básicos sobre la computadora y su funcionamiento, así como aprender a programar de manera estructurada sobre el lenguaje C para resolver problemas reales.',
 'Ninguna', 'Programación Orientada a Objetos, Sistemas Operativos'),

('Introducción a la Ingeniería en Computación', 6, 1, 'Entorno Social',                  'Curso', 'Teórico', 'Obligatorio',
 'Definir el plan de vida, conocer el método de la ingeniería para la resolución de problemas y comprender el manejo básico de software, para desempeñarse de forma responsable como ingeniero en computación.',
 'Ninguna', 'Emprendimiento 1');

-- ============================================================
--   AUTORES  (ids resultantes: 15-64)
-- ============================================================
INSERT INTO autores (apellidos, inicial) VALUES
-- Álgebra
('Cárdenas',        'T. H.'),   -- 15
('De Oteyza',       'E.'),      -- 16
('Fuller',          'G.'),      -- 17
('Hall',            'H.'),      -- 18
('Lehmann',         'C.'),      -- 19
('Lipschutz',       'S.'),      -- 20
('Mariscal',        'L. G.'),   -- 21
('Ross',            'K.'),      -- 22
('Sahai',           'V.'),      -- 23
('Bist',            'V.'),      -- 24
('Zill',            'D.'),      -- 25
('Dewar',           'J.'),      -- 26
-- Cálculo
('Colley',          'S.'),      -- 27
('Lax',             'P.'),      -- 28
('López',           'S. I.'),   -- 29
('Mena',            'B.'),      -- 30
('Stewart',         'J.'),      -- 31
('Thomas',          'G.'),      -- 32
-- Computadoras y Programación
('Deitel',          'H. M.'),   -- 33
('Kernighan',       'B.'),      -- 34
('Méndez',          'A.'),      -- 35
('Peñaloza',        'R. E.'),   -- 36
('Schildt',         'H.'),      -- 37
('Sznajdleder',     'P.'),      -- 38
('Wirth',           'N.'),      -- 39
('Alvarado',        'I.'),      -- 40
('Long',            'L.'),      -- 41
('Pradip',          'D.'),      -- 42
('Restrepo',        'J.'),      -- 43
('Zapata',          'L.'),      -- 44
-- Introducción a la Ingeniería en Computación
('Forouzan',        'B. A.'),   -- 45
('Gómez de Silva',  'G. A.'),   -- 46
('Harris',          'C.'),      -- 47
('Lazzati',         'S.'),      -- 48
('Mc Grath',        'J.'),      -- 49
('Parsons',         'J.'),      -- 50
('Peña',            'P. R.'),   -- 51
('Pérez',           'D. A.'),   -- 52
('Rees',            'W.'),      -- 53
('Sánchez',         'P. S.'),   -- 54
('García',          'O.'),      -- 55
('Serrat',          'O. M.'),   -- 56
('Sexton',          'W.'),      -- 57
('Shah',            'S.'),      -- 58
('Sumner',          'M.'),      -- 59
('Tellez',          'V. J.'),   -- 60
('Tovar',           'E. O.'),   -- 61
('Walter',          'R.'),      -- 62
('Wielsch',         'M.'),      -- 63
('Viqueira',        'J.');      -- 64

-- ============================================================
--   BIBLIOGRAFÍAS — ÁLGEBRA (materia_id = 2)
--   Básica: ids 13-26  |  Complementaria: ids 27-29
-- ============================================================
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
(2, 'basica', 'libro', 'Algebra superior',                                             2014, 'Editorial Trillas',                              'México',      NULL,        '1,2,3,4,5,6'),  -- 13
(2, 'basica', 'libro', 'Álgebra',                                                      2013, 'Prentice Hall, Pearson',                         'México',      NULL,        '1,3,5'),         -- 14
(2, 'basica', 'libro', 'Álgebra Elemental',                                            2005, 'CECSA',                                          'México',      NULL,        '1,2,3,4,5,6'),  -- 15
(2, 'basica', 'libro', 'Álgebra y geometría: teoría, práctica y aplicaciones',         2018, 'Universitas Editorial Científica Universitaria', 'Argentina',   NULL,        '1,2,3,4,5,6'),  -- 16
(2, 'basica', 'libro', 'Álgebra superior',                                             1991, 'Hispanoamérica',                                 'México',      NULL,        '1,3,4,5,6'),    -- 17
(2, 'basica', 'libro', 'Álgebra intermedia',                                           2000, 'Thomson',                                        'México',      NULL,        '1,2,3,4,5,6'),  -- 18
(2, 'basica', 'libro', 'Álgebra',                                                      2008, 'Limusa',                                         'México',      NULL,        '1,3,4,5,6'),    -- 19
(2, 'basica', 'libro', 'Teoría y problemas de teoría de conjuntos y temas afines',     1991, 'McGrawHill',                                     'México',      NULL,        '1,2,3,4,5,6'),  -- 20
(2, 'basica', 'libro', 'Vive la Probabilidad y Estadística 2',                         2013, 'Editorial Progreso, S.A. de C.V.',               'México',      NULL,        '6'),            -- 21
(2, 'basica', 'libro', 'Matemáticas discretas',                                        1990, 'Prentice-Hall',                                  'México',      NULL,        '2,6'),          -- 22
(2, 'basica', 'libro', 'Algebra',                                                      2008, 'Alpha Science International',                    'Oxford',      NULL,        '1'),            -- 23
(2, 'basica', 'libro', 'Algebra and trigonometry',                                     2011, 'Pearson',                                        'New Jersey',  'EUA',       '1,3,4,5,6'),    -- 24
(2, 'basica', 'libro', 'Álgebra y trigonometría con geometría analítica',              2002, 'International Thomson',                          'México',      NULL,        '1,3,4,5,6'),    -- 25
(2, 'basica', 'libro', 'Algebra and trigonometry',                                     2012, 'Brooks and Cole, Cengage',                       NULL,          'EUA',       '1,3,4,5'),      -- 26
(2, 'complementaria', 'libro', 'Writing the History of Mathematics: Its Historical Development', 2002, 'Springer', NULL, 'Switzerland', '1,2,3,4,5,6'),                                   -- 27
(2, 'complementaria', 'libro', 'Imagine Math. Between Culture and Mathematics',        2012, 'Springer',                                       NULL,          'Italia',    '1,2,3,4,5,6'),  -- 28
(2, 'complementaria', 'libro', 'Tales of Mathematicians and Physicists',               2007, 'Springer',                                       'New York',    NULL,        '1,2,3,4,5,6');  -- 29

-- ============================================================
--   BIBLIOGRAFÍAS — CÁLCULO DIFERENCIAL E INTEGRAL (materia_id = 3)
--   Básica: ids 30-37  |  Complementaria: ids 38-40
-- ============================================================
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
(3, 'basica', 'libro', 'Cálculo Vectorial',                                          2013, 'Pearson',         'México',    NULL,        '1,2,3,4,5,6,7'),  -- 30
(3, 'basica', 'libro', 'Cálculo Diferencial e Integral',                             2008, 'Limusa',          'México',    NULL,        '1,2,3,4,5,6,7'),  -- 31
(3, 'basica', 'libro', 'Calculus with Applications',                                 2014, 'Springer',        'New York',  NULL,        '1,2,3,4,5,6,7'),  -- 32
(3, 'basica', 'libro', 'Cálculo diferencial de una variable con aplicaciones',       2006, 'Thomson',         'México',    NULL,        '1,2,3'),           -- 33
(3, 'basica', 'libro', 'Introducción al Cálculo Vectorial',                          2003, 'Thomson',         'México',    NULL,        '1,2,3,4,5,6,7'),  -- 34
(3, 'basica', 'libro', 'Cálculo diferencial e integral',                             2007, 'Cengage Learning','México',    NULL,        '1,2,3,4,6,7'),    -- 35
(3, 'basica', 'libro', 'Fundamentos de cálculo avanzado',                            1989, 'Limusa',          'México',    NULL,        '1,2,3,4'),         -- 36
(3, 'basica', 'libro', 'Cálculo: una variable',                                      2016, 'Pearson',         'México',    NULL,        '1,2,3,4,5,6,7'),  -- 37
(3, 'complementaria', 'libro', 'Writing the History of Mathematics: Its Historical Development', 2002, 'Birkhäuser', NULL, 'Germany', '1,2,3,4,5,6,7'),   -- 38
(3, 'complementaria', 'libro', 'Imagine Math. Between Culture and Mathematics',      2012, 'Springer',        NULL,        'Italia',    '1,2,3,4,5,6,7'),  -- 39
(3, 'complementaria', 'libro', 'Tales of Mathematicians and Physicists',             2007, 'Springer',        'New York',  NULL,        '1,2,3,4,5,6,7');  -- 40

-- ============================================================
--   BIBLIOGRAFÍAS — COMPUTADORAS Y PROGRAMACIÓN (materia_id = 4)
--   Básica: ids 41-47  |  Complementaria: ids 48-52
-- ============================================================
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
(4, 'basica', 'libro', 'Como programar en C++',                                                              2009, 'Pearson Educación',   'México',       NULL,       '1'),      -- 41
(4, 'basica', 'libro', 'El lenguaje de programación C',                                                      1991, 'Prentice Hall',        'México',       NULL,       '3'),      -- 42
(4, 'basica', 'libro', 'Diseño de algoritmos y su programación en C',                                        2013, 'Alfaomega',            'México',       NULL,       '2,3'),    -- 43
(4, 'basica', 'libro', 'Fundamentos de programación',                                                        2004, 'UNAM ENEP Aragón',     'México',       NULL,       '1,2,3'), -- 44
(4, 'basica', 'libro', 'Ansi C a su alcance',                                                                1991, 'McGraw Hill',          'México',       NULL,       '3'),      -- 45
(4, 'basica', 'libro', 'Programación estructurada a fondo: implementación de algoritmos en C',               2017, 'Alfaomega',            'Buenos Aires', NULL,       '2,3'),    -- 46
(4, 'basica', 'libro', 'Algorithms and data structures',                                                     1976, 'Prentice Hall',        NULL,           'USA',      '3'),      -- 47
(4, 'complementaria', 'libro', '100 problemas resueltos de programación en lenguaje C para ingeniería',      2017, 'Ediciones Paraninfo',  'Madrid',       NULL,       '2,3'),    -- 48
(4, 'complementaria', 'libro', 'Introducción a las Computadoras y a los Sistemas de Información',            1995, 'Prentice Hall',        'México',       NULL,       '1,2,3'), -- 49
(4, 'complementaria', 'libro', 'Computer fundamentals and programming in C',                                 2014, 'Oxford University Press','New Delhi',  NULL,       '1,2,3'), -- 50
(4, 'complementaria', 'libro', 'De dos a Windows Introducción a las Computadoras Personales',                1996, 'Random House Reference',NULL,          'EU',       '1,2,3'), -- 51
(4, 'complementaria', 'libro', 'Desarrollo del pensamiento analítico y sistémico: guía práctica para aprender a programar por competencias', 2012, 'Politécnico Colombiano Jaime Isaza Cadavid', 'Colombia', NULL, '2'); -- 52

-- ============================================================
--   BIBLIOGRAFÍAS — INTRODUCCIÓN A LA ING. EN COMPUTACIÓN (materia_id = 5)
--   Básica: ids 53-69  |  Compl. libro: id 70  |  Webs: ids 71-92
-- ============================================================
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, ciudad, pais, temas_recomendados) VALUES
(5, 'basica', 'libro', 'Introducción a la ciencia de la computación, De la manipulación de datos a la teoría de la computación', 2003, 'Thomson',            'México',    NULL,        '2,4'),  -- 53
(5, 'basica', 'libro', 'Introducción a la computación',                                                      2008, 'Cengage Learning',     'México',       NULL,        '2,4'),   -- 54
(5, 'basica', 'libro', 'Engineering Ethics: Concepts and Cases',                                             2014, 'Wadsworth Publishing', NULL,           'USA',       '1,5'),   -- 55
(5, 'basica', 'libro', 'Anatomía de la organización',                                                        1997, 'Ediciones Machi',      'Argentina',    NULL,        '1,5'),   -- 56
(5, 'basica', 'libro', 'El pequeño manual de las grandes teorías de la administración',                      2015, 'Trillas',              'México',       NULL,        '1,5'),   -- 57
(5, 'basica', 'libro', 'Conceptos de computación',                                                           2008, 'Cengage Learning',     NULL,           'USA',       '2,4'),   -- 58
(5, 'basica', 'libro', 'Office 2010: todo práctica',                                                         2010, 'Alfa Omega',           'México',       NULL,        '2'),     -- 59
(5, 'basica', 'libro', 'Habilidades de dirección',                                                           2003, 'Thompson',             NULL,           'España',    '2,5'),   -- 60
(5, 'basica', 'libro', 'Linux Guía práctica',                                                                2009, 'AlfaOmega',            NULL,           'España',    '3'),     -- 61
(5, 'basica', 'libro', 'Ubuntu Linux',                                                                       2010, 'RA-MA',                NULL,           'España',    '3'),     -- 62
(5, 'basica', 'libro', 'Teorías de la Organización',                                                         1977, 'Trillas',              'México',       NULL,        '1,5'),   -- 63
(5, 'basica', 'libro', 'Manual de administración de Linux',                                                  2007, 'Mc Graw Hill',         NULL,           'España',    '3'),     -- 64
(5, 'basica', 'libro', 'Computers concepts and uses',                                                        1988, 'Prentice Hall',        NULL,           'USA',       '2,4'),   -- 65
(5, 'basica', 'libro', 'Derecho Informático',                                                                2004, 'McGraw-Hill',          'México',       NULL,        '5'),     -- 66
(5, 'basica', 'libro', 'Plan de vida y carrera',                                                             2011, 'Trillas',              'México',       NULL,        '1'),     -- 67
(5, 'basica', 'libro', 'The secret guide to computers',                                                      1993, NULL,                   NULL,           'USA',       '2,5'),   -- 68
(5, 'basica', 'libro', 'Todo sobre Linux',                                                                   1999, 'Data Becker',          NULL,           'España',    '3'),     -- 69
(5, 'complementaria', 'libro', 'Ingeniería, Sociedad y Medio Ambiente',                                      1994, 'Limusa',               'México',       NULL,        '4,5');   -- 70

-- Fuentes electrónicas (webs) de Introducción a la Ingeniería
INSERT INTO bibliografias (materia_id, tipo, tipo_recurso, titulo, anio, editorial, url, temas_recomendados) VALUES
(5, 'complementaria', 'web', 'Documentación de Photoshop',     2017, 'Adobe',     'https://helpx.adobe.com/support/photoshop.html',                                                          '2'),  -- 71
(5, 'complementaria', 'web', 'Guías de Trello',                2017, 'Atlassian', 'https://trello.com/guide',                                                                                '2'),  -- 72
(5, 'complementaria', 'web', 'Documentación de Audacity',      2017, 'Audacity',  'https://www.audacityteam.org/help/documentation/',                                                        '2'),  -- 73
(5, 'complementaria', 'web', 'Manuales de Brackets',           2017, 'Brackets',  'http://brackets.io/',                                                                                     '2'),  -- 74
(5, 'complementaria', 'web', 'Manuales de Chamilo',            2017, 'Chamilo',   'https://chamilo.org/es/chamilo-lms/#documentacion',                                                       '2'),  -- 75
(5, 'complementaria', 'web', 'Documentación de Dropbox',       2017, 'Dropbox',   'https://www.dropbox.com/es/help',                                                                         '2'),  -- 76
(5, 'complementaria', 'web', 'Documentación de Facebook',      2017, 'Facebook',  'https://www.facebook.com/help/',                                                                          '2'),  -- 77
(5, 'complementaria', 'web', 'Documentación de GIT',           2017, 'Git',       'https://git-scm.com/book/es/v1/Empezando',                                                                '2'),  -- 78
(5, 'complementaria', 'web', 'Documentación de GitHub',        2017, 'GitHub',    'https://guides.github.com/activities/hello-world/',                                                       '2'),  -- 79
(5, 'complementaria', 'web', 'Manuales de Atom',               2017, 'GitHub',    'https://atom.io/docs',                                                                                    '2'),  -- 80
(5, 'complementaria', 'web', 'Documentación de GMAIL',         2017, 'Google',    'https://gsuite.google.es/learning-center/products/gmail/get-started/',                                    '2'),  -- 81
(5, 'complementaria', 'web', 'Documentación de Google Chrome', 2017, 'Google',    'https://support.google.com/chrome/?hl=es#topic=7439538',                                                  '2'),  -- 82
(5, 'complementaria', 'web', 'Documentación de Google Docs',   2017, 'Google',    'https://gsuite.google.com/learning-center/products/docs/get-started/',                                    '2'),  -- 83
(5, 'complementaria', 'web', 'Documentación de Google Drive',  2017, 'Google',    'https://support.google.com/drive#topic=14940',                                                            '2'),  -- 84
(5, 'complementaria', 'web', 'Documentación de Mercurial',     2017, 'Mercurial', 'https://www.mercurial-scm.org/wiki/SpanishTutorial',                                                      '2'),  -- 85
(5, 'complementaria', 'web', 'Documentación de Outlook',       2017, 'Microsoft', 'https://support.office.com/es-es/article/aprendizaje-de-outlook-8a5b816d9052-4190-a5eb-494512343cca',    '2'),  -- 86
(5, 'complementaria', 'web', 'Documentación de Wunderlist',    2017, 'Microsoft', 'https://6wunderkinder.desk.com/',                                                                         '2'),  -- 87
(5, 'complementaria', 'web', 'Manuales de Moodle',             2017, 'Moodle',    'https://docs.moodle.org/all/es/Manuales_de_Moodle',                                                       '2'),  -- 88
(5, 'complementaria', 'web', 'Documentación de Firefox',       2017, 'Mozilla',   'https://support.mozilla.org/es/kb/guia-basica-de-firefox-una-introduccion-lasprinci',                     '2'),  -- 89
(5, 'complementaria', 'web', 'Documentación de Opera Browser', 2017, 'Oracle',    'http://www.opera.com/help/tutorials/',                                                                    '2'),  -- 90
(5, 'complementaria', 'web', 'Documentación de Twitter',       2017, 'Twitter',   'https://help.twitter.com/es',                                                                             '2'),  -- 91
(5, 'complementaria', 'web', 'Documentación de Virtual Dub',   2017, 'VirtualDub','http://www.virtualdub.org/virtualdub_docs.html',                                                          '2');  -- 92

-- ============================================================
--   RELACIÓN AUTORES ↔ BIBLIOGRAFÍAS
-- ============================================================

-- ── ÁLGEBRA (bib 13-29) ─────────────────────────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
(13, 15, 1),  -- Cárdenas    → Algebra superior (Trillas)
(14, 16, 1),  -- De Oteyza   → Álgebra (Pearson)
(15, 17, 1),  -- Fuller      → Álgebra Elemental
(16,  2, 1),  -- Gigena      → Álgebra y geometría (reutiliza id=2)
(17, 18, 1),  -- Hall        → Álgebra superior (Hispanoamérica)
(18,  4, 1),  -- Kaufmann    → Álgebra intermedia (reutiliza id=4)
(19, 19, 1),  -- Lehmann     → Álgebra (Limusa)
(20, 20, 1),  -- Lipschutz   → Teoría y problemas de conjuntos
(21, 21, 1),  -- Mariscal    → Vive la Probabilidad
(22, 22, 1),  -- Ross        → Matemáticas discretas
(23, 23, 1),  -- Sahai       → Algebra (Oxford) autor 1
(23, 24, 2),  -- Bist        → Algebra (Oxford) autor 2
(24,  7, 1),  -- Sullivan    → Algebra and trigonometry (reutiliza id=7)
(25,  8, 1),  -- Swokowski   → Álgebra y trigonometría (reutiliza id=8)
(26, 25, 1),  -- Zill        → Algebra and trigonometry (Cengage) autor 1
(26, 26, 2),  -- Dewar       → Algebra and trigonometry (Cengage) autor 2
(27, 11, 1),  -- Dauben      → Writing the History (reutiliza id=11)
(27, 12, 2),  -- Scriba      → Writing the History (reutiliza id=12)
(28, 13, 1),  -- Emmer       → Imagine Math (reutiliza id=13)
(29, 14, 1);  -- Gindikin    → Tales of Mathematicians (reutiliza id=14)

-- ── CÁLCULO DIFERENCIAL E INTEGRAL (bib 30-40) ──────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
(30, 27, 1),  -- Colley      → Cálculo Vectorial
(31,  3, 1),  -- Granville   → Cálculo Diferencial e Integral (reutiliza id=3)
(32, 28, 1),  -- Lax         → Calculus with Applications
(33, 29, 1),  -- López       → Cálculo diferencial una variable
(34, 30, 1),  -- Mena        → Introducción al Cálculo Vectorial
(35, 31, 1),  -- Stewart     → Cálculo diferencial e integral
(36,  9, 1),  -- Taylor      → Fundamentos de cálculo avanzado (reutiliza id=9)
(36, 10, 2),  -- Mann        → Fundamentos de cálculo avanzado (reutiliza id=10)
(37, 32, 1),  -- Thomas      → Cálculo: una variable
(38, 11, 1),  -- Dauben      → Writing the History (reutiliza id=11)
(38, 12, 2),  -- Scriba      → Writing the History (reutiliza id=12)
(39, 13, 1),  -- Emmer       → Imagine Math (reutiliza id=13)
(40, 14, 1);  -- Gindikin    → Tales of Mathematicians (reutiliza id=14)

-- ── COMPUTADORAS Y PROGRAMACIÓN (bib 41-52) ─────────────────
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
(41, 33, 1),  -- Deitel      → Como programar en C++
(42, 34, 1),  -- Kernighan   → El lenguaje de programación C
(43, 35, 1),  -- Méndez      → Diseño de algoritmos
(44, 36, 1),  -- Peñaloza    → Fundamentos de programación
(45, 37, 1),  -- Schildt     → Ansi C a su alcance
(46, 38, 1),  -- Sznajdleder → Programación estructurada a fondo
(47, 39, 1),  -- Wirth       → Algorithms and data structures
(48, 40, 1),  -- Alvarado    → 100 problemas resueltos
(49, 41, 1),  -- Long        → Introducción a las Computadoras
(50, 42, 1),  -- Pradip      → Computer fundamentals
(51, 43, 1),  -- Restrepo    → De dos a Windows
(52, 44, 1);  -- Zapata      → Desarrollo del pensamiento analítico

-- ── INTRODUCCIÓN A LA INGENIERÍA EN COMPUTACIÓN (bib 53-70) ─
INSERT INTO bibliografia_autores (bibliografia_id, autor_id, orden) VALUES
(53, 45, 1),  -- Forouzan       → Introducción a la ciencia de la computación
(54, 46, 1),  -- Gómez de Silva → Introducción a la computación
(55, 47, 1),  -- Harris         → Engineering Ethics
(56, 48, 1),  -- Lazzati        → Anatomía de la organización
(57, 49, 1),  -- Mc Grath       → El pequeño manual...
(58, 50, 1),  -- Parsons        → Conceptos de computación
(59, 51, 1),  -- Peña           → Office 2010 autor 1
(59, 52, 2),  -- Pérez          → Office 2010 autor 2
(60, 53, 1),  -- Rees           → Habilidades de dirección
(61, 54, 1),  -- Sánchez        → Linux Guía práctica autor 1
(61, 55, 2),  -- García         → Linux Guía práctica autor 2
(62, 56, 1),  -- Serrat         → Ubuntu Linux
(63, 57, 1),  -- Sexton         → Teorías de la Organización
(64, 58, 1),  -- Shah           → Manual de administración de Linux
(65, 59, 1),  -- Sumner         → Computers concepts and uses
(66, 60, 1),  -- Tellez         → Derecho Informático
(67, 61, 1),  -- Tovar          → Plan de vida y carrera
(68, 62, 1),  -- Walter         → The secret guide to computers
(69, 63, 1),  -- Wielsch        → Todo sobre Linux
(70, 64, 1);  -- Viqueira       → Ingeniería, Sociedad y Medio Ambiente
-- Nota: bib 71-92 (webs) no tienen autor registrado en la tabla autores.

-- ============================================================
--   VERIFICACIÓN FINAL
-- ============================================================
SELECT
    m.nombre                                  AS materia,
    COUNT(b.id)                               AS total_refs,
    SUM(b.tipo = 'basica')                    AS basicas,
    SUM(b.tipo = 'complementaria')            AS complementarias,
    SUM(b.tipo_recurso = 'web')               AS webs
FROM   materias m
LEFT JOIN bibliografias b ON b.materia_id = m.id
WHERE  m.semestre_id = 1
GROUP  BY m.id, m.nombre
ORDER  BY m.nombre;