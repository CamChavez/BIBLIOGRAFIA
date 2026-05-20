<?php
/**
 * Generador de citas bibliográficas en cuatro formatos:
 *
 *   - APA (7ma edición)
 *   - IEEE
 *   - BibTeX
 *   - MLA (9na edición)
 *
 * Recibe:
 *   $b       = array asociativo con los datos de la bibliografía
 *              (tal cual viene de la tabla bibliografias).
 *   $autores = array de autores, cada uno con
 *              ['apellidos' => 'Barry', 'inicial' => 'P.', 'nombre' => null, 'orden' => 1].
 *
 * Devuelve cadenas en texto plano. El frontend se encarga de mostrar
 * itálicas si quiere — la cita "limpia" es lo que el usuario copia/pega.
 */

declare(strict_types=1);

class CitationFormatter
{
    /**
     * Genera la cita en los 4 formatos a la vez.
     */
    public static function all(array $b, array $autores): array
    {
        return [
            'apa'    => self::apa($b, $autores),
            'ieee'   => self::ieee($b, $autores),
            'bibtex' => self::bibtex($b, $autores),
            'mla'    => self::mla($b, $autores),
        ];
    }

    // ════════════════════════════════════════════════════════════════
    //   APA 7
    //   Libro:    Apellido, I. (Año). Título (edición). Editorial.
    //   Artículo: Apellido, I. (Año). Título del artículo.
    //             Nombre de la revista, vol(núm), págs.
    // ════════════════════════════════════════════════════════════════
    public static function apa(array $b, array $autores): string
    {
        $aut    = self::authorsApa($autores);
        $anio   = self::nz($b['anio'] ?? null, 's. f.');
        $titulo = self::nz($b['titulo'] ?? '');
        $edicion = !empty($b['edicion']) ? " ({$b['edicion']})" : '';

        $cierre = '';
        if (!empty($b['doi']))      $cierre = " https://doi.org/{$b['doi']}";
        elseif (!empty($b['url']))  $cierre = " {$b['url']}";

        if (($b['tipo_recurso'] ?? '') === 'articulo' && !empty($b['revista'])) {
            $rev  = $b['revista'];
            $vol  = !empty($b['volumen']) ? ", {$b['volumen']}" : '';
            $num  = !empty($b['numero_revista']) ? "({$b['numero_revista']})" : '';
            $pags = !empty($b['paginas']) ? ", {$b['paginas']}" : '';
            return "{$aut} ({$anio}). {$titulo}. {$rev}{$vol}{$num}{$pags}.{$cierre}";
        }

        $editorial = self::nz($b['editorial'] ?? '');
        $editorialOut = $editorial !== '' ? " {$editorial}." : '';
        return "{$aut} ({$anio}). {$titulo}{$edicion}.{$editorialOut}{$cierre}";
    }

    private static function authorsApa(array $autores): string
    {
        $autores = self::sortAutores($autores);
        if (empty($autores)) return '';

        $partes = array_map(
            fn($a) => trim("{$a['apellidos']}, {$a['inicial']}"),
            $autores
        );

        if (count($partes) === 1) return $partes[0];

        $ultimo = array_pop($partes);
        return implode(', ', $partes) . ', & ' . $ultimo;
    }

    // ════════════════════════════════════════════════════════════════
    //   IEEE
    //   Libro:    [N] I. Apellido, Título, ed. Ciudad: Editorial, año.
    //   Artículo: [N] I. Apellido, "Título," Revista, vol. X, no. Y,
    //             pp. Z, año.
    // ════════════════════════════════════════════════════════════════
    public static function ieee(array $b, array $autores): string
    {
        $aut    = self::authorsIeee($autores);
        $titulo = self::nz($b['titulo'] ?? '');
        $anio   = self::nz($b['anio'] ?? null);

        if (($b['tipo_recurso'] ?? '') === 'articulo' && !empty($b['revista'])) {
            $rev  = $b['revista'];
            $vol  = !empty($b['volumen']) ? ", vol. {$b['volumen']}" : '';
            $num  = !empty($b['numero_revista']) ? ", no. {$b['numero_revista']}" : '';
            $pags = !empty($b['paginas']) ? ", pp. {$b['paginas']}" : '';
            return "{$aut}, \"{$titulo},\" {$rev}{$vol}{$num}{$pags}, {$anio}.";
        }

        // Libro
        $edicion   = !empty($b['edicion']) ? ", {$b['edicion']}" : '';
        $ciudad    = $b['ciudad'] ?? $b['pais'] ?? '';
        $editorial = self::nz($b['editorial'] ?? '');
        $lugarEd   = $ciudad !== '' ? "{$ciudad}: " : '';
        return "{$aut}, {$titulo}{$edicion}. {$lugarEd}{$editorial}, {$anio}.";
    }

    private static function authorsIeee(array $autores): string
    {
        $autores = self::sortAutores($autores);
        $partes  = array_map(
            fn($a) => trim("{$a['inicial']} {$a['apellidos']}"),
            $autores
        );
        $n = count($partes);
        if ($n === 0) return '';
        if ($n === 1) return $partes[0];
        if ($n === 2) return "{$partes[0]} and {$partes[1]}";
        $ultimo = array_pop($partes);
        return implode(', ', $partes) . ', and ' . $ultimo;
    }

