-- Q3b: How much delay does a train add *between* two Hamburg stations?
-- LAG() looks up the same train's previous Hamburg stop, so we can compare
-- the delay it arrived with and the delay it left with.
WITH ordered AS (
    SELECT
        train_line_ride_id,
        category,
        station,
        stop_number,
        delay_min,
        LAG(station)     OVER w AS prev_station,
        LAG(delay_min)   OVER w AS prev_delay,
        LAG(stop_number) OVER w AS prev_stop_number
    FROM stops
    WHERE delay_min IS NOT NULL
    WINDOW w AS (PARTITION BY train_line_ride_id ORDER BY stop_number)
)
SELECT
    category,
    prev_station || ' -> ' || station         AS segment,
    COUNT(*)                                  AS trains,
    ROUND(AVG(prev_delay), 1)                 AS delay_before_min,
    ROUND(AVG(delay_min), 1)                  AS delay_after_min,
    ROUND(AVG(delay_min - prev_delay), 2)     AS added_min
FROM ordered
WHERE stop_number - prev_stop_number = 1      -- directly consecutive stops only
GROUP BY category, segment
HAVING COUNT(*) >= 1000
ORDER BY category, delay_before_min DESC;
