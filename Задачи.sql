-- 1. Вывести имена всех людей, которые есть в базе данных авиакомпаний.
SELECT name
FROM Passenger

-- 2. Вывести названия всеx авиакомпаний
SELECT name
FROM Company

-- 3. Вывести все рейсы, совершенные из Москвы
SELECT *
FROM Trip
WHERE town_from = 'Moscow'

-- 4. Вывести имена людей, которые заканчиваются на "man"
SELECT name
FROM Passenger
WHERE name like '%man'

-- 5. Вывести количество рейсов, совершенных на TU-134
SELECT COUNT(*) AS count
FROM Trip
WHERE plane = "TU-134"

-- 6. Какие компании совершали перелеты на Boeing
SELECT Company.name
FROM Trip
LEFT JOIN Company ON Company.id = Trip.company
WHERE plane = 'Boeing'
GROUP BY company

-- 7. Вывести все названия самолётов, на которых можно улететь в Москву (Moscow)
SELECT DISTINCT plane
FROM Trip
WHERE town_to = 'Moscow'

-- 8. В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?
-- 9. Какие компании организуют перелеты из Владивостока (Vladivostok)?
SELECT name
FROM Company AS c
LEFT JOIN Trip AS t ON c.id = t.company
WHERE t.town_from = 'Vladivostok'

-- 10. Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г.
SELECT * FROM Trip 
WHERE time_out BETWEEN '1900-01-01T10:00:00.000Z' AND '1900-01-01T14:00:00.000Z'
	
-- 11. Выведите пассажиров с самым длинным ФИО. Пробелы, дефисы и точки считаются частью имени.
SELECT name
FROM passenger
WHERE LENGTH(name) = (SELECT MAX(LENGTH(name)) FROM passenger);

-- 12. Вывести id и количество пассажиров для всех прошедших полётов
SELECT trip, COUNT(passenger) AS count
FROM Pass_in_trip
GROUP BY trip
	
-- 13. Вывести имена людей, у которых есть полный тёзка среди пассажиров
SELECT name
FROM Passenger
GROUP BY name
HAVING COUNT(*) > 1
	
-- 14. В какие города летал Bruce Willis
SELECT DISTINCT town_to
FROM Trip
JOIN Pass_in_trip ON Trip.id = Pass_in_trip.trip
JOIN Passenger ON Pass_in_trip.passenger = Passenger.id
Where name = 'Bruce Willis'
	
-- 15. Выведите дату и время прилёта пассажира Стив Мартин (Steve Martin) в Лондон (London)
SELECT t.time_in
FROM Trip AS t
JOIN Pass_in_trip AS pit ON t.id = trip
JOIN Passenger AS p ON p.id = passenger
WHERE name = 'Steve Martin' AND town_to = 'London'

-- 16. Вывести отсортированный по количеству перелетов (по убыванию) и имени (по возрастанию) список пассажиров, 
       совершивших хотя бы 1 полет.
SELECT p.name, COUNT(passenger) AS count 
FROM Trip AS t JOIN Pass_in_trip AS pit ON t.id = trip 
JOIN Passenger AS p ON p.id = passenger GROUP BY p.name HAVING count >= 1 
ORDER BY count DESC, p.name ASC
	
-- 17. Определить, сколько потратил в 2005 году каждый из членов семьи. 
       В результирующей выборке не выводите тех членов семьи, которые ничего не потратили.
SELECT member_name,status, SUM(unit_price*amount) AS costs
FROM Payments AS p JOIN FamilyMembers AS fm ON p.family_member = fm.member_id 
WHERE date LIKE '2005%' 
GROUP BY family_member

-- 18. Выведите имя самого старшего человека. Если таких несколько, то выведите их всех.
SELECT member_name
fROM FamilyMembers
Order BY birthday ASC 
LIMIT 1

-- 19. Определить, кто из членов семьи покупал картошку (potato)
SELECT status
From FamilyMembers fm
JOIN Payments AS p ON fm.member_id = p.family_member
JOIN Goods AS g ON p.good = g.good_id
WHERE good_name LIKE 'potato'
GROUP BY status

-- 20. Сколько и кто из семьи потратил на развлечения (entertainment). 
       Вывести статус в семье, имя, сумму
