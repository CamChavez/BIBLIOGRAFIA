-- ============================================================
--   OPTATIVAS — Ingeniería en Computación · FES Aragón UNAM
--   Adaptado a referencias_db (MySQL)
-- ============================================================

USE referencias_db;

-- ============================================================
--   TABLA OPTATIVAS
-- ============================================================
CREATE TABLE IF NOT EXISTS optativas (
    id                      INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
    clave                   CHAR(4)         NOT NULL UNIQUE,
    asignatura              VARCHAR(100)    NOT NULL,
    creditos                INT             NOT NULL,
    semestre_sugerido       INT,
    area                    VARCHAR(100),
    modulo_salida           VARCHAR(100),
    tipo                    VARCHAR(20)     DEFAULT 'Teórico',
    caracter                VARCHAR(20)     DEFAULT 'Optativo',
    horas_teoria_semana     DECIMAL(4,1),
    horas_practica_semana   DECIMAL(4,1),
    horas_teoria_semestre   DECIMAL(5,1),
    horas_practica_semestre DECIMAL(5,1)
);

-- ============================================================
--   TABLA TEMAS POR OPTATIVA
-- ============================================================
CREATE TABLE IF NOT EXISTS optativa_temas (
    id              INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
    clave_optativa  CHAR(4)         NOT NULL,
    numero_tema     INT             NOT NULL,
    nombre_tema     VARCHAR(200)    NOT NULL,
    horas_teoria    DECIMAL(4,1)    DEFAULT 0.0,
    horas_practica  DECIMAL(4,1)    DEFAULT 0.0,
    CONSTRAINT fk_optativa_temas
        FOREIGN KEY (clave_optativa) REFERENCES optativas(clave)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
--   INSERT OPTATIVAS
-- ============================================================
INSERT INTO optativas (
    clave, asignatura, creditos, semestre_sugerido,
    area, modulo_salida,
    tipo, caracter,
    horas_teoria_semana, horas_practica_semana,
    horas_teoria_semestre, horas_practica_semestre
) VALUES
('0001', 'Adquisición de Datos',                  8, 7, 'Arquitectura de Computadoras',  'Adquisición y Procesamiento de Señales',  'Teórico', 'Optativo', 4.0, 0.0, 64.0, 0.0),
('0005', 'Modelado y Simulación',                 8, 7, 'Interacción Hombre-Máquina',    'Cómputo Gráfico',                         'Teórico', 'Optativo', 4.0, 0.0, 64.0, 0.0),
('0008', 'Administración de Sistemas Multiusuario',8,8, 'Redes',                         'Administración de Sistemas Computacionales','Teórico','Optativo', 4.0, 0.0, 64.0, 0.0),
('0010', 'Cómputo Distribuido y Paralelo',        8, 9, 'Arquitectura de Computadoras',  'Administración de Sistemas Computacionales','Teórico','Optativo', 4.0, 0.0, 64.0, 0.0),
('0013', 'Temas Especiales de Bases de Datos',    8, 9, 'Tratamiento de Información',    'Desarrollo de Software',                  'Teórico', 'Optativo', 4.0, 0.0, 64.0, 0.0),
('0018', 'Seminario de Ingeniería en Computación',8, 9, 'Variable',                      'Todos los módulos',                       'Teórico', 'Optativo', 4.0, 0.0, 64.0, 0.0),
('0115', 'Bioingeniería',                         8, 9, 'Interacción Hombre-Máquina',    'Adquisición y Procesamiento de Señales',  'Teórico', 'Optativo', 4.0, 0.0, 64.0, 0.0);

-- ============================================================
--   INSERT TEMAS
-- ============================================================

-- Adquisición de Datos (0001)
INSERT INTO optativa_temas (clave_optativa, numero_tema, nombre_tema, horas_teoria, horas_practica) VALUES
('0001', 1, 'Arquitectura General del Sistema de Instrumentación Virtual', 14.0, 0.0),
('0001', 2, 'Tecnologías para la Adquisición de Datos',                    14.0, 0.0),
('0001', 3, 'Manipulación y Procesamiento de Datos',                       12.0, 0.0),
('0001', 4, 'Diseño, Desarrollo e Integración de Instrumentos Virtuales',  12.0, 0.0),
('0001', 5, 'Aplicaciones',                                                12.0, 0.0);

-- Modelado y Simulación (0005)
INSERT INTO optativa_temas (clave_optativa, numero_tema, nombre_tema, horas_teoria, horas_practica) VALUES
('0005', 1, 'Fundamentos del Modelado',                     14.0, 0.0),
('0005', 2, 'Sistemas Físicos y su Modelado',               14.0, 0.0),
('0005', 3, 'Sistemas Biológicos y su Modelado',            12.0, 0.0),
('0005', 4, 'Sistemas Económicos y su Modelado',            12.0, 0.0),
('0005', 5, 'Factores a Considerar para Simular un Modelo', 12.0, 0.0);

-- Administración de Sistemas Multiusuario (0008)
INSERT INTO optativa_temas (clave_optativa, numero_tema, nombre_tema, horas_teoria, horas_practica) VALUES
('0008', 1, 'Centro de Datos Clásico (CDC)',    6.0, 0.0),
('0008', 2, 'Sistemas Operativos en Servidores',7.0, 0.0),
('0008', 3, 'Linux',                           18.0, 0.0),
('0008', 4, 'Windows',                         18.0, 0.0),
('0008', 5, 'Gestión de Recursos',             15.0, 0.0);

-- Cómputo Distribuido y Paralelo (0010)
INSERT INTO optativa_temas (clave_optativa, numero_tema, nombre_tema, horas_teoria, horas_practica) VALUES
('0010', 1, 'Introducción a la Programación en Paralelo', 8.0,  0.0),
('0010', 2, 'Procesos',                                  10.0,  0.0),
('0010', 3, 'Programación en Paralelo',                  15.0,  0.0),
('0010', 4, 'Particionamiento de Datos',                  8.0,  0.0),
('0010', 5, 'Particionamiento de Funciones',             15.0,  0.0),
('0010', 6, 'Herramientas',                               8.0,  0.0);

-- Temas Especiales de Bases de Datos (0013)
INSERT INTO optativa_temas (clave_optativa, numero_tema, nombre_tema, horas_teoria, horas_practica) VALUES
('0013', 1, 'Depende del Tema a Tratar', 64.0, 0.0);

-- Seminario de Ingeniería en Computación (0018)
INSERT INTO optativa_temas (clave_optativa, numero_tema, nombre_tema, horas_teoria, horas_practica) VALUES
('0018', 1, 'Depende del Tema a Tratar', 64.0, 0.0);

-- Bioingeniería (0115)
INSERT INTO optativa_temas (clave_optativa, numero_tema, nombre_tema, horas_teoria, horas_practica) VALUES
('0115', 1, 'Sistemas Fisiológicos de Control',       16.0, 0.0),
('0115', 2, 'Modelación Neuronal',                    16.0, 0.0),
('0115', 3, 'Fundamentos de Bio-Dispositivos',        16.0, 0.0),
('0115', 4, 'Tratamiento y Gestión de Datos Médicos', 16.0, 0.0);

-- ============================================================
--   VERIFICACIÓN FINAL
-- ============================================================
SELECT o.clave, o.asignatura, o.semestre_sugerido, o.area,
       COUNT(t.id) AS num_temas,
       SUM(t.horas_teoria) AS total_horas_teoria
FROM optativas o
LEFT JOIN optativa_temas t ON t.clave_optativa = o.clave
GROUP BY o.clave, o.asignatura, o.semestre_sugerido, o.area
ORDER BY o.clave;