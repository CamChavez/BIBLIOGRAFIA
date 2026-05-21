<?php
/**
 * API de autores.
 *
 * Pensado para el ejemplo de la maestra:
 *   "Buscar 'Shannon' y que salgan todos los artículos de Shannon."
 *
 * Rutas:
 *   GET /api/autores.php                  → lista todos los autores
 *   GET /api/autores.php?q=Shannon        → busca autores por apellido
 *   GET /api/autores.php?id=3             → trae un autor + todas sus bibliografías
 */

declare(strict_types=1);

require_once __DIR__ . '/../includes/db.php';

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') jsonResponse(['ok' => true]);
if ($_SERVER['REQUEST_METHOD'] !== 'GET')     jsonResponse(['error' => 'Solo GET'], 405);

$pdo = DB::conn();
$id  = isset($_GET['id']) ? (int)$_GET['id'] : null;
$q   = trim($_GET['q'] ?? '');

try {

    // ── Un autor con todas sus obras ─────────────────────
    if ($id) {
        $a = $pdo->prepare('SELECT * FROM autores WHERE id = ?');
        $a->execute([$id]);
        $autor = $a->fetch();
        if (!$autor) jsonResponse(['error' => 'Autor no encontrado'], 404);

        $obras = $pdo->prepare("
            SELECT b.id, b.titulo, b.anio, b.editorial, b.tipo, b.tipo_recurso,
                   b.revista, b.volumen, b.numero_revista, b.paginas,
                   b.ciudad, b.pais,
                   m.id   AS materia_id,
                   m.nombre AS materia_nombre,
                   s.nombre AS semestre_nombre
            FROM   bibliografia_autores ba
            JOIN   bibliografias b ON b.id = ba.bibliografia_id
            JOIN   materias m      ON m.id = b.materia_id
            JOIN   semestres s     ON s.id = m.semestre_id
            WHERE  ba.autor_id = ?
            ORDER  BY b.anio DESC
        ");
        $obras->execute([$id]);
        $autor['obras'] = $obras->fetchAll();
        jsonResponse($autor);
    }

    // ── Búsqueda / listado ───────────────────────────────
    if ($q !== '') {
        $stmt = $pdo->prepare("
            SELECT a.id, a.nombre, a.apellidos, a.inicial,
                   COUNT(ba.bibliografia_id) AS num_obras
            FROM   autores a
            LEFT JOIN bibliografia_autores ba ON ba.autor_id = a.id
            WHERE  a.apellidos LIKE :q1 OR a.nombre LIKE :q2
            GROUP BY a.id
            ORDER BY a.apellidos
        ");
        $stmt->execute([':q1' => "%{$q}%", ':q2' => "%{$q}%"]);
    } else {
        $stmt = $pdo->query("
            SELECT a.id, a.nombre, a.apellidos, a.inicial,
                   COUNT(ba.bibliografia_id) AS num_obras
            FROM   autores a
            LEFT JOIN bibliografia_autores ba ON ba.autor_id = a.id
            GROUP BY a.id
            ORDER BY a.apellidos
        ");
    }
    jsonResponse($stmt->fetchAll());

} catch (Throwable $e) {
    jsonResponse(['error' => 'Error del servidor', 'detalle' => $e->getMessage()], 500);
}