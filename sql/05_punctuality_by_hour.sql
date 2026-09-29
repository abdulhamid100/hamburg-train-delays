-- Q2: When during the day does punctuality drop?
SELECT
    CAST(strftime('%H', time) AS INTEGER)   AS hour,
    category,
    COUNT(delay_min)                        AS stops,
    ROUND(AVG(on_time) * 100, 1)            AS on_time_pct
FROM stops
WHERE delay_min IS NOT NULL
GROUP BY hour, category
ORDER BY category, hour;
