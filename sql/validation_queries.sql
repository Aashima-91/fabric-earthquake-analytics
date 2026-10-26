-- Validation queries for the Fabric SQL analytics endpoint

-- 1. Silver: row count and time range should match the loaded window
SELECT
    COUNT(*)  AS total_events,
    MIN(time) AS earliest_event,
    MAX(time) AS latest_event
FROM dbo.earthquake_events_silver;

-- 2. Gold: events and max significance by class
SELECT
    sig_class,
    COUNT(*)          AS total_earthquakes,
    MAX(significance) AS max_significance
FROM dbo.earthquake_events_gold
GROUP BY sig_class;

-- 3. Duplicate check (append mode can duplicate events if a window is rerun)
SELECT id, COUNT(*) AS copies
FROM dbo.earthquake_events_gold
GROUP BY id
HAVING COUNT(*) > 1;
