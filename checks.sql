-- Each check returns the rows that FAIL it. An empty result means the check passed.
-- The runner splits this file on lines starting with "-- check:".

-- check: tasks with a missing label
SELECT task_id, annotator_id, project FROM tasks WHERE label IS NULL OR TRIM(label) = '';

-- check: labels outside the allowed set for their project
SELECT task_id, project, label FROM tasks
WHERE (project = 'sentiment' AND label NOT IN ('positive', 'negative', 'neutral'))
   OR (project = 'search'    AND label NOT IN ('relevant', 'partially-relevant', 'off-topic'));

-- check: tasks pointing at an annotator that does not exist (orphan rows)
SELECT t.task_id, t.annotator_id FROM tasks t
LEFT JOIN annotators a ON a.annotator_id = t.annotator_id
WHERE a.annotator_id IS NULL;

-- check: completed before it was created
SELECT task_id, created_at, completed_at FROM tasks WHERE completed_at < created_at;

-- check: suspiciously fast tasks (under 5 seconds) that may need a quality review
SELECT task_id, annotator_id, seconds_spent FROM tasks WHERE seconds_spent < 5;

-- check: annotators with a missing email
SELECT annotator_id, name FROM annotators WHERE email IS NULL OR TRIM(email) = '';

-- check: email used by more than one annotator
SELECT email, COUNT(*) AS accounts, GROUP_CONCAT(name, ', ') AS names
FROM annotators WHERE email IS NOT NULL GROUP BY LOWER(email) HAVING COUNT(*) > 1;
