CREATE DATABASE IF NOT EXISTS movie_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
USE movie_db;

CREATE TABLE genre (
    id_genre INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    age_limit VARCHAR(20),
    status VARCHAR(30)
);

CREATE TABLE director (
    id_director INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    birth_date DATE,
    country VARCHAR(100),
    biography VARCHAR(255)
);

CREATE TABLE artist (
    id_artist INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    birth_date DATE,
    country VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE movie (
    id_movie INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    release_date DATE,
    duration INT,
    id_genre INT,
    id_director INT,
    country VARCHAR(100),
    age_rating VARCHAR(20),
    description VARCHAR(255),
    FOREIGN KEY (id_genre) REFERENCES genre(id_genre),
    FOREIGN KEY (id_director) REFERENCES director(id_director)
);

CREATE TABLE role (
    id_role INT PRIMARY KEY AUTO_INCREMENT,
    id_movie INT NOT NULL,
    id_artist INT NOT NULL,
    role_name VARCHAR(100),
    character_name VARCHAR(100),
    description VARCHAR(255),
    payment DECIMAL(10,2),
    FOREIGN KEY (id_movie) REFERENCES movie(id_movie),
    FOREIGN KEY (id_artist) REFERENCES artist(id_artist)
);