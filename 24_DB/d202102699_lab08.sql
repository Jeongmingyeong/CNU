drop table MATZIP1;
drop table MATZIP2;
drop table REVIEW;

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

-- create table2 : information of restaurant --
CREATE TABLE MATZIP2 (
    TELEPHONE VARCHAR(12),                  -- telephone number of restaurant (primary key)
    RESTAURANT_NAME VARCHAR(20) NOT NULL,   -- restaurant name
    PRICE NUMBER(8),                        -- food price
    FOOD_KIND VARCHAR(20),                  -- category of food (e.g. '한식', '중식' etc)
    LOC VARCHAR(20),                        -- location of restaurant (e.g. '서울', '대전' etc)
    OPEN_DATE DATE,                         -- the opening date of restaurant
    primary key (TELEPHONE)
);

-- create table3 : review of restaurant --
CREATE TABLE REVIEW (
    REVIEW_ID INT,                          -- unique review id
    REVIEW_RATE INT NOT NULL,               -- review score (e.g. 별점4점 == 4)
    REVIEW_COMMENT VARCHAR(50),             -- review message
    TELEPHONE VARCHAR(12),                  -- telephone number of restaurant (foreign key)
    REVIEWER_ID VARCHAR(12) NOT NULL,       -- reviewer id
    PRIMARY KEY(REVIEW_ID)
);

-- insert 5 data into MATZIP1 table --
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('02-111-2222', 'Gopizza', 10000, '양식', '서울', '2023-01-15');
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('033-333-4444', 'BBQ', 18000, '패스트푸드', '평창', '2002-01-23');
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('042-333-6666', 'NuovoNaples', 9000, '양식', '대전', '2021-01-15');
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('042-123-4567', 'ebiga', 11000, '중식', '대전', '2017-04-29');
INSERT INTO MATZIP1 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, OPEN_DATE)
    VALUES ('000-000-0001', 'bibimbap', 14000, '한식', '2002-11-20');
    
-- insert 5 data into MATZIP2 table --
INSERT INTO MATZIP2 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('042-123-4567', 'ebiga', 11000, '중식', '대전', '2017-04-29');
INSERT INTO MATZIP2 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, OPEN_DATE)
    VALUES ('000-000-0001', 'bibimbap', 14000, '한식', '2002-11-20');