SELECT status, member_name, SUM(unit_price*amount) AS costs 
FROM FamilyMembers AS fm 
JOIN Payments AS p ON fm.member_id = p.family_member 
JOIN Goods AS g ON p.good = g.good_id 
JOIN GoodTypes as gp ON g.type = gp.good_type_id 
WHERE good_type_name = 'entertainment' GROUP BY family_member

-- 21. Определить товары, которые покупали более 1 раза
SELECT good_name
FROM Goods
INNER JOIN 
Payments ON Goods.good_id = Payments.good
GROUP BY good
HAVING COUNT(good) > 1
	
-- 22. Найти имена всех матерей (mother)
SELECT member_name
FROM FamilyMembers
WHERE status = "mother"

-- 23. Найдите самый дорогой деликатес (delicacies) и выведите его цену
SELECT good_name,
       unit_price
FROM Goods gs
         JOIN GoodTypes gt ON gs.type = gt.good_type_id
         JOIN Payments ps ON gs.good_id = ps.good
WHERE good_type_name = 'delicacies'
ORDER BY unit_price DESC
LIMIT 1
	
-- 24. Определить кто и сколько потратил в июне 2005
SELECT member_name, SUM(unit_price*amount) as costs 
FROM Payments as p JOIN FamilyMembers as fm ON p.family_member = fm.member_id 
WHERE date LIKE '2005-06%' GROUP BY member_name
	
-- 25. Определить, какие товары не покупались в 2005 году
SELECT good_name
FROM Goods
LEFT JOIN Payments ON Goods.good_id = Payments.good AND YEAR(Payments.date) = 2005 
WHERE Payments.good IS NULL GROUP BY good_id

Второй вариант 
SELECT good_name
FROM Goods
WHERE good_id NOT IN (
    SELECT good
    FROM Payments
    WHERE YEAR(date) = 2005)

-- 26. Определить группы товаров, которые не приобретались в 2005 году
 SELECT good_type_name 
 FROM GoodTypes 
 WHERE good_type_id NOT IN (SELECT good_type_id FROM Goods 
 JOIN Payments ON Goods.good_id = Payments.good AND YEAR(date) = 2005 
 JOIN GoodTypes ON GoodTypes.good_type_id = Goods.type)
	
-- 27. Узнайте, сколько было потрачено на каждую из групп товаров в 2005 году. 
       Выведите название группы и потраченную на неё сумму. Если потраченная сумма равна нулю, 
       т.е. товары из этой группы не покупались в 2005 году, то не выводите её.
SELECT good_type_name, SUM(amount*unit_price) AS costs 
FROM GoodTypes JOIN Goods ON good_type_id = type 
JOIN Payments ON good = good_id AND YEAR(date) = 2005 GROUP BY good_type_name
	
-- 28. Сколько рейсов совершили авиакомпании из Ростова (Rostov) в Москву (Moscow)?
SELECT COUNT(town_from) as COUNT
FROM trip
WHERE town_from = "Rostov" AND town_to = "Moscow"
	
-- 29. Выведите имена пассажиров улетевших в Москву (Moscow) на самолете TU-134
SELECT name
FROM Passenger ps
         JOIN Pass_in_trip pt ON ps.id = pt.passenger
         JOIN Trip tr ON pt.trip = tr.id
WHERE plane = 'TU-134'
  AND town_to = 'Moscow'
GROUP BY name
	
-- 30. Выведите нагруженность (число пассажиров) каждого рейса (trip). 
       Результат вывести в отсортированном виде по убыванию нагруженности.
SELECT trip,
       COUNT(passenger) AS count
FROM Pass_in_trip
GROUP BY trip
ORDER BY count DESC
	
-- 31. Вывести всех членов семьи с фамилией Quincey.
SELECT *
FROM FamilyMembers
WHERE member_name LIKE "%Quincey"
	
-- 32. Вывести средний возраст людей (в годах), хранящихся в базе данных. 
       Результат округлите до целого в меньшую сторону.
SELECT FLOOR(AVG(TIMESTAMPDIFF(YEAR, birthday, CURRENT_TIMESTAMP))) AS age
FROM FamilyMembers

Еще один вариант 
SELECT FLOOR(AVG(FLOOR(DATEDIFF(NOW(), birthday)/365))) AS age
FROM FamilyMembers

