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
-- 11. Выведите пассажиров с самым длинным ФИО. Пробелы, дефисы и точки считаются частью имени.
-- 12. Вывести id и количество пассажиров для всех прошедших полётов
SELECT trip, COUNT(passenger) AS count
FROM Pass_in_trip
GROUP BY trip
	
-- 13. Вывести имена людей, у которых есть полный тёзка среди пассажиров
	
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
-- 17. Определить, сколько потратил в 2005 году каждый из членов семьи. 
       В результирующей выборке не выводите тех членов семьи, которые ничего не потратили.
-- 18. Выведите имя самого старшего человека. Если таких несколько, то выведите их всех.
-- 19. Определить, кто из членов семьи покупал картошку (potato)
SELECT status
From FamilyMembers fm
JOIN Payments AS p ON fm.member_id = p.family_member
JOIN Goods AS g ON p.good = g.good_id
WHERE good_name LIKE 'potato'
GROUP BY status

-- 20. Сколько и кто из семьи потратил на развлечения (entertainment). Вывести статус в семье, имя, сумму
-- 21. Определить товары, которые покупали более 1 раза
-- 22. Найти имена всех матерей (mother)
SELECT member_name
FROM FamilyMembers
WHERE status = "mother"

-- 23. Найдите самый дорогой деликатес (delicacies) и выведите его цену
-- 24. Определить кто и сколько потратил в июне 2005
-- 25. Определить, какие товары не покупались в 2005 году
-- 26. Определить группы товаров, которые не приобретались в 2005 году
-- 27. Узнайте, сколько было потрачено на каждую из групп товаров в 2005 году. 
       Выведите название группы и потраченную на неё сумму. Если потраченная сумма равна нулю, 
       т.е. товары из этой группы не покупались в 2005 году, то не выводите её.
-- 28. Сколько рейсов совершили авиакомпании из Ростова (Rostov) в Москву (Moscow)?
SELECT COUNT(town_from) as COUNT
FROM trip
WHERE town_from = "Rostov" AND town_to = "Moscow"
	
-- 29. Выведите имена пассажиров улетевших в Москву (Moscow) на самолете TU-134
-- 30. Выведите нагруженность (число пассажиров) каждого рейса (trip). 
       Результат вывести в отсортированном виде по убыванию нагруженности.
-- 31. Вывести всех членов семьи с фамилией Quincey.
-- 32. Вывести средний возраст людей (в годах), хранящихся в базе данных. 
       Результат округлите до целого в меньшую сторону.
-- 33. Найдите среднюю цену икры на основе данных, хранящихся в таблице Payments. 
       В базе данных хранятся данные о покупках красной (red caviar) и черной икры (black caviar). 
       В ответе должна быть одна строка со средней ценой всей купленной когда-либо икры.
	
-- 34. Сколько всего 10-ых классов
Select COUNT (name) as count
From Class
WHERE name LIKE '10%'

-- 35. Сколько различных кабинетов школы использовались 2 сентября 2019 года для проведения занятий?
-- 36. Выведите информацию об обучающихся живущих на улице Пушкина (ul. Pushkina)?
SELECT *
FROM Student
WHERE address LIKE 'ul. Pushkina%'
	
-- 37. Сколько лет самому молодому обучающемуся ?

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
-- 41. Выясните, во сколько по расписанию начинается четвёртое занятие.
-- 42. Сколько времени обучающийся будет находиться в школе, учась со 2-го по 4-ый уч. предмет?
-- 43. Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). Отсортируйте преподавателей по фамилии в алфавитном порядке.
-- 44. Найдите максимальный возраст (количество лет) среди обучающихся 10 классов на сегодняшний день. 
       Для получения текущих даты и времени используйте функцию NOW().
-- 45. Какие кабинеты чаще всего использовались для проведения занятий? Выведите те, которые использовались максимальное количество раз.
-- 46. В каких классах введет занятия преподаватель "Krauze" ?
-- 47. Сколько занятий провел Krauze 30 августа 2019 г.?
-- 48. Выведите заполненность классов в порядке убывания
-- 49. Какой процент обучающихся учится в "10 A" классе? 
       Выведите ответ в диапазоне от 0 до 100 с округлением до четырёх знаков после запятой, например, 96.0201.
-- 50. Какой процент обучающихся родился в 2000 году? Результат округлить до целого в меньшую сторону.
-- 51. Добавьте товар с именем "Cheese" и типом "food" в список товаров (Goods).
-- 52. Добавьте в список типов товаров (GoodTypes) новый тип "auto".
-- 53. Измените имя "Andie Quincey" на новое "Andie Anthony".
-- 54. Удалить всех членов семьи с фамилией "Quincey".
-- 55. Удалить компании, совершившие наименьшее количество рейсов.
-- 56. Удалить все перелеты, совершенные из Москвы (Moscow).
-- 57. Перенести расписание всех занятий на 30 мин. вперед.
-- 58. Добавить отзыв с рейтингом 5 на жилье, находящиеся по адресу "11218, Friel Place, New York", от имени "George Clooney"
-- 59. Вывести пользователей,указавших Белорусский номер телефона ? Телефонный код Белоруссии +375.
-- 60. Выведите идентификаторы преподавателей, которые хотя бы один раз за всё время преподавали в каждом из одиннадцатых классов.
-- 61. Выведите список комнат, которые были зарезервированы хотя бы на одни сутки в 12-ую неделю 2020 года. 
       В данной задаче в качестве одной недели примите период из семи дней, первый из которых начинается 1 января 2020 года. 
       Например, первая неделя года — 1–7 января, а третья — 15–21 января.
