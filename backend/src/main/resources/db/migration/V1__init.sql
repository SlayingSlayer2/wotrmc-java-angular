-- ====================================================================
-- V1__init.sql  (Minimal core schema only; no triggers; one example row)
-- ====================================================================

-- =====================
-- Enums (used by later seeds)
-- =====================
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'control_level') THEN
    CREATE TYPE control_level AS ENUM ('NONE','CONTESTED','CONTROLLED');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'relation_kind') THEN
    CREATE TYPE relation_kind AS ENUM ('ALLY','FRIEND','ENEMY','MORTAL_ENEMY');
  END IF;
END $$;

-- =====================
-- Core tables (as referenced by V2..V4)
-- =====================

-- Factions (use code as natural key)
CREATE TABLE IF NOT EXISTS factions (
  code              TEXT PRIMARY KEY,
  display_name      TEXT NOT NULL,
  banner            TEXT,
  capital_waypoint  TEXT,
  lord_name         TEXT
);

-- Realms
CREATE TABLE IF NOT EXISTS realms (
  code              TEXT PRIMARY KEY,
  display_name      TEXT,
  banner            TEXT,
  capital_waypoint  TEXT
);

-- Link: which realms belong to which faction
CREATE TABLE IF NOT EXISTS faction_realms (
  faction_code  TEXT NOT NULL REFERENCES factions(code) ON DELETE CASCADE,
  realm_code    TEXT NOT NULL REFERENCES realms(code)   ON DELETE RESTRICT,
  PRIMARY KEY (faction_code, realm_code)
);
-- (V4 may create a unique index on realm_code to enforce 1:1)

-- Player accounts (minimal fields used by seeds)
CREATE TABLE IF NOT EXISTS app_user (
  id            BIGSERIAL PRIMARY KEY,     -- matches Long + IDENTITY
  email         TEXT UNIQUE NOT NULL,
  display_name  TEXT NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role          TEXT NOT NULL
);

-- User ↔ Faction mapping with role label
CREATE TABLE IF NOT EXISTS account_faction (
  user_id       INTEGER NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
  faction_code  TEXT    NOT NULL REFERENCES factions(code) ON DELETE CASCADE,
  role          TEXT    NOT NULL,
  PRIMARY KEY (user_id, faction_code)
);

-- Biomes and coverage by faction (uses control_level enum)
CREATE TABLE IF NOT EXISTS biome (
  code          TEXT PRIMARY KEY,
  display_name  TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS faction_biome (
  faction_code  TEXT NOT NULL REFERENCES factions(code) ON DELETE CASCADE,
  biome_code    TEXT NOT NULL REFERENCES biome(code)    ON DELETE RESTRICT,
  control       control_level NOT NULL DEFAULT 'NONE',
  PRIMARY KEY (faction_code, biome_code)
);

-- Faction relations using codes and relation_kind enum
CREATE TABLE IF NOT EXISTS faction_relations (
  src_faction   TEXT NOT NULL REFERENCES factions(code) ON DELETE CASCADE,
  dst_faction   TEXT NOT NULL REFERENCES factions(code) ON DELETE CASCADE,
  kind          relation_kind NOT NULL,
  PRIMARY KEY (src_faction, dst_faction)
);

-- Waypoints + Fiefdoms (lightweight, no triggers)
CREATE TABLE IF NOT EXISTS waypoints (
  code          TEXT PRIMARY KEY,
  display_name  TEXT,
  realm_code    TEXT NOT NULL REFERENCES realms(code) ON DELETE RESTRICT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS fiefdoms (
  code            TEXT PRIMARY KEY,
  waypoint_code   TEXT NOT NULL REFERENCES waypoints(code) ON DELETE RESTRICT,
  display_name    TEXT,
  realm_code      TEXT NOT NULL REFERENCES realms(code) ON DELETE RESTRICT,
  lord_name       TEXT,
  banner          TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

