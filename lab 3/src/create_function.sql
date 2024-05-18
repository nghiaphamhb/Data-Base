CREATE TABLE circle_log (
    id SERIAL PRIMARY KEY,
    circle_id INT NOT NULL REFERENCES circle(id),
    log_time TIMESTAMP NOT NULL,
    log_type TEXT NOT NULL,
    old_radius INT,
    new_radius INT
);

-- Trigger function for insert
CREATE OR REPLACE FUNCTION insert_circle()
RETURNS TRIGGER AS $$
BEGIN 
    INSERT INTO circle_log (circle_id, log_time, log_type, new_radius)
    VALUES (NEW.id, now(), 'APPEAR', NEW.radius);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_circle_trigger
AFTER INSERT ON circle
FOR EACH ROW 
EXECUTE FUNCTION insert_circle();

-- Trigger function for update
CREATE OR REPLACE FUNCTION update_circle()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO circle_log (circle_id, log_time, log_type, old_radius, new_radius)
    VALUES (NEW.id, now(), 'CHANGED', OLD.radius, NEW.radius);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_circle_trigger
AFTER UPDATE ON circle
FOR EACH ROW
EXECUTE FUNCTION update_circle();

-- Trigger function for delete
CREATE OR REPLACE FUNCTION delete_circle()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO circle_log (circle_id, log_time, log_type, old_radius)
    VALUES (OLD.id, now(), 'DISAPPEAR', OLD.radius);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_circle_trigger
AFTER DELETE ON circle
FOR EACH ROW
EXECUTE FUNCTION delete_circle();


-- -- Drop the foreign key constraint
-- ALTER TABLE circle_log DROP CONSTRAINT circle_log_circle_id_fkey;

-- -- Delete the record from the circle table
-- DELETE FROM circle WHERE id = 4;

-- -- Recreate the foreign key constraint
-- ALTER TABLE circle_log
-- ADD CONSTRAINT circle_log_circle_id_fkey
-- FOREIGN KEY (circle_id)
-- REFERENCES circle(id)
-- ON DELETE CASCADE;
