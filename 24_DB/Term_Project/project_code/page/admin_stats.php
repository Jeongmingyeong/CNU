<?php
session_start();
include '../db_connect.php';

// 사용자 정보를 세션에서 가져오기 
$username = $_SESSION['username'];
$userid = $_SESSION['user_id'];

// 카테고리 정보 조회
$category_sql = "SELECT * FROM category;";
$result_categories = $conn->query($category_sql); // 카테고리 정보 저장


// 카테고리 별 인기메뉴 조회하는 쿼리
$populer_menu_sql = "
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
    rs.categoryName AS category, 
    rs.foodName AS popular_menu,
    rs.cnt AS amount
FROM ranked_sales rs
WHERE rs.rnk = 1;
";

$result_popular_menu = $conn->query($populer_menu_sql);


$data_menu = [];

if ($result_popular_menu->num_rows > 0) {
    while ($row = $result_popular_menu->fetch_assoc()) {
        $data_menu[] = $row;
    }
} else {
    echo "0 결과";
}

?>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>판매 통계 및 인기 메뉴 조회</title>
    <link rel="stylesheet" href="../style/mainpage.css">
    <link rel="stylesheet" href="../style/admin_stats.css">
</head>
<body>
    <div class="top-container">
				<a href="./main.php">
					<img src="../images/logo.png" alt="Profile Picture">
				</a>
        <div class="title_box">
            <h1>판매 통계 및 인기 메뉴 조회</h1>
        </div>
        <div class="user-info">
            <?php
                echo "<p>".$username."</p>";
                echo "<p>".$userid."</p>";
            ?>
        </div>
    </div>
    <div class="main-container">
        <!-- 판매 통계 영역 -->
        <div class="sales-stats">
            <h2>기간 내 판매금액 조회내용</h2>
						<div class="date-filter">
                <input type="number" id="year" name="year" placeholder="연도 입력">
                <button id="filter-button" onClick="getYearInfo()">조회</button>
            </div>
            <!-- 판매 통계 데이터를 표시하는 부분 -->
						<?php
						// URL에서 연도를 가져옴, 없으면 현재 연도 사용
						$year = isset($_GET['year']) && !empty($_GET['year']) ? intval($_GET['year']) : date('Y');

						// 판매정보를 조회하는 SQL 쿼리
						$price_sql = "
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
									    ct.categoryName AS category, 
									    m.month AS mon, 
									    COALESCE(SUM(CASE WHEN od.foodName = ctn.foodName AND ctn.categoryName = ct.categoryName THEN od.totalPrice ELSE 0 END), 0) AS totalprice
									FROM categories ct
									CROSS JOIN months m
									LEFT JOIN Cart c ON m.month = MONTH(c.orderDateTime) AND YEAR(c.orderDateTime) = '$year'
									LEFT JOIN OrderDetail od ON c.id = od.id
									LEFT JOIN Contain ctn ON od.foodName = ctn.foodName
									LEFT JOIN Category ct2 ON ctn.categoryName = ct2.categoryName
									GROUP BY ct.categoryName, m.month
									WITH ROLLUP
									HAVING mon IS NOT NULL AND category IS NOT NULL
									ORDER BY m.month, ct.categoryName;
									";
						
						$result_price = $conn->query($price_sql); // 판매 정보 저장
						
						// 쿼리로 얻어낸 데이터를 표 형식에 맞게 변환
						$data = []; // data 저장 배열
						$totalSales = []; // 총 판매금액 저장 배열
						while ($row = $result_price->fetch_assoc()) {
							$data[$row["mon"]][$row["category"]] = $row["totalprice"];
							if(!isset($totalSales[$row["category"]])) { // totalSales array 에 아직 카테고리의 합산금액이 없는 경우 0으로 설정
								$totalSales[$row["category"]] = 0;
							}
							$totalSales[$row["category"]] += $row["totalprice"];
						}
						?>
						<?php
						// table 정보 위에 조회된 연도 출력
						echo "<h3>".$year."년 조회 결과</h3>";			
						?>
						<table>
			        <thead>
			            <tr>
			                <th>월</th>
											<?php
								      // 카테고리 헤더 출력
											foreach ($data[key($data)] as $category => $value) {
												echo "<th>$category</th>";
											}

											?>
			            </tr>
			        </thead>
							<tbody>
								<?php
		            // 데이터 출력
								foreach ($data as $month => $categories) { // key => value
									echo "<tr>";
									echo "<td>".$month."월</td>";
									foreach ($categories as $value) {
                    echo "<td>".$value."원</td>";
									}
									echo "</tr>";
								}
								?>
								</tbody>
				        <tfoot>
				            <tr>
				                <td>총 판매 금액</td>
				                <?php
				                // 총 판매 금액 출력
				                foreach ($totalSales as $total) {
				                    echo "<td>".$total."원</td>";
				                }
				                ?>
				            </tr>
				        </tfoot>
						</table>
        </div>
        <!-- 인기 메뉴 조회 영역 -->
        <div class="popular-menus">
            <h2>카테고리 별 인기메뉴 조회</h2>
						<h3>이 정보는 판매 시작시점부터 조회시점까지의 총 판매개수가 많은 음식을 보여줍니다.</h3>
            <!-- 인기 메뉴 조회 기능을 구현하는 부분 -->
						<table>
							 <thead>
                    <tr>
                        <?php foreach ($data_menu as $row): ?>
                            <th><?php echo $row["category"]; ?></th>
                        <?php endforeach; ?>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <?php foreach ($data_menu as $row): ?>
                            <td><?php echo $row["popular_menu"]; ?></td>
                        <?php endforeach; ?>
                    </tr>
                    <tr>
                        <?php foreach ($data_menu as $row): ?>
                            <td><?php echo $row["amount"]; ?>개</td>
                        <?php endforeach; ?>
                    </tr>
                </tbody>
	         </table>
        </div>
		</div>

    <script>
        function nevigateToMainpage(usermode) {
					window.location.href = './main.php';
        }
    </script>

    <script>
				function getYearInfo() {
					var year = document.getElementById('year').value;
					if (year) {
						window.location.href = window.location.pathname + "?year=" + year;
					} else {
						alert("연도를 입력하세요.");
					}
				}
    </script>

</body>
</html>

