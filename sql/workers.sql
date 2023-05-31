--Створити таблицю workers

CREATE TABLE workers(
    id serial PRIMARY KEY,
    first_name varchar(300) NOT NULL CHECK (first_name != ''),
    last_name varchar(300) NOT NULL CHECK (last_name != ''),
    birthday date CHECK (birthday < current_date),
    salary decimal NOT NULL CHECK (salary > 0 )
);

--INSERT
--1. Додати робітника на ім'я Олег 90р.н., зп 300
INSERT INTO workers (first_name, last_name,birthday, salary)VALUES
('Олег','Олегович','1990-10-20',300);

--2. Додати робітницю Ярославу, зп 1200
INSERT INTO workers (first_name, last_name,birthday, salary)VALUES
('Ярослава','Ярославна','1970-06-01',1200);

--3. Додати двох нових робітників одним запитом: Сашу 85р.н, зп 1000, Машу 95рн, зп 900
INSERT INTO workers (first_name, last_name,birthday, salary)VALUES
('Саша','Николаевна','1985-08-01',1000),
('Маша','Николаевна','1995-02-14',900);

--UPDATE

--1. Встановити Олегу зп 500
UPDATE workers
SET salary =500
WHERE first_name ='Олег';

--2. Робітнику з id = 4 встановити рік народження 87
UPDATE workers
SET birthday ='1987-01-14'
WHERE id = 4;

--3. Всім в кого зп > 500, встановити 700
UPDATE workers
SET salary = 700
WHERE salary = 500;

--4. Робітникам з id від 2 до 5 встановити рік народження 99
UPDATE workers
SET birthday = birthday + MAKE_INTERVAL(
    years => 1999 - EXTRACT(
      year
      from birthday
    )::INTEGER
  )
WHERE id BETWEEN 2 AND 5;

--5. Змінити Саші ім'я на Женю та встановити зп 900
UPDATE workers
SET first_name = 'Женя', salary = 900
WHERE first_name = 'Саша';

--SELECT
--1. Отримати дані робітника з id = 3
SELECT * FROM workers
WHERE id = 3;

--2. Вибрати робітників з зп > 400
SELECT * FROM workers
WHERE (salary > 400);

--3. Дізнатись зп та вік Жені
SELECT salary,EXTRACT(YEAR FROM age(current_date, birthday)) AS age FROM workers
WHERE first_name = 'Женя';

--4. Вибрати робітника на ім'я Петя
SELECT * FROM workers
WHERE first_name = 'Петя';

--5. Вибрати робітників у віці 27 років або більше та зп менше 1000
SELECT * FROM workers
WHERE (EXTRACT(YEAR FROM age(current_date, birthday)) >= 27 ) AND (salary < 1000);


--6. Вибрати всіх робітників віком від 25 та 30 років
SELECT * FROM workers 
WHERE (EXTRACT(YEAR FROM age(birthday, current_date)) BETWEEN 25 AND 30);

--7. Вибрати робітників, salary яких більше 300 або ім'я менше 6 літер

SELECT * FROM workers 
WHERE salary > 300 OR LENGTH(first_name) < 6;

--DELETE

--1. Видалити робітника з id = 4
 DELETE FROM workers 
WHERE id = 4;

--2. Видалити Петю
DELETE FROM workers 
WHERE first_name = 'Петя';

--3. Видалити робітників старше 40 років
DELETE FROM workers 
WHERE (EXTRACT(YEAR FROM age(current_date, birthday)) > 40 );


--Задачки з *:

--1. Вивести всі дані робітників + колонку з кількості літер у повному імені
SELECT *, CONCAT(first_name,' ',last_name) AS full_name, char_length(CONCAT(CAST(first_name AS varchar), ' ', CAST(last_name AS varchar))) AS name_length FROM workers;

--2. Вивести робітників по троє
SELECT * FROM workers
LIMIT 3;

SELECT * FROM workers
OFFSET 3 
LIMIT 3;

--3. Вивести робітника, в якого місяць народження - лютий, або кількість років > 30
SELECT *
FROM workers
WHERE ( EXTRACT(MONTH FROM birthday) = 2 OR EXTRACT(YEAR FROM age(current_date, birthday))  > 30);

--4. Вивести робітника, в якого в наступному місяці буде день народження
SELECT  CONCAT(first_name,' ',last_name) AS full_name
FROM workers
WHERE ( EXTRACT(MONTH FROM birthday) =  EXTRACT(MONTH FROM (current_date +1)));


