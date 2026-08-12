-- Runs once, automatically, the first time the db volume is created
-- (MySQL only executes files in /docker-entrypoint-initdb.d on an empty
-- data directory). Creates the table the app reads and writes.
CREATE TABLE IF NOT EXISTS items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO items (name) VALUES ("seed-item-1"), ("seed-item-2");