INSERT INTO MATZIP2 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('033-333-9374', 'momstouch', 7000, '패스트푸드', '평창', '2002-11-03');
INSERT INTO MATZIP2 (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('033-333-5234', 'sushi', 18000, '일식', '평창', '2012-02-01');
INSERT INTO MATZIP2 (TELEPHONE, RESTAURANT_NAME, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('000-000-0000', 'gyoban', '한식', '세종', '2024-01-01');
    
-- insert 5 data into REVIEW table --
INSERT INTO REVIEW (REVIEW_ID, REVIEW_RATE, REVIEW_COMMENT, TELEPHONE, REVIEWER_ID)
    VALUES (1, 5, 'very nice!!', '02-111-2222', 'jmink002');
INSERT INTO REVIEW (REVIEW_ID, REVIEW_RATE, TELEPHONE, REVIEWER_ID)
    VALUES (2, 2, '042-333-6666', 'jmink002');
INSERT INTO REVIEW (REVIEW_ID, REVIEW_RATE, REVIEW_COMMENT, TELEPHONE, REVIEWER_ID)
    VALUES (3, 1, 'not tasty..', '02-111-2222', 'rbf119');
INSERT INTO REVIEW (REVIEW_ID, REVIEW_RATE, REVIEW_COMMENT, TELEPHONE, REVIEWER_ID)
    VALUES (4, 5, 'I like it!!', '000-000-0001', 'eclipse');
INSERT INTO REVIEW (REVIEW_ID, REVIEW_RATE, REVIEW_COMMENT, TELEPHONE, REVIEWER_ID)
    VALUES (5, 3, 'soso', '042-123-4567', 'zinzero');
    
-- Q1. 서브쿼리에 대해 IN 연산자 이용하여 정보 검색 --
-- 양식 메뉴를 파는 가게가 있는지 확인해 출력 --
SELECT LOC 지역, RESTAURANT_NAME 가게이름, FOOD_KIND 음식카테고리
FROM MATZIP1
-- 서브쿼리를 통해 MATZIP1 테이블에서 음식종류가 양식인 경우 가게 정보 출력 --
-- IN 연산자를 사용해 서브 쿼리 결과에 존재하는(양식인 경우) 식당 조건 입력 --
WHERE FOOD_KIND IN (SELECT FOOD_KIND
                    FROM MATZIP1
                    WHERE FOOD_KIND = '양식')
ORDER BY 지역; -- 지역에 대해 오름차순 정렬 --

-- Q2. 서브쿼리에 대해 EXISTS 연산자 이용하여 정보 검색 --
-- 2개의 맛집리스트에서 동일한 가게 검색 --
-- 지역 정보가 null 인 경우 '지역알수없음' 으로 치환 --
SELECT NVL(LOC, '지역알수없음') 지역, RESTAURANT_NAME 식당이름, PRICE 가격
FROM MATZIP1 m1
-- 연관 서브쿼리를 통해 두 개의 맛집 리스트에서 동일한 가게 이름이 있다면 그 식당의 정보 출력 --
-- EXISTS 연산자를 통해 조건에 만족하는지 확인 --
WHERE EXISTS (SELECT *
              FROM MATZIP2 m2
              WHERE m1.TELEPHONE = m2.TELEPHONE)
ORDER BY 지역;

-- Q3. 연관서브쿼리를 이용하여 정보 검색 --
-- 2개의 맛집리스트에서 동일한 가게 검색 --
-- 지역 정보가 null 인 경우 '지역알수없음' 으로 치환 --
SELECT NVL(LOC, '지역알수없음') 지역, RESTAURANT_NAME 식당이름, PRICE 가격
FROM MATZIP1 m1
-- 연관 서브쿼리를 통해 두 개의 맛집 리스트에서 동일한 가게 이름이 있다면 그 식당의 정보 출력 --
-- IN 연산자를 통해 조건에 만족하는 식당이 있다면 출력하는 조건 설정 --
WHERE RESTAURANT_NAME IN (SELECT RESTAURANT_NAME
              FROM MATZIP2 m2
              WHERE m1.TELEPHONE = m2.TELEPHONE)
ORDER BY 지역;

-- Q4. INLINE VIEW 를 이용하여 정보 검색 --
-- 리뷰 점수가 5점인 가게 이름 출력 --
SELECT M.RESTAURANT_NAME 식당이름, R.REVIEW_RATE 별점
-- 리뷰가 5점인 식당의 리뷰정보와 맛집리스트 테이블에서 검색 -- 
FROM (SELECT *
      FROM REVIEW
      WHERE REVIEW_RATE = 5) R, MATZIP1 M
-- 리뷰가 5점인 식당의 리뷰 테이블과 맛집리스트에 동일한 식당이 있다면 출력하는 조건 설정 --
WHERE R.TELEPHONE = M.TELEPHONE
ORDER BY 식당이름;

-- Q5-1. 두 개의 테이블을 이용하여 뷰를 정의하시오. --
-- 식당 이름, 음식 종류, 가격, 별점이 저장된 뷰 --
-- 생성한 view 는 V_MATZIP 으로 이름 설정 --
CREATE VIEW V_MATZIP AS 
SELECT m.RESTAURANT_NAME, m.FOOD_KIND, m.PRICE, r.REVIEW_RATE 
FROM MATZIP1 m, REVIEW r
-- 맛집리스트와 리뷰에 동일한 가게가 있는 경우만 저장이 되도록 설정 --
WHERE m.TELEPHONE = r.TELEPHONE;

-- Q5-2. 5-1에서 만든 뷰를 이용하여 정보 검색 --
-- 가격이 10000원 이상이, 별점이 3점 이상인 식당 정보 출력 --
SELECT *
-- 5-1에서 생성한 V_MATZIP 에서 --
FROM V_MATZIP
-- 가격이 10000원 이상이며 별점이 3점 이상인 경우 출력하도록 조건 설정 --
WHERE PRICE >= 10000 AND REVIEW_RATE >= 3; 


