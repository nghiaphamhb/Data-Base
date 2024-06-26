-- Сделать запрос для получения атрибутов из указанных таблиц, применив фильтры по указанным условиям:
-- Таблицы: Н_ОЦЕНКИ, Н_ВЕДОМОСТИ.
-- Вывести атрибуты: Н_ОЦЕНКИ.ПРИМЕЧАНИЕ, Н_ВЕДОМОСТИ.ЧЛВК_ИД.
-- Фильтры (AND):
-- a) Н_ОЦЕНКИ.ПРИМЕЧАНИЕ > хорошо.
-- b) Н_ВЕДОМОСТИ.ИД < 1426978.
-- Вид соединения: INNER JOIN.

SELECT "Н_ОЦЕНКИ"."ПРИМЕЧАНИЕ", "Н_ВЕДОМОСТИ"."ЧЛВК_ИД"
FROM "Н_ОЦЕНКИ"
INNER JOIN "Н_ВЕДОМОСТИ" ON "Н_ОЦЕНКИ"."КОД" = "Н_ВЕДОМОСТИ"."ОЦЕНКА"
WHERE "Н_ОЦЕНКИ"."ПРИМЕЧАНИЕ" > 'хорошо'
AND "Н_ВЕДОМОСТИ"."ИД" < 1426978;

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Сделать запрос для получения атрибутов из указанных таблиц, применив фильтры по указанным условиям:
-- Таблицы: Н_ЛЮДИ, Н_ВЕДОМОСТИ, Н_СЕССИЯ.
-- Вывести атрибуты: Н_ЛЮДИ.ФАМИЛИЯ, Н_ВЕДОМОСТИ.ДАТА, Н_СЕССИЯ.ИД.
-- Фильтры (AND):
-- a) Н_ЛЮДИ.ИМЯ < Александр.
-- b) Н_ВЕДОМОСТИ.ЧЛВК_ИД > 142390.
-- c) Н_СЕССИЯ.ИД > 14369.
-- Вид соединения: INNER JOIN.

SELECT "Н_ЛЮДИ"."ФАМИЛИЯ", "Н_ВЕДОМОСТИ"."ДАТА", "Н_СЕССИЯ"."ИД"
FROM "Н_ЛЮДИ"
INNER JOIN "Н_ВЕДОМОСТИ" ON "Н_ЛЮДИ"."ИД" = "Н_ВЕДОМОСТИ"."ЧЛВК_ИД"
INNER JOIN "Н_СЕССИЯ" ON "Н_ЛЮДИ"."ИД" = "Н_СЕССИЯ"."ЧЛВК_ИД"
WHERE "Н_ЛЮДИ"."ИМЯ" < 'Александр'
AND "Н_ВЕДОМОСТИ"."ЧЛВК_ИД" > 142390
AND "Н_СЕССИЯ"."ИД" > 14369;

-----------------------------------------------------------------------------------------------------------------------------------------------
--  Составить запрос, который ответит на вопрос, есть ли среди студентов вечерней формы обучения те, кто не имеет отчества.

SELECT DISTINCT 'ЕСТЬ' AS "ОТВЕТ"
FROM "Н_УЧЕНИКИ"
INNER JOIN "Н_ЛЮДИ" ON "Н_УЧЕНИКИ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД"
INNER JOIN "Н_ПЛАНЫ" ON "Н_УЧЕНИКИ"."ПЛАН_ИД" = "Н_ПЛАНЫ"."ИД"
INNER JOIN "Н_ФОРМЫ_ОБУЧЕНИЯ" ON "Н_ПЛАНЫ"."ФО_ИД" = "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИД"
WHERE "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИМЯ_В_РОД_ПАДЕЖЕ" = 'вечерней'
AND "Н_ЛЮДИ"."ОТЧЕСТВО" = '.';

-----------------------------------------------------------------------------------------------------------------------------------------------
-- В таблице Н_ГРУППЫ_ПЛАНОВ найти номера планов, по которым обучается (обучалось) ровно 2 групп на заочной форме обучения.
-- Для реализации использовать подзапрос.

SELECT "Н_ПЛАНЫ"."НОМЕР" 
FROM "Н_ПЛАНЫ"
WHERE (
    SELECT COUNT(*) 
    FROM "Н_ГРУППЫ_ПЛАНОВ" 
    WHERE "Н_ПЛАНЫ"."ПЛАН_ИД" = "Н_ГРУППЫ_ПЛАНОВ"."ПЛАН_ИД" 
    AND "Н_ПЛАНЫ"."ПЛАН_ИД" IN (
        SELECT "Н_ПЛАНЫ"."ПЛАН_ИД" 
        FROM "Н_ПЛАНЫ"
        INNER JOIN "Н_ФОРМЫ_ОБУЧЕНИЯ" ON "Н_ПЛАНЫ"."ФО_ИД" = "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИД"
        WHERE "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИМЯ_В_ПРЕД_ПАДЕЖЕ" = 'заочной'
    )
) = 2;

-- SELECT "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИД"
-- FROM "Н_ФОРМЫ_ОБУЧЕНИЯ"
-- WHERE "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИМЯ_В_ПРЕД_ПАДЕЖЕ" = 'заочной'; // ид- это 3

-- SELECT COUNT(*)
-- FROM "Н_ПЛАНЫ"
-- WHERE "Н_ПЛАНЫ"."ФО_ИД" = 3; //0 т. е. никто не обучались на заочной форме обучения

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Выведите таблицу со средними оценками студентов группы 4100 (Номер, ФИО, Ср_оценка), у которых средняя оценка равна средней оценк(е|и) в группе 3100.

SELECT 
    "Номер",
    "ФИО",
    "Ср_оценка"
FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY "Н_ЛЮДИ"."ФАМИЛИЯ" ASC) AS "Номер",
        CONCAT("Н_ЛЮДИ"."ФАМИЛИЯ", ' ', "Н_ЛЮДИ"."ИМЯ", ' ', "Н_ЛЮДИ"."ОТЧЕСТВО") AS "ФИО",
        ROUND(AVG(CAST("Н_ВЕДОМОСТИ"."ОЦЕНКА" AS numeric)), 2) AS "Ср_оценка"
    FROM 
        "Н_УЧЕНИКИ"
    INNER JOIN 
        "Н_ЛЮДИ" ON "Н_ЛЮДИ"."ИД" = "Н_УЧЕНИКИ"."ЧЛВК_ИД"
    INNER JOIN 
        "Н_ВЕДОМОСТИ" ON "Н_ВЕДОМОСТИ"."ЧЛВК_ИД" = "Н_УЧЕНИКИ"."ЧЛВК_ИД"
    WHERE 
        "Н_УЧЕНИКИ"."ГРУППА" = '4100'
        AND "Н_ВЕДОМОСТИ"."ОЦЕНКА" IN ('2', '3', '4', '5')
    GROUP BY 
        "Н_УЧЕНИКИ"."ЧЛВК_ИД", "Н_ЛЮДИ"."ФАМИЛИЯ", "Н_ЛЮДИ"."ИМЯ", "Н_ЛЮДИ"."ОТЧЕСТВО"
) AS sup 
WHERE 
    "Ср_оценка" IN (
        SELECT ROUND(AVG(CAST("Н_ВЕДОМОСТИ"."ОЦЕНКА" AS numeric)), 2) 
        FROM "Н_ВЕДОМОСТИ"
        INNER JOIN "Н_УЧЕНИКИ" ON "Н_ВЕДОМОСТИ"."ЧЛВК_ИД" = "Н_УЧЕНИКИ"."ЧЛВК_ИД"
        WHERE "Н_УЧЕНИКИ"."ГРУППА" = '3100'
        AND "Н_ВЕДОМОСТИ"."ОЦЕНКА" IN ('2', '3', '4', '5')
    );

    
-----------------------------------------------------------------------------------------------------------------------------------------------
-- Получить список студентов, зачисленных ровно первого сентября 2012 года на первый курс заочной формы обучения. В результат включить:
-- номер группы;
-- номер, фамилию, имя и отчество студента;
-- номер и состояние пункта приказа;
-- Для реализации использовать подзапрос с EXISTS.

SELECT 
    "Н_УЧЕНИКИ"."ГРУППА" AS "номер группы",
    CONCAT("Н_ЛЮДИ"."ФАМИЛИЯ", ' ', "Н_ЛЮДИ"."ИМЯ", ' ', "Н_ЛЮДИ"."ОТЧЕСТВО") AS "ФИО",
    "Н_УЧЕНИКИ"."СОСТОЯНИЕ"
FROM 
    "Н_УЧЕНИКИ"
INNER JOIN 
    "Н_ЛЮДИ" ON "Н_ЛЮДИ"."ИД" = "Н_УЧЕНИКИ"."ЧЛВК_ИД" 
INNER JOIN 
    "Н_ПЛАНЫ" ON "Н_ПЛАНЫ"."ПЛАН_ИД" = "Н_УЧЕНИКИ"."ПЛАН_ИД"
INNER JOIN 
    "Н_ФОРМЫ_ОБУЧЕНИЯ" ON "Н_ПЛАНЫ"."ФО_ИД" = "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИД" 
    AND "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИМЯ_В_РОД_ПАДЕЖЕ" = 'заочной'
INNER JOIN 
    "Н_СЕССИЯ" ON "Н_СЕССИЯ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД" 
    AND "Н_СЕССИЯ"."СЕМЕСТР" IN ('1', '2')
WHERE EXISTS (
    SELECT *
    FROM "Н_УЧЕНИКИ"
    WHERE DATE("Н_УЧЕНИКИ"."НАЧАЛО") = '2012-09-01'
    AND "Н_УЧЕНИКИ"."СОСТОЯНИЕ" = 'утвержден'
)
GROUP BY "Н_УЧЕНИКИ"."ГРУППА", "Н_ЛЮДИ"."ФАМИЛИЯ", "Н_ЛЮДИ"."ИМЯ", "Н_ЛЮДИ"."ОТЧЕСТВО", "Н_УЧЕНИКИ"."СОСТОЯНИЕ";

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Вывести список студентов, имеющих одинаковые отчества, но не совпадающие ид.

SELECT DISTINCT 
    "Н_ЛЮДИ"."ОТЧЕСТВО",
    "Н_ЛЮДИ"."ИМЯ",
    "Н_ЛЮДИ"."ФАМИЛИЯ",
    "Н_УЧЕНИКИ"."ИД"
FROM 
    "Н_УЧЕНИКИ"
INNER JOIN
    "Н_ЛЮДИ" ON "Н_УЧЕНИКИ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД"
WHERE 
    "Н_ЛЮДИ"."ОТЧЕСТВО" <> '.'
    AND "Н_ЛЮДИ"."ИМЯ" <> '.'
    AND "Н_ЛЮДИ"."ФАМИЛИЯ" <> '.'
    AND "Н_ЛЮДИ"."ОТЧЕСТВО" IN (
        SELECT "Н_ЛЮДИ"."ОТЧЕСТВО"
        FROM "Н_ЛЮДИ"
        GROUP BY "Н_ЛЮДИ"."ОТЧЕСТВО"
        HAVING COUNT(*) >=2
    )
ORDER BY
    "Н_ЛЮДИ"."ОТЧЕСТВО";