<?php
include 'db_connect.php';

// 카테고리정보 조회
$category_sql = "SELECT * FROM CATEGORY;";
$result_categories = $conn->query($category_sql); // 카테고리 정보 저장

// 카테고리가 존재하는지 확인
if ($result_categories->num_rows > 0) {
	while($category = $result_categories->fetch_assoc()) {
		$category_name = $catogory['categoryName'];

		// 카테고리 하나하나 가져오기
		echo "<h2>".$category_name."<h2>"; // 카테고리 이름 표시
		
		// 음식정보 조회
		$food_sql = "SELECT FOOD.foodname Fname, FOOD.price Fprice
								 FROM FOOD JOIN CONTAIN ON FOOD.foodname = CONTAIN.foodname
								 WHERE CONTAIN.categoryname = '$category_name'";
		$result_foods = $conn->query($food_sql); // 특정 카테고리에 속하는 음식 정보 저장

		if ($result_foods->num_rows > 0) {
			echo "<ul>";
			while ($food = $result_foods->fetch_assoc()) {
				echo "<li>".$food['foodname']." - ".$food['price']."원</li>";
			}
			echo "</ul>";
		} else {
			echo "카테고리에 속한 음식이 없습니다.";
		}
	}
} else {
	echo "설정된 카테고리가 없습니다.";
}
?>

