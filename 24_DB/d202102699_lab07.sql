drop table MATZIP1;
drop table MATZIP2;

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
    

-- Q1. 2개 테이블에 대해 union or intersection 연산 수행 --
SELECT RESTAURANT_NAME as 음식점, FOOD_KIND as 음식종류 
FROM MATZIP1
INTERSECT                                           -- 위 아래에 있는 table 두개의 Intersection 연산 수행 --
SELECT RESTAURANT_NAME as 음식점, FOOD_KIND as 음식종류
FROM MATZIP2;

-- Q2-1. 2개 테이블에 대해 minus 연산 수행 --
SELECT RESTAURANT_NAME as 음식점, FOOD_KIND as 음식종류
FROM MATZIP1
minus -- 위에 명시되어있는 table에서 아래에 명시되어있는 TABLE 의 차집합 --
SELECT RESTAURANT_NAME as 음식점, FOOD_KIND as 음식종류
FROM MATZIP2;

-- Q2-2. 2개 테이블에 대해 minus 연산을 사용하지 않고 2-1과 동일한 결과 출력 -- 
-- where clause is shortcurcuit evaluation by query optimizer --
SELECT RESTAURANT_NAME as 음식점, FOOD_KIND as 음식종류
FROM MATZIP1
WHERE RESTAURANT_NAME NOT IN (SELECT RESTAURANT_NAME as 음식점 FROM MATZIP2)   -- 조건1) 음식점이 두번째 TABLE에 없는 경우 --
OR FOOD_KIND NOT IN (SELECT FOOD_KIND as 음식종류 FROM MATZIP2);               -- 조건2) 음식종류가 두번째 TABLE에 없는 경우 --


-- Q3. 특정 관리자가 관리하는 모든 사원의 정보를 순방향 계층구조로 출력 --
-- 출력 시, 중간 위치에 있는 사원은 X, 최하위에 있는 사원은 O를 표시 --

-- 사원 정보 출력 --
SELECT EMPNO AS 사원번호, ENAME AS 사원이름, MGR AS 관리자번호, DEPTNO AS 회사번호,  
    CASE WHEN   -- 사원 위치에 따른 O X 출력문 --
        CONNECT_BY_ISLEAF = 1 THEN 'O'  -- 사원이 leaf node 즉, 최하위 사원인 경우 O를 출력 --
        ELSE 'X'                        -- 그렇지 않은 경우 중간위치이므로 X 출력 --
    END AS "최하위사원?"                   -- column 이름은 최하위사원? 으로 설정 --  
FROM EMP
START WITH MGR IS NULL                  -- MGR 이 NULL 인 사원부터 탐색 시작 --
CONNECT BY PRIOR EMPNO = MGR;           -- 하위 사원쪽으로 내려가는 순방향 전개 사용 --

-- Q4. 최상위 관리자부터 최하위 사원까지의 경로를 순방향 계층구조로 검색 --
-- 출력 시, level(관리자 = 1), 경로 출력 --

-- level 과 경로 출력 --
SELECT LEVEL AS "Level", SYS_CONNECT_BY_PATH (ENAME, '/') AS 경로 
FROM EMP
WHERE CONNECT_BY_ISLEAF = 1  -- 최하위 사원들에 대한 정보만 출력 --
START WITH MGR IS NULL      -- 최상위 관리자 (MGR = null) 에서부터 탐색 시작 --
CONNECT BY PRIOR EMPNO = MGR; -- 최상위관리자에서부터 최하위관리자로 내려가는 순방향 전개 사용 --

-- Q5. 특정 사원을 관리하는 상위 사원들의 정보를 역방향 계층구조로 검색 --
-- 출력 시, level(관리자 = 1), 이름 : 사원의 이름, 직급 : 사원의 직급, TOP : 최상위 관리자 여부 --

-- 주어진 조건 정보 출력 --
SELECT LEVEL AS "level", ENAME AS "이름", JOB AS "직급",  
    CASE WHEN   
        MGR IS NULL THEN 'O' -- 최상위 관리자는 O 출력 --
        ELSE 'X'            -- 최상위 관리자가 아닌 경우는 X 출력 --
    END AS "TOP"            -- 출력 column 이름은 TOP --
FROM EMP
START WITH EMPNO = 7499     -- 사원번호 7499번인 사원부터 탐색 시작 --
CONNECT BY PRIOR MGR = EMPNO; -- 특정사원부터 최상위 사원까지 올라가는 역방향 전개 사용 --

    
    
    