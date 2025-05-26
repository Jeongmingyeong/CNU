drop table MATZIP1;
drop table REVIEWER;

-- create table1 : information of restaurant --
CREATE TABLE MATZIP1 (
    TELEPHONE VARCHAR(12),                  -- telephone number of restaurant (primary key)
    RESTAURANT_NAME VARCHAR(20) NOT NULL,   -- restaurant name
    PRICE NUMBER(8),                        -- food price
    FOOD_KIND VARCHAR(20),                  -- category of food (e.g. '한식', '중식' etc)
    LOC VARCHAR(20),                        -- location of restaurant (e.g. '서울', '대전' etc)
    OPEN_DATE DATE,                         -- the opening date of restaurant
    primary key (TELEPHONE)
);

-- create table2 : reviewer --
CREATE TABLE REVIEWER (
    REVIEWER_ID VARCHAR(12),                -- unique reviewer id
    REVIEWER_NAME VARCHAR(20),              -- reviewer name 
    REVIEWER_EMAIL VARCHAR(20),             -- reviewer email
    PRIMARY KEY(REVIEWER_ID)
);



-- insert 8 data into MATZIP1 table --
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('02-111-2222', 'Gopizza', 10000, '양식', '서울', '2023-01-15');
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('033-333-4444', 'BBQ', 18000, '패스트푸드', '평창', '2002-01-23');
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('042-333-6666', 'NuovoNaples', 9000, '양식', '대전', '2021-01-15');
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('042-123-4567', 'ebiga', 11000, '중식', '대전', '2017-04-29');
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('000-000-0001', 'bibimbap', 14000, '한식', '대전', '2002-11-20');
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('033-333-9374', 'momstouch', 7000, '패스트푸드', '평창', '2002-11-03');
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('033-333-5234', 'sushi', 18000, '일식', '평창', '2012-02-01');
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('000-000-0000', 'gyoban', 9500, '한식', '세종', '2024-01-01');

-- insert 5 data into REVIEWER table --
INSERT INTO REVIEWER (REVIEWER_ID, REVIEWER_NAME, REVIEWER_EMAIL)
    VALUES ('jmink002', '민경', 'jmink002@naver.com');
INSERT INTO REVIEWER (REVIEWER_ID, REVIEWER_NAME, REVIEWER_EMAIL)
    VALUES ('rbf119', '귤', 'rbf119@gmail.com');
INSERT INTO REVIEWER (REVIEWER_ID, REVIEWER_NAME, REVIEWER_EMAIL)
    VALUES ('rlczl', '아지', 'rlczl@gmail.com');
INSERT INTO REVIEWER (REVIEWER_ID, REVIEWER_NAME, REVIEWER_EMAIL)
    VALUES ('zinzero', '노트북', 'zinzero@naver.com');
INSERT INTO REVIEWER (REVIEWER_ID, REVIEWER_NAME, REVIEWER_EMAIL)
    VALUES ('eclipse', 'candy', 'ecp@gmail.com');

-- Q1-1 . ROLLUP 함수를 이용하여 데이터 집계 정보 검색 --
-- 지역과 음식종류 기준으로 식당개수, 평균가격 정보 출력 --
SELECT LOC as 지역, FOOD_KIND as 음식종류,
        COUNT(*) as 식당개수, AVG(PRICE) as 평균가격
FROM MATZIP1
-- 지역에 대해 group으로 묶은 후 각 지역의 식당개수, 평균가격에 대한 통계정보 출력 --
GROUP BY ROLLUP (LOC, FOOD_KIND)
-- 지역, 음식종류에 대한 내림차순 정렬 --
ORDER BY LOC, FOOD_KIND;

-- Q1-2. CUBE 함수를 이용하여 데이터 집계 정보 검색 --
-- 지역과 음식종류 기준으로 식당개수, 평균가격 정보 출력 --
SELECT LOC as 지역, FOOD_KIND as 음식종류,
        COUNT(*) as 식당개수, AVG(PRICE) as 평균가격
