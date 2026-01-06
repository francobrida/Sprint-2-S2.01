CREATE SCHEMA youtube;
USE youtube;

CREATE TABLE User(
id INT PRIMARY KEY AUTO_INCREMENT,
email VARCHAR(100) UNIQUE,
password VARCHAR(50),
username VARCHAR(50),
date_of_birth DATE,
gender VARCHAR(10),
country VARCHAR(50),
postal_code VARCHAR(20)
);

CREATE TABLE Channel (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100),
description TEXT,
creation_date DATETIME,
user_id INT UNIQUE,
FOREIGN KEY(user_id) REFERENCES User(id) ON DELETE CASCADE
);

CREATE TABLE Video(
id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(50),
description TEXT,
size INT,
name_file VARCHAR(250),
duration INT,
thumbnail VARCHAR(250),
views INT,
state ENUM('public','private','hidden'),
user_id INT,
datetime DATETIME,
FOREIGN KEY(user_id) REFERENCES User(id) ON DELETE CASCADE
);

CREATE TABLE Tag(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100)
);

CREATE TABLE tag_on_video(
video_id INT,
tag_id INT,
PRIMARY KEY(video_id, tag_id),
FOREIGN KEY(video_id) REFERENCES Video(id) ON DELETE CASCADE,
FOREIGN KEY(tag_id) REFERENCES Tag(id) ON DELETE CASCADE
);

CREATE TABLE Playlist(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50),
creation_date DATETIME,
status ENUM('private','public'),
user_id INT,
FOREIGN KEY(user_id) REFERENCES User(id) ON DELETE CASCADE);

CREATE TABLE video_playlist(
video_id INT,
playlist_id INT,
PRIMARY KEY(video_id, playlist_id),
FOREIGN KEY(video_id) REFERENCES Video(id) ON DELETE CASCADE,
FOREIGN KEY(playlist_id) REFERENCES Playlist(id) ON DELETE CASCADE
);

CREATE TABLE Comment(
id INT PRIMARY KEY AUTO_INCREMENT,
text VARCHAR(300),
datetime DATETIME,
user_id INT,
video_id INT,
FOREIGN KEY(user_id) REFERENCES User(id) ON DELETE CASCADE,
FOREIGN KEY(video_id) REFERENCES Video(id) ON DELETE CASCADE
);

CREATE TABLE Subscription(
user_id INT,
channel_id INT,
PRIMARY KEY(user_id, channel_id),
FOREIGN KEY(user_id) REFERENCES User(id) ON DELETE CASCADE,
FOREIGN KEY(channel_id) REFERENCES Channel(id) ON DELETE CASCADE
);

CREATE TABLE Like_dislike_video(
user_id INT,
video_id INT,
type ENUM('like','dislike'),
datetime DATETIME,
PRIMARY KEY(user_id, video_id),
FOREIGN KEY(user_id) REFERENCES User(id) ON DELETE CASCADE,
FOREIGN KEY(video_id) REFERENCES Video(id) ON DELETE CASCADE
);

CREATE TABLE Like_dislike_comment(
user_id INT,
comment_id INT,
type ENUM('like','dislike'),
datetime DATETIME,
PRIMARY KEY(user_id, comment_id),
FOREIGN KEY(user_id) REFERENCES User(id) ON DELETE CASCADE,
FOREIGN KEY(comment_id) REFERENCES Comment(id) ON DELETE CASCADE);
