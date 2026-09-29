-- Rows that need a decision before any delay statistic is trusted.
SELECT
    COUNT(*)                                                        AS total_rows,
    SUM(train_type = 'Bus')                                         AS replacement_buses,
    SUM(is_canceled = 1)                                            AS canceled_stops,
    SUM(is_canceled = 0 AND delay_in_min BETWEEN -30 AND -1)        AS early_by_up_to_30_min,
    SUM(is_canceled = 0 AND delay_in_min < -30)                     AS impossible_early,
    SUM(is_canceled = 0 AND delay_in_min > 720)                     AS over_12h_late,
    SUM(arrival_planned_time IS NULL)                               AS no_arrival_time_origin_stops,
    SUM(departure_planned_time IS NULL)                             AS no_departure_time_final_stops
FROM raw_stops;
