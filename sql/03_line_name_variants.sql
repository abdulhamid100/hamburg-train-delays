-- The same line appears under different labels (operator prefix, spaces).
-- "ME RE3" (metronom) and "RE 7" (DB Regio) need one consistent format: RE3, RE7.
SELECT
    train_type,
    train_name,
    COUNT(*) AS stops
FROM raw_stops
WHERE train_type IN ('RE', 'RB', 'ME', 'NBE')
GROUP BY train_type, train_name
ORDER BY stops DESC
LIMIT 15;
