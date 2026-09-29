-- Data coverage: how many stops do we have per month and station?
-- A missing or very small month means a gap in the source data, not "no trains".
SELECT
    strftime('%Y-%m', time)                   AS month,
    COUNT(*)                                  AS stops,
    COUNT(DISTINCT date(time))                AS days_with_data,
    SUM(station = 'Hamburg Hbf')              AS hbf,
    SUM(station = 'Hamburg Dammtor')          AS dammtor,
    SUM(station = 'Hamburg-Altona')           AS altona,
    SUM(station = 'Hamburg-Harburg')          AS harburg
FROM raw_stops
GROUP BY month
ORDER BY month;
