-- Q4: Which regional and S-Bahn lines are the least reliable?
-- RANK() orders lines within each category, worst first.
WITH line_stats AS (
    SELECT
        category,
        line,
        COUNT(delay_min)                    AS stops,
        ROUND(AVG(on_time) * 100, 1)        AS on_time_pct,
        ROUND(AVG(delay_min), 2)            AS avg_delay_min
    FROM stops
    WHERE category IN ('Regional', 'S-Bahn')
      AND delay_min IS NOT NULL
    GROUP BY category, line
    HAVING COUNT(delay_min) >= 2000         -- ignore rare one-off labels
)
SELECT
    category,
    line,
    stops,
    on_time_pct,
    avg_delay_min,
    RANK() OVER (PARTITION BY category ORDER BY on_time_pct) AS rank_worst_first
FROM line_stats
ORDER BY on_time_pct;