FROM MATZIP1
-- 지역에 대해 group으로 묶은 후 각 지역의 식당개수, 평균가격에 대한 통계정보 출력 --
-- CUBE를 사용했기 때문에 지역에 대한 통계정보와, 음식종류에 대한 통계정보 출력 --
GROUP BY CUBE (LOC, FOOD_KIND)
ORDER BY LOC, FOOD_KIND;


-- Q2. RANK() 함수를 이용하여 검색 정보에 대한 순위 출력 --
-- 같은 음식종류 별 가격 순위 검색 --
SELECT FOOD_KIND as 음식종류, LOC as 지역, RESTAURANT_NAME as 식당이름, PRICE as 가격,
    -- RANK 함수를 사용해서 각 음식종류별 가격에 대한 순위를 나타냄. --
    -- 이때 PRICE에 대해 내림차순 정렬했기 때문에 비싼 음식이 더 높은 순위로 출력됨. --
    RANK() OVER (PARTITION BY FOOD_KIND ORDER BY PRICE DESC) as 가격순위
FROM MATZIP1;
    

-- Q3. FIRST(or LAST)_VALUE() 함수를 이용하여 파티션 별 처음(또는 마지막) 값 출력 --
-- 지역 별 음식가격에 대해 내림차순 정렬 후 가장 저렴한 식당 출력 --
SELECT LOC as 지역, FOOD_KIND as 음식종류, PRICE as 가격,
    -- PARTITION BY LOC을 통해 각 지역별로 파티션함을 명시 --
    -- 가격에 대해 내림차순 정렬한 정보에서 LAST_VALUE를 가져올 것임. --
    -- 내가 보고자 하는 범위는 앞뒤로 UNBOUNDED 를 사용해 파티션된 전체 범위를 보고자 함. --
    LAST_VALUE(RESTAURANT_NAME) OVER (PARTITION BY LOC ORDER BY PRICE DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as 최저가격식당
FROM MATZIP1;

-- Q4. PIVOT 함수를 이용하여 데이터 집계 정보 검색 --
-- 지역에 따라 column 정보를 food_kind 로 설정하여 각각의 지역에 있는 음식 평균가격 출력 --
SELECT *
FROM (SELECT LOC, FOOD_KIND, PRICE FROM MATZIP1)
-- PIVOT 함수를 사용해 각각의 음식종류를 column 으로 명시해 그 지역에서 각 음식종류에 포함하는 
-- 음식이 있다면 평균내어 출력함. --
PIVOT (AVG(PRICE) FOR FOOD_KIND IN ('양식' as 양식, '패스트푸드' as 패스트푸드, '중식' as 중식, '한식' as 한식, '일식' as 일식))
-- 지역에 대해 오름차순 정렬. --
ORDER BY 1;

-- Q5. REGEXP_SUBSTR() 함수를 이용하여 정보 검색 --
-- reviewer의 email 이 gmail인 경우 
-- email id (@gmail.com 앞에 있는 string)와 사이트를 각각 출력 --
-- RE에서 명시한 Pattern은 리뷰어의 이메일을 대상으로 @ 앞쪽의 email id 를 추출해 출력 --
SELECT REGEXP_SUBSTR(REVIEWER_EMAIL, '(.*)@[^.]*.com', 1, 1, 'i', 1) as Email_ID,
    -- 두번째 출력 column은 이메일의 도메인을 보고 사이트를 출력하고자 함. --
    CASE 
        -- case1) 도메인이 gmail인 경우 GOOGLE 로 출력 --
        WHEN REGEXP_SUBSTR(REVIEWER_EMAIL, '.*@([^.]*).com', 1, 1, 'i', 1) = 'gmail' THEN  'GOOGLE'
        -- case2) 도메인이 naver인 경우 NAVER 로 출력 --
        WHEN REGEXP_SUBSTR(REVIEWER_EMAIL, '.*@([^.]*).com', 1, 1, 'i', 1) = 'naver' THEN  'NAVER'
        -- else) 그 외의 경우 모르는 사이트임을 명시.
        ELSE 'Unknown site'
    END as 사이트
FROM REVIEWER;


