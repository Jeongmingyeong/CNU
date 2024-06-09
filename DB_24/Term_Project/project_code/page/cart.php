<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니 조회</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .top-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            height: 100px;
            background-color: #d3d3d3;
            padding: 0 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .top-container img {
            height: 80px;
            width: 270px;
        }
        .search-bar {
            display: flex;
            align-items: center;
            flex-grow: 1;
            margin: 0 20px;
        }
        .search-bar input {
            width: 80%;
            flex-grow: 1;
            padding: 10px;
            font-size: 16px;
        }
        .search-bar button {
            margin-left: 10px;
            padding: 10px 20px;
            font-size: 14px;
            cursor: pointer;
        }
        .user-info {
            align-items: center;
            margin: 0 30px 0 0;
        }
        .user-info p {
            margin: 0 10px;
        }
        .main-container {
            display: flex;
            flex-grow: 1;
        }
        .main-content {
            flex-grow: 1;
            padding: 20px;
        }
        .total-section {
            background-color: #f0f0f0;
            padding: 20px;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            margin-top: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .total-section p {
            margin: 0;
            margin-right: 100px;
            font-size: 30px;
        }
        .total-section button {
            padding: 15px 30px;
            font-size: 16px;
            cursor: pointer;
            background-color: #4CAF50;
            color: white;
            border: none;
            transition: background-color 0.3s;
        }
        .total-section button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="top-container">
        <img src="../images/logo.png" alt="Profile Picture">
        <div class="search-bar">
            <input type="text" placeholder="음식 이름 검색">
            <button>검색</button>
        </div>
        <div class="user-info">
            <p>정민경</p>
            <p>CN0</p>
        </div>
    </div>
    <div class="main-container">
        <div class="main-content">
            <h1>장바구니 조회</h1>
            <!-- 여기에 장바구니 내역을 표시하는 부분을 추가하세요 -->
        </div>
    </div>
    <div class="total-section">
        <p>총 금액: $100</p>
        <button>결제하기</button>
    </div>
</body>
</html>

