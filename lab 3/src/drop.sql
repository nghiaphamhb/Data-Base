BEGIN;
DROP TABLE IF EXISTS choose_quality CASCADE;
DROP TABLE IF EXISTS screen CASCADE;
DROP TABLE IF EXISTS image CASCADE;
DROP TABLE IF EXISTS map CASCADE;
DROP TABLE IF EXISTS quality CASCADE;
DROP TABLE IF EXISTS place CASCADE;
DROP TABLE IF EXISTS planet CASCADE;
DROP FUNCTION IF EXISTS insert_circle CASCADE;
DROP FUNCTION IF EXISTS update_circle CASCADE;
DROP FUNCTION IF EXISTS delete_circle CASCADE;
DROP TABLE IF EXISTS circle_log CASCADE;
DROP TABLE IF EXISTS circle CASCADE;
DROP TABLE IF EXISTS interact CASCADE;
DROP TABLE IF EXISTS dot CASCADE;
DROP TABLE IF EXISTS line CASCADE;
DROP TYPE IF EXISTS resolution_quality;
DROP TYPE IF EXISTS direction;
DROP TYPE IF EXISTS aspect;
COMMIT;