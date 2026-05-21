<?php
/**
 * API CRUD de bibliografías.
 *
 * Una bibliografía siempre pertenece a una materia y puede tener
 * 1+ autores (relación N:M via tabla bibliografia_autores).
 *
 * Rutas:
 *   GET    /api/bibliografias.php           → lista (opcional ?q=, ?materia_id=, ?tipo=)
 *   GET    /api/bibliografias.php?id=1      → trae una con sus autores
 *   POST   /api/bibliografias.php           → crea (body JSON con autores[])
 *   PUT    /api/bibliografias.php?id=1      → actualiza
 *   DELETE /api/bibliografias.php?id=1      → borra
 */

declare(strict_types=1);

require_once __DIR__ . '/../includes/db.php';

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') jsonResponse(['ok' => true]);

$method = $_SERVER['REQUEST_METHOD'];
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;
$pdo    = DB::conn();

try {
    switch ($method) {

        case 'GET':
            if ($id) {
                $row = fetchBibliografia($pdo, $id);
                if (!$row) jsonResponse(['error' => 'Bibliografía no encontrada'], 404);
                jsonResponse($row);
            }
            // Búsqueda libre + filtros
            $q          = trim($_GET['q'] ?? '');
            $materia_id = isset($_GET['materia_id']) ? (int)$_GET['materia_id'] : null;
            $tipo       = $_GET['tipo'] ?? null;

            $where  = [];
            $params = [];
            if ($q !== '') {
                $where[] = '(b.titulo LIKE :q1 OR a.apellidos LIKE :q2 OR b.editorial LIKE :q3)';
                $params[':q1'] = "%{$q}%";
                $params[':q2'] = "%{$q}%";
                $params[':q3'] = "%{$q}%";
            }
            if ($materia_id) {
                $where[] = 'b.materia_id = :mid';
                $params[':mid'] = $materia_id;
            }
            if ($tipo && in_array($tipo, ['basica', 'complementaria'], true)) {
                $where[] = 'b.tipo = :tipo';
                $params[':tipo'] = $tipo;
            }
            $whereSql = $where ? 'WHERE ' . implode(' AND ', $where) : '';

            $sql = "
                SELECT b.id, b.materia_id, b.tipo, b.tipo_recurso, b.titulo,
                       b.anio, b.editorial, b.ciudad, b.pais, b.revista,
                       b.temas_recomendados,
                       m.nombre AS materia_nombre,
                       GROUP_CONCAT(DISTINCT
                         CONCAT(a.apellidos, '|', a.inicial, '|', COALESCE(a.nombre,''))
                         ORDER BY ba.orden SEPARATOR '||'
                       ) AS autores_raw
                FROM   bibliografias b
                JOIN   materias m                   ON m.id = b.materia_id
                LEFT JOIN bibliografia_autores ba   ON ba.bibliografia_id = b.id
                LEFT JOIN autores a                 ON a.id = ba.autor_id
                {$whereSql}
                GROUP BY b.id
                ORDER BY b.anio DESC, b.titulo
            ";
            $stmt = $pdo->prepare($sql);
            $stmt->execute($params);
            $rows = $stmt->fetchAll();
            foreach ($rows as &$r) {
                $r['autores'] = parseAutoresRaw($r['autores_raw'] ?? '');
                unset($r['autores_raw']);
            }
            jsonResponse($rows);
            break;

        case 'POST':
            $d = readJsonBody();
            if (empty($d['titulo']) || empty($d['materia_id'])) {
                jsonResponse(['error' => 'titulo y materia_id son obligatorios'], 400);
            }

            $pdo->beginTransaction();

            $stmt = $pdo->prepare("
                INSERT INTO bibliografias
                    (materia_id, tipo, tipo_recurso, titulo, subtitulo, anio,
                     editorial, ciudad, pais, edicion,
                     revista, volumen, numero_revista, paginas,
                     doi, isbn, issn, url, fecha_consulta,
                     temas_recomendados, notas)
                VALUES
                    (:materia_id, :tipo, :tipo_recurso, :titulo, :subtitulo, :anio,
                     :editorial, :ciudad, :pais, :edicion,
                     :revista, :volumen, :numero_revista, :paginas,
                     :doi, :isbn, :issn, :url, :fecha_consulta,
                     :temas, :notas)
            ");
            $stmt->execute(bindBibliografia($d));
            $newId = (int)$pdo->lastInsertId();

            // Vincular autores
            attachAutores($pdo, $newId, $d['autores'] ?? []);

            $pdo->commit();
            jsonResponse(['ok' => true, 'id' => $newId], 201);
            break;

        case 'PUT':
            if (!$id) jsonResponse(['error' => 'Falta el id'], 400);
            $d = readJsonBody();
            $pdo->beginTransaction();

            $stmt = $pdo->prepare("
                UPDATE bibliografias SET
                    materia_id = :materia_id, tipo = :tipo, tipo_recurso = :tipo_recurso,
                    titulo = :titulo, subtitulo = :subtitulo, anio = :anio,
                    editorial = :editorial, ciudad = :ciudad, pais = :pais, edicion = :edicion,
                    revista = :revista, volumen = :volumen, numero_revista = :numero_revista,
                    paginas = :paginas,
                    doi = :doi, isbn = :isbn, issn = :issn, url = :url,
                    fecha_consulta = :fecha_consulta,
                    temas_recomendados = :temas, notas = :notas
                WHERE id = :id
            ");
            $params = bindBibliografia($d);
            $params[':id'] = $id;
            $stmt->execute($params);

            // Re-vincular autores: borramos los existentes y agregamos los nuevos
            $pdo->prepare('DELETE FROM bibliografia_autores WHERE bibliografia_id = ?')
                ->execute([$id]);
            attachAutores($pdo, $id, $d['autores'] ?? []);

            $pdo->commit();
            jsonResponse(['ok' => true]);
            break;

        case 'DELETE':
            if (!$id) jsonResponse(['error' => 'Falta el id'], 400);
            $stmt = $pdo->prepare('DELETE FROM bibliografias WHERE id = ?');
            $stmt->execute([$id]);
            jsonResponse(['ok' => true, 'deleted' => $stmt->rowCount()]);
            break;

        default:
            jsonResponse(['error' => 'Método no permitido'], 405);
    }
} catch (Throwable $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    jsonResponse(['error' => 'Error del servidor', 'detalle' => $e->getMessage()], 500);
}

// ─────────────────────────────────────────────────────────────────
function fetchBibliografia(PDO $pdo, int $id): ?array
{
    $stmt = $pdo->prepare("
        SELECT b.*, m.nombre AS materia_nombre,
               GROUP_CONCAT(
                 CONCAT(a.id, '|', a.apellidos, '|', a.inicial, '|', COALESCE(a.nombre,''))
                 ORDER BY ba.orden SEPARATOR '||'
               ) AS autores_raw
        FROM   bibliografias b
        JOIN   materias m                 ON m.id = b.materia_id
        LEFT JOIN bibliografia_autores ba ON ba.bibliografia_id = b.id
        LEFT JOIN autores a               ON a.id = ba.autor_id
        WHERE  b.id = ?
        GROUP BY b.id
    ");
    $stmt->execute([$id]);
    $row = $stmt->fetch();
    if (!$row) return null;
    $row['autores'] = parseAutoresRawWithId($row['autores_raw'] ?? '');
    unset($row['autores_raw']);
    return $row;
}

/** Crea o reutiliza el autor (por apellidos+inicial) y lo vincula. */
function attachAutores(PDO $pdo, int $bibId, array $autores): void
{
    $orden = 1;
    foreach ($autores as $a) {
        $apellidos = trim($a['apellidos'] ?? '');
        $inicial   = trim($a['inicial']   ?? '');
        $nombre    = trim($a['nombre']    ?? '') ?: null;
        if ($apellidos === '' || $inicial === '') continue;

        if (!empty($a['id'])) {
            // Autor ya existente, lo reutilizamos
            $autorId = (int)$a['id'];
        } else {
            // Buscar si ya existe (mismo apellido + inicial)
            $find = $pdo->prepare("SELECT id FROM autores WHERE apellidos = ? AND inicial = ?");
            $find->execute([$apellidos, $inicial]);
            $autorId = (int)($find->fetchColumn() ?: 0);
            if (!$autorId) {
                $ins = $pdo->prepare("INSERT INTO autores (apellidos, inicial, nombre) VALUES (?, ?, ?)");
                $ins->execute([$apellidos, $inicial, $nombre]);
                $autorId = (int)$pdo->lastInsertId();
            }
        }

        $link = $pdo->prepare("
            INSERT IGNORE INTO bibliografia_autores (bibliografia_id, autor_id, orden)
            VALUES (?, ?, ?)
        ");
        $link->execute([$bibId, $autorId, $orden++]);
    }
}

function bindBibliografia(array $d): array
{
    return [
        ':materia_id'    => (int)($d['materia_id'] ?? 0),
        ':tipo'          => $d['tipo']           ?? 'basica',
        ':tipo_recurso'  => $d['tipo_recurso']   ?? 'libro',
        ':titulo'        => $d['titulo']         ?? '',
        ':subtitulo'     => $d['subtitulo']      ?? null,
        ':anio'          => isset($d['anio']) && $d['anio'] !== '' ? (int)$d['anio'] : null,
        ':editorial'     => $d['editorial']      ?? null,
        ':ciudad'        => $d['ciudad']         ?? null,
        ':pais'          => $d['pais']           ?? null,
        ':edicion'       => $d['edicion']        ?? null,
        ':revista'       => $d['revista']        ?? null,
        ':volumen'       => $d['volumen']        ?? null,
        ':numero_revista'=> $d['numero_revista'] ?? null,
        ':paginas'       => $d['paginas']        ?? null,
        ':doi'           => $d['doi']            ?? null,
        ':isbn'          => $d['isbn']           ?? null,
        ':issn'          => $d['issn']           ?? null,
        ':url'           => $d['url']            ?? null,
        ':fecha_consulta'=> !empty($d['fecha_consulta']) ? $d['fecha_consulta'] : null,
        ':temas'         => $d['temas_recomendados'] ?? null,
        ':notas'         => $d['notas']          ?? null,
    ];
}

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

function parseAutoresRawWithId(?string $raw): array
{
    if (!$raw) return [];
    $autores = [];
    foreach (explode('||', $raw) as $i => $piece) {
        [$autorId, $apellidos, $inicial, $nombre] = array_pad(explode('|', $piece), 4, '');
        $autores[] = [
            'id'        => (int)$autorId,
            'apellidos' => $apellidos,
            'inicial'   => $inicial,
            'nombre'    => $nombre !== '' ? $nombre : null,
            'orden'     => $i + 1,
        ];
    }
    return $autores;
}