-- Drop old broken trigger & function if they exist
DROP TRIGGER IF EXISTS trg_mirror_faction_relation ON faction_relations;
DROP FUNCTION IF EXISTS mirror_faction_relation();

-- Create fixed function
CREATE OR REPLACE FUNCTION mirror_faction_relation()
RETURNS TRIGGER AS $$
BEGIN
    -- Insert or update the mirrored relation
    INSERT INTO faction_relations (src_faction, dst_faction, kind)
    VALUES (NEW.dst_faction, NEW.src_faction, NEW.kind)
    ON CONFLICT (src_faction, dst_faction)
    DO UPDATE SET kind = EXCLUDED.kind;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Recreate the trigger
CREATE TRIGGER trg_mirror_faction_relation
AFTER INSERT OR UPDATE ON faction_relations
FOR EACH ROW
EXECUTE FUNCTION mirror_faction_relation();
