<?php
session_start();
include '../db_connect.php';

// 사용자정보를 세션에서 가져오기 
$username = $_SESSION['username'];
$userid = $_SESSION['user_id'];

// 장바구니 내역을 조회하는 SQL 쿼리
$cart_sql = "SELECT 
							 od.foodName AS foodname, 
							 od.quantity AS quantity, 
							 f.price AS price, 
							 od.totalPrice AS totalprice
						 FROM Cart c
						 INNER JOIN OrderDetail od ON c.id = od.id
						 INNER JOIN Food f ON od.foodName = f.foodName
						 WHERE c.cno = '$userid' AND c.id = 0"; // cart id == 0 : 현재 주문중인 장바구니 (아직 결제 x)
$result_cart = $conn->query($cart_sql); // 장바구니 정보 저장
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니 조회</title>
		<link rel="stylesheet" href="../style/mainpage.css">
		<link rel="stylesheet" href="../style/cart.css">
</head>
<body>
    <div class="top-container">
				<a href="./main.php">
					<img src="../images/logo.png" alt="Profile Picture">
				</a>
        <div class="title_box">
					<h1>장바구니 조회</h1>
        </div>

        <div class="user-info">
            <?php
                echo "<p>".$username."</p>";
                echo "<p>".$userid."</p>";
            ?>
        </div>
    </div>
    <div class="main-container">
        <div class="cart-content">
            <h1>장바구니 조회</h1>
            <table>
                <thead>
                    <tr>
                        <th>음식 이름</th>
                        <th>수량</th>
                        <th>1개당 가격</th>
                        <th>총 가격</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    $total_amount = 0;
                    if ($result_cart->num_rows > 0) {
                        while ($item = $result_cart->fetch_assoc()) {
                            $foodname = $item['foodname'];
                            $quantity = $item['quantity'];
                            $price = $item['price'];
                            $total_price = $item['totalprice'];
                            $total_amount += $total_price;
                            echo "<tr>
                                    <td>$foodname</td>
                                    <td>$quantity</td>
                                    <td>$price 원</td>
                                    <td>$total_price 원</td>
                                  </tr>";
                        }
                    } else {
                        echo "<tr><td colspan='4'>장바구니가 비어 있습니다.</td></tr>";
                    }
                    ?>
                </tbody>
            </table>
        </div>
    </div>
    <div class="total-section">
        <p>총 금액: <?php echo $total_amount; ?> 원</p>
        <button onClick="location.href='../cart_to_history.php'">결제하기</button>
    </div>
								
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

