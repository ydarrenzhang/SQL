/*
Darren Zhang
08/10/23
Data retrieved through Kaggle of Spotify's top 50 artists and albums of 2021
Querying to retrieve interesting insights through SQLite Studio
Now first create a table for Spotify data
*/
CREATE TABLE BIT_DB.Spotifydata (
id integer PRIMARY KEY,
artist_name varchar NOT NULL,
track_name varchar NOT NULL,
track_id varchar NOT NULL,
popularity integer NOT NULL,
danceability decimal(4,3) NOT NULL,
energy decimal(4,3) NOT NULL,
song_key integer NOT NULL,
loudness decimal(5,3) NOT NULL,
song_mode integer NOT NULL,
speechiness decimal(5,4) NOT NULL,
acousticness decimal(6,5) NOT NULL,
instrumentalness decimal(8,7) NOT NULL,
liveness decimal(5,4) NOT NULL,
valence decimal(4,3) NOT NULL,
tempo decimal(6,3) NOT NULL,
duration_ms integer NOT NULL,
time_signature integer NOT NULL );

--With table created, insert the data from tools in SQLite toolbar > Import the spotify data. Now I should be able to query my table!
SELECT * FROM BIT_DB.Spotifydata;

--What is avg danceability by artist and track?
SELECT artist_name, track_name, AVG(danceability) FROM BIT_DB.Spotifydata;

--Now let's look at the top 10 artists by their track's popularity
SELECT artist_name, track_name, popularity FROM BIT_DB.Spotifydata
ORDER BY popularity DESC
LIMIT 10;

--Which song is the longest and what artist released it?
SELECT track_name, artist_name, duration_ms FROM BIT_DB.Spotifydata
ORDER BY duration_ms DESC
LIMIT 1;

--Now let's create a CTE(a temp. table that doesn't get saved, only for reference for the SQL after it) from the Spotifydata table
--Let's calculate the avg popularity for artists, then for every artist with an average popularity of 90 or above, show their name, their average popularity, and label them as a “Top Star
WITH avgpop_CTE AS (
SELECT s.artist_name, AVG(s.popularity) AS avg_popularity FROM Spotifydata s
GROUP BY s.artist_name
)
SELECT artist_name, avg_popularity, 'Top Star' AS TAG FROM avgpop_CTE
WHERE avg_popularity >= 90;
