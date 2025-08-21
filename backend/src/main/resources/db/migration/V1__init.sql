-- Enums
CREATE TYPE control_level AS ENUM ('NONE','CONTESTED','CONTROLLED');
CREATE TYPE relation_kind AS ENUM ('ALLY','FRIEND','ENEMY','MORTAL_ENEMY');

-- Core domain ---------------------------------------------------------------

-- Factions (your spec; 'banner_slug' renamed to 'banner')
CREATE TABLE factions (
  code             TEXT PRIMARY KEY,                       -- e.g. 'GONDOR'
  display_name     TEXT NOT NULL,                          -- e.g. 'Gondor'
  banner           TEXT,                                   -- e.g. 'gondor'
  capital_waypoint TEXT,                                   -- e.g. 'MINAS_TIRITH'
  lord_name        TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- updated_at helper
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END$$;
CREATE TRIGGER trg_factions_updated
BEFORE UPDATE ON factions
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Biomes (same as before)
CREATE TABLE biome (
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
CREATE TABLE faction_biome (
  faction_code TEXT REFERENCES factions(code) ON DELETE CASCADE,
  biome_id     BIGINT REFERENCES biome(id) ON DELETE CASCADE,
  control      control_level NOT NULL DEFAULT 'NONE',
  PRIMARY KEY (faction_code, biome_id)
);

-- Faction-to-faction relations (absence = neutral)
CREATE TABLE faction_relations (
  src_faction TEXT NOT NULL REFERENCES factions(code) ON DELETE CASCADE,
  dst_faction TEXT NOT NULL REFERENCES factions(code) ON DELETE CASCADE,
  kind        relation_kind NOT NULL,
  PRIMARY KEY (src_faction, dst_faction),
  CHECK (src_faction <> dst_faction)
);
CREATE INDEX ON faction_relations (src_faction, kind);
CREATE INDEX ON faction_relations (dst_faction, kind);

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

-- Accounts / auth -----------------------------------------------------------

CREATE TABLE app_user (
  id BIGSERIAL PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL
);

-- User membership in factions
CREATE TABLE account_faction (
  account_id   BIGINT REFERENCES app_user(id) ON DELETE CASCADE,
  faction_code TEXT  REFERENCES factions(code) ON DELETE CASCADE,
  title        TEXT,
  joined_at    TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (account_id, faction_code)
);

-- Seed data -----------------------------------------------------------------

INSERT INTO factions (code, display_name, banner, capital_waypoint, lord_name) VALUES
('GONDOR','Gondor','gondor','MINAS_TIRITH','Denethor II'),
('ROHAN','Rohan','rohan','EDORAS','Théoden'),
('MORDOR','Mordor','mordor','BARAD_DUR','Sauron');

INSERT INTO biome (code,display_name,region,climate,primary_tree,secondary_tree,tags) VALUES
('ANDUIN_VALES','Anduin Vales','Rhovanion','Temperate','Beech','Oak','["RIVER","FORESTED"]'),
('HARAD_DESERT','Red Deserts','Harad','Arid','Acacia','Date Palm','["DESERT"]'),
('EPHEL_DUATH','Ephel Dúath','Mordor','Arid','None','None','["MOUNTAIN","BARREN"]');

-- Example control
INSERT INTO faction_biome (faction_code, biome_id, control)
SELECT 'GONDOR', id, 'CONTROLLED'::control_level FROM biome WHERE code = 'EPHEL_DUATH';

-- Example faction relations (mirrors will be auto-created)
INSERT INTO faction_relations (src_faction, dst_faction, kind) VALUES
('GONDOR','ROHAN','ALLY'),
('GONDOR','MORDOR','MORTAL_ENEMY'),
('ROHAN','MORDOR','ENEMY');

-- Dev user (password is literally "password" using {noop})
INSERT INTO app_user (email, display_name, password_hash, role)
VALUES ('frodo@shire.me','Frodo Baggins','{noop}password','USER');

INSERT INTO account_faction (account_id, faction_code, title)
VALUES ((SELECT id FROM app_user WHERE email='frodo@shire.me'), 'GONDOR', 'Messenger');
