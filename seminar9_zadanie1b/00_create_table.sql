CREATE SCHEMA IF NOT EXISTS bronze;
CREATE TABLE bronze.age_group(
    id TEXT,
    name TEXT,
    #_source_file TEXT DEFAULT 'age_group.csv',
    #_loaded_at TIMESTAMPTZ DEFAULT now()
)

CREATE TABLE bronze.genres(
    id INT,
    genre TEXT,
    #_source_file TEXT DEFAULT 'age_group.csv',
    #_loaded_at TIMESTAMPTZ DEFAULT now()

CREATE TRTABLE bronze.users(
    id INT,
    age TEXT,
    gender TEXT,
    occupation TEXT,
    zip_code TEXT,
    #_source_file TEXT DEFAULT 'age_group.csv',
    #_loaded_at TIMESTAMPTZ DEFAULT now()
)

CREATE TABLE bronze.genres_movies(
    id INT,
    movie_id TEXT,
    genre_id TEXT,
    #_source_file TEXT DEFAULT 'age_group.csv',
    #_loaded_at TIMESTAMPTZ DEFAULT now()
)

CREATE TABLE bronze.movies(
    id INT,
    title TEXT,
    release_year TEXT,
    #_source_file TEXT DEFAULT 'age_group.csv',
    #_loaded_at TIMESTAMPTZ DEFAULT now()
)

CREATE TABLE bronze.occupations(
    id INT,
    name TEXT,
    #_source_file TEXT DEFAULT 'age_group.csv',
    #_loaded_at TIMESTAMPTZ DEFAULT now() 
)

CREATE TABLE bronze.ratings(
    id INT,
    user_id TEXT,
    movie_id TEXT,
    rating TEXT,
    rated_at TEXT,
    #_source_file TEXT DEFAULT 'age_group.csv',
    #_loaded_at TIMESTAMPTZ DEFAULT now()
)



BEGIN; 
COPY bronze.age_group (id, name)
FROM 'D:/DOWNLOADS/age_group.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

COPY bronze.genres (id, genre)
FROM 'D:/DOWNLOADS/genres.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

COPY bronze.users (id, age, gender, occupation, zip_code)
FROM 'D:/DOWNLOADS/users.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

COPY bronze.genres_movies (id, movie_id, genre_id)
FROM 'D:/DOWNLOADS/genres_movies.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

COPY bronze.movies (id, title, release_year)
FROM 'D:/DOWNLOADS/movies.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

COPY bronze.occupations (id, name)
FROM 'D:/DOWNLOADS/occupations.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

COPY bronze.ratings (id, user_id, movie_id, rating, rated_at)
FROM 'D:/DOWNLOADS/ratings.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

COMMIT;
