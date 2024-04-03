-- Here's a selection of particularly tricky SQL queries from the Google Data Analytics Certification Program

-- Which mascots had the highest average wins in Division NCAA basketball throughout the 90s?
SELECT
    seasons.market AS university,
    seasons.name AS team_name,
    mascots.mascot AS mascot_name,
    CAST(AVG(seasons.wins)AS int) AS avg_wins,
    CAST(AVG(seasons.losses) AS int) AS avg_losses,
    CAST(AVG(seasons.ties) AS int) AS avg_ties
FROM
    `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons` AS seasons
LEFT JOIN
    `bigquery-public-data.ncaa_basketball.mascots` AS mascots
ON 
    mascots.id = seasons.team_id
WHERE 
    seasons.season BETWEEN 1990 AND 1999
    AND seasons.division = 1
GROUP BY 
    university,
    team_name,
    mascot_name
ORDER BY 
    avg_wins DESC,
    university


-- New York Citibike data set

-- Which New York Citibike stations had trips that were significantly longer than the average trip duration for that station?
SELECT
    starttime,
    start_station_id,
    tripduration,
    (
        SELECT ROUND(AVG(tripduration),2)
        FROM bigquery-public-data.new_york_citibike.citibike_trips
        WHERE start_station_id = outer_trips.start_station_id
    ) AS avg_duration_for_station,
    ROUND(tripduration - (
        SELECT AVG(tripduration)
        FROM bigquery-public-data.new_york_citibike.citibike_trips
        WHERE start_station_id = outer_trips.start_station_id), 2) AS difference_from_avg
FROM bigquery-public-data.new_york_citibike.citibike_trips AS outer_trips
ORDER BY difference_from_avg DESC
LIMIT 25;


-- List the various trip durations for the top 5 stations with the highest average trip duration.
SELECT
    tripduration,
    start_station_id
FROM bigquery-public-data.new_york_citibike.citibike_trips
WHERE start_station_id IN
    (
        SELECT
            start_station_id
        FROM
        (
            SELECT
                start_station_id,
                AVG(tripduration) AS avg_duration
            FROM bigquery-public-data.new_york_citibike.citibike_trips
            GROUP BY start_station_id
        ) AS top_five
        ORDER BY avg_duration DESC
        LIMIT 5
    );



