<?php
/**
 * Shared DB connection + session helpers
 * Copy to config.php and fill in real credentials.
 */
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$db_host = 'localhost';
$db_name = 'YOUR_DB_NAME';
$db_user = 'YOUR_DB_USER';
$db_pass = 'YOUR_DB_PASSWORD';

try {
    $pdo = new PDO(
        "mysql:host={$db_host};dbname={$db_name};charset=utf8mb4",
        $db_user,
        $db_pass,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    );
} catch (PDOException $e) {
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['ok' => false, 'error' => 'db_connection'], JSON_UNESCAPED_UNICODE);
    exit;
}

function current_user_id(): ?int {
    return isset($_SESSION['user_id']) ? (int)$_SESSION['user_id'] : null;
}

function require_login(): int {
    $uid = current_user_id();
    if (!$uid) {
        http_response_code(401);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(['ok' => false, 'error' => 'login_required'], JSON_UNESCAPED_UNICODE);
        exit;
    }
    return $uid;
}

function level_from_xp(int $xp): int {
    return (int)floor(sqrt(max(0, $xp) / 40)) + 1;
}

function title_from_level(int $level): string {
    if ($level >= 30) return 'افسانه خوارزمیکا';
    if ($level >= 20) return 'قهرمان استان';
    if ($level >= 12) return 'استاد شهر';
    if ($level >= 7)  return 'حلّال';
    if ($level >= 3)  return 'کاوشگر';
    return 'تازه‌وارد';
}

function xp_to_next_level(int $xp): array {
    $level = level_from_xp($xp);
    $currFloor = (int)(40 * pow($level - 1, 2));
    $nextFloor = (int)(40 * pow($level, 2));
    return [
        'level' => $level,
        'xp' => $xp,
        'xp_into_level' => $xp - $currFloor,
        'xp_needed' => max(1, $nextFloor - $currFloor),
        'title' => title_from_level($level),
    ];
}
