-- ============================================================
--   OPTATIVAS → tabla materias (semestre_id = 10)
--   Corre DESPUÉS de database.sql, semestre1.sql, semestre2.sql
-- ============================================================

USE referencias_db;

-- Verificar que el semestre Optativa existe con id=10
-- Si tu id es diferente ajusta el semestre_id abajo
-- SELECT id, nombre FROM semestres WHERE numero IS NULL;

INSERT INTO materias
    (nombre, creditos, semestre_id, area, modalidad, tipo, caracter,
     objetivo, asignatura_antecedente, asignatura_subsecuente)
VALUES
(
    'Adquisición de Datos', 8,
    (SELECT id FROM semestres WHERE nombre = 'Optativa'),
    'Arquitectura de Computadoras', 'Curso', 'Teórico', 'Optativo',
    'Diseñar sistemas de instrumentación virtual para la adquisición, manipulación y procesamiento de datos mediante tecnologías de hardware y software.',
    NULL, NULL
),
(
    'Modelado y Simulación', 8,
    (SELECT id FROM semestres WHERE nombre = 'Optativa'),
    'Interacción Hombre-Máquina', 'Curso', 'Teórico', 'Optativo',
    'Comprender los fundamentos del modelado matemático y la simulación de sistemas físicos, biológicos y económicos.',
    NULL, NULL
),
(
    'Administración de Sistemas Multiusuario', 8,
    (SELECT id FROM semestres WHERE nombre = 'Optativa'),
    'Redes', 'Curso', 'Teórico', 'Optativo',
    'Administrar sistemas operativos multiusuario en entornos de servidores Linux y Windows, gestionando recursos de manera eficiente.',
    NULL, NULL
),
(
    'Cómputo Distribuido y Paralelo', 8,
    (SELECT id FROM semestres WHERE nombre = 'Optativa'),
    'Arquitectura de Computadoras', 'Curso', 'Teórico', 'Optativo',
    'Diseñar y desarrollar aplicaciones que aprovechen el procesamiento paralelo y distribuido para resolver problemas de alto rendimiento.',
    NULL, NULL
),
(
    'Temas Especiales de Bases de Datos', 8,
    (SELECT id FROM semestres WHERE nombre = 'Optativa'),
    'Tratamiento de Información', 'Curso', 'Teórico', 'Optativo',
    'Estudiar temas avanzados y emergentes en el área de bases de datos según las tendencias tecnológicas vigentes.',
    NULL, NULL
),
(
    'Seminario de Ingeniería en Computación', 8,
    (SELECT id FROM semestres WHERE nombre = 'Optativa'),
    'Variable', 'Seminario', 'Teórico', 'Optativo',
    'Analizar y discutir temas relevantes y de actualidad en el campo de la Ingeniería en Computación.',
    NULL, NULL
),
(
    'Bioingeniería', 8,
    (SELECT id FROM semestres WHERE nombre = 'Optativa'),
    'Interacción Hombre-Máquina', 'Curso', 'Teórico', 'Optativo',
    'Aplicar los principios de la ingeniería en computación al análisis, modelación y procesamiento de sistemas y datos biomédicos.',
    NULL, NULL
);

-- ============================================================
--   VERIFICACIÓN
-- ============================================================
SELECT m.id, m.nombre, m.creditos, m.area, s.nombre AS semestre
FROM   materias m
JOIN   semestres s ON s.id = m.semestre_id
WHERE  s.numero IS NULL
ORDER  BY m.nombre;