-- 33. Найдите среднюю цену икры на основе данных, хранящихся в таблице Payments. 
       В базе данных хранятся данные о покупках красной (red caviar) и черной икры (black caviar). 
       В ответе должна быть одна строка со средней ценой всей купленной когда-либо икры.
SELECT AVG(unit_price) AS cost
FROM Payments ps
JOIN Goods gs ON ps.good = gs.good_id
WHERE good_name = 'red caviar' OR good_name = 'black caviar'
	
-- 34. Сколько всего 10-ых классов
Select COUNT (name) as count
From Class
WHERE name LIKE '10%'

-- 35. Сколько различных кабинетов школы использовались 2 сентября 2019 года для проведения занятий?
SELECT DISTINCT COUNT(classroom) AS count 
FROM Schedule 
WHERE date LIKE '2019-09-02%'

Второй вариант:
SELECT COUNT(DISTINCT classroom) AS count
FROM Student_in_class sc
JOIN Class cl ON sc.class = cl.id
JOIN Schedule sh ON sh.class = cl.id
WHERE DATE_FORMAT(date, '%e.%m.%Y') = '2.09.2019'

-- 36. Выведите информацию об обучающихся живущих на улице Пушкина (ul. Pushkina)?
SELECT *
FROM Student
WHERE address LIKE 'ul. Pushkina%'
	
-- 37. Сколько лет самому молодому обучающемуся?
SELECT TIMESTAMPDIFF(YEAR, birthday, CURRENT_TIMESTAMP) AS year
FROM Student
ORDER BY year ASC
LIMIT 1

-- 38. Сколько Анн (Anna) учится в школе ?
SELECT COUNT(first_name) AS count
FROM Student
WHERE first_name = "Anna"

-- 39. Сколько обучающихся в 10 B классе ?
SELECT COUNT(*) AS count
FROM Student_in_class sc
JOIN Class cl ON sc.class = cl.id
WHERE name = '10 B'

-- 40. Выведите название предметов, которые преподает Ромашкин П.П. (Romashkin P.P.). 
       Обратите внимание, что в базе данных есть несколько учителей с такими фамилией и инициалами.
SELECT name AS subjects
FROM Subject sj
         JOIN Schedule sc ON sj.id = sc.subject
         JOIN Teacher tc ON tc.id = sc.teacher
WHERE last_name = 'Romashkin'
  AND first_name LIKE 'P%'
  AND middle_name LIKE 'P%'

Второй вариант: 
SELECT DISTINCT(Subject.name) AS subjects 
FROM Subject JOIN Schedule ON Subject.id=Schedule.subject 
JOIN Teacher ON Teacher.id=Schedule.teacher AND last_name='Romashkin'
	
-- 41. Выясните, во сколько по расписанию начинается четвёртое занятие.
SELECT start_pair
FROM Timepair
WHERE id = "4"
-- 42. Сколько времени обучающийся будет находиться в школе, учась со 2-го по 4-ый уч. предмет?
SELECT TIMEDIFF(MAX(end_pair), MIN(start_pair)) AS time
FROM Timepair
WHERE id BETWEEN 2 AND 4

Второй вариант:
SELECT DISTINCT TIMEDIFF((SELECT end_pair 
FROM Timepair WHERE id = 4), (SELECT start_pair FROM Timepair WHERE id = 2)) as time FROM Timepair
	
-- 43. Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). Отсортируйте преподавателей по фамилии в алфавитном порядке.
SELECT last_name
FROM Teacher tc
         JOIN Schedule sc ON tc.id = sc.teacher
         JOIN Subject sj ON sj.id = sc.subject
WHERE name = 'Physical Culture'
ORDER BY last_name
	
-- 44. Найдите максимальный возраст (количество лет) среди обучающихся 10 классов на сегодняшний день. 
       Для получения текущих даты и времени используйте функцию NOW().
SELECT FLOOR(MAX((DATEDIFF(NOW(), birthday)/365))) AS max_year 
FROM Student JOIN Student_in_class ON Student.id=Student_in_class.student 
JOIN Class ON Class.id=Student_in_class.class 
WHERE Class.name LIKE '10%'

