-- Kharazmika Arena schema (phases 1-4)
-- Prefer: open competition.php?action=bootstrap once on the server.

CREATE TABLE IF NOT EXISTS xp_log (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  amount INT NOT NULL,
  reason VARCHAR(200) NOT NULL,
  source VARCHAR(40) NOT NULL DEFAULT 'app',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_xp_user_time (user_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS badges (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(40) NOT NULL UNIQUE,
  title VARCHAR(100) NOT NULL,
  description VARCHAR(255) NOT NULL,
  icon VARCHAR(40) NOT NULL DEFAULT 'fa-medal'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_badges (
  user_id INT NOT NULL,
  badge_id INT UNSIGNED NOT NULL,
  earned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, badge_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS daily_missions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  mission_date DATE NOT NULL,
  code VARCHAR(40) NOT NULL,
  title VARCHAR(200) NOT NULL,
  target_count INT NOT NULL DEFAULT 3,
  xp_reward INT NOT NULL DEFAULT 25,
  UNIQUE KEY uq_day_code (mission_date, code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_missions (
  user_id INT NOT NULL,
  mission_date DATE NOT NULL,
  code VARCHAR(40) NOT NULL,
  progress INT NOT NULL DEFAULT 0,
  completed TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, mission_date, code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS duels (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(12) NOT NULL UNIQUE,
  host_id INT NOT NULL,
  guest_id INT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'waiting',
  question_json TEXT NOT NULL,
  host_answer VARCHAR(64) NULL,
  guest_answer VARCHAR(64) NULL,
  host_correct TINYINT(1) NULL,
  guest_correct TINYINT(1) NULL,
  host_ms INT NULL,
  guest_ms INT NULL,
  winner_id INT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  finished_at DATETIME NULL,
  INDEX idx_duel_host (host_id),
  INDEX idx_duel_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS classes (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(10) NOT NULL UNIQUE,
  name VARCHAR(120) NOT NULL,
  teacher_id INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_class_teacher (teacher_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS class_members (
  class_id INT UNSIGNED NOT NULL,
  user_id INT NOT NULL,
  joined_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (class_id, user_id),
  INDEX idx_cm_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS mystery_problems (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  problem_date DATE NOT NULL UNIQUE,
  prompt TEXT NOT NULL,
  answer VARCHAR(64) NOT NULL,
  xp_reward INT NOT NULL DEFAULT 80,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS mystery_solves (
  user_id INT NOT NULL,
  problem_date DATE NOT NULL,
  solved_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, problem_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS weekly_snapshots (
  user_id INT NOT NULL,
  week_key VARCHAR(10) NOT NULL,
  xp_gained INT NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, week_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS shop_items (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(40) NOT NULL UNIQUE,
  category VARCHAR(20) NOT NULL,
  title VARCHAR(100) NOT NULL,
  description VARCHAR(255) NOT NULL DEFAULT '',
  price_xp INT NOT NULL,
  css_class VARCHAR(60) NOT NULL DEFAULT '',
  sort_order INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_inventory (
  user_id INT NOT NULL,
  item_id INT UNSIGNED NOT NULL,
  bought_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_loadout (
  user_id INT NOT NULL PRIMARY KEY,
  frame_code VARCHAR(40) NULL,
  title_style_code VARCHAR(40) NULL,
  mark_code VARCHAR(40) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
