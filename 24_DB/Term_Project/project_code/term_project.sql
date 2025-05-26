use term_project;

DROP TABLE IF EXISTS OrderDetail;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Contain;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Food;

CREATE TABLE Customer (
    cno VARCHAR(10),
    name VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    phoneno VARCHAR(20) NOT NULL,
    PRIMARY KEY (cno)
);

CREATE TABLE Food (
    foodName VARCHAR(100),
    price INT NOT NULL,
    PRIMARY KEY (foodName)
);

CREATE TABLE Category (
    categoryName VARCHAR(100),
    noOfFoods INT NOT NULL,
    PRIMARY KEY (categoryName)
);

CREATE TABLE Contain (
    foodName VARCHAR(100),
    categoryName VARCHAR(100) NOT NULL,
    PRIMARY KEY (foodName, categoryName),
    FOREIGN KEY (foodName) REFERENCES Food(foodName),
    FOREIGN KEY (categoryName) REFERENCES Category(categoryName)
);

CREATE TABLE Cart (
    id INT,
    orderDateTime TIMESTAMP,
    cno VARCHAR(10),
    PRIMARY KEY (id),
    FOREIGN KEY (cno) REFERENCES Customer(cno)
);

CREATE TABLE OrderDetail (
    itemNo INT,
    id INT,
    quantity INT,
    totalPrice INT,
    foodName VARCHAR(100),
    PRIMARY KEY (itemNo, id),
    FOREIGN KEY (id) REFERENCES Cart(id) on UPDATE CASCADE on DELETE CASCADE,
    FOREIGN KEY (foodName) REFERENCES Food(foodName)
);

-- Data insertion
INSERT INTO Food (foodName, price) VALUES 
('김밥', 5000), ('떡볶이', 6000), ('라볶이', 7000), ('치즈떡볶이', 7000), ('치즈라볶이', 8000),
('냉면', 8000), ('우동', 6000), ('김치찌개', 8000), ('순두부찌개', 8000), ('된장찌개', 8000),
('부대찌개', 10000), ('돈까스', 12000), ('과일빙수', 12000), ('팥빙수', 9000), ('소프트콘', 1200),
('공기밥', 1000), ('콜라', 2000), ('사이다', 2000), ('소주', 5000), ('맥주', 5000);

INSERT INTO Category (categoryName, noOfFoods) VALUES
('분식', 0), ('한식', 0), ('디저트', 0), ('추가 및 음료', 0), ('시즌메뉴(여름)', 0);

INSERT INTO Contain (foodName, categoryName) VALUES 
('김밥', '분식'), ('떡볶이', '분식'), ('라볶이', '분식'), ('치즈떡볶이', '분식'), ('치즈라볶이', '분식'),
('냉면', '분식'), ('냉면', '시즌메뉴(여름)'), ('우동', '분식'), ('김치찌개', '한식'), ('순두부찌개', '한식'), 
('된장찌개', '한식'), ('부대찌개', '한식'), ('돈까스', '한식'), ('과일빙수', '디저트'), ('과일빙수', '시즌메뉴(여름)'),
('팥빙수', '디저트'), ('팥빙수', '시즌메뉴(여름)'), ('소프트콘', '디저트'), ('공기밥', '추가 및 음료'), ('콜라', '추가 및 음료'),
('사이다', '추가 및 음료'), ('소주', '추가 및 음료'), ('맥주', '추가 및 음료');

UPDATE Category c SET c.noOfFoods = (SELECT COUNT(*) FROM Contain ct WHERE c.categoryName = ct.categoryName);

INSERT INTO Customer (cno, name, password, phoneno) VALUES 
('C0', '주인', '1111', '010-1111-1111'), ('C1', '정민경', '1234', '010-1234-5678'),
('C2', '홍길동', '0000', '010-9876-6789'), ('C3', '오백이', '5252', '010-5025-0250');

INSERT INTO Cart (id, orderDateTime, cno) VALUES 
('1', NOW(), 'C3'), ('2', DATE_SUB(NOW(), INTERVAL 30 DAY), 'C3'), ('3', DATE_SUB(NOW(), INTERVAL 3 DAY), 'C1');

INSERT INTO OrderDetail (itemNo, id, quantity, totalPrice, foodName) VALUES 
(1, '1', 3, (SELECT price FROM Food WHERE foodName = '김밥') * 3, '김밥'), 
(2, '1', 2, (SELECT price FROM Food WHERE foodName = '콜라') * 2, '콜라'),
(3, '1', 2, (SELECT price FROM Food WHERE foodName = '사이다') * 2, '사이다'), 
(1, '2', 2, (SELECT price FROM Food WHERE foodName = '김치찌개') * 2, '김치찌개'),
(2, '2', 1, (SELECT price FROM Food WHERE foodName = '소주') * 1, '소주'),
(1, '3', 2, (SELECT price FROM Food WHERE foodName = '소프트콘') * 2, '소프트콘'), 
(2, '3', 1000, (SELECT price FROM Food WHERE foodName = '과일빙수') * 1000, '과일빙수');


-- Group function: 관리자가 원하는 연도의 달별 판매금액 조회 기능 --
WITH months AS (
    SELECT 1 AS month UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
    SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION 
    SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12
),
categories AS (
    SELECT DISTINCT categoryName
    FROM Category
)
SELECT 
    ct.categoryName AS 음식종류, 
    m.month AS 월, 
    COALESCE(SUM(CASE WHEN od.foodName = ctn.foodName AND ctn.categoryName = ct.categoryName THEN od.totalPrice ELSE 0 END), 0) AS 총판매가격
FROM categories ct
CROSS JOIN months m
LEFT JOIN Cart c ON m.month = MONTH(c.orderDateTime) AND YEAR(c.orderDateTime) = 2024
LEFT JOIN OrderDetail od ON c.id = od.id
LEFT JOIN Contain ctn ON od.foodName = ctn.foodName
LEFT JOIN Category ct2 ON ctn.categoryName = ct2.categoryName
GROUP BY ct.categoryName, m.month
WITH ROLLUP
ORDER BY m.month, ct.categoryName;

-- Window function: 각 카테고리 별 가장 인기있는 음식 정보 제공 --
WITH countofsale AS (
    SELECT 
        ct.categoryName, 
        od.foodName, 
        SUM(od.quantity) AS cnt
    FROM Category ct
    INNER JOIN Contain ctn ON ct.categoryName = ctn.categoryName
    INNER JOIN OrderDetail od ON ctn.foodName = od.foodName
    GROUP BY ct.categoryName, od.foodName
),
ranked_sales AS (
    SELECT 
        cs.categoryName,
        cs.foodName,
        cs.cnt,
        ROW_NUMBER() OVER (PARTITION BY cs.categoryName ORDER BY cs.cnt DESC) AS rnk
    FROM countofsale cs
)
SELECT 
    rs.categoryName AS 음식종류, 
    rs.foodName AS 가장_인기있는_음식,
    rs.cnt AS 판매량
FROM ranked_sales rs
WHERE rs.rnk = 1;
