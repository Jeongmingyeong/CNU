<?php
session_start();
include '../db_connect.php';

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
				<a href="./main.php">
					<img src="../images/logo.png" alt="Profile Picture">
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
						// 세션에 저장되어있는 사용자 정보를 받아와 오른쪽 상단에 출력.
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
										// 각 카테고리 별로 클릭 가능한 태그 만들고, 각 카테고리 별 조회 정보를 제공하기 위한 함수 호출
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
                <button onClick="location.href='./cart.php'">장바구니 조회</button>
                <button onClick="location.href='./order_history.php'">주문내역 조회</button>
								<?php
									// 만약 로그인한 사용자가 관리자이면, 판매 통계조회 버튼 display
									if($_SESSION['user_id'] === 'C0') {
										echo "<button onClick=\"location.href='../page/admin_stats.php'\">판매 통계 조회</button>";
									}
								?>
            </div>
        </div>
        <div class="main-content">
						<?php
						// 카테고리 정보 조회
						$category_sql = "SELECT * FROM category;";
						$result_categories = $conn->query($category_sql); // 카테고리 정보 저장

            if ($result_categories->num_rows > 0) {
                while ($category = $result_categories->fetch_assoc()) {
                    $category_name = $category['categoryName'];
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

													echo "<a href=# class='food-card'>";
                          echo "<img src='../images/$foodimage' alt='$foodname'>";
													echo "<div class='food-details'>";
                          echo "<div class='food-name'>$foodname</div>";
                          echo "<div class='food-price'>$foodprice 원</div>";
                          echo "</div>";
                          echo "</a>";
                        }
                        echo "</div>";

                    } else {
                        echo "<p>이 카테고리에 속한 음식이 없습니다.</p>";
                    }
                }
            } else {
                echo "<p>설정된 카테고리가 없습니다.</p>";
            }
            ?>
        </div>
    </div>
		
		<!-- 모달 창 -->
		<div id="foodModal" class="modal">
		    <div class="modal-content">
		        <span class="close">&times;</span>
		        <h2 id="modalFoodName"></h2>
		        <img id="modalFoodImage" src="" alt="음식 이미지">
		        <p id="modalFoodPrice"></p>
		        <form id="cartForm" method="post" action="../add_food_to_cart.php">
		            <input type="hidden" id="hiddenFoodName" name="foodname" value="">
		            <input type="hidden" id="hiddenFoodPrice" name="foodprice" value="">
		            <label for="quantity">수량:</label>
		            <input type="number" id="quantity" name="quantity" min="1" value="1">
		            <button type="submit">장바구니에 추가</button>
		        </form>
		    </div>
		</div>

		<!-- javascript code -->
		<script>
				document.addEventListener('DOMContentLoaded', function() {
		    // 모든 food-card 요소에 클릭 이벤트 리스너 추가
		    document.querySelectorAll('.food-card').forEach(function(card) {
		        card.addEventListener('click', function(event) {
		            event.preventDefault();
		            
		            // 클릭한 음식 데이터 가져오기
		            const foodName = card.querySelector('.food-name').textContent;
		            const foodPrice = card.querySelector('.food-price').textContent;
		            const foodImageSrc = card.querySelector('img').src;
		            
		            // 모달 요소를 가져와서 데이터로 업데이트
		            document.getElementById('modalFoodName').textContent = foodName;
		            document.getElementById('modalFoodPrice').textContent = foodPrice;
		            document.getElementById('modalFoodImage').src = foodImageSrc;
								document.getElementById('hiddenFoodName').value = foodName;
                document.getElementById('hiddenFoodPrice').value = foodPrice;
		            
		            // 모달 표시
		            const modal = document.getElementById('foodModal');
		            modal.style.display = 'block';
		        });
		    });
		
		    // 모달 닫는 기능
		    document.querySelector('.close').addEventListener('click', function() {
		        document.getElementById('foodModal').style.display = 'none';
		    });
		
		    // 모달 외부 클릭 시 모달 닫기
		    window.addEventListener('click', function(event) {
		        const modal = document.getElementById('foodModal');
		        if (event.target === modal) {
		            modal.style.display = 'none';
		        }
		    });
		});
		</script>

    <script>
        function nevigateToCategory(category) {
					// 선택한 카테고리 정보를 URL 파라미터로 추가하여 페이지 이동
					window.location.href = '../search_category.php?category=' + encodeURIComponent(category);
        }
    </script>

    <script>
        function nevigateToMainpage(usermode) {
					window.location.href = './main.php';
        }
    </script>
</body>
</html>

<?php
$conn->close();
?>

