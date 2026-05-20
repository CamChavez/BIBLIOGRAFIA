<?php

return [
    'db' => [
        'host'     => '127.0.0.1',
        'port'     => 3306,
        'database' => 'referencias_db',
        'username' => 'root',
        'password' => 'cam080818',   // ← pon aquí tu password de MySQL
        'charset'  => 'utf8mb4',
    ],

    // Para debug en desarrollo (true muestra errores detallados).
    // Cámbialo a false cuando entregues el proyecto.
    'debug' => true,
];