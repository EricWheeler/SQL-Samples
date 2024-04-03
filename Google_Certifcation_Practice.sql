-- Here's a selection of SQL challenges from the Google Data Analytics Certification Program for a variety of data sets. 

-- NCAA Division 1 Basketball
-- Which mascots had the highest average wins in NCAA Division 1 Basketball throughout the 90s?
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


-- New York Citibike rentals
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


-- Warehouse Orders
-- Display how effective each warehouse is at fulfilling orders. 
SELECT
    warehouse.warehouse_id,
    CONCAT(warehouse.state, ': ', warehouse.warehouse_alias) AS warehouse_name,
    COUNT(orders.order_id) AS number_of_orders,
    (SELECT COUNT(*) FROM `tidy-way-285818.warehouse_orders.orders` AS orders) AS total_orders,
    CASE
      WHEN COUNT(orders.order_id)/(SELECT COUNT(*) FROM `tidy-way-285818.warehouse_orders.orders` AS Orders) <= 0.20
      THEN 'Fulfilled 0-20% of Orders'
        WHEN COUNT(orders.order_id)/(SELECT COUNT(*) FROM `tidy-way-285818.warehouse_orders.orders` AS Orders) > 0.20
      AND COUNT(orders.order_id)/(SELECT COUNT(*) FROM `tidy-way-285818.warehouse_orders.orders` AS Orders) <= 0.60
      THEN 'Fulfilled 21-60% of Orders'
      ELSE 'Fulfilled more than 60% of Orders'
    END AS fulfillment_summary
FROM
    `tidy-way-285818.warehouse_orders.warehouse` AS warehouse
LEFT JOIN
    `tidy-way-285818.warehouse_orders.orders` AS orders
ON warehouse.warehouse_id = orders.warehouse_id
GROUP BY
    warehouse.warehouse_id,
    warehouse_name
HAVING
    COUNT(orders.order_id) > 0

-- Store Product Inventory and Sales
-- create a temp table that stores the sales history of products and then check the average products sold to the current quantity available.
with sales_history as (
  SELECT
    EXTRACT(YEAR FROM Date) AS YEAR,
    EXTRACT(MONTH FROM Date) AS MONTH, 
    ProductId,
    StoreID,
    SUM(quantity) AS UnitsSold, 
    AVG(UnitPrice) AS UnitPriceProxy, 
    COUNT(DISTINCT salesID) AS NumTransactions 
  FROM `tidy-way-285818.sales.sales_info`
  GROUP BY YEAR, MONTH, ProductId, StoreID
)
SELECT
    inventory.*
 , (SELECT AVG(UnitsSold) 
    FROM sales_history
    WHERE  inventory.ProductID=sales_history.ProductID AND 
           inventory.StoreID=sales_history.StoreID) AS avg_quantity_sold_in_a_month
FROM `tidy-way-285818.sales.inventory` AS inventory
