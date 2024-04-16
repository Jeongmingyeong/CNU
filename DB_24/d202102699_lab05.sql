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
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES (6, 'momstouch', 7000, '패스트푸드', '평창', '2002-11-03');
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES (7, 'sushi', 18000, '일식', '평창', '2012-02-01');
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, FOOD_KIND, LOC, OPEN_DATE)
    VALUES (8, 'gyoban', '한식', '세종', '2024-01-01');
    
-- Q1. 두개 이상의 조건을 만족하는 SQL 문 작성. 결과는 정렬해 출력 --
SELECT *
FROM MATZIP
WHERE (OPEN_DATE > '2010-01-01')    -- 조건1. 개업일자가 2010년 이후인 경우 -- 
AND (PRIZE >= 10000)                -- 조건2. 가격이 10000원 이상인 경우 --
ORDER BY OPEN_DATE;                 -- 오픈한지 오래된 가게부터 출력 --



-- Q2. 집계함수 사용해 데이터 분석 & 분석 결과가 특정 조건을 만족하는 경우 출력 --
-- 전체 데이터 개수, loc 개수 count해서 출력 --
-- 1) 지역별 식당개수를 count 집계함수를 사용해서 분석 --
-- 2) 지역별 최대금액을 MAX 집계함수를 사용해서 분석 --
-- 집계함수를 사용하여 분석한 데이터 (지역별 식당개수, 지역별 최대금액) 출력 --
SELECT LOC AS "지역", COUNT(LOC) "지역 별 식당 개수", MAX(PRIZE) "지역 별 최대 금액"
FROM MATZIP     -- MATZIP table 에서 --
GROUP BY LOC    -- 위치 기준으로 group 지음 --
HAVING MAX(PRIZE) > 10000 AND COUNT(LOC) >= 2 -- 지역별 최대금액이 10000원 이상이며, 그 지역에 있는 식당개수가 2개 이상인 경우에 한정 --
ORDER BY "지역 별 식당 개수" desc, "지역 별 최대 금액" desc; -- 집계함수를 사용한 data 의 내림차순으로 정렬 --
    
    
-- Q3. 카테고리별로 데이터를 그룹화하여 집계 (NULL 값을 갖는 열도 집계대상에 포함되도록) --
-- 위치로 그룹화했기 때문에 위치 조회, 지역 별 모든 식당을 방문했을 때 소요비용, 지역별 식당개수를 집계함수를 사용해서 구함. --
-- 이때 두번째 조건인 NULL 값을 가지는 열에 대해서도 처리하는 것을 만족시키고자 NVL 함수를 사용해서 가격이 NULL 이면 0으로 변경해 sum 하도록 구현 --
SELECT LOC AS "지역", NVL(SUM(PRIZE), 0) AS "지역 별 모든 식당을 방문했을 때 소요비용", COUNT(LOC) "지역 별 식당 개수" 
FROM MATZIP     -- MATZIP table 에서 --
GROUP BY LOC    -- 위치 기준으로 그룹화 --
HAVING LOC IS NOT NULL; -- 위치가 널인 경우 제외하고 출력 --

-- Q4. 카테고리별로 데이터를 그룹화하여 집계 (최소 3개의 조건 명시) --
-- 가게 위치를 기준으로 그룹화 한 후, 그 지역에서 개업년도를 기준으로 개수를 count 해서 출력 --
-- 기준 년도는 2020년대, 2010년대, 2000년대, 2000년대 이전을 case 함수를 사용해서 조회 --
SELECT LOC AS "지역",
       NVL(SUM(CASE WHEN EXTRACT(YEAR FROM OPEN_DATE) >= 2020 THEN 1 END), 0) "2020년대 개업 식당개수", 
       NVL(SUM(CASE WHEN 2020 > EXTRACT(YEAR FROM OPEN_DATE) AND EXTRACT(YEAR FROM OPEN_DATE) >= 2010 THEN 1 END), 0) "2010년대 개업 식당개수",
       NVL(SUM(CASE WHEN 2010 > EXTRACT(YEAR FROM OPEN_DATE) AND EXTRACT(YEAR FROM OPEN_DATE) >= 2000 THEN 1 END), 0) "2000년대 개업 식당개수",
       NVL(SUM(CASE WHEN EXTRACT(YEAR FROM OPEN_DATE) < 2000 THEN 1 END), 0) "2000년대 이전 개업 식당개수",
       COUNT(RESTAURANT_NAME) "총 식당 개수"
FROM MATZIP
GROUP BY LOC
HAVING LOC IS NOT NULL; -- 위치가 null 인 경우 제외하고 조회 --

-- Q5. 조건을 만족하는 데이터를 정렬하여 상위 5개 출력 --
SELECT *
FROM MATZIP
WHERE PRIZE >= 9000 -- 가격이 9000원 이상인 경우만 조회 --
ORDER BY PRIZE      -- 가격을 기준으로 오름차순 정렬 --
FETCH FIRST 5 ROWS ONLY; -- 오름차순 정렬에서 상위 5개 행만 출력 --

-- delete table --
DROP TABLE MATZIP;
