-- create table --
CREATE TABLE MATZIP (
    FOOD_ID NUMBER(8),                      -- unique number for food (primary key)
    RESTAURANT_NAME VARCHAR(20) NOT NULL,   -- restaurant name
    PRIZE NUMBER(8),                        -- food prize
    FOOD_KIND VARCHAR(20),                  -- category of food (e.g. '한식', '중식' etc)
    LOC VARCHAR(20),                        -- location of restaurant (e.g. '서울', '대전' etc)
    OPEN_DATE DATE,                         -- the opening date of restaurant
    primary key (FOOD_ID)
);
-- insert 5 data --
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES (1, 'Gopizza', 10000, '양식', '서울', '2023-01-15');
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES (2, 'BBQ', 18000, '패스트푸드', '평창', '2002-01-23');
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES (3, 'NuovoNaples', 9000, '양식', '대전', '2021-01-15');
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES (4, 'ebiga', 11000, '중식', '대전', '2017-04-29');
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, OPEN_DATE)
    VALUES (5, 'bibimbap', 14000, '한식', '2002-11-20');

-- display table --
SELECT * FROM MATZIP;

-- Q1. search data that satisfy condition --
-- condition : 식당이름의 길이가 5 이상 => 식당이름과 음식종류 display --
SELECT RESTAURANT_NAME AS 식당이름, FOOD_KIND AS 음식종류
FROM MATZIP
WHERE LENGTH(RESTAURANT_NAME) > 5;

-- Q2. search data that satisfy condition --
-- condition : 식당이름의 길이가 5 이상 => 식당이름과 음식종류 display --
-- 정렬방식은 가격을 기준으로 내림차순 정렬 (비싼 음식을 파는 식당부터 display) --
SELECT RESTAURANT_NAME AS 식당이름, FOOD_KIND AS 음식종류, PRIZE AS 가격
FROM MATZIP
WHERE MOD(PRIZE, 10000) > 3000
ORDER BY PRIZE DESC;

-- Q3. search data that satisfy condition --
-- condition : 개업년도가 2015년 이후 --
-- 식당이름과, 오픈년도, 오픈월, 오픈일 display --
SELECT RESTAURANT_NAME AS 식당이름,
       EXTRACT(YEAR FROM OPEN_DATE) 오픈년도,
       EXTRACT(MONTH FROM OPEN_DATE) 오픈월,
       EXTRACT(DAY FROM OPEN_DATE) 오픈일
FROM MATZIP
WHERE OPEN_DATE > '2015-01-01'
ORDER BY 오픈년도;

-- Q4.change data that satisfy condition --
-- 양식이면 가격 10%씩 인상 --
-- 식당이름과 기존가격, 인상가격, 음식종류 display --
SELECT RESTAURANT_NAME AS 식당이름,
       PRIZE AS 기존가격,
       CASE WHEN FOOD_KIND = '양식'
            THEN PRIZE*1.1
            ELSE PRIZE
        END AS 인상가격,
        FOOD_KIND AS 음식종류
FROM MATZIP;

-- Q5.use two or more condition --
-- 지역이 null 이 아니고, 1월 또는 11월에 개업한 식당 list 출력 --
-- 식당이름과 지역, 오픈날짜 display --

-- 식당이름과 지역, 오픈날짜 조회 (개업일자는 형태를 “2024년 04월 05일” 과 같은 형태로 변환해 출력 --
SELECT RESTAURANT_NAME AS 식당이름,
       LOC AS 지역,
       TO_CHAR(OPEN_DATE, 'YYYY"년" MM"월" DD"일"') AS 오픈날짜
-- MATZIP table에서 --
FROM MATZIP
-- 개업월이 1월 또는 11월이거나, 지역이 null 값이 아닌 경우 --
WHERE TO_CHAR(OPEN_DATE, 'MM') IN ('01', '11');
    AND NVL(LOC, 'x') != 'x';

-- delete table --
DROP TABLE MATZIP;