-- Demo schema: annotation tasks assigned to annotators.
CREATE TABLE annotators (
    annotator_id INTEGER PRIMARY KEY,
    name         TEXT NOT NULL,
    email        TEXT,
    joined_on    TEXT
);

CREATE TABLE tasks (
    task_id      INTEGER PRIMARY KEY,
    annotator_id INTEGER,
    project      TEXT,
    label        TEXT,
    created_at   TEXT,
    completed_at TEXT,
    seconds_spent INTEGER
);
