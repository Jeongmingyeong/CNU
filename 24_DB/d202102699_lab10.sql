-- Q1 Answer --
-- EMP Table에 새로운 직원 추가 --
INSERT INTO EMP VALUES (8888, 'NEWB', 'ANALYST', 7782, '81/05/24', 3500, NULL, 10);
SELECT * FROM EMP;
COMMIT;
SELECT * FROM EMP;
-- SAL이 3500 이상인 사람의 직업을 STUDENT로 변경 --
UPDATE EMP SET JOB = 'STUDENT' WHERE SAL >= 3500;
SELECT * FROM EMP;
ROLLBACK;
SELECT * FROM EMP;

DELETE FROM EMP WHERE ENAME = 'NEWB';

-- Q2 Answer --
-- EMP Table에 새로운 직원 추가 --
INSERT INTO EMP VALUES (8888, 'NEWB', 'ANALYST', 7782, '81/05/24', 3500, NULL, 10);
SELECT * FROM EMP;
SAVEPOINT A;
-- SAL이 3500 이상인 사람의 직업을 STUDENT로 변경 --
UPDATE EMP SET JOB = 'STUDENT' WHERE SAL >= 3500;
SELECT * FROM EMP;
SAVEPOINT B;
-- DEPTNO가 20인 사람의 SAL을 10000으로 변경 --
UPDATE EMP SET SAL = 10000 WHERE DEPTNO = 20;
SELECT * FROM EMP;
-- B상태로 rollback --
ROLLBACK TO B;
SELECT * FROM EMP;
-- A상태로 rollback --
ROLLBACK TO A;
SELECT * FROM EMP;
COMMIT;
SELECT * FROM EMP;

-- Q3 Answer --
-- 여기부터는 관리자로 접속하여 권한 부여 코드 (위는 d202102699 계정으로 접속) --
-- 계정 이름 앞에 C##을 붙여야하는 설정 변경 (붙이지 않아도 생성되도록) --
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- 새로운 계정 생성 --
CREATE USER testuser IDENTIFIED BY qwer;
-- 데이터베이스에 로그인 할 수 있는 권한 부여 --
GRANT CREATE SESSION TO testuser;
-- 로그인 확인 --
SHOW USER;

-- Q4 Answer --
-- testuser에게 테이블을 생성할 수 있는 권한 부여 --
GRANT CREATE TABLE TO testuser;
-- testuser 계정으로 로그인 --
SHOW USER;
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
-- 생성한 table 확인 --
describe MATZIP1;

-- Q5 Answer --
-- 새로운 계정(2) 만들기 --
CREATE USER test2 IDENTIFIED BY asdf;
-- 로그인과 테이블 생성이 가능한 역할(Role) 생성 --
CREATE ROLE LOGIN_CREATE_TABLE;
-- 로그인과 테이블 생성기 가능하도록 권한 부여 --
GRANT CREATE SESSION, CREATE TABLE TO LOGIN_CREATE_TABLE;
-- 바로 위에서 생성한 역할을 test2에게 역할부여 --
GRANT LOGIN_CREATE_TABLE TO test2;

-- 현재 계정 확인 --
SHOW USER;

-- create table2 : reviewer --
CREATE TABLE REVIEWER (
    REVIEWER_ID VARCHAR(12),                -- unique reviewer id
    REVIEWER_NAME VARCHAR(20),              -- reviewer name 
    REVIEWER_EMAIL VARCHAR(20),             -- reviewer email
    PRIMARY KEY(REVIEWER_ID)
);
-- 생성한 table 확인 --
describe REVIEWER;

