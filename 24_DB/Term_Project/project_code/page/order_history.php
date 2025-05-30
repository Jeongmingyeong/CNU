<?php
session_start();
include '../db_connect.php';

// 사용자 정보를 세션에서 가져오기 
$username = $_SESSION['username'];
$userid = $_SESSION['user_id'];

// 날짜 필터링을 위한 기본값 설정
$start_date = isset($_GET['start_date']) ? $_GET['start_date'] : '';
$end_date = isset($_GET['end_date']) ? $_GET['end_date'] : '';

// 주문 내역을 조회하는 SQL 쿼리
$order_sql = "SELECT 
    c.id AS ordernum,
    DATE(c.orderDateTime) AS orderdate,
    c.orderDateTime AS ordertime,
    od.foodName AS foodname,
    od.quantity AS quantity,
    f.price AS price,
    od.totalPrice AS totalprice
    FROM Cart c
    INNER JOIN OrderDetail od ON c.id = od.id
    INNER JOIN Food f ON od.foodName = f.foodName
    WHERE c.cno = '$userid' AND c.id <> 0";

if (!empty($start_date) && !empty($end_date)) {
    $order_sql .= " AND DATE(c.orderDateTime) BETWEEN '$start_date' AND '$end_date'";
} else {
	if (empty($start_date)) {
		$sdate = '1900-01-01';
	} else {
		$sdate = $start_date;
	}
	
	if(empty($end_date)) {
		$edate = date('Y-m-d');
	} else {	
		$edate = $end_date;
	}
  $order_sql .= " AND DATE(c.orderDateTime) BETWEEN '$sdate' AND '$edate'";
}

$order_sql .= " ORDER BY c.orderDateTime DESC";

$result_order = $conn->query($order_sql); // 장바구니 정보 저장
?>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문내역 조회</title>
    <link rel="stylesheet" href="../style/mainpage.css">
    <link rel="stylesheet" href="../style/cart.css">
    <link rel="stylesheet" href="../style/order_history.css">
</head>
<body>
    <div class="top-container">
				<a href="./main.php">
					<img src="../images/logo.png" alt="Profile Picture">
				</a>
        <div class="title_box">
            <h1>주문내역 조회</h1>
        </div>
        <div class="user-info">
            <?php
                echo "<p>".$username."</p>";
                echo "<p>".$userid."</p>";
            ?>
        </div>
		</div>

		<div class="date-filter-container">
        <form action="" method="get">
            <label for="start_date">시작 날짜:</label>
            <input type="date" id="start_date" name="start_date" value="<?php echo htmlspecialchars($start_date); ?>">
            <label for="end_date">종료 날짜:</label>
            <input type="date" id="end_date" name="end_date" value="<?php echo htmlspecialchars($end_date); ?>">
            <button type="submit">검색</button>
            <button type="submit" id="reset_dates">초기화</button>
        </form>
    </div>

    <div class="main-container">
        <div class="order-history-content">
            <?php
            $current_date = null;
            if ($result_order->num_rows > 0) {
                while ($item = $result_order->fetch_assoc()) {
                    $orderdate = $item['ordertime'];
                    $foodname = $item['foodname'];
                    $quantity = $item['quantity'];
                    $price = $item['price'];
                    $total_price = $item['totalprice'];

                    // 날짜가 변경될 때마다 새로운 테이블 시작
                    if ($current_date !== $orderdate) {
                        if ($current_date !== null) {
                            // 이전 날짜의 테이블을 닫음
                            echo "</tbody></table></div>";
                        }
                        $current_date = $orderdate;
                        // 새로운 날짜의 테이블을 시작
                        echo "<div class='order-date'>";
                        echo "<h2>$orderdate</h2>";
                        echo "<table>
                                <thead>
                                    <tr>
                                        <th>음식 이름</th>
                                        <th>수량</th>
                                        <th>1개당 가격</th>
                                        <th>총 가격</th>
                                    </tr>
                                </thead>
                                <tbody>";
                    }

                    // 현재 날짜의 테이블에 행 추가
                    echo "<tr>
                            <td>$foodname</td>
                            <td>$quantity</td>
                            <td>$price 원</td>
                            <td>$total_price 원</td>
                          </tr>";
                }
                // 마지막 날짜의 테이블을 닫음
                echo "</tbody></table></div>";
            } else {
                echo "<p>주문 내역이 없습니다.</p>";
            }
            ?>
        </div>
    </div>
				
		<script>
        function nevigateToMainpage(usermode) {
					window.location.href = './main.php;
        }
		</script>

		<script>
        document.getElementById('reset_dates').addEventListener('click', function() {
            document.getElementById('start_date').value = '';
            document.getElementById('end_date').value = '';
        });
    </script>

</body>
</html>

<?php
$conn->close();
?>

