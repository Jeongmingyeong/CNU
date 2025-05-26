-- TP3 answer --
DROP TABLE OrderDetail;
DROP TABLE Cart;
DROP TABLE Customer;
DROP TABLE CONTAIN;
DROP TABLE CATEGORY;
DROP TABLE Food;

CREATE TABLE Customer (
    cno VARCHAR(10),
    name VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    phoneno VARCHAR(20) NOT NULL,
    CONSTRAINT pk_customer PRIMARY KEY (cno)
);

CREATE TABLE Food (
    foodName VARCHAR(100),
    price NUMBER NOT NULL,
    CONSTRAINT pk_food PRIMARY KEY (foodName)
);

CREATE TABLE Category (
    categoryName VARCHAR(100),
    noOfFoods NUMBER NOT NULL,
    CONSTRAINT pk_category PRIMARY KEY (categoryName)
);

CREATE TABLE Contain (
    foodName VARCHAR(100),
    categoryName VARCHAR(100) NOT NULL,
    CONSTRAINT pk_contain PRIMARY KEY (foodName, categoryName),
    CONSTRAINT fk_contain1 FOREIGN KEY (foodName) REFERENCES Food(foodName),
    CONSTRAINT fk_contain2 FOREIGN KEY (categoryName) REFERENCES Category(categoryName)
);

CREATE TABLE Cart (
    id VARCHAR(5),
    orderDateTime TIMESTAMP,
    cno VARCHAR(10),
    CONSTRAINT pk_cart PRIMARY KEY (id),
    CONSTRAINT fk_cart FOREIGN KEY (cno) REFERENCES Customer(cno)
);

CREATE TABLE OrderDetail (
    itemNo NUMBER,
    id VARCHAR(5),
    quantity NUMBER,
    totalPrice NUMBER,
    foodName VARCHAR(100),
    CONSTRAINT pk_orderdetail PRIMARY KEY (itemNo, id),
    CONSTRAINT fk_orderdetail1 FOREIGN KEY (id) REFERENCES Cart(id),
    CONSTRAINT fk_orderdetail2 FOREIGN KEY (foodName) REFERENCES Food(foodName)
);


