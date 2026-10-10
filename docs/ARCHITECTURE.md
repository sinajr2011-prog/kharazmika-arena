# Architecture

## Session contract

Arena expects the host application to start a PHP session and set:

```php
$_SESSION['user_id'] = (int) $userId;
```

`config.php` calls `session_start()` and exposes `current_user_id()` / `require_login()`.

## Level curve

```
level = floor(sqrt(xp / 40)) + 1
```

Titles scale with level: Newcomer → Explorer → Solver → City Master → Province Champion → Kharazmika Legend.

## Award policy

| Source | Max XP per call |
|--------|-----------------|
| equation | 15 |
| calc | 5 |
| geometry | 10 |
| mission | 40 |
| quiz | 12 |
| duel | granted inside duel finish logic |
| shop | negative XP log on purchase |

Night Raid (22:00–24:00 Asia/Tehran) doubles non-mission awards up to 2× cap.

## Tables

See `sql/competition_schema.sql` and the `bootstrap` action in `competition.php` for the live schema (xp_log, badges, missions, duels, classes, mystery, shop, loadout, weekly_snapshots).
