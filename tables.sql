CREATE DATABASE billboard_top_100

CREATE TABLE song (
    song_id INT NOT NULL AUTO_INCREMENT,
    song_name VARCHAR(255) NOT NULL,
    artist_id INT NOT NULL,
    PRIMARY KEY ( song_id )
    FOREIGN KEY ( artist_id ) REFERENCES artist( artist_id )
);

CREATE TABLE artist (
    artist_id INT NOT NULL AUTO_INCREMENT,
    artist_name VARCHAR(255)
);

CREATE TABLE song_ranking (
    ranking_id INT NOT NULL AUTO_INCREMENT,
    song_id INT NOT NULL,
    week_id INT NOT NULL,
    song_rank INT NOT NULL
    PRIMARY KEY ( ranking_id )
    FOREIGN KEY ( song_id ) REFERENCES song( song_id )
    FOREIGN KEY ( week_id ) REFERENCES billboard_week( week_id )
);

CREATE TABLE billboard_week (
    week_id INT NOT NULL AUTO_INCREMENT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
    PRIMARY KEY ( week_id )
);