Второй вариант:
SELECT TIMESTAMPDIFF(YEAR, birthday, CURRENT_TIMESTAMP) AS max_year
FROM Student st
         JOIN Student_in_class sc ON sc.student = st.id
         JOIN Class cl ON cl.id = sc.class
WHERE name LIKE '10 %'
ORDER BY max_year DESC
LIMIT 1

-- 45. Какие кабинеты чаще всего использовались для проведения занятий? Выведите те, которые использовались максимальное количество раз.
SELECT classroom
FROM Schedule
GROUP BY classroom
HAVING count(classroom) = (
    SELECT COUNT(*) AS count
    FROM Schedule
    GROUP BY classroom
    ORDER BY count DESC
    LIMIT 1
);
-- 46. В каких классах введет занятия преподаватель "Krauze" ?
SELECT DISTINCT name 
FROM Class 
JOIN Schedule ON Class.id=Schedule.class 
JOIN Teacher ON Teacher.id=Schedule.teacher 
WHERE last_name = 'Krauze'

Второй вариант: 
SELECT name
FROM Schedule sc
JOIN Teacher tc ON tc.id = sc.teacher
JOIN Class cl ON cl.id = sc.class
WHERE last_name = 'Krauze'
GROUP BY name
	
-- 47. Сколько занятий провел Krauze 30 августа 2019 г.?
SELECT COUNT(teacher) AS count 
FROM Schedule JOIN Teacher ON Teacher.id=Schedule.teacher AND last_name = 'Krauze' 
WHERE date LIKE '2019-08-30%'

Второй вариант:
SELECT COUNT(*) AS count
FROM Schedule sc
JOIN Teacher tc ON tc.id = sc.teacher
WHERE DATE_FORMAT(date, '%e %M %Y') = '30 August 2019'
  AND last_name = 'Krauze'

-- 48. Выведите заполненность классов в порядке убывания
SELECT name, COUNT(class) as count 
FROM Class JOIN Student_in_class ON Class.id=Student_in_class.class 
GROUP BY name
ORDER BY COUNT(*) DESC

Второй вариант: 
SELECT name, COUNT(student) AS count
FROM Class cl
JOIN Student_in_class sc ON sc.class = cl.id
GROUP BY name
ORDER BY count DESC

-- 49. Какой процент обучающихся учится в "10 A" классе? 
       Выведите ответ в диапазоне от 0 до 100 с округлением до четырёх знаков после запятой, например, 96.0201.
SELECT (COUNT(*)*100/(SELECT COUNT(Student.id) as count 
FROM Student 
JOIN Student_in_class ON Student.id=Student_in_class.student)) AS percent 
FROM Student_in_class JOIN Class ON Class.id=Student_in_class.class AND name = '10 A'

-- 50. Какой процент обучающихся родился в 2000 году? Результат округлить до целого в меньшую сторону.
SELECT FLOOR((COUNT(*)*100/(SELECT COUNT(Student.id) as count 
FROM Student JOIN Student_in_class ON Student.id=Student_in_class.student))) AS percent 
FROM Student 
WHERE YEAR(birthday) = 2000
	
-- 51. Добавьте товар с именем "Cheese" и типом "food" в список товаров (Goods).
INSERT INTO Goods
SET good_id   = (SELECT COUNT(*) + 1
FROM Goods AS gs
),
    good_name = 'Cheese',
    type      = (SELECT good_type_id
                 FROM GoodTypes
	         WHERE good_type_name = 'food'
);

Второй вариант:
INSERT INTO Goods(good_id, good_name, type) 
VALUES (17, 'Cheese', 2)
	
-- 52. Добавьте в список типов товаров (GoodTypes) новый тип "auto".
INSERT INTO GoodTypes(good_type_id, good_type_name) 
VALUES (9, 'auto')

Второй варинат:
INSERT INTO GoodTypes
SET good_type_id  = (SELECT COUNT(*) + 1
                       FROM GoodTypes AS gt), good_type_name = 'auto'
	
-- 53. Измените имя "Andie Quincey" на новое "Andie Anthony".
UPDATE FamilyMembers
SET member_name = 'Andie Anthony'
WHERE member_name = 'Andie Quincey'
	
-- 54. Удалить всех членов семьи с фамилией "Quincey".
DELETE 
FROM FamilyMembers 
WHERE member_name LIKE '%Quincey'
	
