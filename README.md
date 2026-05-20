# 📚 RefICO — Sistema de Referencias Bibliográficas
### FES Aragón · UNAM · Ingeniería en Computación

---

> CRUD de referencias bibliográficas con generación automática de citas en **APA 7, IEEE, MLA y BibTeX**, organizado por semestre, materia y tipo de recurso.

---

## 📋 Tabla de contenido

1. [Descripción general](#descripción-general)
2. [Requisitos del sistema](#requisitos-del-sistema)
3. [Instalación](#instalación)
4. [Estructura del proyecto](#estructura-del-proyecto)
5. [Base de datos](#base-de-datos)
6. [API REST](#api-rest)
7. [Interfaz web](#interfaz-web)
8. [Formatos de cita soportados](#formatos-de-cita-soportados)
9. [Grupos y semestres](#grupos-y-semestres)
10. [Equipo](#equipo)

---

## Descripción general

**RefICO** es una aplicación web que permite a estudiantes y profesoras de Ingeniería en Computación (ICO) gestionar la bibliografía del plan de estudios. Nació a partir de la necesidad de consultar literatura formal afín a las Ciencias e Ingeniería en Computación y generar los respectivos formatos de cita académica.

**Funcionalidades principales:**

- CRUD completo de bibliografías (básica y complementaria)
- CRUD de materias y semestres
- Búsqueda de autores: escribe "Shannon" y obtienes todas sus obras
- Generación automática de citas en APA 7, IEEE, MLA y BibTeX
- Filtrado por semestre, materia, tipo de recurso y grupo
- Búsqueda avanzada multi-criterio (título, autor, editorial, materia, tipo)
- Relación N:M entre bibliografías y autores con orden de aparición en la cita

---

## Requisitos del sistema

| Componente | Versión mínima |
|---|---|
| PHP | 8.1+ |
| MySQL / MariaDB | 8.0+ / 10.5+ |
| Servidor web | Apache 2.4+ o Nginx 1.18+ |
| Navegador | Cualquier navegador moderno (Chrome, Firefox, Edge, Safari) |

> No se requieren dependencias de JavaScript externas. El frontend es HTML/CSS/JS puro.

---

## Instalación

### 1. Clonar o copiar el proyecto

```bash
git clone <url-del-repo> referencias-ico
cd referencias-ico
```

### 2. Crear la base de datos

```bash
mysql -u root -p < database.sql
```

Esto crea la base de datos `referencias_db`, todas las tablas y los datos de ejemplo (Geometría Analítica con sus 12 bibliografías y 14 autores).

### 3. Configurar la conexión

Editar `includes/config.php`:

```php
return [
    'db' => [
        'host'     => '127.0.0.1',
        'port'     => 3306,
        'database' => 'referencias_db',
        'username' => 'root',
        'password' => 'tu_contraseña',   // ← cambia aquí
        'charset'  => 'utf8mb4',
    ],
    'debug' => false,   // ← false en producción
];
```

### 4. Colocar en el servidor web

Copia la carpeta al directorio raíz de tu servidor:

```bash
# Apache / XAMPP / WAMP
cp -r referencias-ico /var/www/html/
# o en Windows: copiar a C:\xampp\htdocs\referencias-ico

# Nginx: ajustar document root en la configuración del virtual host
```

### 5. Abrir en el navegador

```
http://localhost/referencias-ico/
```

### 6. (Opcional) Probar el backend en terminal

```bash
php test_citations.php
```

---

## Estructura del proyecto

```
BIBLIOGRAFIA
│
├── index.html                  ← Interfaz web (SPA, un solo archivo)
│
├── api/                        ← Endpoints REST
│   ├── autores.php             ← GET autores, búsqueda por apellido
│   ├── bibliografias.php       ← CRUD completo de bibliografías
│   ├── citas.php               ← Generación de citas por id/materia/autor
│   ├── materias.php            ← CRUD de materias
│   └── semestres.php           ← Catálogo de semestres (GET)
│
├── includes/
│   ├── db.php                  ← Singleton de conexión PDO + helpers JSON
│   ├── config.php              ← Configuración BD y entorno
│   └── formatter.php          ← Clase CitationFormatter (APA, IEEE, MLA, BibTeX)
│
├── database.sql                ← Script completo: tablas + datos de ejemplo
└── test_citations.php          ← Script CLI de prueba del formateador
```

---

## Base de datos

### Modelo Entidad-Relación (conceptual)

```
SEMESTRES ──< MATERIAS ──< BIBLIOGRAFIAS >──< AUTORES
                                ↕
                      BIBLIOGRAFIA_AUTORES
                        (orden del autor)
```

### Tablas

#### `semestres`
| Campo | Tipo | Descripción |
|---|---|---|
| id | INT PK | Clave primaria |
| numero | INT NULL | 1-9; NULL = Optativa |
| nombre | VARCHAR(50) | "Primer Semestre", etc. |

#### `materias`
| Campo | Tipo | Descripción |
|---|---|---|
| id | INT PK | Clave primaria |
| nombre | VARCHAR(200) | Nombre de la asignatura |
| clave | VARCHAR(20) | Clave del plan |
| creditos | INT | Número de créditos |
| semestre_id | INT FK | → semestres.id |
| area | VARCHAR(100) | Matemáticas, Programación… |
| modalidad | VARCHAR(50) | Curso, Taller, Seminario |
| tipo | VARCHAR(50) | Teórico, Práctico, T/P |
| caracter | VARCHAR(20) | Obligatorio / Optativo |
| objetivo | TEXT | Objetivo de la asignatura |
| asignatura_antecedente | VARCHAR(200) | — |
| asignatura_subsecuente | VARCHAR(200) | — |

#### `autores`
| Campo | Tipo | Descripción |
|---|---|---|
| id | INT PK | Clave primaria |
| apellidos | VARCHAR(150) | Apellido(s) del autor |
| inicial | VARCHAR(20) | "P." o "A. V." |
| nombre | VARCHAR(100) | Nombre completo (opcional) |

Se separan en tabla propia para soportar la búsqueda "Shannon → todas sus obras".

#### `bibliografias`
| Campo | Tipo | Descripción |
|---|---|---|
| id | INT PK | Clave primaria |
| materia_id | INT FK | → materias.id (CASCADE DELETE) |
| tipo | ENUM | basica / complementaria |
| tipo_recurso | ENUM | libro / articulo / capitulo / tesis / web / otro |
| titulo | VARCHAR(500) | Título principal |
| subtitulo | VARCHAR(500) | Subtítulo (opcional) |
| anio | INT | Año de publicación |
| editorial | VARCHAR(200) | — |
| ciudad | VARCHAR(100) | — |
| pais | VARCHAR(100) | — |
| edicion | VARCHAR(50) | — |
| revista | VARCHAR(200) | Solo artículos |
| volumen | VARCHAR(20) | Solo artículos |
| numero_revista | VARCHAR(20) | Solo artículos |
| paginas | VARCHAR(50) | — |
| doi | VARCHAR(200) | — |
| isbn | VARCHAR(50) | — |
| issn | VARCHAR(20) | — |
| url | VARCHAR(500) | — |
| fecha_consulta | DATE | Para recursos web |
| temas_recomendados | VARCHAR(100) | Ej: "1,2,3,4,5" |
| notas | TEXT | Notas internas |

#### `bibliografia_autores` (N:M)
| Campo | Tipo | Descripción |
|---|---|---|
| bibliografia_id | INT FK | → bibliografias.id |
| autor_id | INT FK | → autores.id |
| orden | INT | 1er autor, 2do autor… |

### Normalización

El esquema está en **3FN**:

- **1FN**: todos los atributos son atómicos; la relación N:M autor-bibliografía está en tabla separada con el campo `orden`.
- **2FN**: no hay dependencias parciales; cada tabla tiene PK simple o compuesta correctamente definida.
- **3FN**: no hay dependencias transitivas; `materia_nombre` y `semestre_nombre` se obtienen por JOIN y no se almacenan en `bibliografias`.

---

## API REST

Todas las rutas devuelven `Content-Type: application/json`.

### Bibliografías

| Método | URL | Descripción |
|---|---|---|
| GET | `/api/bibliografias.php` | Lista todas (filtros: `?q=`, `?materia_id=`, `?tipo=`) |
| GET | `/api/bibliografias.php?id=1` | Una bibliografía con sus autores |
| POST | `/api/bibliografias.php` | Crear (body JSON, incluye `autores[]`) |
| PUT | `/api/bibliografias.php?id=1` | Actualizar |
| DELETE | `/api/bibliografias.php?id=1` | Borrar |

### Autores

| Método | URL | Descripción |
|---|---|---|
| GET | `/api/autores.php` | Lista todos |
| GET | `/api/autores.php?q=Shannon` | Busca por apellido |
| GET | `/api/autores.php?id=3` | Un autor + todas sus obras |

### Materias

| Método | URL | Descripción |
|---|---|---|
| GET | `/api/materias.php` | Lista (filtro: `?semestre_id=`) |
| GET | `/api/materias.php?id=1` | Una materia + sus bibliografías |
| POST | `/api/materias.php` | Crear |
| PUT | `/api/materias.php?id=1` | Actualizar |
| DELETE | `/api/materias.php?id=1` | Borrar (CASCADE sobre bibliografías) |

### Semestres

| Método | URL | Descripción |
|---|---|---|
| GET | `/api/semestres.php` | Lista todos (catálogo) |

### Citas

| Método | URL | Descripción |
|---|---|---|
| GET | `/api/citas.php?id=5` | Citas de una bibliografía (todos los formatos) |
| GET | `/api/citas.php?id=5&formato=apa` | Solo APA |
| GET | `/api/citas.php?materia_id=1` | Todas las citas de una materia |
| GET | `/api/citas.php?autor_id=8` | Todas las citas de un autor |

**Formatos válidos:** `apa` · `ieee` · `mla` · `bibtex` · `all` (default)

#### Ejemplo de respuesta `/api/citas.php?id=1`

```json
{
  "id": 1,
  "titulo": "Geometry and trigonometry",
  "citas": {
    "apa":    "Barry, P. (2001). Geometry and trigonometry. Woodhead Publishing.",
    "ieee":   "[1] P. Barry, Geometry and trigonometry. Irlanda: Woodhead Publishing, 2001.",
    "mla":    "Barry, P. Geometry and Trigonometry. Woodhead Publishing, 2001.",
    "bibtex": "@book{Barry2001,\n  author    = {Barry, P.},\n  title     = {Geometry and trigonometry},\n  publisher = {Woodhead Publishing},\n  year      = {2001}\n}"
  }
}
```

---

## Interfaz web

La interfaz es una **SPA (Single Page Application)** en HTML/CSS/JS puro, sin frameworks externos. Funciona en cualquier servidor web sin compilación.

### Secciones

| Sección | Descripción |
|---|---|
| 🏠 Inicio | Panel de bienvenida con estadísticas globales |
| 📖 Bibliografías | Tabla CRUD con búsqueda y filtros |
| ✍️ Autores | Galería de autores; clic → todas sus obras |
| 🎓 Materias | Tabla CRUD de asignaturas |
| 📅 Semestres | Mosaico de semestres; clic → filtra materias |
| 🔍 Búsqueda avanzada | Filtro multi-criterio |
| 📝 Generador de citas | Por materia o por ID; pestañas APA/IEEE/MLA/BibTeX |

### Formulario de referencia

Incluye campos para todos los tipos de recurso:
- Libros (editorial, edición, ciudad, país, ISBN)
- Artículos de revista (revista, volumen, número, páginas, ISSN, DOI)
- Recursos web (URL, fecha de consulta)
- Tesis y otros

Los autores se agregan dinámicamente (1 o más), con campos para apellidos, inicial y nombre completo.

---

## Formatos de cita soportados

### APA 7
```
Apellidos, I. (Año). Título del libro. Editorial.
```

### IEEE
```
[N] I. Apellidos, Título del libro. Ciudad: Editorial, Año.
```

### MLA
```
Apellidos, I. Título del Libro. Editorial, Año.
```

### BibTeX
```bibtex
@book{ClaveÚnica,
  author    = {Apellidos, I.},
  title     = {Título del libro},
  publisher = {Editorial},
  year      = {Año}
}
```

---

## Grupos y semestres

| Grupo | Semestres | Enfoque |
|---|---|---|
| **2808** | 1° – 3° | Fundamentos: matemáticas, programación básica |

---

## Equipo

**Número de equipo:** 13

**Integrantes** (orden alfabético por apellido):

| Apellido | Nombre |
|---|---|---|
| Chávez Ramírez | Camila Simone |
| Padilla Torres| Michelle Denise|
| Villagomez Venegas| Leslie Naomi |

> Proyecto para la asignatura de **Bases de Datos 2** · Ingeniería en Computación · FES Aragón UNAM

---