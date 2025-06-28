-- Using SELECT without FROM
SELECT (500 * 3) / 2 AS RESULT;


SELECT * FROM (VALUES (1, 'Apple'), (2, 'Banana'));
-- Using VALUES Constructor
SELECT e.firstName, e.lastName, d.deptName
FROM practical_future.employees e
JOIN (VALUES (10, 'Sales'), (30, 'HR')) d(deptId, deptName)
  ON e.departmentId = d.deptId;

-- Find the average task duration for completed projects
SELECT AVG(endDate - startDate) AS averageDuration
FROM practical_future.projectTasks
WHERE isCompleted = TRUE;

-- Group tasks by week, using a fixed date as the origin
SELECT
    TIME_BUCKET(startDate, INTERVAL '7' DAY, TIMESTAMP '2023-01-01 00:00:00') AS weekBucket,
    COUNT(*) as taskCount
FROM practical_future.projectTasks
GROUP BY TIME_BUCKET(startDate, INTERVAL '7' DAY, TIMESTAMP '2023-01-01 00:00:00')
ORDER BY weekBucket;

SELECT * FROM practical_future.PROJECTTASKS;