-- 55. Удалить компании, совершившие наименьшее количество рейсов.
DELETE
FROM company
WHERE id IN (
    SELECT company
    FROM trip
    GROUP BY company
    HAVING COUNT(*) = (
        SELECT COUNT(*) AS count
        FROM trip
        GROUP BY company
        ORDER BY count
        LIMIT 1
    )
);
Второй вариант:
SELECT name, COUNT(company) as company 
FROM Trip JOIN Company ON Company.id=Trip.company 
GROUP BY name; DELETE FROM Company WHERE id = 4; 
DELETE FROM Company 
WHERE id = 3; DELETE 
FROM Company 
WHERE id = 2
	
-- 56. Удалить все перелеты, совершенные из Москвы (Moscow).
DELETE 
FROM Trip 
WHERE town_from = "Moscow" 
	
-- 57. Перенести расписание всех занятий на 30 мин. вперед.
UPDATE Timepair 
SET start_pair = DATE_ADD(start_pair, INTERVAL 30 MINUTE); 
UPDATE Timepair 
SET end_pair = DATE_ADD(end_pair, INTERVAL 30 MINUTE)

Второй вариант: 
UPDATE Timepair
SET start_pair = ADDTIME(start_pair, '00:30:00'),
    end_pair   = ADDTIME(end_pair, '00:30:00');

-- 58. Добавить отзыв с рейтингом 5 на жилье, находящиеся по адресу "11218, Friel Place, New York", от имени "George Clooney"
INSERT INTO Reviews
SET id             = (
    SELECT COUNT(*) + 1
    FROM Reviews rw
),
    reservation_id = (
        SELECT rs.id
        FROM Reservations rs
                 JOIN Rooms rm ON rm.id = rs.room_id
                 JOIN Users us ON rs.user_id = us.id
        WHERE address = '11218, Friel Place, New York'
          AND name = 'George Clooney'
    ),
    rating         = 5;

-- 59. Вывести пользователей,указавших Белорусский номер телефона ? Телефонный код Белоруссии +375.
SELECT * 
FROM Users 
WHERE phone_number LIKE '+375%'

-- 60. Выведите идентификаторы преподавателей, которые хотя бы один раз за всё время преподавали в каждом из одиннадцатых классов.
SELECT teacher
FROM Schedule sc
JOIN Class cl ON sc.class = cl.id
WHERE name LIKE '11 %'
GROUP BY teacher
HAVING COUNT(DISTINCT name) = 2;

-- 61. Выведите список комнат, которые были зарезервированы хотя бы на одни сутки в 12-ую неделю 2020 года. 
       В данной задаче в качестве одной недели примите период из семи дней, первый из которых начинается 1 января 2020 года. 
       Например, первая неделя года — 1–7 января, а третья — 15–21 января.

SELECT Rooms.* 
FROM Rooms 
JOIN Reservations ON Rooms.id=Reservations.room_id AND YEAR(start_date)=2020 AND YEAR(end_date)=2020 
WHERE WEEK(start_date, 1)=12 OR WEEK(end_date, 1)=12

Второй вариант:
SELECT Rooms.*
FROM Reservations
         JOIN Rooms ON Rooms.id = Reservations.room_id
WHERE WEEK(start_date, 1) = 12
  AND YEAR(start_date) = 2020;

-- 62. Вывести в порядке убывания популярности доменные имена 2-го уровня, используемые пользователями для электронной почты. 
       Полученный результат необходимо дополнительно отсортировать по возрастанию названий доменных имён.
SELECT SUBSTRING_INDEX(email, '@', -1) as domain, count(*) AS count 
FROM Users GROUP BY domain 
ORDER BY count DESC, domain ASC

-- 63. Выведите отсортированный список (по возрастанию) фамилий и имен студентов в виде Фамилия.И.
SELECT CONCAT(last_name, '.', LEFT(first_name, 1), '.') AS name
FROM Student
ORDER BY name

-- 64. Вывести количество бронирований по каждому месяцу каждого года, в которых было хотя бы 1 бронирование. 
       Результат отсортируйте в порядке возрастания даты бронирования.
SELECT YEAR(start_date)  AS year,
       MONTH(start_date) AS month,
       COUNT(*)          AS amount
FROM Reservations
GROUP BY YEAR(start_date),
         MONTH(start_date)
