INSERT INTO annotators VALUES
 (1, 'Riya Shah',   'riya@example.com',   '2024-01-10'),
 (2, 'Arjun Mehta', 'arjun@example.com',  '2024-02-05'),
 (3, 'Neha Kulkarni', 'neha@example.com', '2024-03-12'),
 (4, 'Imran Ali',   'riya@example.com',   '2024-04-01');

INSERT INTO tasks VALUES
 (101, 1, 'sentiment', 'positive', '2024-05-01 09:00', '2024-05-01 09:02', 95),
 (102, 1, 'sentiment', 'negative', '2024-05-01 09:03', '2024-05-01 09:04', 60),
 (103, 2, 'sentiment', 'Positive', '2024-05-01 10:00', '2024-05-01 10:01', 50),
 (104, 2, 'sentiment', NULL,       '2024-05-01 10:05', '2024-05-01 10:07', 110),
 (105, 3, 'search',    'relevant', '2024-05-02 11:00', '2024-05-02 10:58', 40),
 (106, 9, 'search',    'relevant', '2024-05-02 11:10', '2024-05-02 11:12', 120),
 (107, 3, 'search',    'off-topic','2024-05-02 11:20', '2024-05-02 11:20', 2),
 (108, 4, 'sentiment', 'neutral',  '2024-05-03 08:00', '2024-05-03 08:03', 170);
