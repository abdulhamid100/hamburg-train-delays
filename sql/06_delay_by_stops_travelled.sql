-- Q3a: Do long-distance trains arrive in Hamburg already late?
-- stop_number = position of this stop on the train's route (1 = the train starts here).
-- If delay grows with the number of stops a train made before Hamburg, the delay is imported.
SELECT
    CASE
        WHEN stop_number = 1         THEN '1 (starts in Hamburg)'
        WHEN stop_number <= 3        THEN '2-3'
        WHEN stop_number <= 6        THEN '4-6'
        WHEN stop_number <= 10       THEN '7-10'
        WHEN stop_number <= 15       THEN '11-15'
        ELSE                              '16+'
    END                                     AS stops_into_route,
    MIN(stop_number)                        AS sort_key,
    COUNT(delay_min)                        AS stops,
    ROUND(AVG(on_time) * 100, 1)            AS on_time_pct,
    ROUND(AVG(delay_min), 2)                AS avg_delay_min
FROM stops
WHERE category = 'Long-distance'
  AND delay_min IS NOT NULL
GROUP BY stops_into_route
ORDER BY sort_key;