ORDER BY year, month

-- 65. Необходимо вывести рейтинг для комнат, которые хоть раз арендовали, как среднее значение рейтинга отзывов округленное до целого вниз.
SELECT room_id, FLOOR(AVG(rating)) AS rating 
FROM Reservations JOIN Reviews ON Reviews.reservation_id=Reservations.id 
GROUP BY room_id
-- 66. Вывести список комнат со всеми удобствами (наличие ТВ, интернета, кухни и кондиционера), 
       а также общее количество дней и сумму за все дни аренды каждой из таких комнат.
SELECT home_type, address, COALESCE(SUM(DATEDIFF(end_date, start_date)), 0) as days, COALESCE(SUM(Reservations.total), 0) AS total_fee 
FROM Reservations RIGHT JOIN Rooms ON Rooms.id=Reservations.room_id 
WHERE has_tv !=0 AND has_internet !=0 AND has_kitchen !=0 AND has_air_con !=0 
GROUP BY address, home_type

-- 67. Вывести время отлета и время прилета для каждого перелета в формате "ЧЧ:ММ, ДД.ММ - ЧЧ:ММ, ДД.ММ", 
       где часы и минуты с ведущим нулем, а день и месяц без.
SELECT CONCAT(
               DATE_FORMAT(time_out, '%H:%i, %e.%c'),
               ' - ',
               DATE_FORMAT(time_in, '%H:%i, %e.%c')
           ) AS flight_time
FROM Trip

-- 68. Для каждой комнаты, которую снимали как минимум 1 раз, найдите имя человека, снимавшего ее последний раз, и дату, когда он выехал
SELECT rs.room_id,
       name,
       date AS end_date
FROM (
         SELECT room_id,
                MAX(end_date) AS date
         FROM Reservations
         GROUP BY room_id
     ) rs
         JOIN Reservations rsv ON rs.room_id = rsv.room_id
    AND rs.date = rsv.end_date
         JOIN Users us ON rsv.user_id = us.id;
-- 69. Вывести идентификаторы всех владельцев комнат, что размещены на сервисе бронирования жилья и сумму, которую они заработали
SELECT owner_id,
       IFNULL(SUM(total), 0) AS total_earn
FROM Rooms rm
         LEFT JOIN Reservations rs ON rm.id = rs.room_id
GROUP BY owner_id;
-- 70. Необходимо категоризовать жилье на economy, comfort, premium по цене соответственно <= 100, 100 < цена < 200, >= 200. 
       В качестве результата вывести таблицу с названием категории и количеством жилья, попадающего в данную категорию
SELECT 
CASE
WHEN price <= 100 THEN 'economy'
WHEN price > 100 AND price < 200 THEN 'comfort'
WHEN price >= 200 THEN 'premium'
END  AS category,
COUNT(price) AS count
FROM Rooms
GROUP BY category;

-- 71. Найдите какой процент пользователей, зарегистрированных на сервисе бронирования, хоть раз арендовали или сдавали в аренду жилье. 
       Результат округлите до сотых.
SELECT ROUND( (SELECT COUNT(*) 
FROM (SELECT DISTINCT owner_id
FROM Rooms rm
JOIN Reservations rs ON rm.id = rs.room_id
UNION
SELECT user_id
FROM Reservations) active_users) * 100 / (
                           SELECT COUNT(*)
                           FROM Users
                       ), 2
           ) AS percent;
-- 72. Выведите среднюю цену бронирования за сутки для каждой из комнат, которую бронировали хотя бы один раз. 
       Среднюю цену необходимо округлить до целого значения вверх.
SELECT room_id,
       CEILING(AVG(price)) AS avg_price
FROM Reservations
GROUP BY room_id

-- 73. Выведите id тех комнат, которые арендовали нечетное количество раз
SELECT room_id,
       COUNT(*) AS count
FROM Reservations
GROUP BY room_id
HAVING count % 2 != 0

-- 74. Выведите идентификатор и признак наличия интернета в помещении. 
Если интернет в сдаваемом жилье присутствует, то выведите «YES», иначе «NO».

SELECT id,
IF(has_internet = 1, 'YES', 'NO') AS has_internet
FROM Rooms;

