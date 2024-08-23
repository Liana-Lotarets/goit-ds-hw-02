-- Отримати всі завдання певного користувача.
SELECT title
FROM tasks
WHERE user_id = 1; -- user_id користувача

-- Вибрати завдання за певним статусом.
SELECT title
FROM tasks
WHERE status_id = (SELECT id FROM status WHERE name = 'new');

-- Оновити статус конкретного завдання.
UPDATE tasks SET status_id = (SELECT id FROM status WHERE name = 'in progress') WHERE id = 5;

-- Отримати список користувачів, які не мають жодного завдання. 
-- Попередньо можна зробити: (для користувача з user_id = 3 видалемо завдання)
-- UPDATE tasks SET user_id = NULL WHERE user_id = 3;
SELECT fullname FROM users WHERE id NOT IN(SELECT user_id
	FROM tasks
	WHERE user_id IN(SELECT user_id FROM tasks));

-- Додати нове завдання для конкретного користувача.
INSERT INTO tasks (title, description, status_id, user_id)
VALUES ('NewTask title', 'NewTask description', 1, 5); -- Нове завдання для користувача з id = 5

-- Отримати всі завдання, які ще не завершено. 
SELECT title
FROM tasks
WHERE status_id = 1 OR status_id = 2;

-- Видалити конкретне завдання. 
DELETE FROM tasks WHERE id = 4;

-- Знайти користувачів з певною електронною поштою.
SELECT fullname 
FROM users
WHERE email LIKE '%example.net';

-- Оновити ім'я користувача.
UPDATE users SET fullname = 'Bob' WHERE id = 3;

-- Отримати кількість завдань для кожного статусу.
SELECT COUNT(status_id) as total_tasks, status_id
FROM tasks
GROUP BY status_id;

-- Отримати завдання, які призначені користувачам з певною доменною частиною електронної пошти.
SELECT tasks.title, users.fullname, users.email
FROM tasks
JOIN users ON users.email LIKE '%@example.net';

-- Отримати список завдань, що не мають опису.
-- Попередньо можна зробити: (для користувача з user_id = 4 видалемо опис)
-- UPDATE tasks SET description = NULL WHERE user_id = 4;
SELECT title
FROM tasks
WHERE description IS NULL;

-- Вибрати користувачів та їхні завдання, які є у статусі 'in progress'. 
SELECT users.fullname, tasks.title
FROM tasks
JOIN users ON tasks.status_id = (SELECT id FROM status WHERE name = 'in progress');

-- Отримати користувачів та кількість їхніх завдань.
SELECT users.fullname, COUNT(tasks.user_id) as total_tasks
FROM users
LEFT JOIN tasks ON tasks.user_id = users.id
GROUP BY tasks.user_id;
