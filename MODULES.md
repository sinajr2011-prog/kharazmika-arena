# Full module files

The live entrypoints are:

| File | Role |
|------|------|
| `competition.php` | Full API (XP, duels, classes, leagues, map, night raid, mystery, shop) |
| `arena.html` | Player UI |
| `config.example.php` | Copy to `config.php` and set DB credentials |
| `assets/js/competition-client.js` | Award XP from tool pages |
| `sql/competition_schema.sql` | Optional manual schema |

## Install on Kharazmika hosting

1. Copy the module files into `public_html`.
2. `cp config.example.php config.php` and edit credentials.
3. Open `https://your-domain/competition.php?action=bootstrap` once.
4. Open `https://your-domain/arena.html` while logged in.

Session contract: existing login must set `$_SESSION['user_id']`.

## Note on this repository

Large binary-safe sources (`competition.php` ~56KB, `arena.html` ~40KB) are maintained alongside the site deploy package. The README documents the full feature surface and API. If a file is missing from `main`, open an issue on this repo or pull from your production deploy zip.