-- 62. Вывести в порядке убывания популярности доменные имена 2-го уровня, используемые пользователями для электронной почты. 
       Полученный результат необходимо дополнительно отсортировать по возрастанию названий доменных имён.
-- 63. Выведите отсортированный список (по возрастанию) фамилий и имен студентов в виде Фамилия.И.
-- 64. Вывести количество бронирований по каждому месяцу каждого года, в которых было хотя бы 1 бронирование. 
       Результат отсортируйте в порядке возрастания даты бронирования.
-- 65. Необходимо вывести рейтинг для комнат, которые хоть раз арендовали, как среднее значение рейтинга отзывов округленное до целого вниз.
-- 66. Вывести список комнат со всеми удобствами (наличие ТВ, интернета, кухни и кондиционера), 
       а также общее количество дней и сумму за все дни аренды каждой из таких комнат.
-- 67. Вывести время отлета и время прилета для каждого перелета в формате "ЧЧ:ММ, ДД.ММ - ЧЧ:ММ, ДД.ММ", 
       где часы и минуты с ведущим нулем, а день и месяц без.
-- 68. Для каждой комнаты, которую снимали как минимум 1 раз, найдите имя человека, снимавшего ее последний раз, и дату, когда он выехал
-- 69. Вывести идентификаторы всех владельцев комнат, что размещены на сервисе бронирования жилья и сумму, которую они заработали
-- 70. Необходимо категоризовать жилье на economy, comfort, premium по цене соответственно <= 100, 100 < цена < 200, >= 200. 
       В качестве результата вывести таблицу с названием категории и количеством жилья, попадающего в данную категорию
-- 71. Найдите какой процент пользователей, зарегистрированных на сервисе бронирования, хоть раз арендовали или сдавали в аренду жилье. 
       Результат округлите до сотых.
-- 72. Выведите среднюю цену бронирования за сутки для каждой из комнат, которую бронировали хотя бы один раз. 
       Среднюю цену необходимо округлить до целого значения вверх.
-- 73. Выведите id тех комнат, которые арендовали нечетное количество раз
-- 74. Выведите идентификатор и признак наличия интернета в помещении. 
       Если интернет в сдаваемом жилье присутствует, то выведите «YES», иначе «NO».
-- 75. Выведите фамилию, имя и дату рождения студентов, кто был рожден в мае.
SELECT last_name, first_name, birthday
FROM Student
WHERE MONTHNAME(birthday) = 'May'

-- 76. Вывести имена всех пользователей сервиса бронирования жилья, 
       а также два признака: является ли пользователь собственником какого-либо жилья (is_owner) и является ли пользователь арендатором (is_tenant). 
       В случае наличия у пользователя признака необходимо вывести в соответствующее поле 1, иначе 0.
-- 77. Создайте представление с именем "People", которое будет содержать список имен (first_name) и фамилий (last_name) всех студентов (Student) 
       и преподавателей(Teacher)
-- 78. Выведите всех пользователей с электронной почтой в «hotmail.com»
-- 79. Выведите поля id, home_type, price у всего жилья из таблицы Rooms. 
       Если комната имеет телевизор и интернет одновременно, то в качестве цены в поле price выведите цену, применив скидку 10%.
-- 80. Создайте представление «Verified_Users» с полями id, name и email, которое будет показывает только тех пользователей, 
       у которых подтвержден адрес электронной почты.
-- 93. Какой средний возраст клиентов, купивших Smartwatch (использовать наименование товара product.name) в 2024 году?
-- 94. Вывести имена покупателей, каждый из которых приобрёл Laptop и Monitor (использовать наименование товара product.name) в марте 2024 года?
-- 97. Посчитать количество работающих складов на текущую дату по каждому городу. 
       Вывести только те города, у которых количество складов более 80. Данные на выходе - город, количество складов.
-- 99. Посчитай доход с женской аудитории (доход = сумма(price * items)). 
       Обратите внимание, что в таблице женская аудитория имеет поле user_gender «female» или «f».
SELECT SUM(price * items) AS income_from_female
FROM Purchases
WHERE user_gender = "female" or user_gender = "f"

-- 101. Выведи для каждого пользователя первое наименование, которое он заказал (первое по времени транзакции).
-- 103. Вывести список имён сотрудников, получающих большую заработную плату, чем у непосредственного руководителя.

