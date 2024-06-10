<?php
session_start();
include './db_connect.php';

// 카테고리 정보 조회
$category_sql = "SELECT * FROM category;";
$result_categories = $conn->query($category_sql); // 카테고리 정보 저장

// 음식 이름에 대한 이미지 파일명을 매핑하는 배열
$image_map = [
	'팥빙수' => 'red_been.png',
	'과일빙수' => 'fruit_ice.png',
	'소프트콘' => 'softcon.png',
	'김밥' => 'riceroll.png',
	'냉면' => 'cold_noodle.png',
	'떡볶이' => 'tteokbokki.png',
	'라볶이' => 'rabokki.png',
	'우동' => 'udong.png',
	'치즈떡볶이' => 'cheeze_tteokbokki.png',
	'치즈라볶이' => 'cheeze_rabokki.png',
	'공기밥' => 'rice.png',
	'맥주' => 'beer.png',
	'사이다' => 'between.png',
	'소주' => 'soju.png',
	'콜라' => 'coke.png',
	'김치찌개' => 'kimchi_soup.png',
	'돈까스' => 'fried_pork.png',
	'된장찌개' => 'soybeen_soup.png',
	'부대찌개' => 'Budaejjigae.png',
	'순두부찌개' => 'Tofu_Stew.png',

];
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CON</title>
		<link rel="stylesheet" href="../style/mainpage.css">
</head>
<body>
    <div class="top-container">
				<a href="./page/main.php">
					<img src="./images/logo.png" alt="Profile Picture">
				</a>
        <div class="search-bar">
						<form id="search-form" action="../search_results.php" method="get">
                <input type="text" name="search" placeholder="음식 이름 검색">
                <button type="submit">검색</button>
            </form>
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
								<form id="select-price" action="../search_price.php" method="get">
									<input type="number" name="min_price" placeholder="최소 금액">
									<input type="number" name="max_price" placeholder="최대 금액">
									<button>확인</button>
								</form>
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
            $category_name = $_GET['category']; 
            echo "<h2>" . $category_name . "</h2>";
            
            // 음식 정보 조회
            $food_sql = "SELECT food.foodname, food.price
                         FROM food JOIN contain ON food.foodname = contain.foodname
                         WHERE contain.categoryname = '$category_name'";
            $result_foods = $conn->query($food_sql);

            if ($result_foods->num_rows > 0) {
							echo "<div class='food-list'>";
              while ($food = $result_foods->fetch_assoc()) {
								$foodname = $food['foodname'];
								$foodprice = $food['price'];
								$foodimage = isset($image_map[$foodname]) ? $image_map[$foodname] : 'default.png';

								echo "<div class='food-card'>";
                echo "<img src='../images/$foodimage' alt='$foodname'>";
								echo "<div class='food-details'>";
                echo "<div class='food-name'>$foodname</div>";
                echo "<div class='food-price'>$foodprice 원</div>";
                echo "</div>";
                echo "</div>";
              }
              echo "</div>";
            } else {
                echo "<p>이 카테고리에 속한 음식이 없습니다.</p>";
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