-- 75. Выведите фамилию, имя и дату рождения студентов, кто был рожден в мае.
SELECT last_name, first_name, birthday
FROM Student
WHERE MONTHNAME(birthday) = 'May'

-- 76. Вывести имена всех пользователей сервиса бронирования жилья, 
       а также два признака: является ли пользователь собственником какого-либо жилья (is_owner) и является ли пользователь арендатором (is_tenant). 
       В случае наличия у пользователя признака необходимо вывести в соответствующее поле 1, иначе 0.
SELECT name,
       IF(
                   id IN (
                   SELECT owner_id
                   FROM Rooms
               ),
                   1,
                   0
           ) AS is_owner,
       IF(
                   id IN (
                   SELECT user_id
                   FROM Reservations
               ),
                   1,
                   0
           ) AS is_tenant
FROM Users;

-- 77. Создайте представление с именем "People", которое будет содержать список имен (first_name) и фамилий (last_name) всех студентов (Student) 
       и преподавателей(Teacher)
CREATE VIEW People AS
SELECT first_name,
       last_name
FROM Student
UNION
SELECT first_name,
       last_name
FROM Teacher;
-- 78. Выведите всех пользователей с электронной почтой в «hotmail.com»
SELECT *
FROM Users
WHERE email RLIKE '@hotmail.com'

-- 79. Выведите поля id, home_type, price у всего жилья из таблицы Rooms. 
       Если комната имеет телевизор и интернет одновременно, то в качестве цены в поле price выведите цену, применив скидку 10%.
SELECT id,
       home_type,
       IF(has_tv AND has_internet, price * 0.9, price) AS price
FROM Rooms

-- 80. Создайте представление «Verified_Users» с полями id, name и email, которое будет показывает только тех пользователей, 
       у которых подтвержден адрес электронной почты.
CREATE VIEW Verified_Users AS
SELECT id, name, email
FROM Users
WHERE email_verified_at IS NOT NULL

-- 93. Какой средний возраст клиентов, купивших Smartwatch (использовать наименование товара product.name) в 2024 году?
SELECT AVG(uniqueCustomers.age) AS average_age
FROM ( SELECT DISTINCT Customer.customer_key, Customer.age
           FROM Purchase
		JOIN Customer ON Purchase.customer_key = Customer.customer_key
		JOIN Product ON Purchase.product_key = Product.product_key
		WHERE Product.name = 'Smartwatch'
			AND YEAR(Purchase.date) = 2024) AS uniqueCustomers
-- 94. Вывести имена покупателей, каждый из которых приобрёл Laptop и Monitor (использовать наименование товара product.name) в марте 2024 года?
SELECT Customer.name
FROM Customer
JOIN Purchase ON Customer.customer_key = Purchase.customer_key
JOIN Product ON Purchase.product_key = Product.product_key
WHERE Product.name IN ('Laptop', 'Monitor')
	AND MONTH(Purchase.date) = 3
	AND YEAR(Purchase.date) = 2024
GROUP BY Customer.customer_key
HAVING COUNT(DISTINCT Product.name) = 2

-- 97. Посчитать количество работающих складов на текущую дату по каждому городу. 
       Вывести только те города, у которых количество складов более 80. Данные на выходе - город, количество складов.
SELECT city, COUNT(warehouse_id) AS warehouse_count
FROM Warehouses
WHERE date_close IS NULL -- Выбираем склады, у которых дата закрытия отсутствует, т.е. работающие
GROUP BY city
HAVING COUNT(warehouse_id) > 80 -- Фильтруем результат, оставляя только города с количеством складов больше 80
ORDER BY city; -- Сортируем по городу

-- 99. Посчитай доход с женской аудитории (доход = сумма(price * items)). 
       Обратите внимание, что в таблице женская аудитория имеет поле user_gender «female» или «f».
SELECT SUM(price * items) AS income_from_female
FROM Purchases
WHERE user_gender = "female" or user_gender = "f"

-- 101. Выведи для каждого пользователя первое наименование, которое он заказал (первое по времени транзакции).
SELECT user_id, item
FROM Transactions t
WHERE t.transaction_ts = (SELECT MIN(transaction_ts)
    FROM Transactions
    WHERE user_id = t.user_id
)
-- 103. Вывести список имён сотрудников, получающих большую заработную плату, чем у непосредственного руководителя.

