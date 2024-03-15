BEGIN;
INSERT INTO line (direction, thickness) VALUES 
('близко', 5), ('параллельно', 10), ('близко', 15);

INSERT INTO dot (name, coords) VALUES 
('A', POINT(10, 20)), ('B', POINT(30, 40)), ('C', POINT(50, 70));

INSERT INTO interact (dot_id, line_id) VALUES 
(1, 1), (2, 3), (3,2);

INSERT INTO circle (interact_id, radius) VALUES 
(1, 15), (2, 20), (3, 25);

INSERT INTO planet (name, radius) VALUES 
('Earth', 6371), ('Mars', 3389), ('Venus', 3000);

INSERT INTO place (planet_id, name, explore_time, aspect) VALUES 
(1, 'Mount Everest', '1953-05-29', 'превышение над уровнем моря'),
(2, 'Valles Marineris', '1971-07-15', 'интенсивность магнитного поля'),
(3, 'Marina', '1967-03-15', 'интенсивность магнитного поля');

INSERT INTO quality (resolution_quality) VALUES ('SD'), ('HD'), ('FHD');

INSERT INTO map (dot_id, line_id, circle_id, place_id) VALUES 
(1, 1, 1, 1), (2, 2, 2, 2), (3, 3, 3, 3);

INSERT INTO image (map_id, name) VALUES
    (1, 'Изображение 1'),
    (2, 'Изображение 2'),
    (3, 'Изображение 3');

INSERT INTO choose_quality (image_id, quality_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3);

INSERT INTO screen (image_id, name) VALUES
    (1, 'Экран 1'),
    (2, 'Экран 2'),
    (3, 'Экран 3');
COMMIT;
