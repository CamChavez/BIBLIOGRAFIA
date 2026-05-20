<?php
/**
 * Conexión PDO en patrón Singleton.
 * Una sola instancia para toda la app, evita abrir N conexiones.
 *
 * Uso:
 *   $pdo = DB::conn();
 *   $stmt = $pdo->prepare('SELECT * FROM materias WHERE id = ?');
 *   $stmt->execute([$id]);
 */

declare(strict_types=1);

class DB
{
    private static ?PDO $pdo = null;

    public static function conn(): PDO
    {
        if (self::$pdo === null) {
            $cfg = require __DIR__ . '/../config.php';
            $c   = $cfg['db'];

            $dsn = "mysql:host={$c['host']};port={$c['port']};"
                 . "dbname={$c['database']};charset={$c['charset']}";

            try {
                self::$pdo = new PDO($dsn, $c['username'], $c['password'], [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES   => false,
                ]);
            } catch (PDOException $e) {
                // Error legible cuando algo está mal configurado.
                http_response_code(500);
                if ($cfg['debug'] ?? false) {
                    die(json_encode([
                        'error'   => 'No se pudo conectar a MySQL.',
                        'detalle' => $e->getMessage(),
                        'tip'     => 'Revisa config.php (usuario, password, host, base de datos).',
                    ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
                }
                die(json_encode(['error' => 'Error de conexión.']));
            }
        }
        return self::$pdo;
    }
}

/**
 * Helper: responde JSON con el status code adecuado y termina la ejecución.
 */
function jsonResponse($data, int $status = 200): void
{
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type');
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

/**
 * Helper: lee el body JSON de una petición POST/PUT.
 */
function readJsonBody(): array
{
    $raw = file_get_contents('php://input');
    if (!$raw) return [];
    $data = json_decode($raw, true);
    return is_array($data) ? $data : [];
}