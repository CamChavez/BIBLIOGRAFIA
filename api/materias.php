<?php
/**
 * API CRUD de materias.
 *
 * Rutas:
 *   GET    /api/materias.php           → lista todas las materias
 *   GET    /api/materias.php?id=1      → trae UNA materia + sus bibliografías
 *   GET    /api/materias.php?semestre_id=1  → filtra por semestre
 *   POST   /api/materias.php           → crea una materia (body JSON)
 *   PUT    /api/materias.php?id=1      → actualiza la materia 1
 *   DELETE /api/materias.php?id=1      → borra la materia 1 (y sus bibliografías por CASCADE)
 */

declare(strict_types=1);

require_once __DIR__ . '/../includes/db.php';

// Manejo del preflight CORS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    jsonResponse(['ok' => true]);
}

$method = $_SERVER['REQUEST_METHOD'];
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;
$pdo    = DB::conn();

try {
    switch ($method) {

        // ───────────────────────────────────────
        //   GET  → listar o traer una sola
        // ───────────────────────────────────────
        case 'GET':
            if ($id) {
                $m = $pdo->prepare("
                    SELECT m.*, s.numero AS semestre_numero, s.nombre AS semestre_nombre
                    FROM   materias m
                    JOIN   semestres s ON s.id = m.semestre_id
                    WHERE  m.id = ?
                ");
                $m->execute([$id]);
                $materia = $m->fetch();
                if (!$materia) jsonResponse(['error' => 'Materia no encontrada'], 404);

                // También traemos sus bibliografías
                $bib = $pdo->prepare("
                    SELECT b.*,
                           GROUP_CONCAT(
                             CONCAT(a.apellidos, '|', a.inicial, '|', COALESCE(a.nombre,''))
                             ORDER BY ba.orden SEPARATOR '||'
                           ) AS autores_raw
                    FROM   bibliografias b
                    LEFT JOIN bibliografia_autores ba ON ba.bibliografia_id = b.id
                    LEFT JOIN autores a               ON a.id = ba.autor_id
                    WHERE  b.materia_id = ?
                    GROUP BY b.id
                    ORDER BY b.tipo, b.anio, b.titulo
                ");
                $bib->execute([$id]);
                $bibs = $bib->fetchAll();
                foreach ($bibs as &$row) {
                    $row['autores'] = parseAutoresRaw($row['autores_raw'] ?? '');
                    unset($row['autores_raw']);
                }
                $materia['bibliografias'] = $bibs;
                jsonResponse($materia);
            }

            // Listado general (opcionalmente filtrado por semestre)
            $semId = isset($_GET['semestre_id']) ? (int)$_GET['semestre_id'] : null;
            if ($semId) {
                $stmt = $pdo->prepare("
                    SELECT m.id, m.nombre, m.creditos, m.area, m.caracter,
                           s.numero AS semestre_numero, s.nombre AS semestre_nombre,
                           (SELECT COUNT(*) FROM bibliografias b WHERE b.materia_id = m.id) AS num_bibliografias
                    FROM   materias m
                    JOIN   semestres s ON s.id = m.semestre_id
                    WHERE  m.semestre_id = ?
                    ORDER  BY m.nombre
                ");
                $stmt->execute([$semId]);
            } else {
                $stmt = $pdo->query("
                    SELECT m.id, m.nombre, m.creditos, m.area, m.caracter,
                           s.numero AS semestre_numero, s.nombre AS semestre_nombre,
                           (SELECT COUNT(*) FROM bibliografias b WHERE b.materia_id = m.id) AS num_bibliografias
                    FROM   materias m
                    JOIN   semestres s ON s.id = m.semestre_id
                    ORDER  BY s.numero IS NULL, s.numero, m.nombre
                ");
            }
            jsonResponse($stmt->fetchAll());
            break;

        // ───────────────────────────────────────
        //   POST → crear
        // ───────────────────────────────────────
        case 'POST':
            $d = readJsonBody();
            $required = ['nombre', 'semestre_id'];
            foreach ($required as $f) {
                if (empty($d[$f])) jsonResponse(['error' => "Campo obligatorio: {$f}"], 400);
            }
            $stmt = $pdo->prepare("
                INSERT INTO materias
                    (nombre, clave, creditos, semestre_id, area, modalidad, tipo,
                     caracter, objetivo, asignatura_antecedente, asignatura_subsecuente)
                VALUES
                    (:nombre, :clave, :creditos, :semestre_id, :area, :modalidad, :tipo,
                     :caracter, :objetivo, :ant, :sub)
            ");
            $stmt->execute([
                ':nombre'     => $d['nombre'],
                ':clave'      => $d['clave']     ?? null,
                ':creditos'   => isset($d['creditos']) ? (int)$d['creditos'] : null,
                ':semestre_id'=> (int)$d['semestre_id'],
                ':area'       => $d['area']      ?? null,
                ':modalidad'  => $d['modalidad'] ?? null,
                ':tipo'       => $d['tipo']      ?? null,
                ':caracter'   => $d['caracter']  ?? null,
                ':objetivo'   => $d['objetivo']  ?? null,
                ':ant'        => $d['asignatura_antecedente'] ?? null,
                ':sub'        => $d['asignatura_subsecuente'] ?? null,
            ]);
            jsonResponse(['ok' => true, 'id' => (int)$pdo->lastInsertId()], 201);
            break;

        // ───────────────────────────────────────
        //   PUT → actualizar
        // ───────────────────────────────────────
        case 'PUT':
            if (!$id) jsonResponse(['error' => 'Falta el id'], 400);
            $d = readJsonBody();
            $stmt = $pdo->prepare("
                UPDATE materias SET
                    nombre = :nombre, clave = :clave, creditos = :creditos,
                    semestre_id = :semestre_id, area = :area,
                    modalidad = :modalidad, tipo = :tipo, caracter = :caracter,
                    objetivo = :objetivo,
                    asignatura_antecedente = :ant,
                    asignatura_subsecuente = :sub
                WHERE id = :id
            ");
            $stmt->execute([
                ':nombre'     => $d['nombre']     ?? '',
                ':clave'      => $d['clave']      ?? null,
                ':creditos'   => isset($d['creditos']) ? (int)$d['creditos'] : null,
                ':semestre_id'=> (int)($d['semestre_id'] ?? 0),
                ':area'       => $d['area']       ?? null,
                ':modalidad'  => $d['modalidad']  ?? null,
                ':tipo'       => $d['tipo']       ?? null,
                ':caracter'   => $d['caracter']   ?? null,
                ':objetivo'   => $d['objetivo']   ?? null,
                ':ant'        => $d['asignatura_antecedente'] ?? null,
                ':sub'        => $d['asignatura_subsecuente'] ?? null,
                ':id'         => $id,
            ]);
            jsonResponse(['ok' => true, 'updated' => $stmt->rowCount()]);
            break;

        // ───────────────────────────────────────
        //   DELETE
        // ───────────────────────────────────────
        case 'DELETE':
            if (!$id) jsonResponse(['error' => 'Falta el id'], 400);
            $stmt = $pdo->prepare('DELETE FROM materias WHERE id = ?');
            $stmt->execute([$id]);
            jsonResponse(['ok' => true, 'deleted' => $stmt->rowCount()]);
            break;

        default:
            jsonResponse(['error' => 'Método no permitido'], 405);
    }
} catch (Throwable $e) {
    jsonResponse(['error' => 'Error del servidor', 'detalle' => $e->getMessage()], 500);
}

// ─────────────────────────────────────────────────────────────────
function parseAutoresRaw(?string $raw): array
{
    if (!$raw) return [];
    $autores = [];
    foreach (explode('||', $raw) as $i => $piece) {
        [$apellidos, $inicial, $nombre] = array_pad(explode('|', $piece), 3, '');
        $autores[] = [
            'apellidos' => $apellidos,
            'inicial'   => $inicial,
            'nombre'    => $nombre !== '' ? $nombre : null,
            'orden'     => $i + 1,
        ];
    }
    return $autores;
}