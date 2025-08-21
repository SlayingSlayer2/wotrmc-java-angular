-- ====================================================================
-- V1__init.sql  (Schema only: enums, tables, triggers, views)
-- ====================================================================

-- =====================
-- Enums
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
-- Core domain
-- =====================

CREATE TABLE IF NOT EXISTS factions (
  code             TEXT PRIMARY KEY,                       -- e.g. 'GONDOR'
  display_name     TEXT NOT NULL,                          -- e.g. 'Gondor'
  banner           TEXT,                                   -- e.g. 'gondor' (slug)
  capital_waypoint TEXT,                                   -- e.g. 'MINAS_TIRITH'
  lord_name        TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- updated_at helper + trigger
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END$$;
DROP TRIGGER IF EXISTS trg_factions_updated ON factions;
CREATE TRIGGER trg_factions_updated
BEFORE UPDATE ON factions
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Biomes (example domain)
CREATE TABLE IF NOT EXISTS biome (
  id BIGSERIAL PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  region TEXT NOT NULL,
  climate TEXT NOT NULL,
  primary_tree TEXT,
  secondary_tree TEXT,
  tags JSONB DEFAULT '[]'::jsonb
);

-- Which faction controls which biome
CREATE TABLE IF NOT EXISTS faction_biome (
  faction_code TEXT REFERENCES factions(code) ON DELETE CASCADE,
  biome_id     BIGINT REFERENCES biome(id) ON DELETE CASCADE,
  control      control_level NOT NULL DEFAULT 'NONE',
  PRIMARY KEY (faction_code, biome_id)
);

-- Faction-to-faction relations (absence = neutral)
CREATE TABLE IF NOT EXISTS faction_relations (
  src_faction TEXT NOT NULL REFERENCES factions(code) ON DELETE CASCADE,
  dst_faction TEXT NOT NULL REFERENCES factions(code) ON DELETE CASCADE,
  kind        relation_kind NOT NULL,
  PRIMARY KEY (src_faction, dst_faction),
  CHECK (src_faction <> dst_faction)
);
CREATE INDEX IF NOT EXISTS idx_faction_rel_src ON faction_relations (src_faction, kind);
CREATE INDEX IF NOT EXISTS idx_faction_rel_dst ON faction_relations (dst_faction, kind);

-- Mirror relation trigger (keep graph symmetric)
CREATE OR REPLACE FUNCTION mirror_faction_relation()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO faction_relations (src_faction, dst_faction, kind)
    VALUES (NEW.dst_faction, NEW.src_faction, NEW.kind)
    ON CONFLICT (src_faction, dst_faction)
    DO UPDATE SET kind = EXCLUDED.kind;
    RETURN NEW;

  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE faction_relations
       SET kind = NEW.kind
     WHERE src_faction = NEW.dst_faction
       AND dst_faction = NEW.src_faction;
    RETURN NEW;

  ELSIF TG_OP = 'DELETE' THEN
    DELETE FROM faction_relations
     WHERE src_faction = OLD.dst_faction
       AND dst_faction = OLD.src_faction;
    RETURN OLD;
  END IF;
END$$;

DROP TRIGGER IF EXISTS trg_mirror_faction_relation ON faction_relations;
CREATE TRIGGER trg_mirror_faction_relation
AFTER INSERT OR UPDATE OR DELETE ON faction_relations
FOR EACH ROW EXECUTE FUNCTION mirror_faction_relation();

-- Accounts / auth
CREATE TABLE IF NOT EXISTS app_user (
  id BIGSERIAL PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS account_faction (
  account_id   BIGINT REFERENCES app_user(id) ON DELETE CASCADE,
  faction_code TEXT  REFERENCES factions(code) ON DELETE CASCADE,
  title        TEXT,
  joined_at    TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (account_id, faction_code)
);

-- Realms (sub-factions)
CREATE TABLE IF NOT EXISTS realms (
  code             TEXT PRIMARY KEY,         -- e.g. 'AdornlandMan'
  display_name     TEXT NOT NULL,            -- e.g. 'Adornland'
  banner           TEXT,                     -- e.g. 'adornland' (slug used by UI)
  capital_waypoint TEXT,                     -- e.g. 'FRECA_HOLD'
  lord_name        TEXT
);

-- Link table: many realms per faction
CREATE TABLE IF NOT EXISTS faction_realms (
  faction_code TEXT NOT NULL REFERENCES factions(code) ON DELETE CASCADE,
  realm_code   TEXT NOT NULL REFERENCES realms(code)   ON DELETE CASCADE,
  PRIMARY KEY (faction_code, realm_code)
);

-- =====================
-- Views (optional but useful)
-- =====================
CREATE OR REPLACE VIEW faction_with_realms AS
SELECT
  f.code,
  f.display_name,
  f.banner,
  f.capital_waypoint,
  COALESCE(jsonb_agg(
    jsonb_build_object(
      'code', r.code,
      'display_name', r.display_name,
      'banner', r.banner,
      'capital_waypoint', r.capital_waypoint
    )
  ) FILTER (WHERE r.code IS NOT NULL), '[]'::jsonb) AS realms
FROM factions f
LEFT JOIN faction_realms fr ON fr.faction_code = f.code
LEFT JOIN realms r ON r.code = fr.realm_code
GROUP BY f.code, f.display_name, f.banner, f.capital_waypoint;
