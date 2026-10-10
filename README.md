<p align="center">
  <img src="https://img.shields.io/badge/Kharazmika-Arena-22d3ee?style=for-the-badge&labelColor=050811" alt="Kharazmika Arena" />
  <br/>
  <img src="https://img.shields.io/badge/PHP-MySQL-777BB4?style=flat-square&logo=php&logoColor=white" />
  <img src="https://img.shields.io/badge/RTL-Persian-8b5cf6?style=flat-square" />
  <img src="https://img.shields.io/badge/license-MIT-34d399?style=flat-square" />
</p>

<h1 align="center">∑ Kharazmika Arena</h1>

<p align="center">
  <b>A nationwide math competition layer for middle-school learners.</b><br/>
  XP · 1v1 duels · class codes · weekly leagues · cosmetic shop · seasonal events
</p>

<p align="center">
  Built for <a href="https://kharazmika.ir">kharazmika.ir</a> — drop-in modules for an existing PHP + MySQL site.
</p>

---

## Why this exists

Kharazmika already teaches math. **Arena turns practice into a game people return for.**

Students solve equations → earn XP → climb boards → duel friends → unlock cosmetics.  
Teachers open a class with a short code and watch rankings update live.

No fantasy multiplayer MMO. Just systems that actually ship on shared hosting.

---

## Feature map

| Phase | What you get |
|------|----------------|
| **1 — Core loop** | Accounts (session), XP, levels, titles, badges, daily missions, global leaderboards |
| **2 — Social** | 1v1 duels with share codes, teacher class codes, weekly league divisions (Gold / Silver / Bronze) |
| **3 — Atmosphere** | Province heat map, Night Raid (22:00–24:00 Tehran, 2× XP), Shadow Duel vs last week, daily Mystery Box, season blurb |
| **4 — Shop** | Spend XP on frames, title colors, ∑ mark skins — equip loadout, zero real money |

---

## Quick start

```bash
# 1) Copy modules into your site root (public_html)
cp competition.php arena.html config.example.php /path/to/public_html/
cp assets/js/competition-client.js /path/to/public_html/assets/js/
cp sql/competition_schema.sql /path/to/public_html/sql/

# 2) Configure database
cp config.example.php config.php
# edit DB host / name / user / password

# 3) Bootstrap schema (or import sql/competition_schema.sql)
# open once in browser:
# https://your-domain/competition.php?action=bootstrap

# 4) Open the arena
# https://your-domain/arena.html
```

Your existing login must set `$_SESSION['user_id']` (same pattern as Kharazmika’s `index.php`).

Hook XP from tools:

```html
<script src="assets/js/competition-client.js"></script>
<script>
  // after a successful solve
  KharazmikaXP.award(10, 'Quadratic solved', 'equation');
</script>
```

---

## API surface

All routes: `competition.php?action=...` (GET or JSON POST).

| Action | Auth | Purpose |
|--------|------|---------|
| `bootstrap` | — | Create tables + seed badges/shop |
| `me` | session | Profile, XP, badges, cosmetics |
| `award` | login | Grant XP (server-side caps + anti-spam) |
| `leaderboard` | — | `period=all\|week\|today` |
| `missions` | login | Daily missions progress |
| `duel_create` / `duel_join` / `duel_answer` | login | 1v1 flow |
| `class_create` / `class_join` / `class_leaderboard` | login | Teacher classes |
| `league_week` | — | Weekly divisions |
| `map_provinces` | — | Province activity heat |
| `night_status` | — | Night Raid window |
| `shadow_me` | login | You vs last week |
| `mystery_today` / `mystery_answer` | login* | Daily hard problem |
| `shop_catalog` / `shop_buy` / `shop_equip` | login* | Cosmetics economy |

\*catalog works for guests (browse only).

---

## Architecture (short)

```
arena.html  ──JSON──▶  competition.php  ──PDO──▶  MySQL
                │
                └── uses  config.php  (session + PDO)
                └── optional  competition-client.js  from tool pages
```

- **Server is source of truth** for XP (client amounts are capped).
- **Bootstrap** is idempotent — safe to hit more than once.
- **RTL UI** — Persian copy, Vazirmatn, dark cyan/purple theme aligned with Kharazmika design tokens.

---

## Security notes

- Never commit real `config.php` — only `config.example.php`.
- Rotate any credentials that ever appeared in backups or chats.
- XP awards are rate-limited per source; shop purchases use row locks.
- Leaderboards mask display names by default.

---

## Project layout

```
kharazmika-arena/
├── arena.html                 # Competition UI (tabs: home, duel, class, league, map, events, shop, board)
├── competition.php            # Full API
├── config.example.php         # DB + session helpers
├── assets/js/competition-client.js
├── sql/competition_schema.sql
├── docs/
└── README.md
```

---

## Roadmap (honest)

Shipped in this repo: phases 1–4 above.  

Nice next steps if the product grows:

- Telegram bot pings for duel invites  
- Referral links with mutual XP  
- Richer province “ownership” seasons  

Keep it boring where hosting is shared. Flash belongs in the UI, not in ops.

---

## Credits

**Kharazmika** — math learning platform for Iranian middle school (grades 7–9).  
Arena modules authored for production use on classic PHP hosting.

<p align="center">
  <sub>∑ Learn deep. Compete fair. Climb the board.</sub>
</p>
