<?php
/**
 * test_citations.php
 *
 * Script de prueba en línea de comandos.
 * Conecta a la BD y genera las citas en los 4 formatos para
 * TODAS las bibliografías de Geometría Analítica.
 *
 * Cómo correrlo:
 *   php test_citations.php
 */

declare(strict_types=1);

require_once __DIR__ . '/includes/db.php';
require_once __DIR__ . '/includes/Formatter.php';

$pdo = DB::conn();

echo "\n╔══════════════════════════════════════════════════════════════╗\n";
echo   "║   PRUEBA: Generador de citas APA / IEEE / BibTeX / MLA       ║\n";
echo   "╚══════════════════════════════════════════════════════════════╝\n\n";

// Traer todas las bibliografías de la materia 1
$stmt = $pdo->prepare("
    SELECT b.*, m.nombre AS materia_nombre
    FROM   bibliografias b
    JOIN   materias m ON m.id = b.materia_id
    WHERE  b.materia_id = ?
    ORDER  BY b.tipo, b.anio
");
$stmt->execute([1]);
$bibs = $stmt->fetchAll();

foreach ($bibs as $bib) {

    // Cargar los autores de esa bibliografía
    $a = $pdo->prepare("
        SELECT a.apellidos, a.inicial, a.nombre, ba.orden
        FROM   bibliografia_autores ba
        JOIN   autores a ON a.id = ba.autor_id
        WHERE  ba.bibliografia_id = ?
        ORDER  BY ba.orden
    ");
    $a->execute([$bib['id']]);
    $autores = $a->fetchAll();

    $citas = CitationFormatter::all($bib, $autores);

    echo "─────────────────────────────────────────────────────────────\n";
    echo "📖  {$bib['titulo']}  ({$bib['tipo']})\n";
    echo "─────────────────────────────────────────────────────────────\n";
    echo "🟣 APA    : {$citas['apa']}\n\n";
    echo "🟪 IEEE   : {$citas['ieee']}\n\n";
    echo "🟫 MLA    : {$citas['mla']}\n\n";
    echo "🟦 BibTeX :\n{$citas['bibtex']}\n\n";
}

// Pruebita rápida del caso "buscar Shannon" (aunque acá no tenemos Shannon
// todavía; simulamos con Taylor que tiene un libro con 2 autores).
echo "═════════════════════════════════════════════════════════════\n";
echo " EJEMPLO: buscar autor por apellido (caso de la maestra)\n";
echo "═════════════════════════════════════════════════════════════\n";

$buscar = 'Taylor';   // cámbialo a 'Shannon' cuando agregues sus obras
$find = $pdo->prepare("
    SELECT a.id, a.apellidos, a.inicial,
           b.titulo, b.anio, b.editorial
    FROM   autores a
    JOIN   bibliografia_autores ba ON ba.autor_id = a.id
    JOIN   bibliografias b         ON b.id = ba.bibliografia_id
    WHERE  a.apellidos LIKE ?
");
$find->execute(["%{$buscar}%"]);
$resultados = $find->fetchAll();

if ($resultados) {
    foreach ($resultados as $r) {
        echo "→ {$r['apellidos']}, {$r['inicial']} ({$r['anio']}). {$r['titulo']}. {$r['editorial']}.\n";
    }
} else {
    echo "(no se encontró '{$buscar}')\n";
}
echo "\n✅ Si ves citas formateadas arriba, el backend funciona perfectamente.\n\n";
