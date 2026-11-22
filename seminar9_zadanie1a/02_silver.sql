CREATE SCHEMA IF NOT EXISTS silver;

CREATE OR REPLACE VIEW silver.stg_users AS
    SELECT TRIM(id)::INT AS user_id,
    TRIM(age)::INT AS age,
    UPPER(TRIM(gender)) AS gender,
    TRIM(occupation)::INT AS occupation_id,
    TRIM(zip_code) AS zip_code
    FROM bronze.users;
 
CREATE OR REPLACE VIEW silver.stg_age_group AS
SELECT
    TRIM(id)::INT AS age_group_id,
    TRIM(name) AS age_group
FROM bronze.age_group;



CREATE OR REPLACE VIEW silver.stg_genres AS
SELECT
    TRIM(id)::INT AS genre_id,
    TRIM(genre) AS genre
FROM bronze.genres;


CREATE OR REPLACE VIEW silver.stg_genres_movies AS
SELECT
    TRIM(id)::INT AS genres_movies_id,
    TRIM(movie_id)::INT AS movie_id,
    TRIM(genre_id)::INT AS genre_id
FROM bronze.genres_movies;



CREATE OR REPLACE VIEW silver.stg_movies AS
SELECT
    TRIM(id)::INT AS movie_id,
    TRIM(title) AS title,
    TRIM(release_year)::INT AS release_year
FROM bronze.movies;



CREATE OR REPLACE VIEW silver.stg_occupations AS
SELECT
    TRIM(id)::INT AS occupation_id,
    TRIM(name) AS occupation
FROM bronze.occupations;


CREATE VIEW silver.stg_ratings AS
SELECT
    TRIM(id)::INT AS rating_id,
    TRIM(user_id)::INT AS user_id,
    TRIM(movie_id)::INT AS movie_id,
    TRIM(rating)::NUMERIC(2,1) AS rating,
    TRIM(rated_at)::TIMESTAMP AS rated_at
FROM bronze.ratings;

SELECT * FROM silver.stg_users ORDER BY user_id LIMIT 100;