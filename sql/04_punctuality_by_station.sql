-- Q1: How punctual is each kind of train at each Hamburg station?
-- On time = less than 6 minutes late (Deutsche Bahn's official threshold).
-- Canceled stops have no delay (NULL) and are reported separately.
SELECT
    station,
    category,
    COUNT(delay_min)                        AS stops_with_delay_data,
    ROUND(AVG(on_time) * 100, 1)            AS on_time_pct,
    ROUND(AVG(delay_min), 2)                AS avg_delay_min,
    ROUND(AVG(is_canceled) * 100, 1)        AS canceled_pct
FROM stops
GROUP BY station, category
ORDER BY category, on_time_pct;
