<?php
session_start();
include './db_connect.php';

// 카테고리 정보 조회
$category_sql = "SELECT * FROM category;";
$result_categories = $conn->query($category_sql); // 카테고리 정보 저장
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Left and Top Container Example</title>
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
        .left-container {
            width: 250px;
            background-color: #f0f0f0;
            padding: 20px;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .left-container h3 {
            margin-top: 0;
        }
        .left-container input {
            width: 100%;
            padding: 5px;
            margin-bottom: 10px;
            box-sizing: border-box;
        }
        .left-container .category-section {
            margin-bottom: 20px;
        }
        .left-container button {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        .left-container button:hover {
            background-color: #45a049;
        }
        .left-container ul {
            list-style-type: none;
            padding: 0;
        }
        .left-container ul li {
            padding: 5px 0;
        }
        .left-container ul li a {
            text-decoration: none;
            color: #000;
            cursor: pointer;
        }
        .left-container ul li a:hover {
            text-decoration: underline;
        }
        .main-content {
            flex-grow: 1;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="top-container">
				<a href="./page/main.php">
					<img src="../images/logo.png" alt="Profile Picture">
				</a>
        <div class="search-bar">
            <input type="text" placeholder="음식 이름 검색">
            <button>검색</button>
        </div>
				<div class="user-info">
					<?php
						$username = $_SESSION['username'];
						$userid = $_SESSION['user_id'];

            echo "<p>".$username."</p>";
            echo "<p>".$userid."</p>"
					?>
        </div>
    </div>
    <div class="main-container">
        <div class="left-container">
            <div>
                <h3>금액 설정</h3>
                <input type="number" placeholder="최소 금액">
                <input type="number" placeholder="최대 금액">
                <button>확인</button>
            </div>
            <div class="category-section">
                <h3>카테고리</h3>
                <ul>
                    <?php
                    if ($result_categories->num_rows > 0) {
                        while ($category = $result_categories->fetch_assoc()) {
                            echo '<li><a href="#" onclick="nevigateToCategory(\'' . $category['categoryName'] . '\')">' . $category['categoryName'] . '</a></li>';
                        }
                    } else {
                        echo "<li>카테고리가 없습니다.</li>";
                    }
                    ?>
                </ul>
            </div>
            <div>
                <button>장바구니 조회</button>
                <button>주문내역 조회</button>
            </div>
        </div>
        <div class="main-content">
						<?php
            $search_keyword = $_GET['search']; 
            
            // 음식 정보 조회
            $search_sql = "SELECT food.foodname, food.price
													 FROM food 
													 WHERE food.foodname LIKE '%$search_keyword%'"; 
            $result_search = $conn->query($search_sql);

            if ($result_search->num_rows > 0) {
                echo "<ul>";
                while ($food = $result_search->fetch_assoc()) {
                    echo "<li>" . $food['foodname'] . " - " . $food['price'] . "원</li>";
                }
                echo "</ul>";
            } else {
                echo "<p> 검색결과가 존재하지 않습니다.</p>";
            }
            ?>
        </div>
    </div>
		<!-- javascript code -->
    <script>
        function nevigateToCategory(category) {
					// 선택한 카테고리 정보를 URL 파라미터로 추가하여 페이지 이동
					window.location.href = './get_foods.php?category=' + encodeURIComponent(category);
        }
    </script>
</body>
</html>

<?php
$conn->close();
?>


