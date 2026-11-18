
DROP SCHEMA IF EXISTS gold CASCADE;
CREATE SCHEMA gold;

CREATE TABLE gold.dim_time (
    time_id INT PRIMARY KEY,
    rated_time TIME NOT NULL,
    second INT,
    minute INT,
    hour INT,
    time_of_day VARCHAR(10)
);

CREATE TABLE gold.dim_date (
    date_id INT PRIMARY KEY,
    rated_at DATE NOT NULL,
    day INT,
    month INT,
    year INT,
    day_of_week INT,
    day_name VARCHAR(10),
    week INT,
    month_name VARCHAR(10),
    quarter INT
);

CREATE TABLE gold.dim_user (
    user_id INT PRIMARY KEY,
    gender CHAR(1) NOT NULL CHECK (gender IN ('M', 'F')),
    zip_code VARCHAR(10),
    age_group VARCHAR(20) NOT NULL,
    occupation VARCHAR(50) NOT NULL
);

CREATE TABLE gold.dim_movie (
    movie_id INT PRIMARY KEY,
    title TEXT NOT NULL,
    release_year INT,
    genre_name TEXT
);

CREATE TABLE gold.fact_rating (
    rating_id INT PRIMARY KEY,
    rating DECIMAL(2,1) NOT NULL,
    rating_count INT NOT NULL,
    rating_percentage INT NOT NULL,
    user_id INT NOT NULL REFERENCES gold.dim_user(user_id),
    time_id INT NOT NULL REFERENCES gold.dim_time(time_id),
    date_id INT NOT NULL REFERENCES gold.dim_date(date_id),
    movie_id INT NOT NULL REFERENCES gold.dim_movie(movie_id)
);

INSERT INTO gold.dim_user (
    user_id,
    gender,
    zip_code,
    age_group,
    occupation
)
SELECT DISTINCT ON (u.user_id)
    u.user_id,
    u.gender,
    u.zip_code,
    COALESCE(a.age_group, 'unknown'),
    COALESCE(o.occupation, 'unknown')
FROM silver.stg_users u
LEFT JOIN silver.stg_age_group a
    ON a.age_group_id = u.age
LEFT JOIN silver.stg_occupations o
    ON o.occupation_id = u.occupation_id
ORDER BY u.user_id;

INSERT INTO gold.dim_movie (
    movie_id,
    title,
    release_year,
    genre_name
)
SELECT
    m.movie_id,
    m.title,
    m.release_year,
    STRING_AGG(DISTINCT g.genre, ', ' ORDER BY g.genre)
FROM silver.stg_movies m
LEFT JOIN silver.stg_genres_movies gm
    ON gm.movie_id = m.movie_id
LEFT JOIN silver.stg_genres g
    ON g.genre_id = gm.genre_id
GROUP BY
    m.movie_id,
    m.title,
    m.release_year
ORDER BY m.movie_id;

INSERT INTO gold.dim_date (
    date_id,
    rated_at,
    day,
    month,
    year,
    day_of_week,
    day_name,
    week,
    month_name,
    quarter
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT,
    d::DATE,
    EXTRACT(DAY FROM d)::INT,
    EXTRACT(MONTH FROM d)::INT,
    EXTRACT(YEAR FROM d)::INT,
    EXTRACT(ISODOW FROM d)::INT,
    TRIM(TO_CHAR(d, 'Day')),
    EXTRACT(WEEK FROM d)::INT,
    TRIM(TO_CHAR(d, 'Month')),
    EXTRACT(QUARTER FROM d)::INT
FROM GENERATE_SERIES(
    (SELECT MIN(rated_at)::DATE FROM silver.stg_ratings),
    (SELECT MAX(rated_at)::DATE FROM silver.stg_ratings),
    INTERVAL '1 day'
) AS gs(d);

INSERT INTO gold.dim_time (
    time_id,
    rated_time,
    second,
    minute,
    hour,
    time_of_day
)
SELECT
    TO_CHAR(MAKE_INTERVAL(secs => sec), 'HH24MISS')::INT,
    MAKE_TIME(
        (sec / 3600)::INT,
        ((sec / 60) % 60)::INT,
        (sec % 60)::DOUBLE PRECISION
    ),
    sec % 60,
    (sec / 60) % 60,
    sec / 3600,
    CASE
        WHEN sec / 3600 BETWEEN 5 AND 11 THEN 'morning'
        WHEN sec / 3600 BETWEEN 12 AND 17 THEN 'afternoon'
        WHEN sec / 3600 BETWEEN 18 AND 21 THEN 'evening'
        ELSE 'night'
    END
FROM GENERATE_SERIES(0, 86399) AS gs(sec);

INSERT INTO gold.fact_rating (
    rating_id,
    rating,
    rating_count,
    rating_percentage,
    user_id,
    time_id,
    date_id,
    movie_id
)
SELECT
    r.rating_id,
    r.rating,
    COUNT(*) OVER (PARTITION BY r.movie_id)::INT,
    ROUND(
        100.0 * COUNT(*) OVER (
            PARTITION BY r.movie_id, r.rating
        ) / COUNT(*) OVER (
            PARTITION BY r.movie_id
        )
    )::INT,
    r.user_id,
    TO_CHAR(r.rated_at, 'HH24MISS')::INT,
    TO_CHAR(r.rated_at::DATE, 'YYYYMMDD')::INT,
    r.movie_id
FROM silver.stg_ratings r;

CREATE INDEX ON gold.fact_rating(user_id);
CREATE INDEX ON gold.fact_rating(movie_id);
CREATE INDEX ON gold.fact_rating(date_id);
CREATE INDEX ON gold.fact_rating(time_id);

SELECT * FROM gold.dim_user LIMIT 10;
SELECT * FROM gold.dim_movie LIMIT 10;
SELECT * FROM gold.dim_date LIMIT 10;
SELECT * FROM gold.dim_time LIMIT 10;
SELECT * FROM gold.fact_rating LIMIT 10;
