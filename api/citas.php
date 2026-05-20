<?php
/**
 * API de generación de citas.
 *
 * Rutas:
 *   GET /api/citas.php?id=5            → cita de la bibliografía 5 en los 4 formatos
 *   GET /api/citas.php?id=5&formato=apa → solo APA
 *   GET /api/citas.php?materia_id=1    → todas las citas de una materia
 *   GET /api/citas.php?autor_id=8      → todas las citas de un autor
 *
 *   Formatos válidos: apa | ieee | bibtex | mla | all (default)
 */

declare(strict_types=1);

require_once __DIR__ . '/../includes/db.php';
require_once __DIR__ . '/../includes/formatter.php';

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') jsonResponse(['ok' => true]);
if ($_SERVER['REQUEST_METHOD'] !== 'GET')     jsonResponse(['error' => 'Solo GET'], 405);

$pdo        = DB::conn();
$id         = isset($_GET['id']) ? (int)$_GET['id'] : null;
$materia_id = isset($_GET['materia_id']) ? (int)$_GET['materia_id'] : null;
$autor_id   = isset($_GET['autor_id']) ? (int)$_GET['autor_id'] : null;
$formato    = strtolower($_GET['formato'] ?? 'all');

try {
    if ($id) {
        $bib = fetchBib($pdo, $id);
        if (!$bib) jsonResponse(['error' => 'Bibliografía no encontrada'], 404);
        jsonResponse(buildCitas($bib, $formato));
    }

    if ($materia_id) {
        $ids = $pdo->prepare('SELECT id FROM bibliografias WHERE materia_id = ? ORDER BY tipo, anio');
        $ids->execute([$materia_id]);
        jsonResponse(buildList($pdo, $ids->fetchAll(PDO::FETCH_COLUMN), $formato));
    }

    if ($autor_id) {
        $ids = $pdo->prepare("
            SELECT b.id
            FROM   bibliografia_autores ba
            JOIN   bibliografias b ON b.id = ba.bibliografia_id
            WHERE  ba.autor_id = ?
            ORDER  BY b.anio DESC
        ");
        $ids->execute([$autor_id]);
        jsonResponse(buildList($pdo, $ids->fetchAll(PDO::FETCH_COLUMN), $formato));
    }

    jsonResponse(['error' => 'Especifica ?id=, ?materia_id= o ?autor_id='], 400);

} catch (Throwable $e) {
    jsonResponse(['error' => 'Error del servidor', 'detalle' => $e->getMessage()], 500);
}

// ─────────────────────────────────────────────────────────────────
function fetchBib(PDO $pdo, int $id): ?array
{
    $stmt = $pdo->prepare('SELECT * FROM bibliografias WHERE id = ?');
    $stmt->execute([$id]);
    $bib = $stmt->fetch();
    if (!$bib) return null;

    $autores = $pdo->prepare("
        SELECT a.apellidos, a.inicial, a.nombre, ba.orden
        FROM   bibliografia_autores ba
        JOIN   autores a ON a.id = ba.autor_id
        WHERE  ba.bibliografia_id = ?
        ORDER  BY ba.orden
    ");
    $autores->execute([$id]);
    $bib['autores_data'] = $autores->fetchAll();
    return $bib;
}

function buildCitas(array $bib, string $formato): array
{
    $autores = $bib['autores_data'] ?? [];
    if ($formato === 'all') {
        return [
            'id'      => (int)$bib['id'],
            'titulo'  => $bib['titulo'],
            'citas'   => CitationFormatter::all($bib, $autores),
        ];
    }
    $valido = ['apa', 'ieee', 'bibtex', 'mla'];
    if (!in_array($formato, $valido, true)) {
        return ['error' => 'Formato no válido. Usa apa, ieee, bibtex o mla.'];
    }
    // Llamada dinámica al método estático: CitationFormatter::apa(), ::ieee(), etc.
    $cita = call_user_func([CitationFormatter::class, $formato], $bib, $autores);
    return [
        'id'      => (int)$bib['id'],
        'titulo'  => $bib['titulo'],
        'formato' => $formato,
        'cita'    => $cita,
    ];
}

function buildList(PDO $pdo, array $bibIds, string $formato): array
{
    $resultado = [];
    foreach ($bibIds as $bid) {
        $bib = fetchBib($pdo, (int)$bid);
        if ($bib) $resultado[] = buildCitas($bib, $formato);
    }
    return $resultado;
}