-- TP4 answer --
-- Food table에 20개의 음식 정보 구축 --
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('김밥', 5000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('떡볶이', 6000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('라볶이', 7000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('치즈떡볶이', 7000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('치즈라볶이', 8000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('냉면', 8000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('우동', 6000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('김치찌개', 8000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('순두부찌개', 8000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('된장찌개', 8000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('부대찌개', 10000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('돈까스', 12000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('과일빙수', 12000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('팥빙수', 9000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('소프트콘', 1200);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('공기밥', 1000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('콜라', 2000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('사이다', 2000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('소주', 5000);
INSERT INTO FOOD (FOODNAME, PRICE)
    VALUES ('맥주', 5000);

-- Category table에 최소 3개의 분류 정보 구축 --
INSERT INTO CATEGORY (CATEGORYNAME, NOOFFOODS)
    VALUES ('분식', 0);
INSERT INTO CATEGORY (CATEGORYNAME, NOOFFOODS)
    VALUES ('한식', 0);
INSERT INTO CATEGORY (CATEGORYNAME, NOOFFOODS)
    VALUES ('디저트', 0);
INSERT INTO CATEGORY (CATEGORYNAME, NOOFFOODS)
    VALUES ('추가 및 음료', 0);
INSERT INTO CATEGORY (CATEGORYNAME, NOOFFOODS)
    VALUES ('시즌메뉴(여름)', 0);

    
-- Contain table에 Food 테이블과의 관계 구축 --
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('김밥', '분식');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('떡볶이', '분식');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('라볶이', '분식');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('치즈떡볶이', '분식');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('치즈라볶이', '분식');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('냉면', '분식');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('냉면', '시즌메뉴(여름)');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('우동', '분식');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('김치찌개', '한식');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('순두부찌개', '한식'); 
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('된장찌개', '한식');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('부대찌개', '한식');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('돈까스', '한식');    
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('과일빙수', '디저트');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('과일빙수', '시즌메뉴(여름)');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('팥빙수', '디저트');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('팥빙수', '시즌메뉴(여름)');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('소프트콘', '디저트');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('공기밥', '추가 및 음료');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('콜라', '추가 및 음료');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('사이다', '추가 및 음료');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('소주', '추가 및 음료');
INSERT INTO CONTAIN (FOODNAME, CATEGORYNAME)
    VALUES ('맥주', '추가 및 음료');
    
-- category table 의 음식개수 update --
UPDATE CATEGORY c
    SET c.NOOFFOODS = (SELECT COUNT(*) FROM CONTAIN ct WHERE c.CATEGORYNAME = ct.CATEGORYNAME);
    

-- customer table 에 최소 3명 이상의 회원 정보 구축 --
INSERT INTO CUSTOMER (CNO, NAME, PASSWORD, PHONENO)
    VALUES ('C0', '관리자', '1111', '010-1111-1111');
INSERT INTO CUSTOMER (CNO, NAME, PASSWORD, PHONENO)
    VALUES ('C1', '정민경', '1234', '010-1234-5678');
INSERT INTO CUSTOMER (CNO, NAME, PASSWORD, PHONENO)
    VALUES ('C2', '홍길동', '0000', '010-9876-6789');
INSERT INTO CUSTOMER (CNO, NAME, PASSWORD, PHONENO)
    VALUES ('C3', '오백이', '5252', '010-5025-0250');

-- cart table에 최소 2명 이상의 회원들의 주문 정보 구축 --
INSERT INTO CART (ID, ORDERDATETIME, CNO)
    VALUES (1, sysdate, 'C3');
INSERT INTO CART (ID, ORDERDATETIME, CNO)
    VALUES (2, sysdate-30, 'C3');
INSERT INTO CART (ID, ORDERDATETIME, CNO)
    VALUES (3, sysdate-3, 'C1');
    
-- orderdetail table 에 하나의 주문데이터에 대해 최소 2개 이상의 상세정보데이터 추가 --
INSERT INTO ORDERDETAIL (ITEMNO, ID, QUANTITY, TOTALPRICE, FOODNAME)
    VALUES (1, 1, 3, (SELECT PRICE FROM FOOD f WHERE f.FOODNAME = '김밥') * 3, '김밥');
INSERT INTO ORDERDETAIL (ITEMNO, ID, QUANTITY, TOTALPRICE, FOODNAME)
    VALUES (2, 1, 2, (SELECT PRICE FROM FOOD f WHERE f.FOODNAME = '콜라') * 2, '콜라');
INSERT INTO ORDERDETAIL (ITEMNO, ID, QUANTITY, TOTALPRICE, FOODNAME)
    VALUES (3, 1, 2, (SELECT PRICE FROM FOOD f WHERE f.FOODNAME = '사이다') * 2, '사이다');
INSERT INTO ORDERDETAIL (ITEMNO, ID, QUANTITY, TOTALPRICE, FOODNAME)
    VALUES (1, 2, 2, (SELECT PRICE FROM FOOD f WHERE f.FOODNAME = '김치찌개') * 2, '김치찌개');
INSERT INTO ORDERDETAIL (ITEMNO, ID, QUANTITY, TOTALPRICE, FOODNAME)
    VALUES (2, 2, 1, (SELECT PRICE FROM FOOD f WHERE f.FOODNAME = '소주') * 1, '소주');
INSERT INTO ORDERDETAIL (ITEMNO, ID, QUANTITY, TOTALPRICE, FOODNAME)
    VALUES (1, 3, 2, (SELECT PRICE FROM FOOD f WHERE f.FOODNAME = '소프트콘') * 2, '소프트콘');
INSERT INTO ORDERDETAIL (ITEMNO, ID, QUANTITY, TOTALPRICE, FOODNAME)
    VALUES (2, 3, 1, (SELECT PRICE FROM FOOD f WHERE f.FOODNAME = '과일빙수') * 1, '과일빙수');
    
-- TP5 answer --
-- 관리자가 원하는 연도의 달별 판매금액 조회 기능 (Group function) --
-- 음식카테고리를 기준으로 각 월에 대한 총판매가격 조회 --

-- 1~12월 전체에 대해 조회하고지 하기 때문에 전체 월을 나타내는 임시 테이블 생성 --
WITH months AS ( 
    SELECT LEVEL AS month
    FROM dual
    CONNECT BY LEVEL <= 12
),
-- category 이름만 저장되어있는 임시테이블 생성 --
categories AS(
    SELECT DISTINCT categoryname
    FROM Category
)
-- 사용자가 원하는 년도에 1~12월 판매 금액을 음식종류, 월을 기준으로 조회 --
SELECT ct.CATEGORYNAME 음식종류, m.month AS 월, 
    -- 총판매가격을 구할 때 음식종류가 일치하는 곳에 대해서만 더해야하기 때문에 case문으로 조건을 나눠 sum 계산 --
    NVL(SUM(CASE WHEN od.foodname = ctn.foodname AND ctn.categoryname = ct.categoryname THEN od.totalprice ELSE 0 END), 0) 총판매가격
-- 사용하고자 하는 테이블을 명시. 이때 모든 음식종류와 모든 달에 대한 조합이 있어야 하므로 CROSS JOIN 수행 --
FROM categories ct CROSS JOIN months m
    -- 그리고 모든 조건에 대한 결과를 출력하고 싶기 때문에 전부 LEFT JOIN의 ON절에 조건을 두어 원하는 정보 모두 조회 --
    LEFT JOIN CART c ON (m.month = EXTRACT(MONTH FROM c.orderdatetime) AND EXTRACT(YEAR FROM c.orderdatetime) = 2024)
    LEFT JOIN ORDERDETAIL od ON c.id = od.id
    LEFT JOIN CONTAIN ctn ON od.foodname = ctn.foodname
    LEFT JOIN CATEGORY ct ON ctn.categoryname = ct.categoryname
-- 음식종류와 월을 기준으로 ROLLUP을 통해 소계 계산 --
GROUP BY ROLLUP (ct.CATEGORYNAME, m.month)
-- 월로 먼저 오름차순 정렬 후, 동일한 월에 대해서는 음식종류이름에 대해 오름차순 정렬 --
ORDER BY 2, 1;

-- 과거부터 조회한 시점까지의 데이터 중 주문개수가 가장 많은 음식 정보 제공 --
-- 각 카테고리의 음식이 판매된 개수를 구한 임시 테이블 --
WITH countofsale AS (
    -- 음식종류, 음식이름, 판매개수가 저장된 임시테이블 --
    SELECT ct.categoryname, od.foodname, SUM(od.quantity) AS cnt
    -- 음식종류와 contain, 주문내역을 각각 음식종류, 음식이름을 기준으로 조인한 후 --
    -- 그룹화하여 총 판매개수를 구할 때 사용 --
    FROM CATEGORY ct
    INNER JOIN CONTAIN ctn ON ct.categoryname = ctn.categoryname
    INNER JOIN ORDERDETAIL od ON ctn.foodname = od.foodname
    GROUP BY ct.categoryname, od.foodname
),
-- 판매개수를 기준으로 순위를 저장해놓은 임시테이블 --
ranked_sales AS (
    SELECT 
        cs.categoryname,
        cs.foodname,
        cs.cnt,
        -- window funciton 중 row_number 함수를 사용해 판매개수를 기준으로 순위 구하기 --
        -- 파티션한 기준은 위에 만든 임시테이블 countofsale 테이블의 음식종류로 파티션 진행. --
        -- 순위를 세운 순서는 판매된 음식개수에 대해 내림차순 정렬함. --
        ROW_NUMBER() OVER (PARTITION BY cs.categoryname ORDER BY cs.cnt DESC) AS rnk
    FROM countofsale cs
)
-- 각 카테고리 별 가장 인기있는 음식 정보 조회 기능 (Window function) --
SELECT 
    -- 위에서 구한 ranked_sales 테이블의 정보를 출력 --
    rs.categoryname AS 음식종류, 
    rs.foodname AS "가장 인기있는 음식",
    rs.cnt AS "판매량"
FROM ranked_sales rs
-- 가장 많이 팔린 음식만을 보여주고자 하기 때문에 각 카테고리 별 rank = 1인 음식만 조회 --
WHERE rs.rnk = 1;


