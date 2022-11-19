CREATE DATABASE IF NOT EXISTS billboard_top_100;

USE billboard_top_100;

CREATE TABLE IF NOT EXISTS artist (
    artist_id INT NOT NULL AUTO_INCREMENT,
    artist_name VARCHAR(255) UNIQUE,
    PRIMARY KEY ( artist_id )
);

CREATE TABLE IF NOT EXISTS billboard_week (
    week_id INT NOT NULL AUTO_INCREMENT,
    week_start_date DATE NOT NULL UNIQUE,
    week_end_date DATE NOT NULL UNIQUE,
    PRIMARY KEY ( week_id )
);

CREATE TABLE IF NOT EXISTS song (
    song_id int NOT NULL AUTO_INCREMENT,
    song_name varchar(255) NOT NULL,
    artist_id int NOT NULL,
    CONSTRAINT uq_song UNIQUE(song_name, artist_id),
    PRIMARY KEY ( song_id ),
    FOREIGN KEY ( artist_id ) REFERENCES artist( artist_id )
);

CREATE TABLE IF NOT EXISTS song_ranking (
    ranking_id INT NOT NULL AUTO_INCREMENT,
    song_id INT NOT NULL,
    week_id INT NOT NULL,
    song_rank INT NOT NULL,
    PRIMARY KEY ( ranking_id ),
    FOREIGN KEY ( song_id ) REFERENCES song( song_id ),
    FOREIGN KEY ( week_id ) REFERENCES billboard_week( week_id )
);

LOAD DATA LOCAL INFILE '/Users/angelashen/Projects/throwback-jukebox/charts_processed.csv'
    INTO TABLE artist
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (@a, @b, @c, @d, `artist_name`, @e);

LOAD DATA LOCAL INFILE '/Users/angelashen/Projects/throwback-jukebox/charts_processed.csv'
    INTO TABLE billboard_week
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (week_end_date, week_start_date, @a, @b, @c, @d);

LOAD DATA LOCAL INFILE '/Users/angelashen/Projects/throwback-jukebox/charts_processed.csv'
    INTO TABLE song
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (@a, @b, @c, `song_name`, @primary_artist, @d)
    SET `artist_id` = (SELECT `artist_id` FROM `artist` WHERE `artist_name` = @primary_artist);
