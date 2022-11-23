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
    CONSTRAINT uq_ranking UNIQUE(song_id, week_id, song_rank)
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

LOAD DATA LOCAL INFILE '/Users/angelashen/Projects/throwback-jukebox/charts_processed.csv'
    INTO TABLE song_ranking
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (@week_end_date, @a, `song_rank`, @song_name, @primary_artist, @c)
    SET `song_id` = (SELECT `song_id` FROM `song` WHERE `song_name` = @song_name AND `artist_id` = (SELECT `artist_id` FROM `artist` WHERE `artist_name` = @primary_artist)),
        `week_id` = (SELECT `week_id` FROM `billboard_week` WHERE `week_end_date` = @week_end_date);

SELECT song.song_name, artist.artist_name, billboard_week.week_start_date, billboard_week.week_end_date, song_ranking.song_rank
    FROM song_ranking
    JOIN song ON song_ranking.song_id = song.song_id
    JOIN artist ON song.artist_id = artist.artist_id
    JOIN billboard_week ON song_ranking.week_id = billboard_week.week_id
    WHERE DAYOFYEAR('2021-11-30') BETWEEN DAYOFYEAR(billboard_week.week_start_date) AND DAYOFYEAR(billboard_week.week_end_date)
    AND song_rank = 1;

-- DELETE FROM song_ranking
-- WHERE ranking_id NOT IN (
--     SELECT rid FROM (
--         SELECT MAX(ranking_id) AS rid
--         FROM song_ranking
--         GROUP BY song_id, week_id, song_rank
--     ) AS r
-- );
