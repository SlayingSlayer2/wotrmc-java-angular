-- ====================================================================
-- V4__waypoints_and_fiefdoms.sql
-- Waypoints + Fiefdoms with constraints per user rules.
-- ====================================================================

-- 0) Realm -> Faction must be 1:1 (enforce one faction per realm)
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE schemaname = 'public'
      AND indexname = 'uq_faction_realms_realm_code'
  ) THEN
    CREATE UNIQUE INDEX uq_faction_realms_realm_code
      ON faction_realms (realm_code);
  END IF;
END $$;

-- 1) Waypoints (UUID-like 'code' is primary key; keep case exactly)
CREATE TABLE IF NOT EXISTS waypoints (
  code         TEXT PRIMARY KEY,                -- UUID-like (case preserved)
  display_name TEXT,                            -- optional label
  realm_code   TEXT NOT NULL REFERENCES realms(code) ON DELETE RESTRICT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- updated_at trigger for waypoints
CREATE OR REPLACE FUNCTION set_updated_at_waypoints()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_waypoints_updated ON waypoints;
CREATE TRIGGER trg_waypoints_updated
BEFORE UPDATE ON waypoints
FOR EACH ROW EXECUTE FUNCTION set_updated_at_waypoints();

CREATE INDEX IF NOT EXISTS idx_waypoints_realm ON waypoints(realm_code);

-- 2) Fiefdoms (subset of waypoints; 1-1 with a waypoint)
CREATE TABLE IF NOT EXISTS fiefdoms (
  code           TEXT PRIMARY KEY,              -- UUID-like (case preserved)
  waypoint_code  TEXT UNIQUE NOT NULL REFERENCES waypoints(code) ON DELETE CASCADE,
  display_name   TEXT,                          -- optional label
  realm_code     TEXT NOT NULL REFERENCES realms(code) ON DELETE RESTRICT,
  lord_name      TEXT,
  banner         TEXT,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- updated_at trigger for fiefdoms
CREATE OR REPLACE FUNCTION set_updated_at_fiefdoms()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_fiefdoms_updated ON fiefdoms;
CREATE TRIGGER trg_fiefdoms_updated
BEFORE UPDATE ON fiefdoms
FOR EACH ROW EXECUTE FUNCTION set_updated_at_fiefdoms();

CREATE INDEX IF NOT EXISTS idx_fiefdoms_realm ON fiefdoms(realm_code);

-- 3) Consistency: fiefdom.realm_code must equal its waypoint.realm_code
CREATE OR REPLACE FUNCTION fiefdom_realm_matches_waypoint()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  wp_realm TEXT;
BEGIN
  SELECT realm_code INTO wp_realm
  FROM waypoints WHERE code = NEW.waypoint_code;

  IF wp_realm IS NULL THEN
    RAISE EXCEPTION 'Waypoint % does not exist', NEW.waypoint_code;
  END IF;

  IF NEW.realm_code <> wp_realm THEN
    RAISE EXCEPTION 'Realm mismatch: fiefdom.realm_code(%) must equal waypoint.realm_code(%) for waypoint %',
      NEW.realm_code, wp_realm, NEW.waypoint_code;
  END IF;

  RETURN NEW;
END $$;

DROP TRIGGER IF EXISTS trg_fiefdom_realm_check ON fiefdoms;
CREATE TRIGGER trg_fiefdom_realm_check
BEFORE INSERT OR UPDATE ON fiefdoms
FOR EACH ROW EXECUTE FUNCTION fiefdom_realm_matches_waypoint();

-- 4) Convenience view: Waypoint → Realm → Faction (+ optional fiefdom join)
CREATE OR REPLACE VIEW waypoint_full AS
SELECT
  w.code                AS waypoint_code,
  w.display_name        AS waypoint_name,
  w.realm_code,
  r.display_name        AS realm_name,
  fr.faction_code,
  f.display_name        AS faction_name,
  CASE WHEN fd.code IS NOT NULL THEN true ELSE false END AS is_fiefdom,
  fd.code               AS fiefdom_code,
  fd.display_name       AS fiefdom_name,
  fd.lord_name,
  fd.banner
FROM waypoints w
JOIN realms r ON r.code = w.realm_code
JOIN faction_realms fr ON fr.realm_code = r.code
JOIN factions f ON f.code = fr.faction_code
LEFT JOIN fiefdoms fd ON fd.waypoint_code = w.code;

-- 5) Optional helper upserts (handy for seeding from Java)
CREATE OR REPLACE FUNCTION upsert_waypoint(p_code TEXT, p_display_name TEXT, p_realm TEXT)
RETURNS VOID LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO waypoints(code, display_name, realm_code)
  VALUES (p_code, p_display_name, p_realm)
  ON CONFLICT (code) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    realm_code   = EXCLUDED.realm_code,
    updated_at   = now();
END $$;

CREATE OR REPLACE FUNCTION upsert_fiefdom(p_code TEXT, p_waypoint TEXT, p_display_name TEXT, p_realm TEXT, p_lord TEXT, p_banner TEXT)
RETURNS VOID LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO fiefdoms(code, waypoint_code, display_name, realm_code, lord_name, banner)
  VALUES (p_code, p_waypoint, p_display_name, p_realm, p_lord, p_banner)
  ON CONFLICT (code) DO UPDATE SET
    waypoint_code = EXCLUDED.waypoint_code,
    display_name  = EXCLUDED.display_name,
    realm_code    = EXCLUDED.realm_code,
    lord_name     = EXCLUDED.lord_name,
    banner        = EXCLUDED.banner,
    updated_at    = now();
END $$;
