<?php
/**
 * API: catálogo de semestres (para los <select> del formulario).
 *   GET /api/semestres.php
 */

declare(strict_types=1);
require_once __DIR__ . '/../includes/db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') jsonResponse(['error' => 'Solo GET'], 405);

$pdo = DB::conn();
$rows = $pdo->query("
    SELECT id, numero, nombre
    FROM   semestres
    ORDER  BY numero IS NULL, numero
")->fetchAll();
jsonResponse($rows);