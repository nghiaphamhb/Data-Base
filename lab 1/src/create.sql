BEGIN;
CREATE TYPE resolution_quality AS ENUM (
    'SD', 
    'HD',
	'FHD'
);
CREATE TYPE direction AS ENUM (
    'близко',
    'параллельно'
);
CREATE TYPE aspect AS ENUM (
   'превышение над уровнем моря',
   'интенсивность магнитного поля'
);

CREATE TABLE line (
    id SERIAL PRIMARY KEY,
    direction direction NOT NULL,
    thickness INT NOT NULL
);
CREATE TABLE dot (
    id SERIAL PRIMARY KEY,
    name text,
    coords POINT
);
CREATE TABLE interact (
    id SERIAL PRIMARY KEY,
    dot_id INT NOT NULL REFERENCES dot(id),
    line_id INT NOT NULL REFERENCES line(id)
);
CREATE TABLE circle (
    id SERIAL PRIMARY KEY,
    interact_id INT NOT NULL REFERENCES interact(id),
    radius INT NOT NULL
);
CREATE TABLE planet (
    id SERIAL PRIMARY KEY,
    name text NOT NULL,
    radius INT NOT NULL
);
CREATE TABLE place (
    id SERIAL PRIMARY KEY,
    planet_id INT NOT NULL REFERENCES planet(id),
	name text NOT NULL,
    explore_time date NOT NULL,
    aspect aspect NOT NULL
);
CREATE TABLE quality(
	id SERIAL PRIMARY KEY,
	resolution_quality resolution_quality NOT NULL
);
CREATE TABLE map (
    id SERIAL PRIMARY KEY,
    dot_id INT NOT NULL REFERENCES dot(id),
    line_id INT NOT NULL REFERENCES line(id),
    circle_id INT NOT NULL REFERENCES circle(id),
	place_id INT NOT NULL REFERENCES place(id)
);
CREATE TABLE image (
    id SERIAL PRIMARY KEY,
    map_id INT NOT NULL REFERENCES map(id),
	name text
);
CREATE TABLE choose_quality(
	image_id INT NOT NULL REFERENCES image(id),
	quality_id INT NOT NULL REFERENCES quality(id),
	PRIMARY KEY(image_id, quality_id)
);
CREATE TABLE screen (

    id SERIAL PRIMARY KEY,
    image_id INT REFERENCES image(id),
    name text 
);
COMMIT;