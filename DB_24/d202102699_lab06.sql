drop table MATZIP;
drop table REVIEW;
drop table REVIEWER;

-- create table1 : information of restaurant --
CREATE TABLE MATZIP (
    TELEPHONE VARCHAR(12),                  -- telephone number of restaurant (primary key)
    RESTAURANT_NAME VARCHAR(20) NOT NULL,   -- restaurant name
    PRICE NUMBER(8),                        -- food price
    FOOD_KIND VARCHAR(20),                  -- category of food (e.g. '한식', '중식' etc)
    LOC VARCHAR(20),                        -- location of restaurant (e.g. '서울', '대전' etc)
    OPEN_DATE DATE,                         -- the opening date of restaurant
    primary key (TELEPHONE)
);

-- create table2 : review of restaurant --
CREATE TABLE REVIEW (
    REVIEW_ID INT,                          -- unique review id
    REVIEW_RATE INT NOT NULL,               -- review score (e.g. 별점4점 == 4)
    REVIEW_COMMENT VARCHAR(50),             -- review message
    TELEPHONE VARCHAR(12),                  -- telephone number of restaurant (foreign key)
    REVIEWER_ID VARCHAR(12) NOT NULL,       -- reviewer id
    PRIMARY KEY(REVIEW_ID)
);

-- create table3 : reviewer --
CREATE TABLE REVIEWER (
    REVIEWER_ID VARCHAR(12),                -- unique reviewer id
    REVIEWER_NAME VARCHAR(20),              -- reviewer name 
    REVIEWER_EMAIL VARCHAR(20),             -- reviewer email
    PRIMARY KEY(REVIEWER_ID)
);


-- insert 5 data into MATZIP table --
INSERT INTO MATZIP (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('02-111-2222', 'Gopizza', 10000, '양식', '서울', '2023-01-15');
INSERT INTO MATZIP (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('033-333-4444', 'BBQ', 18000, '패스트푸드', '평창', '2002-01-23');
INSERT INTO MATZIP (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('042-333-6666', 'NuovoNaples', 9000, '양식', '대전', '2021-01-15');
INSERT INTO MATZIP (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('042-123-4567', 'ebiga', 11000, '중식', '대전', '2017-04-29');
INSERT INTO MATZIP (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, OPEN_DATE)
    VALUES ('000-000-0001', 'bibimbap', 14000, '한식', '2002-11-20');
    
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
    
-- insert 5 data into REVIEW table --
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

    
-- Q1. 2개의 table 에 대한 EQUIJOIN 수행 --
SELECT M.TELEPHONE 가게전화번호, M.RESTAURANT_NAME 가게이름, REVIEW_RATE 별점, REVIEW_COMMENT 후기
FROM MATZIP M, REVIEW R
WHERE M.TELEPHONE = R.TELEPHONE    -- MATZIP table의 TELEPHONE 과 REVIEW table 의 TELEPHONE 이 같은 경우 JOIN 수행
ORDER BY 별점 DESC;                 -- 별점 높은 순으로 정렬  

-- Q2. 2개의 table 에 대한 EQUIJOIN 수행 (ON 조건절에 조인 조건 명시, 검색을 위한 추가 조건은 WHERE절에)  --
SELECT M.TELEPHONE 가게전화번호, M.RESTAURANT_NAME 가게이름, REVIEW_RATE 별점, REVIEW_COMMENT 후기
FROM MATZIP M jOIN REVIEW R     -- MATZIP, REVIEW table JOIN 수행 명시
ON M.TELEPHONE = R.TELEPHONE    -- Q1과 동일 JOIN 조건 명시
WHERE REVIEW_RATE >= 3;         -- 별점이 3점 이상인 경우만 조회

-- Q3. 3개의 table 에 대한 JOIN 수행 --
SELECT M.TELEPHONE 가게전화번호, M.RESTAURANT_NAME 가게이름, P.REVIEWER_ID 리뷰어ID, R.REVIEW_RATE 별점, R.REVIEW_COMMENT 후기
FROM MATZIP M, REVIEW R, REVIEWER P     -- 3개의 table로 JOIN 수행
WHERE M.TELEPHONE = R.TELEPHONE         -- JOIN 조건1) 맛집, 리뷰 테이블의 전화번호가 같은 경우
AND R.REVIEWER_ID = P.REVIEWER_ID;      -- JOIN 조건2) 리뷰, 리뷰어 테이블의 ID가 같은 경우

-- Q4. 2개의 table 에 대한 CROSSJOIN 수행 (각각 5개 data 존재하므로 5*5=25개 row 조회) --
SELECT M.TELEPHONE 가게전화번호, M.RESTAURANT_NAME 가게이름, REVIEW_RATE 별점, REVIEW_COMMENT 후기
FROM MATZIP M CROSS JOIN REVIEW R       -- 맛집, 리뷰 테이블 CROSS JOIN 수행 명시
ORDER BY 가게전화번호;                     -- 가게전화번호를 기준으로 정렬해 출력

-- Q5. 2개의 table 에 대한 LEFT OUTER JOIN 수행 --
-- 5번 문제 수행을 위해 MATZIP table 에 data 2개 추가 --
INSERT INTO MATZIP (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('033-333-1938', 'sushi', 18000, '일식', '평창', '2012-02-01');
INSERT INTO MATZIP (TELEPHONE, RESTAURANT_NAME, PRICE, FOOD_KIND, LOC, OPEN_DATE)
    VALUES ('123-456-7890', 'gyoban', 8500, '한식', '세종', '2024-01-01');
    
-- MATZIP 과 REVIEW table 간의 LEFT OUTER JOIN 수행 --
SELECT M.TELEPHONE 가게전화번호, M.RESTAURANT_NAME 가게이름, REVIEW_RATE 별점, REVIEW_COMMENT 후기
FROM MATZIP M LEFT OUTER JOIN REVIEW R  -- 맛집, 리뷰 테이블 LEFT OUTER JOIN 수행 명시
ON M.TELEPHONE = R.TELEPHONE;           -- JOIN 조건 : 맛집, 리뷰 테이블의 전화번호가 같은 경우    
