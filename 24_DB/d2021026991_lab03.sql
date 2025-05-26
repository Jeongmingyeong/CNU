-- create table --
CREATE TABLE MATZIP (
    FOOD_ID NUMBER(8),                      -- unique number for food (primary key)
    RESTAURANT_NAME VARCHAR(20) NOT NULL,   -- restaurant name
    PRIZE NUMBER(8),                        -- food prize
    FOOD_KIND VARCHAR(20),                  -- category of food (e.g. '한식', '중식' etc)
    OPEN_DATE DATE,                         -- the opening date of restaurant
    primary key (FOOD_ID)
);

-- Q1. insert 5 instance --
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, OPEN_DATE)
    VALUES (1, 'pizza', 10000, '양식', '2023-01-15');
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, OPEN_DATE)
    VALUES (2, 'chicken', 18000, '패스트푸드', '2002-01-23');
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, OPEN_DATE)
    VALUES (3, 'pizza', 9000, '양식', '2021-01-15');
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, OPEN_DATE)
    VALUES (4, 'jjambbong', 11000, '중식', '2017-04-29');
INSERT INTO MATZIP (FOOD_ID, RESTAURANT_NAME, PRIZE, FOOD_KIND, OPEN_DATE)
    VALUES (5, 'bibimbap', 14000, '한식', '2002-11-20');   
    
-- Q2. modify information that match condition --
-- FOOD_KIND 가 '양식'인 음식의 가격을 500원 추가하는 코드
UPDATE MATZIP               -- update MATZIP table 
SET PRIZE = PRIZE + 500     -- setting prize value = original prize + 500
WHERE (FOOD_KIND = '양식');  -- setting condition : if food_kind == '양식'

-- Q3. using and, compare, like operator --
-- 음식가격이 13000원 이상이며, 오픈날짜가 2020-01-01 이전인 모든 튜플 조회
SELECT * FROM MATZIP            -- selete all attribute from MATZIP table
WHERE (PRIZE >= 13000)          -- condition1 : if prize >= 13000
AND (OPEN_DATE < '2020-01-01'); -- condition2 : if open date is before 2020-01-01

-- Q4. using AND and OR, compare, using IN operator at least one --
-- FOOD_KIND 가 '양식' 이나 '패스트푸드' 이거나, 오픈날짜가 2010-01-01 이전인 모든 튜플 조회
SELECT * FROM MATZIP                            -- selete all attribute from MATZIP table
WHERE (FOOD_KIND IN ('양식', '패스트푸드'))         -- condition1 : if food_kind is '양식' or '패스트푸드'
OR (OPEN_DATE < '2010-01-01');                  -- condition2 : if open date is before 2010-01-01

-- Q5. using AND, compare, using NOT operator at least one --
-- 음식가격이 10000에서 15000원 사이이며, 동시에 500원단위의 가격이 아닌 모든 튜플 조회
SELECT * FROM MATZIP                            -- selete all attribute from MATZIP table
WHERE (PRIZE BETWEEN 10000 and 15000)           -- condition1 : if prize between 10000 and 15000
AND (NOT (MOD(PRIZE, 1000) = 500));             -- condition2 : if prize % 1000 != 500

DROP TABLE MATZIP

           
           
           
           