    // ════════════════════════════════════════════════════════════════
    //   BibTeX
    //   @book{key, author = {...}, title = {...}, ... }
    // ════════════════════════════════════════════════════════════════
    public static function bibtex(array $b, array $autores): string
    {
        $autores = self::sortAutores($autores);
        $first   = $autores[0]['apellidos'] ?? 'anon';
        $key     = self::sanitizeKey($first) . ($b['anio'] ?? '');

        $entryType = match (strtolower($b['tipo_recurso'] ?? 'libro')) {
            'articulo' => 'article',
            'capitulo' => 'incollection',
            'tesis'    => 'phdthesis',
            'web'      => 'misc',
            default    => 'book',
        };

        $authorsBib = implode(' and ', array_map(
            fn($a) => "{$a['apellidos']}, {$a['inicial']}",
            $autores
        ));

        $fields = ['author' => $authorsBib, 'title' => $b['titulo'] ?? ''];
        if (!empty($b['anio']))           $fields['year']      = (string)$b['anio'];
        if (!empty($b['editorial']))      $fields['publisher'] = $b['editorial'];
        if (!empty($b['ciudad']) || !empty($b['pais']))
                                          $fields['address']   = $b['ciudad'] ?: $b['pais'];
        if (!empty($b['edicion']))        $fields['edition']   = $b['edicion'];
        if (!empty($b['isbn']))           $fields['isbn']      = $b['isbn'];
        if (!empty($b['doi']))            $fields['doi']       = $b['doi'];
        if (!empty($b['url']))            $fields['url']       = $b['url'];
        if (!empty($b['revista']))        $fields['journal']   = $b['revista'];
        if (!empty($b['volumen']))        $fields['volume']    = (string)$b['volumen'];
        if (!empty($b['numero_revista'])) $fields['number']    = (string)$b['numero_revista'];
        if (!empty($b['paginas']))        $fields['pages']     = $b['paginas'];

        $lines  = ["@{$entryType}{{$key},"];
        $keys   = array_keys($fields);
        $maxLen = max(array_map('strlen', $keys));
        foreach ($fields as $k => $v) {
            $pad   = str_repeat(' ', $maxLen - strlen($k));
            $value = self::escapeBibtex((string)$v);
            $lines[] = "  {$k}{$pad} = {{$value}},";
        }
        // Quitar la coma final
        $lines[count($lines) - 1] = rtrim($lines[count($lines) - 1], ',');
        $lines[] = '}';
        return implode("\n", $lines);
    }

    private static function escapeBibtex(string $s): string
    {
        return str_replace(['{', '}'], ['\\{', '\\}'], $s);
    }

    private static function sanitizeKey(string $s): string
    {
        $s = @iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $s) ?: $s;
        $s = preg_replace('/[^a-z0-9]/i', '', $s) ?? '';
        return strtolower($s ?: 'ref');
    }

    // ════════════════════════════════════════════════════════════════
    //   MLA 9
    //   Libro: Apellido, Nombre. Título. Editorial, año.
    //   (Si solo tenemos inicial, usamos la inicial.)
    // ════════════════════════════════════════════════════════════════
    public static function mla(array $b, array $autores): string
    {
        $aut       = self::authorsMla($autores);
        $titulo    = self::nz($b['titulo'] ?? '');
        $editorial = self::nz($b['editorial'] ?? '');
        $anio      = self::nz($b['anio'] ?? null);

        if (($b['tipo_recurso'] ?? '') === 'articulo' && !empty($b['revista'])) {
            $rev  = $b['revista'];
            $vol  = !empty($b['volumen']) ? ", vol. {$b['volumen']}" : '';
            $num  = !empty($b['numero_revista']) ? ", no. {$b['numero_revista']}" : '';
            $pags = !empty($b['paginas']) ? ", pp. {$b['paginas']}" : '';
            return "{$aut} \"{$titulo}.\" {$rev}{$vol}{$num}, {$anio}{$pags}.";
        }

        $editorialOut = $editorial !== '' ? "{$editorial}, " : '';
        return "{$aut} {$titulo}. {$editorialOut}{$anio}.";
    }

    private static function authorsMla(array $autores): string
    {
        $autores = self::sortAutores($autores);
        $n = count($autores);
        if ($n === 0) return '';

        // Si solo tenemos inicial (ej. "P."), evitamos el doble punto al cerrar.
        $nombreDe = fn($a) => !empty($a['nombre']) ? $a['nombre'] : rtrim($a['inicial'], '.');

        if ($n === 1) {
            $a = $autores[0];
            return "{$a['apellidos']}, " . $nombreDe($a) . ".";
        }
        if ($n === 2) {
            $a1 = $autores[0]; $a2 = $autores[1];
            return "{$a1['apellidos']}, " . $nombreDe($a1)
                 . ", and " . $nombreDe($a2) . " {$a2['apellidos']}.";
        }
        // 3+ autores: "et al."
        $a = $autores[0];
        return "{$a['apellidos']}, " . $nombreDe($a) . ", et al.";
    }

    // ════════════════════════════════════════════════════════════════
    //   Utilidades internas
    // ════════════════════════════════════════════════════════════════
    private static function sortAutores(array $autores): array
    {
        usort($autores, fn($a, $b) => ($a['orden'] ?? 1) <=> ($b['orden'] ?? 1));
        return $autores;
    }

    /** Devuelve $val si no es vacío, si no, $alt. */
    private static function nz($val, string $alt = ''): string
    {
        $s = trim((string)($val ?? ''));
        return $s !== '' ? $s : $alt;
    }
}